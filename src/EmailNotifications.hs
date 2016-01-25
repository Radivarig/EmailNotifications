{-# LANGUAGE OverloadedStrings #-}

module EmailNotifications where

import Network.HaskellNet.IMAP.SSL
import Network.HaskellNet.SMTP.SSL as SMTP -- (doSMTPSTARTTLS, sendPlainTextMail)

import Network.HaskellNet.Auth (AuthType(LOGIN))

import qualified Data.ByteString.Char8 as B

username = "user.name@gmail.com"
password = "password"

recipient = "someone@gmail.com"

subject = "Test message"
body = "This is a test message"

doSend = doSMTPSTARTTLS "smtp.gmail.com" $ \c -> do
  authSucceed <- SMTP.authenticate LOGIN username password c
  if authSucceed
    then sendPlainTextMail recipient username subject body c
    else print "Authentication error."

main :: IO ()
main = doSend >> return ()
