module EmailConfig where

data Configuration = Configuration {
  host        :: String,
  port        :: Maybe Int,
  username    :: String,
  password    :: String
} deriving (Show, Read)

-- conf :: Configuration
-- conf = Configuration "smtp.gmail.com" Nothing "user.name@gmail.com" "password"
-- saveConfig :: IO ()
-- saveConfig = writeFile "config.txt" $ show conf

readConfig :: IO Configuration
readConfig = do
  c <- readFile "email.config"
  let config = read c :: Configuration
  return config
