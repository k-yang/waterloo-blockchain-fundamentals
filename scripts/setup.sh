CHAIN_ID="uwaterloo-blockchain-1"

# download binary
curl -s https://get.nibiru.fi/@v1.0.0\! | bash

# clean config directory
rm -rf ~/.nibid

# init config directory
nibid init uwaterloo-blockchain --chain-id $CHAIN_ID &> /dev/null

# other config options
nibid config output json
nibid config broadcast-mode sync

# create an account
nibid config keyring-backend test
nibid keys add validator | jq
nibid add-genesis-account validator 1000000000000unibi

# create a validator
nibid genesis gentx validator 1000000unibi --chain-id $CHAIN_ID &> /dev/null
nibid genesis collect-gentxs &> /dev/null