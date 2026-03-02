---
name: fogo-dev
description: >
  End-to-end Fogo blockchain development playbook (Mar 2026).
  Covers Fogo Sessions, deployment, DeFi ecosystem, program analysis,
  and SVM-compatible development on the fastest L1.
  Companion to solana-dev-skill for base SVM knowledge.
user-invocable: true
---

# Fogo Development Skill

Fogo is a high-performance L1 blockchain built on the Solana Virtual Machine (SVM) with Firedancer.
~40ms block times, ~1.3s finality, full Solana compatibility. Any Solana program deploys on Fogo without code changes.

## Task Classification

1. **Deployment / Getting Started** → [getting-started.md](getting-started.md)
2. **Fogo Sessions (client)** → [fogo-sessions.md](fogo-sessions.md)
3. **Fogo Sessions (on-chain)** → [fogo-sessions-onchain.md](fogo-sessions-onchain.md)
4. **Architecture / Consensus** → [architecture.md](architecture.md)
5. **Tokens / Staking** → [tokens-and-staking.md](tokens-and-staking.md)
6. **DeFi Protocols** → [defi-ecosystem.md](defi-ecosystem.md)
7. **Program Analysis / Reverse Engineering** → [program-analysis.md](program-analysis.md)
8. **Troubleshooting** → [common-errors.md](common-errors.md)
9. **Links & Resources** → [resources.md](resources.md)
10. **On-chain programs (Anchor/Pinocchio)** → use **solana-dev-skill**
11. **Testing (LiteSVM/Mollusk/Surfpool)** → use **solana-dev-skill**

## Default Stack

| Layer | Default | Why |
|-------|---------|-----|
| Network | Fogo testnet → mainnet | SVM-compatible, 40ms blocks |
| RPC | `https://testnet.fogo.io` / `https://mainnet.fogo.io` | Official endpoints |
| CLI | Solana CLI pointed at Fogo RPC | Full compatibility |
| Programs | Anchor (Rust) | Same as Solana, deploy unchanged |
| Frontend | framework-kit + `@fogo/sessions-sdk-react` | Gasless UX via Sessions |
| UX Pattern | Fogo Sessions (sign-once, gasless) | Main differentiator |
| Explorer | fogoscan.com | Fogo block explorer |
| Staking | Brasa (stFOGO) or Ignition | Liquid staking options |

## Operating Procedure

1. **Classify** the task using the table above
2. **Load** the relevant child document(s)
3. **Check** if base SVM knowledge is needed → reference solana-dev-skill
4. **Implement** with Fogo-specific considerations:
   - Use Fogo RPC endpoints (not Solana)
   - Integrate Sessions for gasless UX where applicable
   - Account for faster block times (~40ms vs ~400ms)
   - Distinguish native FOGO (fees) from SPL FOGO (Sessions/DeFi)
5. **Test** on Fogo testnet first (faucet at https://faucet.fogo.io/)
6. **Deliver** with files changed, commands to run, and risk notes
