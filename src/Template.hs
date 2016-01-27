module Template where

import Data.Text (Text, pack, unpack)
import Data.Map.Strict as M (Map, fromList, lookup)
import Text.Regex

-- | From Users module
data Role = Student | TA | Professor deriving (Eq, Ord, Show)
type ID = Int
type JMBAG = String

data User = User
  { uID :: ID 
  , jmbag :: JMBAG
  , uRole :: Role
  , name :: String
  , surname :: String
  , email :: String
  , password1 :: String -- (todo) collision with email password
  , salt :: String
  }

-- | Test data
template = "Hello {firstName} {lastName}\n@if(isTA or isProf)\nSomething\n@else\n@endif\nRegards,\n{authorName}"
regex1 = mkRegex "{.*}"

user = User 1 "0036010101" Student "A" "B" "a@a.com" "password" "12345678"
author = User 2 "0036010102" Student "Author" "" "a2@a.com" "password" "12345678"

userToMap :: User -> Map String Value
userToMap u
  | uRole u == Student   = fromList [("firstName", S (name u)), ("lastName", S (surname u)), ("isTa", B False), ("isProf", B False)]
  | uRole u == TA        = fromList [("firstName", S (name u)), ("lastName", S (surname u)), ("isTa", B True), ("isProf", B False)]
  | uRole u == Professor = fromList [("firstName", S (name u)), ("lastName", S (surname u)), ("isTa", B False), ("isProf", B True)]

type Template = Text

data Value = S String | B Bool deriving Show

unwrap :: Maybe Value -> String
unwrap (Just (S s)) = s
unwrap _ = ""

-- | Replaces one key with its value
replaceOne :: Map String Value -> (String, String, String, [String]) -> String
replaceOne m (s1, s2, s3, _) = s1 ++ newValues ++ s3
  where
    keys       = words $ filter (\c -> (c/='{') && (c/='}')) s2
    values     = map (`M.lookup` m) keys
    newValues  = unwords $ map unwrap values
    
-- | Replaces every key with its value
-- | Key should be wrapped with '{' and '}'
replaceVars :: String -> Map String Value -> String
replaceVars s m = case match of
  Nothing -> s
  Just x -> replaceVars (replaceOne m x) m
  where
    match = matchRegexAll regex1 addAuthor
    -- Replacing {authorName} with name of the author
    addAuthor = subRegex (mkRegex "{authorName}") s (name author ++ " " ++ surname author)

-- | Parses an expression and returns either a result or an error
-- | message, if the parsing fails. If a variable is undefined, you
-- | can either return an error or replace it with an empty string.
-- | You can use a more elaborate type than String for the Map values,
-- | e.g. something that differentiates between Strings and Bools.
compileTemplate :: Template -> Map String Value -> Either String Text
compileTemplate t m = Right $ pack $ replaceVars (unpack t) m

test = compileTemplate (pack template) (userToMap user)
