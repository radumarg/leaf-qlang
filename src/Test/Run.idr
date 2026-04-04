module Test.Run

import Test.TypeParseTests
import Test.ArraysParseTests


main : IO ()
main = do
  runTypeParseTest
  runArraysParseTest
  putStrLn "All tests completed."