# fogo-dev-skill

Claude Code skill for Fogo blockchain development (Mar 2026 best practices).

Gives Claude deep expertise in Fogo's unique features — Sessions, fast finality, DeFi ecosystem, and program analysis — while referencing [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill) for base SVM knowledge (Anchor, Pinocchio, testing).

## Install

### Claude Code Marketplace (Recommended)

```bash
claude plugin marketplace add https://github.com/tung-lee/fogo-dev-skill
claude plugin install fogo-dev-skill
```

Or inside Claude Code interactive mode:
```
/plugin marketplace add https://github.com/tung-lee/fogo-dev-skill
/plugin install fogo-dev-skill
```

### npx skills

```bash
npx skills add https://github.com/tung-lee/fogo-dev-skill
```

### Manual

```bash
git clone https://github.com/tung-lee/fogo-dev-skill.git
cd fogo-dev-skill
./install.sh                # Personal (~/.claude/skills/fogo-dev)
./install.sh --project      # Project-scoped (.claude/skills/fogo-dev)
```

## Companion Skill

This skill focuses on Fogo-specific topics. For base SVM development (Anchor programs, Pinocchio, testing frameworks, security patterns), install the Solana skill too:

```bash
npx skills add https://github.com/solana-foundation/solana-dev-skill
```

## Skill Structure

```
skill/
├── SKILL.md                  # Entry point — task classification & defaults
├── getting-started.md        # RPC setup, CLI config, faucet, first deploy
├── architecture.md           # Firedancer, multi-local consensus, 40ms blocks
├── fogo-sessions.md          # Sessions TypeScript & React SDK
├── fogo-sessions-onchain.md  # Sessions Rust SDK for on-chain programs
├── tokens-and-staking.md     # Native FOGO vs SPL FOGO, Brasa, Ignition
├── defi-ecosystem.md         # Valiant, Pyron, Brasa, Ignition, FogoLend
├── program-analysis.md       # Reverse engineering unverified programs
├── common-errors.md          # Fogo-specific pitfalls & solutions
└── resources.md              # Curated links to docs, SDKs, tools
```

## What's Covered

| Topic | File | Description |
|-------|------|-------------|
| Getting Started | `getting-started.md` | RPC endpoints, Solana CLI config, Anchor deploy, faucet |
| Architecture | `architecture.md` | Firedancer, multi-local consensus, 40ms blocks, curated validators |
| Sessions (Client) | `fogo-sessions.md` | TypeScript SDK, React SDK, FogoSessionProvider, useSession |
| Sessions (On-chain) | `fogo-sessions-onchain.md` | Rust SDK, dual-path signer, program signer PDA |
| Tokens | `tokens-and-staking.md` | Native FOGO vs SPL FOGO, stFOGO liquid staking |
| DeFi | `defi-ecosystem.md` | Valiant DEX, Pyron lending, Brasa staking, Ignition, FogoLend |
| Program Analysis | `program-analysis.md` | Reverse engineering, discriminator brute-forcing, binary analysis |
| Troubleshooting | `common-errors.md` | Wrong RPC, token confusion, session errors, timeouts |
| Resources | `resources.md` | All docs, SDKs, repos, ecosystem links |

## Default Stack Decisions

| Layer | Choice | Rationale |
|-------|--------|-----------|
| Network | Fogo testnet → mainnet | SVM-compatible, 40ms blocks |
| RPC | Official endpoints | `testnet.fogo.io` / `mainnet.fogo.io` |
| Programs | Anchor (Rust) | Same as Solana, deploys unchanged |
| Frontend | framework-kit + Sessions React SDK | Gasless sign-once UX |
| Staking | Brasa (stFOGO) | Open source, audited, most dev-friendly |
| DEX | Valiant | Concentrated liquidity + order book |

## Content Sources

- [Fogo Documentation](https://docs.fogo.io/)
- [Fogo Sessions SDK](https://github.com/fogo-foundation/fogo-sessions)
- [Brasa Finance](https://github.com/Firstset/stake-pool-fogo)
- [Valiant Trade Docs](https://docs.valiant.trade/)
- [Pyron Finance Docs](https://docs.pyron.fi/)
- [Ignition Fi Docs](https://docs.ignitionfi.xyz/)
- [FogoLend Docs](https://docs.fogolend.com/)
## License

MIT
