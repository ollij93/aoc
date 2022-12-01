module Lib2021
  ( solutions2021
  , groups
  ) where

import           Lib       (Solution (..))

import           Data.List (singleton)

-- Parsing for day1
parseNumList :: String -> [Int]
parseNumList = map read . lines

-- Day 1 solutions
groups :: Int -> [Int] -> [[Int]]
groups size l =
  case size of
    1 -> map singleton l
    _ -> zipWith (:) l (tail (groups (size - 1) l))

day1General :: Int -> String -> Int
day1General n input = do
  let sumGroups = map sum . groups n . parseNumList $ input
  let pairs = zip sumGroups $ drop 1 sumGroups
  length $ filter (uncurry (<)) pairs

day1'1 :: String -> Int
day1'1 = day1General 1

day1'2 :: String -> Int
day1'2 = day1General 3

-- Day 2 solutions
data Direction
  = Forward
  | Up
  | Down

parseDirection :: String -> Direction
parseDirection s =
  case s of
    "up"      -> Up
    "down"    -> Down
    _ -> Forward

parseInstruction :: String -> (Direction, Int)
parseInstruction s = do
  let dirPart = takeWhile (/= ' ') s
  let velPart = dropWhile (/= ' ') s
  (parseDirection dirPart, read velPart)

parseInstructions :: String -> [(Direction, Int)]
parseInstructions = map parseInstruction . lines

type ProcessInstructionFnc
   = (Int, Int, Int) -> (Direction, Int) -> (Int, Int, Int)

day2General :: ProcessInstructionFnc -> String -> Int
day2General processInstruction =
  (\(x, y, _) -> x * y) . foldl processInstruction (0, 0, 0) . parseInstructions

processInstruction'1 :: ProcessInstructionFnc
processInstruction'1 (x, y, aim) (dir, spd) =
  case dir of
    Forward -> (x + spd, y, aim)
    Up      -> (x, y - spd, aim)
    Down    -> (x, y + spd, aim)

day2'1 :: String -> Int
day2'1 = day2General processInstruction'1

processInstruction'2 :: ProcessInstructionFnc
processInstruction'2 (x, y, aim) (dir, spd) =
  case dir of
    Forward -> (x + spd, y + aim * spd, aim)
    Up      -> (x, y, aim - spd)
    Down    -> (x, y, aim + spd)

day2'2 :: String -> Int
day2'2 = day2General processInstruction'2

-- Solution registry
solutions2021 :: [Solution]
solutions2021 =
  [ Solution
      { name = "2021 Day 1.1"
      , testPath = "inputs/2021/tests/day1.txt"
      , dataPath = "inputs/2021/day1.txt"
      , fnc = day1'1
      }
  , Solution
      { name = "2021 Day 1.2"
      , testPath = "inputs/2021/tests/day1.txt"
      , dataPath = "inputs/2021/day1.txt"
      , fnc = day1'2
      }
  , Solution
      { name = "2021 Day 2.1"
      , testPath = "inputs/2021/tests/day2.txt"
      , dataPath = "inputs/2021/day2.txt"
      , fnc = day2'1
      }
  , Solution
      { name = "2021 Day 2.2"
      , testPath = "inputs/2021/tests/day2.txt"
      , dataPath = "inputs/2021/day2.txt"
      , fnc = day2'2
      }
  ]
