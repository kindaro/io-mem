module Lib where

import Data.Array
import Data.Array.IO
import Data.Numbers.Primes
import Data.Time.Clock
import System.Random

hardPure :: Int -> Int -> Int
hardPure n m = sum . elems $ array (1, n) $ zip [1..] $ take n $ drop m $ primes

hardIO :: Int -> Int -> IO Int
hardIO space time = do
    arr <- newArray (1, space) 0 :: IO (IOUArray Int Int)
    timer <- spin time
    arrTotal <- sum <$> mapM (readArray arr) [1..space]
    random <- fst . next <$> newStdGen
    return $! arrTotal + random

-- A grace de cirdec at stackoverflow.
spin :: Real a => a -> IO ()
spin seconds =
    do
        startTime <- getCurrentTime 
        let endTime = addUTCTime (fromRational (toRational seconds)) startTime
        let go = do
                now <- getCurrentTime
                if now < endTime then go else return ()
        go
