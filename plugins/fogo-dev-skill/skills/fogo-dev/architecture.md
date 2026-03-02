# Fogo Architecture

## Overview

Fogo is a purpose-built, high-performance Layer 1 blockchain for DeFi. It runs the Solana Virtual Machine (SVM) with a Firedancer-based validator client.

**Not** an L2, rollup, or sidechain — it's a separate L1 that shares Solana's execution environment.

## Core Architecture

### Firedancer Validator

Fogo's validator is a fork of Firedancer, the C-based high-performance Solana validator built by Jump Crypto. Key properties:

- Written in C for maximum performance
- Modular architecture (components: ballet, choreo, disco, flamenco, funk, groove, tango, waltz)
- Single validator client (no Agave multi-client like Solana)
- Inherits Solana's Proof of History (PoH), Tower BFT consensus, and Turbine block propagation

### Multi-Local Consensus

Fogo's key architectural innovation. Instead of globally distributed validators:

- Validators co-locate in geographic zones
- Zones rotate across epochs
- Minimizes network latency while maintaining decentralization
- Enables sub-100ms block times

### Performance

| Metric | Value |
|--------|-------|
| Block time | ~40ms (production), 20ms (devnet benchmarks) |
| Finality | ~1.3 seconds |
| Throughput | 45,000 TPS (devnet), peak 136,866 TPS recorded |
| Comparison | ~18x faster blocks than Solana, ~10x faster than Sui |

### Curated Validator Set

Unlike Solana's permissionless validation:
- Minimum stake thresholds required
- Approval process for new validators
- Deliberate trade-off: more centralized validator set → lower latency
- Target: institutional-grade, low-latency on-chain trading

## SVM Compatibility

Fogo runs the exact same SVM as Solana. This means:

- **Any Solana program deploys without code changes** — just point to Fogo RPC
- Standard Solana tooling works (CLI, Anchor, wallet adapters)
- SPL Token programs are forked from Solana's standard programs
- Same instruction format, account model, and program execution

The only things that differ are operational (RPC endpoints, block timing, validator set).

## Fogo Sessions (Chain-Native Primitive)

Fogo's main differentiator is Sessions — account abstraction + paymaster built into the chain:

- Users sign once with their wallet
- Ephemeral session key handles subsequent transactions
- Paymaster sponsors gas fees (gasless UX)
- Domain registry restricts sessions to specific programs

See [fogo-sessions.md](fogo-sessions.md) for integration details.

## Developer Implications

1. **Faster confirmation** — adjust polling/timeout to exploit ~40ms blocks
2. **Same toolchain** — Solana CLI, Anchor, web3.js/Kit all work
3. **Sessions for UX** — integrate Sessions for sign-once, gasless experience
4. **Native FOGO vs SPL FOGO** — understand the token distinction for fees vs DeFi
5. **Single client** — no multi-client edge cases (Firedancer only)

## Origins

- **Core team:** Douro Labs (creators of Pyth Network oracle)
- **Foundation:** Fogo Foundation (Cayman Islands, est. August 2025)
- **Funding:** $8M community raise (Jan 2025), $7M Binance token sale (Jan 2026)
- **Timeline:** Devnet (Jan 2025) → Testnet (Mar 2025) → Mainnet (Jan 2026)
