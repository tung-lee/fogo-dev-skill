# Common Errors on Fogo

## Wrong RPC Endpoint

**Symptom:** Transactions fail, account not found, or you're seeing Solana mainnet data.

**Cause:** CLI or code still pointed at a Solana RPC instead of Fogo.

**Fix:**
```bash
# Check current config
solana config get

# Should show Fogo, not Solana
solana config set --url https://testnet.fogo.io
```

In code:
```typescript
// Wrong
const connection = new Connection("https://api.mainnet-beta.solana.com");

// Correct
const connection = new Connection("https://mainnet.fogo.io");
```

---

## Native FOGO vs SPL FOGO Confusion

**Symptom:** "Insufficient funds" when you know you have FOGO, or Sessions don't work despite having a balance.

**Cause:** You have native FOGO but need SPL FOGO (or vice versa).

**Fix:** Check both balances:
```bash
# Native FOGO (for fees)
solana balance --url https://testnet.fogo.io

# SPL FOGO (for Sessions/DeFi) — check token accounts
solana account <YOUR_ASSOCIATED_TOKEN_ACCOUNT> --url https://testnet.fogo.io
```

Request the correct type from the faucet: https://faucet.fogo.io/

---

## Session Expired (Error 4000000000)

**Symptom:** Session transaction fails with error code `4000000000`.

**Cause:** The session has expired (time limit reached).

**Fix:**
```typescript
try {
  await session.sendTransaction([instruction]);
} catch (error) {
  if (error.code === 4000000000) {
    const newSession = await replaceSession({ wallet, connection, network, tokens });
  }
}
```

---

## Session Limits Exceeded (Error 4000000008)

**Symptom:** Session transaction fails with error code `4000000008`.

**Cause:** Token transfer limits for this session have been exhausted.

**Fix:** Create a new session with higher limits, or prompt the user to approve a new session:
```typescript
const newSession = await establishSession({
  wallet, connection, network,
  tokens: ["FOGO", "USDC"],
  enableUnlimited: true, // or increase bounded limits
});
```

---

## Over-Conservative Timeouts

**Symptom:** Code works but feels slow, or transactions "timeout" when they already confirmed.

**Cause:** Using Solana-tuned timeout/retry values (~30s confirmation, long polling intervals).

**Fix:** Fogo has ~40ms blocks and ~1.3s finality. Adjust accordingly:
```typescript
// Solana-tuned (too slow for Fogo)
const TIMEOUT = 30_000;
const POLL_INTERVAL = 2_000;

// Fogo-tuned
const TIMEOUT = 5_000;
const POLL_INTERVAL = 200;
```

---

## Faucet Token Type Confusion

**Symptom:** Requested tokens from faucet but still can't pay fees or use Sessions.

**Cause:** The faucet provides multiple token types. Native FOGO, SPL FOGO, and test tokens are separate.

**Fix:** Use the faucet UI carefully — select "Native FOGO" for transaction fees. For Sessions testing, also request SPL FOGO.

---

## Program Not Found on Fogo Explorer

**Symptom:** Your program shows as "Unknown" on Fogoscan with no decoded instructions.

**Cause:** The IDL hasn't been published on-chain.

**Fix:** Publish your Anchor IDL:
```bash
anchor idl init <PROGRAM_ID> --filepath target/idl/my_program.json --provider.cluster https://testnet.fogo.io
```

Or for updates:
```bash
anchor idl upgrade <PROGRAM_ID> --filepath target/idl/my_program.json --provider.cluster https://testnet.fogo.io
```

---

## Transaction Already Processed

**Symptom:** `Transaction already processed` error when retrying.

**Cause:** Fogo's fast block times mean your transaction already landed before the retry.

**Fix:** Check confirmation status before retrying:
```typescript
const status = await connection.getSignatureStatus(signature);
if (status?.value?.confirmationStatus === "confirmed") {
  // Already confirmed, no retry needed
}
```

---

## Anchor Deploy Fails

**Symptom:** `anchor deploy` fails or hangs.

**Cause:** Usually wrong RPC endpoint or insufficient native FOGO for deployment fees.

**Fix:**
1. Verify RPC: `anchor deploy --provider.cluster https://testnet.fogo.io`
2. Check balance: `solana balance --url https://testnet.fogo.io`
3. Get more FOGO from faucet if needed
