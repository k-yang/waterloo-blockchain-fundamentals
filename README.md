# waterloo-blockchain-fundamentals

[Slide Deck](https://docs.google.com/presentation/d/1-5zlushR_7ykjQcqkJotKxLTuGIIaatlDyOz-mqK9tc/edit?usp=sharing)

## Blockchain Quickstart

```bash
sh scripts/setup.sh

nibid start
```

## Contract Quickstart

### Install Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup default stable
rustup update stable
rustup target add wasm32-unknown-unknown
source "$HOME/.cargo/env
```

### Compile Contract

```bash
cd contracts/cw20-base
cargo wasm

cp target/wasm32-unknown-unknown/release/cw20_base.wasm ../../artifacts/
```