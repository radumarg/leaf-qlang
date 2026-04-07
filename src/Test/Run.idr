module Test.Run

import Test.TypeParseTests
import Test.ArraysParseTests
import Test.BitQubitParseTests


main : IO ()
main = do
  runTypeParseTest
  runArraysParseTest
  runBitQubitParseTest
  putStrLn "All tests completed."