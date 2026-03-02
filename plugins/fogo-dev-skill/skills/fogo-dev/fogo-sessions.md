# Fogo Sessions — TypeScript & React Integration

## What Are Sessions?

Fogo Sessions enable users to interact with dApps without paying gas or signing every transaction. The user signs once with their wallet; an ephemeral session key handles the rest, sponsored by a paymaster.

## Architecture

Four on-chain programs work together:

1. **Session Manager** — creates, validates, and revokes session accounts
2. **Domain Registry** — restricts sessions to specific program IDs per domain
3. **Tollbooth** — paymaster/fee management, sponsors gas for session transactions
4. **Intent Transfer** — routes intent-based transfers within sessions

**Flow:**
```
User connects wallet → signs once → SDK generates ephemeral session key
→ session key signs subsequent txns → paymaster pays gas → user pays nothing
```

## TypeScript SDK

```bash
npm install @fogo/sessions-sdk
```

### Core Lifecycle

```typescript
import {
  establishSession,
  reestablishSession,
  replaceSession,
  revokeSession,
} from "@fogo/sessions-sdk";

// Establish a new session
const session = await establishSession({
  wallet,          // Solana wallet adapter
  connection,      // @solana/web3.js Connection to Fogo RPC
  network: "testnet", // or "mainnet"
  tokens: ["FOGO", "USDC"],  // tokens the session can use
  enableUnlimited: false,     // bounded limits recommended
});

// Send a transaction through the session
const signature = await session.sendTransaction([instruction1, instruction2]);

// End the session
await revokeSession(session);
```

### Session Object API

```typescript
session.sendTransaction(instructions)     // Send txn via session key
session.getSessionWrapInstructions()      // Get wrap instructions
session.getSessionUnwrapInstructions()    // Get unwrap instructions
session.walletPublicKey                   // Original wallet pubkey
session.sessionKey                        // Ephemeral session pubkey
session.payer                             // Paymaster payer
```

### Reestablish / Replace

```typescript
// Reconnect to existing session (e.g., page reload)
const session = await reestablishSession({ wallet, connection, network });

// Replace expired session with new one
const newSession = await replaceSession({ wallet, connection, network, tokens });
```

## React SDK

```bash
npm install @fogo/sessions-sdk-react
```

### Provider Setup

```tsx
import { FogoSessionProvider } from "@fogo/sessions-sdk-react";

function App() {
  return (
    <FogoSessionProvider
      network="testnet"
      tokens={["FOGO", "USDC"]}
      enableUnlimited={false}
    >
      <MyApp />
    </FogoSessionProvider>
  );
}
```

### useSession Hook

```tsx
import { useSession, isEstablished } from "@fogo/sessions-sdk-react";

function GameComponent() {
  const session = useSession();

  if (!isEstablished(session)) {
    return <SessionButton />; // Built-in connect + establish UI
  }

  const handleAction = async () => {
    const sig = await session.sendTransaction([gameInstruction]);
    console.log("Confirmed:", sig);
  };

  return (
    <div>
      <p>Wallet: {session.walletPublicKey.toBase58()}</p>
      <p>Session: {session.sessionKey.toBase58()}</p>
      <button onClick={handleAction}>Play</button>
      <button onClick={() => session.endSession()}>End Session</button>
    </div>
  );
}
```

### State Machine

The SDK manages session lifecycle states:

```
Disconnected → Wallet Selected → Establishing → Active → Expired/Revoked
                                                   ↑          ↓
                                                   ← Reestablish ←
```

## Best Practices

1. **Use bounded token limits** — don't enable unlimited unless necessary; users trust bounded sessions more
2. **Unwrap FOGO at transaction end** — always include unwrap instructions to return unused FOGO
3. **Use `variation` hints** — helps paymaster filter match when multiple paymasters exist
4. **Handle error codes:**
   - `4000000000` — session expired, prompt reestablish
   - `4000000008` — token limits exceeded, prompt new session with higher limits
5. **Register your domain** — register with the paymaster's domain registry so sessions work with your program
6. **Prefer `reestablishSession` on page reload** — avoids forcing users to sign again

## Error Handling

```typescript
try {
  await session.sendTransaction([instruction]);
} catch (error) {
  if (error.code === 4000000000) {
    // Session expired — reestablish
    const newSession = await replaceSession({ wallet, connection, network, tokens });
  } else if (error.code === 4000000008) {
    // Limits exceeded — new session with higher limits
  }
}
```
