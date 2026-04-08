module Test.BitQubitParseTests

import Test.TestHelper

export
runBitQubitParseTests : IO ()
runBitQubitParseTests = do

    -- Test bit/qubit type declarations
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/qubitDeclaration1.lf" 
                    "let q : qubit = qalloc();" 
                    "let q : qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/qubitDeclaration2.lf" 
                    "let singleQubit : qubit = qalloc(1);" 
                    "let singleQubit : qubit = qalloc(1);"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/qubitArrayDeclaration.lf" 
                    "let qubits : [qubit; 3] = qalloc(3);" 
                    "let qubits : [qubit; 3] = qalloc(3);"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/bitMeasrDeclaration.lf" 
                    "let singleBit : bit = measr(q);" 
                    "let singleBit : bit = measr(q);"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/bitIntDeclaration.lf" 
                    "let singleBit : bit = 0;" 
                    "let singleBit : bit = 0;"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/bitArrayDeclaration.lf" 
                    "let bs : [bit; 8] = measr(qs);" 
                    "let bs : [bit; 8] = measr(qs);"

    -- Test inferred bit/qubit type declarations
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/inferredQubitDeclaration.lf"
                    "let singleQubit = qalloc(1);"
                    "let singleQubit = qalloc(1);"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/inferredQubitArrayDeclaration.lf" 
                    "let qubits = qalloc(2);" 
                    "let qubits = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/bitInferredDeclaration.lf" 
                    "let bs = measr(qs);" 
                    "let bs = measr(qs);"
                    
    -- Test bit/qubit declarations corner cases
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/noSpacesQubitDeclaration.lf"
                    "let q : qubit = qalloc();"
                    "let q : qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/extraWhitespaceQubitDeclaration.lf"
                    "let q : qubit = qalloc();"
                    "let q : qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/noSpacesQubitArrayDeclaration.lf"
                    "let qubits : [qubit; 3] = qalloc(3);"
                    "let qubits : [qubit; 3] = qalloc(3);"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/noSpacesBitDeclaration.lf"
                    "let singleBit : bit = 0;"
                    "let singleBit : bit = 0;"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/extraWhitespaceBitDeclaration.lf"
                    "let singleBit : bit = 0;"
                    "let singleBit : bit = 0;"
    runParseOkTest "src/Test/Fixtures/Good/BitQubit/noSpacesBitArrayDeclaration.lf"
                    "let bs : [bit; 8] = measr(qs);"
                    "let bs : [bit; 8] = measr(qs);"

    -- Test invalid bit/qubit declarations
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingInitializerInQubitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingEqualsInQubitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedSecondQallocInQubitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingBindingNameInQubitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingInitializerInBitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingEqualsInBitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedSecondBitLiteralInDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingBindingNameInBitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingEqualsInMeasuredBitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedSecondMeasrInBitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedSecondMeasrInBitArrayDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingBindingNameWithCommaSeparatedBitLiterals.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedCommaSeparatedLiteralAfterMeasrBitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingClosingParenInQallocDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingArgumentInQallocDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedSecondArgumentInQallocDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedClosingParenAfterQallocDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingClosingParenInMeasrBitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedLiteralAfterMeasrBitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedCommaAfterMeasrBitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingClosingParenInMeasrBitArrayDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedLiteralAfterMeasrBitArrayDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingBindingNameInTypedQubitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingColonBeforeQubitType.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingTypeAfterColonInQubitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/missingInitializerInNamedBitDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedSecondBitLiteralInNamedDeclaration.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/BitQubit/unexpectedLeadingCommaInBitDeclaration.lf"