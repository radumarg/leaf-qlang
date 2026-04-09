module Test.TypeQualifierParserTests

import Test.TestHelper

export
runTypeQualifierParseTests : IO ()
runTypeQualifierParseTests = do

    -- Test type qualifier declarations
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/linearQubit.lf"
                "let linear q: qubit = qalloc();"
                "let linear q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/linearQubits.lf"
                "let linear qs: [qubit; 2] = qalloc(2);"
                "let linear qs: [qubit; 2] = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/affineQubit.lf"
                "let affine q: qubit = qalloc();"
                "let affine q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/affineQubits.lf"
                "let affine qs: [qubit; 2] = qalloc(2);"
                "let affine qs: [qubit; 2] = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchQubit.lf"
                "let scratch q: qubit = qalloc();"
                "let scratch q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchQubits.lf"
                "let scratch qs: [qubit; 2] = qalloc(2);"
                "let scratch qs: [qubit; 2] = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchLinearQubit.lf"
                "let scratch linear q: qubit = qalloc();"
                "let scratch linear q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchLinearQubits.lf"
                "let scratch linear qs: [qubit; 2] = qalloc(2);"
                "let scratch linear qs: [qubit; 2] = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchAffineQubit.lf"
                "let scratch affine q: qubit = qalloc();"
                "let scratch affine q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/affineScratchQubit.lf"
                "let affine scratch q: qubit = qalloc();"
                "let affine scratch q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/affineScratchQubits.lf"
                "let affine scratch qs: [qubit; 2] = qalloc(2);"
                "let affine scratch qs: [qubit; 2] = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/linearScratchQubit.lf"
                "let linear scratch q: qubit = qalloc();"
                "let linear scratch q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/linearScratchQubits.lf"
                "let linear scratch qs: [qubit; 2] = qalloc(2);"
                "let linear scratch qs: [qubit; 2] = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchAffineQubits.lf"
                "let scratch affine qs: [qubit; 2] = qalloc(2);"
                "let scratch affine qs: [qubit; 2] = qalloc(2);"

    -- Test type qualifier declarations with inferred types
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/linearInferredQubit.lf"
                "let linear q = qalloc();"
                "let linear q = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/linearInferredQubits.lf"
                "let linear qs = qalloc(2);"
                "let linear qs = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/affineInferredQubit.lf"
                "let affine q = qalloc();"
                "let affine q = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/affineInferredQubits.lf"
                "let affine qs = qalloc(2);"
                "let affine qs = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchInferredQubit.lf"
                "let scratch q = qalloc();"
                "let scratch q = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchInferredQubits.lf"
                "let scratch qs = qalloc(2);"
                "let scratch qs = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchInferredLinearQubit.lf"
                "let scratch linear q = qalloc();"
                "let scratch linear q = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchInferredLinearQubits.lf"
                "let scratch linear qs = qalloc(2);"
                "let scratch linear qs = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchInferredAffineQubit.lf"
                "let scratch affine q = qalloc();"
                "let scratch affine q = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/affineScratchInferredQubit.lf"
                "let affine scratch q = qalloc();"
                "let affine scratch q = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/linearScratchInferredQubit.lf"
                "let linear scratch q = qalloc();"
                "let linear scratch q = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/linearScratchInferredQubits.lf"
                "let linear scratch qs = qalloc(2);"
                "let linear scratch qs = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchInferredAffineQubits.lf"
                "let scratch affine qs = qalloc(2);"
                "let scratch affine qs = qalloc(2);"

    -- Test type qualifier declarations corner cases
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/linearSpaceBeforeColonQubit.lf"
                "let linear q: qubit = qalloc();"
                "let linear q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchCompactTypedQubit.lf"
                "let scratch q: qubit = qalloc();"
                "let scratch q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchExtraWhitespaceTypedQubit.lf"
                "let scratch q: qubit = qalloc();"
                "let scratch q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchBindingSplitLine.lf"
                "let scratch q: qubit = qalloc();"
                "let scratch q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/linearScratchTypeOnNextLine.lf"
                "let linear scratch q: qubit = qalloc();"
                "let linear scratch q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/affineScratchArraySplitLine.lf"
                "let affine scratch qs: [qubit; 2] = qalloc(2);"
                "let affine scratch qs: [qubit; 2] = qalloc(2);"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchLinearStackedLines.lf"
                "let scratch linear q: qubit = qalloc();"
                "let scratch linear q: qubit = qalloc();"
    runParseOkTest "src/Test/Fixtures/Good/TypeQualifier/scratchSingleQubitArray.lf"
                "let scratch q: [qubit; 1] = qalloc(1);"
                "let scratch q: [qubit; 1] = qalloc(1);"

    -- Test invalid type qualifier declarations
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/linearAffineInferredQubit.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/linearAffineInferredQubits.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/doubleScratchQubit.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/doubleLinearQubit.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/doubleAffineQubit.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/scratchLinearAffineQubit.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingBindingNameAfterLinear.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingBindingNameAfterAffineScratch.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingBindingNameAfterScratchLinear.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingInitializerAfterQualifiedTypedBinding.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingEqualsBeforeQallocInAffineBinding.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingTypeAfterColonInLinearBinding.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingArrayLengthInScratchTypedBinding.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingArrayLengthInLinearScratchTypedBinding.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingClosingBracketInAffineArrayBinding.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingClosingParenInScratchQalloc.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingClosingParenInLinearScratchQalloc.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingSemicolonInAffineScratchBinding.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/missingTypeAfterColonInScratchBinding.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/unexpectedScratchAfterBindingName.lf"
    runParseShouldFailTest
                    "src/Test/Fixtures/Bad/TypeQualifier/trailingCommaInScratchQalloc.lf"
    runParseShouldFailTest 
                    "src/Test/Fixtures/Bad/TypeQualifier/scratchInferredQallocNoParens.lf"

