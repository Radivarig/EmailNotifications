#!bin/bash

# (todo) if sandbox then confirm reinit, else init
# rm -rf .cabal-sandbox; rm .cabal.sandbox.config
cabal sandbox init
cabal update
cabal install HaskellNet HaskellNet-SSL text regex-compat

