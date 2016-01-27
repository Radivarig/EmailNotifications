{-# LANGUAGE OverloadedStrings #-}

module EmailNotifications where

-- defined in .cabal
import Network.HaskellNet.IMAP.SSL
import Network.HaskellNet.SMTP.SSL as SMTP -- (doSMTPSTARTTLS, sendPlainTextMail)
-- import Network.HaskellNet.Auth (AuthType(LOGIN))
-- import qualified Data.ByteString.Char8 as B

import Data.Text.Lazy (Text, pack)

import EmailConfig

doSend :: String -> String -> String -> String -> Text -> [String] -> IO ()
doSend _host _username _password subject body recipients = doSMTPSTARTTLS _host $ \c -> do
  authSucceed <- SMTP.authenticate LOGIN _username _password c
  let sendToMany = \recipient -> sendPlainTextMail recipient _username subject body c
  if authSucceed
    then mapM_ sendToMany recipients
    else print "Authentication error."

-- sendMail :: Configuration -> Text -> [String] -> IO ()
sendMail' :: Configuration -> String -> Text -> [String] -> IO ()
sendMail' config subject body recipients = do
  doSend (host config) (username config) (password config) subject body recipients
  return ()

main :: IO ()
main = do
  config <- readConfig
  sendMail' config "Subject: Ferko" (pack "Email body Text") ["reslav.hollos@gmail.com"]
