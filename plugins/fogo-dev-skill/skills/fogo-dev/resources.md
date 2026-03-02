# Fogo Developer Resources

## Official Documentation

- [Fogo Docs](https://docs.fogo.io/) — main documentation portal
- [Architecture](https://docs.fogo.io/architecture.html) — consensus, Firedancer, multi-local zones
- [Building on Fogo](https://docs.fogo.io/user-guides/building-on-fogo.html) — deployment guide
- [Using Solana Tools](https://docs.fogo.io/user-guides/using-solana-tools.html) — CLI/Anchor compatibility
- [Fogo Sessions](https://docs.fogo.io/fogo-sessions.html) — session architecture overview
- [Integrating Sessions](https://docs.fogo.io/user-guides/integrating-fogo-sessions.html) — React SDK setup
- [Getting Testnet Tokens](https://docs.fogo.io/user-guides/getting-testnet-tokens.html) — faucet usage
- [Running a Node](https://docs.fogo.io/user-guides/running-a-node.html) — validator setup
- [Community Docs](https://community-docs.fogo.io) — community-maintained portal

## RPC Endpoints

- **Testnet:** `https://testnet.fogo.io`
- **Mainnet:** `https://mainnet.fogo.io`
- **Third-party (production):** FluxRPC (gRPC streaming, higher throughput)

## Faucet

- https://faucet.fogo.io/ — native FOGO, SPL FOGO, test tokens

## Explorer

- [Fogoscan](https://fogoscan.com) — block explorer
- [Fogoscan Testnet](https://fogoscan.com/?cluster=testnet)
- [Explorer Source](https://github.com/fogo-foundation/fogo-explorer) — MIT, open source

## SDKs — Fogo Sessions

| Package | Registry | Purpose |
|---------|----------|---------|
| `@fogo/sessions-sdk` | npm | Core TypeScript SDK |
| `@fogo/sessions-sdk-web` | npm | Framework-agnostic web integration |
| `@fogo/sessions-sdk-react` | npm | React hooks and components |
| `fogo-sessions-sdk` | crates.io | Rust SDK for on-chain programs |

- [Sessions Repo](https://github.com/fogo-foundation/fogo-sessions) — source code, IDLs, examples

## SDKs — DeFi Ecosystem

| Package | Registry | Protocol |
|---------|----------|----------|
| `@valiant-trade/vortex` | npm | Valiant DEX (concentrated liquidity) |
| `@pyron-finance/pyron-client` | npm | Pyron lending/borrowing |
| `@firstset/spl-stake-pool` | npm | Brasa liquid staking |
| `spl-stake-pool` | crates.io | Ignition stake pool (Rust) |

## DeFi Protocol Docs

- [Valiant Trade](https://docs.valiant.trade/) — DEX (AMM + CLOB)
- [Pyron Finance](https://docs.pyron.fi/) — lending/borrowing
- [Brasa Finance](https://docs.brasa.finance/) — liquid staking (stFOGO)
- [Ignition Fi](https://docs.ignitionfi.xyz/) — stake pools
- [FogoLend](https://docs.fogolend.com/) — lending/borrowing

## GitHub Repositories

- [fogo-foundation](https://github.com/fogo-foundation) — organization
- [fogo](https://github.com/fogo-foundation/fogo) — core validator (Firedancer fork)
- [fogo-sessions](https://github.com/fogo-foundation/fogo-sessions) — sessions SDK
- [fogo-explorer](https://github.com/fogo-foundation/fogo-explorer) — block explorer
- [token](https://github.com/fogo-foundation/token) — SPL Token fork
- [associated-token-account](https://github.com/fogo-foundation/associated-token-account) — ATA fork
- [sessions-example](https://github.com/fogo-foundation/sessions-example) — Next.js example
- [sessions-example-vite](https://github.com/fogo-foundation/sessions-example-vite) — Vite example
- [stake-pool-fogo (Brasa)](https://github.com/Firstset/stake-pool-fogo) — liquid staking

## Ecosystem Integrations

- [Pyth Lazer](https://pyth.network/) — financial oracle
- [Wormhole](https://wormhole.com/) — cross-chain bridge
- [Metaplex](https://metaplex.com/) — token/NFT standards
- [Squads](https://squads.so/) — multisig wallet
- [Goldsky](https://goldsky.com/) — indexer
- [FluxRPC](https://fluxrpc.com/) — RPC infrastructure
- [Birdeye](https://birdeye.so/) — token analytics

## Companion Skill

For base SVM development (Anchor, Pinocchio, testing, security):
- [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill) — Solana development playbook
