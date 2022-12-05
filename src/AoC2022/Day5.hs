module AoC2022.Day5
  ( day5'1
  , day5'2
  ) where

import           Data.List.Split (splitOn)
import           Util

parseCrateRow :: [[Char]] -> String -> [[Char]]
parseCrateRow stacks l =
  map
    (\(stack, crate) ->
       case crate of
         ' ' -> stack
         _   -> crate : stack) $
  zip stacks $ every 4 $ "  " ++ l

parseCrates :: String -> [[Char]]
parseCrates s = do
  let ls = drop 1 . reverse . lines $ s
  let baseRow =
        map
          (\c ->
             case c of
               ' ' -> []
               _   -> [c]) $
        every 4 $ "  " ++ (head ls)
  foldl parseCrateRow baseRow $ tail ls

parseInstruction :: String -> (Int, Int, Int)
parseInstruction s = do
  let wrds = words s
  mapTuple3 read (wrds !! 1, wrds !! 3, wrds !! 5)

parsePuzzle :: String -> ([[Char]], [(Int, Int, Int)])
parsePuzzle s = do
  let sections = splitOn "\n\n" s
  let crinp = head sections
  let ininp = last sections
  (parseCrates crinp, map parseInstruction . lines $ ininp)

viewStackTops :: [[Char]] -> String
viewStackTops =
  foldr
    (\stack ret ->
       case stack of
         []  -> ret
         x:_ -> x : ret)
    ""

processInstruction :: (Int -> Int) -> [[Char]] -> (Int, Int, Int) -> [[Char]]
processInstruction moveLimiter stacks (n, frm, to) = do
  let moveCount = moveLimiter n
  case n of
    0 -> stacks
    _ ->
      processInstruction
        moveLimiter
        (processMove moveCount frm to stacks)
        (n - moveCount, frm, to)

processMove :: Int -> Int -> Int -> [[Char]] -> [[Char]]
processMove moveCount frm to stacks = do
  let movingCrates = take moveCount (stacks !! (frm - 1))
  map
    (\(idx, stack) ->
       if idx == frm
         then drop moveCount stack
         else if idx == to
                then movingCrates ++ stack
                else stack) $
    zip [1 ..] stacks

day5 :: (Int -> Int) -> String -> String
day5 moveLimiter =
  viewStackTops . uncurry (foldl $ processInstruction moveLimiter) . parsePuzzle

day5'1 :: String -> String
day5'1 = day5 $ const 1

day5'2 :: String -> String
day5'2 = day5 id