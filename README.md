# Email notifications

### Usage

- run `init.sh` to prepare a sandbox and install dependencies
- create an `email.config` file with the `Configuration` details and place it in root
- allow connection (gmail - access for less secure apps)

```hs
sendMail' :: Configuration -> String -> Text -> [String] -> IO ()
sendMail'    config           subject   body    recipients
```
