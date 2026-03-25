module Test.ParserTests

import Frontend.AST
import Frontend.ExprPrettyPrinter
import Frontend.Lexer
import Frontend.Parser
import Frontend.Token
import System.File
import Text.Bounds

testIntTypeDeclaration : IO ()
testIntTypeDeclaration = do
  fileResult <- readFile "src/Test/Good/Types/IntTypeDeclaration.lf"
  case fileResult of
    Left fileErr => putStrLn $ "Failed to read src/Test/Good/Types/IntTypeDeclaration.lf: " ++ show fileErr
    Right testProgram =>
      case lexProgram testProgram of
        Left err => putStrLn $ "Lexer error: " ++ show err
        Right tokens =>
          case parseProgramAll tokens of
            Left err => putStrLn $ "Parse error: " ++ show err
            Right program => putStrLn $ "Parsed program: " ++ show program

main : IO ()
main = do
  testIntTypeDeclaration