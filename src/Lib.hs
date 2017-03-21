module Lib where

import Data.Array.IO
import Data.Time.Clock
import System.Random


hardIO :: Int -> Int -> IO Int
hardIO space time = do
    arr <- newArray (1, space) 0 :: IO (IOUArray Int Int)
    timer <- spin time
    arrTotal <- sum <$> mapM (readArray arr) [1..space]
    random <- fst . next <$> newStdGen
    return $ arrTotal + random

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
