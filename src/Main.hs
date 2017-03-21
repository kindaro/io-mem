module Main where

import Lib

main :: IO ()
main = do
    print "Testing pure."
    aPure <- return $ hardPure 100000 100000
    bPure <- return $ hardPure 100000 100000
    print (aPure, bPure)
    cPure <- return $ hardPure 100000 100000

    print "Testing IO."
    a <- hardIO 100000 1
    b <- hardIO 100000 1
    print (a,b)
    c <- hardIO 100000 1
    return ()
