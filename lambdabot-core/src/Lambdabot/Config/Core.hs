{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-warn-overlapping-patterns #-}
module Lambdabot.Config.Core
    ( commandPrefixes
    , disabledCommands
    , editDistanceLimit
    , onStartupCmds
    , outputDir
    , textWidth
    , uncaughtExceptionHandler
    
    , replaceRootLogger
    , lbRootLoggerPath
    , consoleLogHandle
    , consoleLogLevel
    , consoleLogFormat
    ) where

import Lambdabot.Config
import Lambdabot.Logging

import Control.Exception
import System.IO

-------------------------------------
-- Core configuration variables

config "commandPrefixes"    [t| [String]                |] [| ["@", "?"]    |]
config "disabledCommands"   [t| [String]                |] [| []            |]
config "editDistanceLimit"  [t| Int                     |] [| 3 :: Int      |]
configWithMerge [| (++) |] "onStartupCmds" [t| [String] |] [| ["offline"]   |]
config "outputDir"          [t| FilePath                |] [| "State/"      |]

-- IRC maximum msg length, minus a bit for safety.
config "textWidth"          [t| Int                     |] [| 200 :: Int    |]

-- basic logging.  for more complex setups, configure directly using System.Log.Logger
config "replaceRootLogger"  [t| Bool                    |] [| True                        |]
config "lbRootLoggerPath"   [t| [String]                |] [| []                          |]
config "consoleLogHandle"   [t| Handle                  |] [| stderr                      |]
config "consoleLogLevel"    [t| Priority                |] [| NOTICE                      |]
config "consoleLogFormat"   [t| String                  |] [| "[$prio] $loggername: $msg" |]

--------------------------------------------
-- Default values with longer definitions

defaultIrcHandler :: SomeException -> IO ()
defaultIrcHandler = errorM . ("Main: caught (and ignoring) "++) . show

config "uncaughtExceptionHandler" [t| SomeException -> IO () |] [| defaultIrcHandler |]