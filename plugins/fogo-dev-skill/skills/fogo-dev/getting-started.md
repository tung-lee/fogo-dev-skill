# Getting Started with Fogo

## RPC Endpoints

| Network | URL |
|---------|-----|
| Testnet | `https://testnet.fogo.io` |
| Mainnet | `https://mainnet.fogo.io` |

For production, consider third-party providers like FluxRPC for higher throughput and gRPC streaming.

## Configure Solana CLI

Fogo is fully SVM-compatible. Point the standard Solana CLI at Fogo:

```bash
# Testnet
solana config set --url https://testnet.fogo.io

# Verify
solana cluster-version
solana balance
```

## Get Testnet Tokens

Faucet: https://faucet.fogo.io/

**Critical distinction:**
- **Native FOGO** — pays transaction fees (gas). You need this to deploy and transact.
- **SPL FOGO** — used within Fogo Sessions and DeFi protocols. Different from native FOGO.

Request native FOGO from the faucet first. If you need SPL FOGO for Sessions testing, the faucet provides that separately.

## Deploy with Anchor

Update `Anchor.toml`:

```toml
[provider]
cluster = "https://testnet.fogo.io"
wallet = "~/.config/solana/id.json"

[programs.testnet]
my_program = "YOUR_PROGRAM_ID"
```

Then build and deploy as normal:

```bash
anchor build
anchor deploy --provider.cluster https://testnet.fogo.io
```

For mainnet:

```bash
anchor deploy --provider.cluster https://mainnet.fogo.io
```

All Anchor features work unchanged — IDL generation, client libs, testing.

## Deploy with Solana CLI (Native)

```bash
solana program deploy target/deploy/my_program.so --url https://testnet.fogo.io
```

## Fogo Explorer

- **Fogoscan:** https://fogoscan.com
- Append `?cluster=testnet` for testnet transactions
- Supports transaction, account, and block inspection
- Open source: https://github.com/fogo-foundation/fogo-explorer

## Key Differences from Solana

| Aspect | Solana | Fogo |
|--------|--------|------|
| Block time | ~400ms | ~40ms |
| Finality | ~2-3s | ~1.3s |
| Validator client | Agave + Firedancer | Firedancer only |
| Validator set | Permissionless | Curated (approval required) |
| Sessions/Paymaster | Not native | Native (Fogo Sessions) |
| Program deployment | Same | Same (just different RPC) |

## Adjusting for Faster Block Times

Fogo's ~40ms block times mean:
- **Tighter confirmation polling** — reduce your polling interval
- **Faster retry logic** — don't wait as long between retries
- **Transaction landing** — txns confirm much faster; Solana-tuned timeouts are overly conservative

```typescript
// Solana-style (too conservative for Fogo)
const CONFIRMATION_TIMEOUT = 30_000; // 30s

// Fogo-adjusted
const CONFIRMATION_TIMEOUT = 5_000; // 5s is plenty
```

## JSON-RPC Access

Fogo supports standard Solana JSON-RPC methods:

```bash
# Check account info
curl -X POST https://testnet.fogo.io -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"getAccountInfo",
       "params":["<ADDRESS>",{"encoding":"jsonParsed"}]}'

# Get recent blockhash
curl -X POST https://testnet.fogo.io -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"getLatestBlockhash"}'

# Get transaction
curl -X POST https://testnet.fogo.io -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"getTransaction",
       "params":["<SIGNATURE>",{"encoding":"jsonParsed","maxSupportedTransactionVersion":0}]}'
```
