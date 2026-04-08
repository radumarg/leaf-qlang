module Test.Run

import Test.ArraysParseTests
import Test.BitQubitParseTests
import Test.QuantumGatesParserTests
import Test.TypeParseTests


main : IO ()
main = do
  runArraysParseTests
  runBitQubitParseTests
  runQuantumGatesParseTests
  runTypeParseTests
  putStrLn "All tests completed."