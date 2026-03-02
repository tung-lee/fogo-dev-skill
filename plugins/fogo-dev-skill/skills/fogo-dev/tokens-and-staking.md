# Tokens & Staking on Fogo

## Token Model

### Native FOGO vs SPL FOGO

This is the most common source of confusion for new Fogo developers:

| Type | Purpose | How to Get |
|------|---------|------------|
| **Native FOGO** | Pays transaction fees (gas) | Faucet, bridges |
| **SPL FOGO** | Used in Fogo Sessions, DeFi protocols | Faucet (separate request), wrapping |

**Native FOGO** is like SOL on Solana — it's the base currency for fees.
**SPL FOGO** is a token (like WSOL) used within Sessions for gasless transactions and DeFi.

When using the faucet (https://faucet.fogo.io/), make sure you request the right type.

## SPL Token Programs

Fogo forks the standard Solana SPL Token programs:

- **Token Program** — standard token operations (mint, transfer, burn)
- **Associated Token Account** — deterministic token account addresses

These are source-level forks from Solana's SPL. Behavior is identical.

GitHub:
- https://github.com/fogo-foundation/token
- https://github.com/fogo-foundation/associated-token-account

## Liquid Staking

### Brasa Finance (stFOGO)

Brasa is the primary liquid staking protocol. Stake FOGO → receive stFOGO (transferable, usable in DeFi).

**SDKs:**
```bash
# TypeScript
npm install @firstset/spl-stake-pool

# Rust CLI
cargo install --path clients/cli --locked
```

**Mainnet Program IDs:**

| Component | Address |
|-----------|---------|
| SPL Stake Pool Program | `SPoo1G3scVhcVWK8RHF2GhauFgbg3aiPNeU5d5Adr8D` |
| Brasa Pool | `4z6piA8DWGfbZge1xkwtkczpZEMsgReNh5AsCKZUQE9X` |
| stFOGO Mint | `Brasa3xzkSC9XqMBEcN9v53x4oMkpb1nQwfaGMyJE88b` |

**Testnet Program IDs:**

| Component | Address |
|-----------|---------|
| SPL Stake Pool Program | `SPRe2ae9JQhySheYsSANX6M8tUZLt5bQonnBJ6Wu6Ud` |
| Brasa Pool | `4yoj9HDiL2pujuh2ME5MJJ6roLseTAkFqLmA4SrG7Yi9` |
| stFOGO Mint | `6FzCV3CDRh7fkxdsJgevtVxU9t5bZ6jiJVYUNCk8eVU7` |

**Session-compatible operations:**
```bash
# Deposit with Fogo Sessions
spl-stake-pool --url https://testnet.fogo.io deposit-wsol-with-session <POOL_ADDR> <AMOUNT>

# Withdraw with Fogo Sessions
spl-stake-pool --url https://testnet.fogo.io withdraw-wsol-with-session <POOL_ADDR> <AMOUNT>
```

Open source (Apache 2.0, audited by Neodyme): https://github.com/Firstset/stake-pool-fogo

### Ignition Fi (Stake Pool)

SPL Stake Pool program for pooled staking:

| Detail | Value |
|--------|-------|
| Program ID | `SP1s4uFeTAX9jsXXmwyDs1gxYYf7cdDZ8qHUHVxE1yr` |
| Max fee increase ratio | 3/2 per epoch |
| Batch limit | 4 validators per update instruction |

Compatible with standard SPL stake pool SDKs:
- Rust: `spl-stake-pool` crate (crates.io)
- TypeScript: `@igneous-labs/stake-pool-sdk` compatible patterns

App: https://app.ignitionfi.xyz/
