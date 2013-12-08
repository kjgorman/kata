module CheckOut where

import PriceRules
import Data.Char
import Data.Monoid

newtype CheckOut s a = CheckOut { runCheckOut :: s -> (a, s) }

instance Monad (CheckOut s) where
  return a = CheckOut $ \c -> (a, c)
  m >>= k = CheckOut $ \c -> let
                     (a, c') = runCheckOut m c
                     in runCheckOut (k a) c'

get = CheckOut $ \c -> (c, c)
put c = CheckOut $ const ((), c)
modify f = do { x <- get; put (f x) }

initialCheckOut :: CheckOut String Int
initialCheckOut = return 0

total :: CheckOut String Int -> Int
total c = fst $ runCheckOut c ""

scan :: Char -> CheckOut String Int -> CheckOut String Int
scan c x = do
  let (current, state) = runCheckOut x ""
      newState = c:state
  put newState
  return $ look newState

look :: String -> Int
look s = discounts + regular
         where (discounts, rest) = discount s
               regular = value rest
