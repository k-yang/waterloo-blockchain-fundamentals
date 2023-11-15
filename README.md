# waterloo-blockchain-fundamentals

[Slide Deck](https://docs.google.com/presentation/d/1-5zlushR_7ykjQcqkJotKxLTuGIIaatlDyOz-mqK9tc/edit?usp=sharing)

## Install Prerequisites

```bash
# install jq
brew install jq # macOS
apt-get install jq # ubuntu

# this alias will help you a lot
alias tx="jq -rcs '.[0].txhash' | { read txhash; sleep 5; nibid q tx \$txhash | jq }"

# install rust and wasm
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup default stable
rustup update stable
rustup target add wasm32-unknown-unknown
source "$HOME/.cargo/env
```

## Blockchain Quickstart

```bash
sh scripts/setup.sh

nibid start
```

## DeFi (CW20) Contract Quickstart

### Compile CW20 Contract

```bash
cd contracts/cw20-base
RUSTFLAGS="-C link-arg=-s" cargo wasm

cp target/wasm32-unknown-unknown/release/cw20_base.wasm ../../artifacts/
```

### Upload CW20 Contract

```bash
nibid tx wasm store artifacts/cw20_base.wasm \
--from validator \
--gas auto \
--gas-adjustment 1.5 \
--yes | tx
```

### Instantiate CW20 Contract

```bash
cat << EOF | jq | tee instantiate.json
{
  "name": "UWaterloo Dank Coin",
  "symbol": "UWDANK",
  "decimals": 6,
  "initial_balances": [{
    "address": "$(nibid keys show validator -a)",
    "amount": "1000000000000"
  }],
  "mint": {
    "minter": "$(nibid keys show validator -a)",
    "cap": "1000000000000000000000"
  }
}
EOF


nibid tx wasm instantiate 1 "$(cat instantiate.json)" \
--label "uwaterloo-dank-coin" \
--no-admin \
--from validator \
--gas auto \
--gas-adjustment 1.5 \
--yes | tx
```

### Query CW20 Contract

```bash
CONTRACT_ADDRESS=nibi14hj2tavq8fpesdwxxcu44rty3hh90vhujrvcmstl4zr3txmfvw9ssa9gcs

# query token info
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
'{"token_info": {}}' | jq

# query minter
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
'{"minter": {}}' | jq

# query all accounts
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
'{"all_accounts": {}}' | jq

# query balance
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
"{\"balance\": { \"address\": \"$(nibid keys show validator -a)\"}}" | jq
```

### Execute CW20 Contract

```bash
CONTRACT_ADDRESS=nibi14hj2tavq8fpesdwxxcu44rty3hh90vhujrvcmstl4zr3txmfvw9ssa9gcs

# create new account
nibid keys add user1
USER_ADDRESS=$(nibid keys show user1 -a)

# transfer tokens
nibid tx wasm execute $CONTRACT_ADDRESS \
"{\"transfer\": {\"recipient\": \"$USER_ADDRESS\", \"amount\": \"420\" } }" \
--from validator \
--gas auto \
--gas-adjustment 1.5 \
--yes | tx

# query user balance
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
"{\"balance\": { \"address\": \"$USER_ADDRESS\"}}" | jq

# query all accounts
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
'{"all_accounts": {}}' | jq
```

## NFT (CW721) Contract Quickstart

### Compile CW721 Contract

```bash
cd contracts/cw721-base
RUSTFLAGS="-C link-arg=-s" cargo wasm

cp target/wasm32-unknown-unknown/release/cw721_base.wasm ../../artifacts/
```

### Upload CW721 Contract

```bash
nibid tx wasm store artifacts/cw721_base.wasm \
--from validator \
--gas auto \
--gas-adjustment 1.5 \
--yes | tx
```

### Instantiate CW721 Contract

```bash
cat << EOF | jq | tee instantiate.json
{
  "name": "UWaterloo Blockchain NFT",
  "symbol": "UW-NFT",
  "minter": "$(nibid keys show validator -a)"
}
EOF


nibid tx wasm instantiate 2 "$(cat instantiate.json)" \
--label "uwaterloo-nft" \
--no-admin \
--from validator \
--gas auto \
--gas-adjustment 1.5 \
--yes | tx
```

### Query CW721 Contract

```bash
CONTRACT_ADDRESS=nibi1nc5tatafv6eyq7llkr2gv50ff9e22mnf70qgjlv737ktmt4eswrqugq26k

# query contract info
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
'{"contract_info": {}}' | jq

# query number of tokens
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
'{"num_tokens": {}}' | jq

# query all tokens
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
'{"all_tokens": {}}' | jq

# query minter
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
'{"minter": {}}' | jq
```

### Execute CW721 Contract

```bash
CONTRACT_ADDRESS=nibi1nc5tatafv6eyq7llkr2gv50ff9e22mnf70qgjlv737ktmt4eswrqugq26k

# create new account
nibid keys add user1
USER_ADDRESS=$(nibid keys show user1 -a)

# mint NFT
nibid tx wasm execute $CONTRACT_ADDRESS \
"{\"mint\": { \"token_id\": \"goose\", \"owner\": \"$USER_ADDRESS\" } }" \
--from validator \
--gas auto \
--gas-adjustment 1.5 \
--yes | tx

# query user balance
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
"{\"tokens\": { \"owner\": \"$USER_ADDRESS\" } }" | jq

# query all accounts
nibid q wasm contract-state smart $CONTRACT_ADDRESS \
'{"all_tokens": {} }' | jq
```