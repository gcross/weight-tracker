{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE UnicodeSyntax #-}

import Database.Sqlite.Enumerator

import System.Console.Readline
import System.Directory
import System.Environment
import System.FilePath

main = do
  args ← getArgs
  weight ←
    case args of
      [] → askForWeight
      (weight:_) → return weight
  connection ← fmap (connect . (</> "Documents/weight.db")) getHomeDirectory
  withSession connection $ do
    execDDL . sql $ "create table if not exists weight (weight real, time text default (current_timestamp));"
    execDML . sql $ "insert into weight (weight) values (" ++ weight ++ ");"
  return ()

askForWeight =
  readline "How much do you weight at this time? "
  >>=
  \maybe_weight →
    case maybe_weight of
      Nothing → askForWeight
      Just weight → return weight
