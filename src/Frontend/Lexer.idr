module Frontend.Lexer

import Derive.Prelude
import Language.Reflection

import Frontend.AST
import Frontend.Token

-- idris2-parser manual tooling for span tracking:
-- Position, begin, next, Bounded, bounded, ...
import Text.Parse.Manual

%default total
%language ElabReflection

--------------------------------------------------------------------------------
-- LexerErr: lexical errors that can happen before parsing.
-- These errors are also Bounded so you can report line/col spans.
--------------------------------------------------------------------------------
public export
data LexerErr
  = LexUnexpectedChar Char
  | LexUnterminatedString
  | LexUnterminatedBlockComment
  | LexInvalidBitStringLiteral String
  | LexInvalidNumberLiteral String
  | LexFuelExhausted

%runElab derive "LexerErr" [Show, Eq]

--------------------------------------------------------------------------------
-- Utility: advance Position by a list of characters (for span calculation).
--------------------------------------------------------------------------------
advanceMany : Position -> List Char -> Position
advanceMany startPosition charsConsumed =
  foldl (flip next) startPosition charsConsumed

mkBoundedHere : a -> Position -> Position -> Bounded a
mkBoundedHere value startPosition endPosition =
  bounded value startPosition endPosition

--------------------------------------------------------------------------------
-- Identifier character classes.
-- [A-Za-z_] start, then [A-Za-z0-9_] continue.
--------------------------------------------------------------------------------
isIdentStartChar : Char -> Bool
isIdentStartChar c = isAlpha c || c == '_'

isIdentContinueChar : Char -> Bool
isIdentContinueChar c = isAlphaNum c || c == '_'

--------------------------------------------------------------------------------
-- takeWhileList: purely functional helper for char streams
--------------------------------------------------------------------------------
takeWhileList : (a -> Bool) -> List a -> (List a, List a)
takeWhileList predicate xs =
  case xs of
    [] => ([], [])
    x :: rest =>
      if predicate x
        then let (taken, remaining) = takeWhileList predicate rest in (x :: taken, remaining)
        else ([], xs)

--------------------------------------------------------------------------------
-- startsWithList: checks prefix matching for multi-character operators/comments
-- startsWithList prefixChars fullChars
--------------------------------------------------------------------------------
startsWithList : List Char -> List Char -> Bool
startsWithList [] _ = True
startsWithList _ [] = False
startsWithList (p :: ps) (f :: fs) =
  if p == f then startsWithList ps fs else False

dropList : Nat -> List a -> List a
dropList Z xs = xs
dropList (S k) xs = case xs of
  [] => []
  _ :: rest => dropList k rest

--------------------------------------------------------------------------------
-- Comment skipping
--------------------------------------------------------------------------------

-- Skip // ... until newline or EOF
skipLineComment : Position -> List Char -> (Position, List Char)
skipLineComment currentPosition charsRemaining =
  case charsRemaining of
    [] => (currentPosition, [])
    c :: cs =>
      if c == '\n'
        then (advanceMany currentPosition [c], cs)
        else skipLineComment (advanceMany currentPosition [c]) cs

-- Skip /* ... */ (non-nesting; easy to extend later)
--
-- NOTE (improvement):
--   This function now expects:
--     * commentStartPosition = position of the '/' that started "/*"
--     * charsAfterStart     = characters AFTER the initial "/*"
--   This gives better spans for LexUnterminatedBlockComment.
skipBlockComment : Position -> List Char -> Either (Bounded LexerErr) (Position, List Char)
skipBlockComment commentStartPosition charsAfterStart =
  let
    -- We begin scanning *after* consuming the initial "/*"
    scanStartPosition : Position
    scanStartPosition = advanceMany commentStartPosition ['/', '*']

    go : Position -> List Char -> Either (Bounded LexerErr) (Position, List Char)
    go currentPosition cs =
      case cs of
        [] =>
          -- No silent error: unterminated block comment is a hard lexical error
          Left (mkBoundedHere LexUnterminatedBlockComment commentStartPosition currentPosition)

        -- Found the closing "*/"
        '*' :: '/' :: rest =>
          let endPosition = advanceMany currentPosition ['*','/'] in
          Right (endPosition, rest)

        c :: rest =>
          go (advanceMany currentPosition [c]) rest
  in
    go scanStartPosition charsAfterStart

--------------------------------------------------------------------------------
-- String literal lexing: " ... "
-- Supports basic escapes: \n, \t, \r, \", \\ .
--
-- NOTE (improvement):
--   This function now expects:
--     * stringQuoteStartPosition = position of the opening quote '"'
--     * charsAfterQuote          = characters AFTER the opening quote
--   This gives better spans for LexUnterminatedString.
--------------------------------------------------------------------------------
lexStringLiteral : Position -> List Char -> Either (Bounded LexerErr) (String, Position, List Char)
lexStringLiteral stringQuoteStartPosition charsAfterQuote =
  let
    -- We begin scanning *after* consuming the opening '"'
    scanStartPosition : Position
    scanStartPosition = advanceMany stringQuoteStartPosition ['"']

    go : Position -> List Char -> List Char -> Either (Bounded LexerErr) (String, Position, List Char)
    go currentPosition accumulatorChars cs =
      case cs of
        [] =>
          Left (mkBoundedHere LexUnterminatedString stringQuoteStartPosition currentPosition)

        -- closing quote
        '"' :: rest =>
          let endPosition = advanceMany currentPosition ['"'] in
          Right (pack (reverse accumulatorChars), endPosition, rest)

        -- escape sequence
        '\\' :: esc :: rest =>
          let decodedChar =
                case esc of
                  'n'  => '\n'
                  't'  => '\t'
                  'r'  => '\r'
                  '"'  => '"'
                  '\\' => '\\'
                  other => other
          in go (advanceMany currentPosition ['\\', esc]) (decodedChar :: accumulatorChars) rest

        -- ordinary character
        c :: rest =>
          go (advanceMany currentPosition [c]) (c :: accumulatorChars) rest
  in
    go scanStartPosition [] charsAfterQuote

--------------------------------------------------------------------------------
-- Bitstring literal lexing: b"0101"
-- Accepts only characters '0' and '1' between the quotes.
--
-- This function expects:
--   * bitStringStartPosition = position of the 'b'
--   * charsAfterPrefix       = characters AFTER the prefix b"
--------------------------------------------------------------------------------
lexBitStringLiteral : Position -> List Char -> Either (Bounded LexerErr) (String, Position, List Char)
lexBitStringLiteral bitStringStartPosition charsAfterPrefix =
  let
    scanStartPosition : Position
    scanStartPosition = advanceMany bitStringStartPosition ['b', '"']

    go : Position -> List Char -> List Char -> Either (Bounded LexerErr) (String, Position, List Char)
    go currentPosition accumulatorChars cs =
      case cs of
        [] =>
          Left (mkBoundedHere LexUnterminatedString bitStringStartPosition currentPosition)

        '"' :: rest =>
          let endPosition = advanceMany currentPosition ['"'] in
          Right (pack (reverse accumulatorChars), endPosition, rest)

        '0' :: rest =>
          go (advanceMany currentPosition ['0']) ('0' :: accumulatorChars) rest

        '1' :: rest =>
          go (advanceMany currentPosition ['1']) ('1' :: accumulatorChars) rest

        c :: _ =>
          Left
            (mkBoundedHere
              (LexInvalidBitStringLiteral ("invalid bitstring character: " ++ singleton c))
              bitStringStartPosition
              (advanceMany currentPosition [c]))
  in
    go scanStartPosition [] charsAfterPrefix

--------------------------------------------------------------------------------
-- Number lexing:
--  * int:    123
--  * float:  123.45
-- Important rule for ranges:
--  * "1..6" must lex as TokIntLitRaw "1" then TokSym SymDotDot then TokIntLitRaw "6"
-- This lexer explicitly checks for ".." after digits before treating '.' as float.
--------------------------------------------------------------------------------
lexNumberLiteral : Position -> List Char -> Either (Bounded LexerErr) (Token, Position, List Char)
lexNumberLiteral startPosition charsRemaining =
  let (digitChars, restAfterDigits) = takeWhileList isDigit charsRemaining in
  case restAfterDigits of
    '.' :: '.' :: _ =>
      -- Range begins: keep integer only
      let endPosition = advanceMany startPosition digitChars in
      Right (TokIntLitRaw (pack digitChars), endPosition, restAfterDigits)

    '.' :: nextChar :: restTail =>
      if isDigit nextChar
        then
          let (fractionChars, remainingChars) = takeWhileList isDigit (nextChar :: restTail) in
          let fullChars = digitChars ++ ('.' :: fractionChars) in
          let endPosition = advanceMany startPosition fullChars in
          Right (TokFloatLitRaw (pack fullChars), endPosition, remainingChars)
        else
          -- Treat "123." as int "123" + '.' symbol later
          let endPosition = advanceMany startPosition digitChars in
          Right (TokIntLitRaw (pack digitChars), endPosition, restAfterDigits)

    _ =>
      let endPosition = advanceMany startPosition digitChars in
      Right (TokIntLitRaw (pack digitChars), endPosition, restAfterDigits)

--------------------------------------------------------------------------------
-- Ident / keyword / type / gate lexing
--
-- Order matters:
--   1) "_" => TokUnderscore
--   2) reserved keywords (let, if, ...)
--   3) reserved type keywords (int, QReg, ...)
--   4) gate keywords (H, CX, ...)
--   5) otherwise identifier
--------------------------------------------------------------------------------
lexIdentOrKeywordOrTypeOrGate : Position -> List Char -> (Token, Position, List Char)
lexIdentOrKeywordOrTypeOrGate startPosition charsRemaining =
  let (identChars, restChars) = takeWhileList isIdentContinueChar charsRemaining in
  let identString = pack identChars in
  let endPosition = advanceMany startPosition identChars in
  if identString == "_"
    then (TokUnderscore, endPosition, restChars)
    else case keywordFromString identString of
      Just kw => (TokKw kw, endPosition, restChars)
      Nothing =>
        case typeFromString identString of
          Just typPrimName => (TokTypPrim typPrimName, endPosition, restChars)
          Nothing =>
            case gateFromString identString of
              Just gateName => (TokGate gateName, endPosition, restChars)
              Nothing => (TokIdent identString, endPosition, restChars)

--------------------------------------------------------------------------------
-- Symbol lexing: longest-match first (..= before .., >= before >, etc.)
--------------------------------------------------------------------------------
lexSymbol : Position -> List Char -> Either (Bounded LexerErr) (Token, Position, List Char)
lexSymbol startPosition charsRemaining =
  let
    tryPattern : List Char -> Symbol -> Maybe (Token, Position, List Char)
    tryPattern patternChars sym =
      if startsWithList patternChars charsRemaining
        then
          let endPosition = advanceMany startPosition patternChars
              remainingChars = dropList (length patternChars) charsRemaining
          in Just (TokSym sym, endPosition, remainingChars)
        else
          Nothing

    tryAll : List (List Char, Symbol) -> Maybe (Token, Position, List Char)
    tryAll candidates =
      case candidates of
        [] => Nothing
        (pat, sym) :: rest =>
          case tryPattern pat sym of
            Just ok => Just ok
            Nothing => tryAll rest

    -- multi-character operators first
    candidates : List (List Char, Symbol)
    candidates =
      [ (unpack "..=", SymDotDotEq)
      , (unpack "..",  SymDotDot)
      , (unpack "=>",  SymFatArrow)
      , (unpack "->",  SymArrow)
      , (unpack "::",  SymDoubleColon)
      , (unpack "==",  SymEqEq)
      , (unpack "!=",  SymNotEq)
      , (unpack ">=",  SymGe)
      , (unpack "<=",  SymLe)
      , (unpack "&&",  SymAndAnd)
      , (unpack "||",  SymOrOr)
      , (unpack "+=",  SymPlusEq)
      , (unpack "-=",  SymMinusEq)
      , (unpack "*=",  SymStarEq)
      , (unpack "/=",  SymSlashEq)
      , (unpack "%=",  SymPercentEq)
      , (unpack ":=",  SymWalrusEq)
      ]
  in
    case tryAll candidates of
      Just ok => Right ok

      Nothing =>
        case charsRemaining of
          [] =>
            -- Defensive; lexSymbol is normally called with non-empty input.
            Left (mkBoundedHere (LexUnexpectedChar '\0') startPosition startPosition)

          c :: rest =>
            let (maybeToken, consumedChars) : (Maybe Token, List Char) =
                case c of
                  '?' => (Just (TokSym SymQuestion), [c])
                  '&' => (Just (TokSym SymAmp), [c])
                  '(' => (Just (TokSym SymLParen), [c])
                  ')' => (Just (TokSym SymRParen), [c])
                  '[' => (Just (TokSym SymLBracket), [c])
                  ']' => (Just (TokSym SymRBracket), [c])
                  '{' => (Just (TokSym SymLBrace), [c])
                  '}' => (Just (TokSym SymRBrace), [c])
                  ',' => (Just (TokSym SymComma), [c])
                  ';' => (Just (TokSym SymSemi), [c])
                  ':' => (Just (TokSym SymColon), [c])
                  '.' => (Just (TokSym SymDot), [c])
                  '!' => (Just (TokSym SymBang), [c])
                  '=' => (Just (TokSym SymEq), [c])
                  '+' => (Just (TokSym SymPlus), [c])
                  '-' => (Just (TokSym SymMinus), [c])
                  '*' => (Just (TokSym SymStar), [c])
                  '/' => (Just (TokSym SymSlash), [c])
                  '%' => (Just (TokSym SymPercent), [c])
                  '>' => (Just (TokSym SymGt), [c])
                  '<' => (Just (TokSym SymLt), [c])
                  '|' => (Just (TokSym SymPipe), [c])
                  '^' => (Just (TokSym SymCaret), [c])
                  _   => (Nothing, [c])
            in
              case maybeToken of
                Just token =>
                  let endPosition = advanceMany startPosition consumedChars in
                  Right (token, endPosition, rest)

                Nothing =>
                  let endPosition = advanceMany startPosition [c] in
                  Left (mkBoundedHere (LexUnexpectedChar c) startPosition endPosition)

--------------------------------------------------------------------------------
-- Main entry point: lexProgram
--
-- Produces a list of tokens, each with bounds.
-- No silent failures: invalid characters or unterminated comments/strings
-- return Left (Bounded LexerErr).
--------------------------------------------------------------------------------
public export
lexProgram : String -> Either (Bounded LexerErr) (List (Bounded Token))
lexProgram inputString =
  let charsAll = unpack inputString
      fuel    = S (length charsAll)  -- enough steps if each iteration consumes ≥ 1 char
  in go fuel begin charsAll
where
  go : Nat -> Position -> List Char -> Either (Bounded LexerErr) (List (Bounded Token))
  go Z currentPosition _ =
    -- If we ever get here, something failed to make progress; report a hard lexer error.
    Left (mkBoundedHere LexFuelExhausted currentPosition currentPosition)

  go (S fuelLeft) currentPosition charsRemaining =
    case charsRemaining of
      [] =>
        Right []

      c :: rest =>
        -- 1) skip whitespace
        if isSpace c then
          go fuelLeft (advanceMany currentPosition [c]) rest

        -- 2) skip line comments: //
        else if startsWithList (unpack "//") (c :: rest) then
          let afterSlashesPosition = advanceMany currentPosition ['/', '/']
              afterSlashesChars    = dropList 2 (c :: rest)
              (newPosition, remainingChars) =
                skipLineComment afterSlashesPosition afterSlashesChars
          in go fuelLeft newPosition remainingChars

        -- 3) skip block comments: /* ... */
        else if startsWithList (unpack "/*") (c :: rest) then
          let afterStartChars = dropList 2 (c :: rest) in
          case skipBlockComment currentPosition afterStartChars of
            Left err => Left err
            Right (newPosition, remainingChars) =>
              go fuelLeft newPosition remainingChars

        -- 4) string literal
        else if c == '"' then
          case lexStringLiteral currentPosition rest of
            Left err => Left err
            Right (stringValue, endPosition, remainingChars) =>
              let boundedToken =
                    mkBoundedHere (TokStringLit stringValue) currentPosition endPosition
              in (boundedToken ::) <$> go fuelLeft endPosition remainingChars

        -- 5) number literal
        else if isDigit c then
          case lexNumberLiteral currentPosition (c :: rest) of
            Left err => Left err
            Right (token, endPosition, remainingChars) =>
              let boundedToken = mkBoundedHere token currentPosition endPosition
              in (boundedToken ::) <$> go fuelLeft endPosition remainingChars

        -- 6) bitstring literal: b"..."
        else if c == 'b' && startsWithList ['b', '"'] (c :: rest) then
          let charsAfterPrefix = dropList 2 (c :: rest) in
          case lexBitStringLiteral currentPosition charsAfterPrefix of
            Left err => Left err
            Right (bitStringValue, endPosition, remainingChars) =>
              let boundedToken =
                    mkBoundedHere (TokBitStringLit bitStringValue) currentPosition endPosition
              in (boundedToken ::) <$> go fuelLeft endPosition remainingChars

        -- 7) identifier/keyword/type/gate
        else if isIdentStartChar c then
          let (token, endPosition, remainingChars) =
                lexIdentOrKeywordOrTypeOrGate currentPosition (c :: rest)
              boundedToken = mkBoundedHere token currentPosition endPosition
          in (boundedToken ::) <$> go fuelLeft endPosition remainingChars

        -- 8) symbols/operators
        else
          case lexSymbol currentPosition (c :: rest) of
            Left err => Left err
            Right (token, endPosition, remainingChars) =>
              let boundedToken = mkBoundedHere token currentPosition endPosition
              in (boundedToken ::) <$> go fuelLeft endPosition remainingChars
