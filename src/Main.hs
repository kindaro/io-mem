module Main where

import Lib

main :: IO ()
main = hardIO 2000 5 >>= print
