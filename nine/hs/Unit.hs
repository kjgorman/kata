module Unit where

import CheckOut
import PriceRules

import Test.HUnit

price :: String -> Int
price items = total $ foldr scan initialCheckOut items

testOverall = TestCase $ do
  assertEqual ""  0 $ price ""
  assertEqual "" 50 $ price "A"
  assertEqual "" 80 $ price "AB"
  assertEqual "" 115 $ price "CDBA"
  assertEqual "" 100 $ price "AA"
  assertEqual "" 130 $ price "AAA"
  assertEqual "" 180 $ price "AAAA"
  assertEqual "" 230 $ price "AAAAA"
  assertEqual "" 260 $ price "AAAAAA"
  assertEqual "" 160 $ price "AAAB"
  assertEqual "" 175 $ price "AAABB"
  assertEqual "" 190 $ price "AAABBD"
  assertEqual "" 190 $ price "DABABA"

main = runTestTT testOverall
