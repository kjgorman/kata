module PriceRules where

data Rule = Rule {
  sku :: Char,
  cost :: Int,
  deals :: [Deal]
  }

data Deal = Deal {
  key :: Char,
  quantity :: Int,
  discounted :: Int
  }
  deriving Show

rules :: [Rule]
rules = [Rule 'D' 15 [], Rule 'C' 20 [],
         Rule 'B' 30 [Deal 'B' 2 45],
         Rule 'A' 50 [Deal 'A' 3 130]]

discount :: String -> (Int, String)
discount [] = (0, "")
discount s = apply rules s

apply :: [Rule] -> String -> (Int, String)
apply [] s = (0, s)
apply _ [] = (0, [])
apply rs s = apply' (rs >>= deals) s

apply' :: [Deal] -> String -> (Int, String)
apply' [] s = (0, s)
apply' _ [] = (0, [])
apply' (d:ds) s = if applicable d s
                  then merge (apply' (d:ds) $ snd res) res
                  else apply' ds s
                       where res = discount' d s

merge :: (Int, String) -> (Int, String) -> (Int, String)
merge a b = (fst a + fst b, snd a)

discount' :: Deal -> String -> (Int, String)
discount' d s = (discounted d, del (key d) (quantity d) s)
  where del _ 0 s = s
        del _ n [] = []
        del k n (x:[]) = if x == k then [] else x:[]
        del k n (x:y:xs) = if x == k
                           then del k (n-1) (y:xs)
                           else x:(del k n (y:xs))

applicable :: Deal -> String -> Bool
applicable _ [] = False
applicable d s = and [keyFound d s, quantity d <= (qty d s)]
                 where
                   keyFound d s = (key d) `elem` s
                   qty d s = length $ filter (== (key d)) s

value :: String -> Int
value [] = 0
value (x:xs) = (first rules x) + value xs

first :: [Rule] -> Char -> Int
first [] _ = 0
first (x:xs) s = if sku x == s then cost x else first xs s
