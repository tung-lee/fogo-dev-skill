# Fogo DeFi Ecosystem

## Overview

Fogo's DeFi ecosystem includes DEXes, lending protocols, and liquid staking. Most protocols offer TypeScript SDKs via npm.

---

## Valiant Trade (DEX)

**What:** High-performance spot DEX combining concentrated liquidity AMM (Vortex) and on-chain central limit order book, with native bridging and token launchpad.

**SDK:**
```bash
npm install @valiant-trade/vortex
```

The `@valiant-trade/vortex` SDK provides TypeScript interfaces for:
- Creating and managing concentrated liquidity pools
- Adding/removing liquidity positions
- Performing swaps
- Supports Fogo testnet and mainnet

**Docs:** https://docs.valiant.trade/

---

## Pyron Finance (Lending/Borrowing)

**What:** Lending and borrowing protocol ("asset productivity layer"). Supply assets into pools for interest, or borrow against collateral with real-time interest accrual.

**SDK:**
```bash
npm install @pyron-finance/pyron-client
```

The `@pyron-finance/pyron-client` SDK supports:
- Account creation
- Deposits (supply assets)
- Borrowing against collateral
- Repaying loans
- Withdrawals

**GitHub:** https://github.com/Pyron-Finance/ (repos currently private)

**Docs:** https://docs.pyron.fi/

---

## Brasa Finance (Liquid Staking)

**What:** Liquid staking protocol. Stake FOGO → receive stFOGO (SPL token, transferable, usable across DeFi while earning staking rewards).

**SDKs:**
```bash
# TypeScript
npm install @firstset/spl-stake-pool

# Rust CLI
cargo install --path clients/cli --locked

# Python bindings also available
```

**Mainnet Addresses:**

| Component | Address |
|-----------|---------|
| Stake Pool Program | `SPoo1G3scVhcVWK8RHF2GhauFgbg3aiPNeU5d5Adr8D` |
| Brasa Pool | `4z6piA8DWGfbZge1xkwtkczpZEMsgReNh5AsCKZUQE9X` |
| stFOGO Mint | `Brasa3xzkSC9XqMBEcN9v53x4oMkpb1nQwfaGMyJE88b` |

**Testnet Addresses:**

| Component | Address |
|-----------|---------|
| Stake Pool Program | `SPRe2ae9JQhySheYsSANX6M8tUZLt5bQonnBJ6Wu6Ud` |
| Brasa Pool | `4yoj9HDiL2pujuh2ME5MJJ6roLseTAkFqLmA4SrG7Yi9` |
| stFOGO Mint | `6FzCV3CDRh7fkxdsJgevtVxU9t5bZ6jiJVYUNCk8eVU7` |

**Session-compatible CLI:**
```bash
# Deposit with Fogo Sessions (gasless)
spl-stake-pool --url https://testnet.fogo.io deposit-wsol-with-session <POOL> <AMOUNT>

# Withdraw with Fogo Sessions
spl-stake-pool --url https://testnet.fogo.io withdraw-wsol-with-session <POOL> <AMOUNT>
```

**Open source:** https://github.com/Firstset/stake-pool-fogo (Apache 2.0, audited by Neodyme)

**Docs:** https://docs.brasa.finance/

---

## Ignition Fi (Stake Pool)

**What:** SPL Stake Pool program for pooled staking. Users pool stake accounts and receive liquid tokens representing their share.

| Detail | Value |
|--------|-------|
| Program ID | `SP1s4uFeTAX9jsXXmwyDs1gxYYf7cdDZ8qHUHVxE1yr` |
| Max fee increase | 3/2 ratio per epoch |
| Batch limit | 4 validators per update instruction |

**SDKs:**
- Rust: `spl-stake-pool` crate (crates.io)
- TypeScript: compatible with `@igneous-labs/stake-pool-sdk` patterns
- Python bindings available

**App:** https://app.ignitionfi.xyz/

**Docs:** https://docs.ignitionfi.xyz/

---

## FogoLend (Lending/Borrowing)

**What:** Decentralized lending and borrowing. Deposit crypto to earn yield or borrow against collateral with competitive rates.

**Status:** Limited public developer tooling as of March 2026.
- No public SDK packages on npm or crates.io
- No published program IDs
- User-facing docs only

**Testnet:** https://fogolend.com/markets/testnet
**Supported test tokens:** USDC, SOL, BTC, ETH, USDT

**Docs:** https://docs.fogolend.com/

---

## Developer Readiness Comparison

| Protocol | Type | TS SDK | Rust SDK | Program IDs | Open Source |
|----------|------|--------|----------|-------------|-------------|
| Valiant | DEX | `@valiant-trade/vortex` | — | — | No |
| Pyron | Lending | `@pyron-finance/pyron-client` | — | — | No |
| Brasa | Staking | `@firstset/spl-stake-pool` | CLI | Published | Yes (Apache) |
| Ignition | Staking | Compatible | `spl-stake-pool` | Published | Partial |
| FogoLend | Lending | — | — | — | No |

**Brasa** is the most developer-friendly: open source, multi-language SDKs, published addresses, security audit.
