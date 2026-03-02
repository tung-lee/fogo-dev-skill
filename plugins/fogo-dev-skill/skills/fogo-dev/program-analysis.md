# Program Analysis & Reverse Engineering on Fogo

## Overview

Fogo runs the SVM, so all Solana program analysis techniques apply. This guide covers how to analyze unverified programs on the Fogo blockchain — programs without published IDLs that show as "Unknown" on Fogoscan.

## Step-by-Step Methodology

### 1. Start from an Address

Given a wallet or program address, open it on Fogoscan:
```
https://fogoscan.com/account/<ADDRESS>?cluster=testnet
```

Look for:
- **BPFLoaderUpgradeable `write`/`upgrade` transactions** — indicates program deployment
- **Program Account** — the deployed program ID
- **Program Data Account** — holds the compiled binary

### 2. Confirm the Program via RPC

```bash
curl -X POST https://testnet.fogo.io -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"getAccountInfo",
       "params":["<PROGRAM_ID>",{"encoding":"jsonParsed"}]}'
```

Check for:
- `executable: true`
- `owner: BPFLoaderUpgradeab1e`
- `programData` address in the parsed data

### 3. Identify the Framework

Look at the first 8 bytes of instruction data in recent transactions. If they look like Anchor discriminators (`sha256("global:method_name")[:8]`), the program uses Anchor.

### 4. Fetch All Program Accounts

```bash
curl -X POST https://testnet.fogo.io -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"getProgramAccounts",
       "params":["<PROGRAM_ID>",
                 {"encoding":"base64","dataSlice":{"offset":0,"length":8}}]}'
```

Using `dataSlice` with `length: 8` fetches only the discriminator (first 8 bytes) of each account. Group by discriminator to identify account types:

```python
from collections import Counter
# Parse response, group by first 8 bytes
discriminators = Counter()
for account in response["result"]:
    data = base64.b64decode(account["account"]["data"][0])
    disc = data[:8].hex()
    discriminators[disc] += 1

for disc, count in discriminators.most_common():
    print(f"{disc} | {count} accounts")
```

### 5. Brute-Force Anchor Discriminators

Anchor generates deterministic discriminators:
- **Accounts:** `sha256("account:TypeName")[:8]`
- **Instructions:** `sha256("global:method_name")[:8]`

Brute-force with common names:

```python
import hashlib

# Common Solana account type names
account_names = [
    "GlobalState", "Config", "Pool", "PlayerState", "User",
    "Vault", "Stake", "Position", "Order", "Market",
    "Metadata", "Collection", "Treasury", "Escrow", "Auction",
    "DifficultyTracker", "ReferrerInfo", "MintRecord",
    # Add domain-specific guesses...
]

observed = {"a32e4aa8d87b8562", "9b0caae01efacc82", ...}  # from step 4

for name in account_names:
    disc = hashlib.sha256(f"account:{name}".encode()).hexdigest()[:16]
    if disc in observed:
        print(f"MATCH: account:{name} -> {disc}")
```

Same for instructions:
```python
instruction_names = [
    "initialize", "transfer", "close", "update",
    "cast_line", "process_fish", "record_catch",  # domain-specific
    # ...
]

for name in instruction_names:
    disc = hashlib.sha256(f"global:{name}".encode()).hexdigest()[:16]
    if disc in observed_instruction_discs:
        print(f"MATCH: global:{name} -> {disc}")
```

### 6. Extract Strings from the Binary

The program data account holds the compiled BPF ELF binary with a 45-byte header:

```python
import base64, struct

# Fetch the program data account (full data)
response = rpc_call("getAccountInfo", [
    "<PROGRAM_DATA_ADDRESS>",
    {"encoding": "base64"}
])

data = base64.b64decode(response["result"]["value"]["data"][0])
elf_binary = data[45:]  # Skip the 45-byte header

# Extract printable ASCII strings (4+ chars)
strings = []
current = ""
for byte in elf_binary:
    if 32 <= byte < 127:
        current += chr(byte)
    else:
        if len(current) >= 4:
            strings.append(current)
        current = ""

print(f"Found {len(strings)} strings")
```

Strings typically reveal:
- **Source file paths** (e.g., `programs/my_program/src/lib.rs`)
- **Instruction names** as log messages (e.g., `Instruction: InitializePlayer`)
- **Error messages** revealing business logic
- **PDA seed strings** (e.g., `"global-state"`, `"difficulty-tracker"`)
- **Hardcoded addresses** (treasuries, mints)

### 7. Decode Account Data

Once you know the account type and approximate structure:

```python
import struct

data = fetch_account_data("<ACCOUNT_ADDRESS>")

# Anchor account layout
discriminator = data[0:8]
pubkey_1 = base58_encode(data[8:40])    # First pubkey field
pubkey_2 = base58_encode(data[40:72])   # Second pubkey field
value_u64 = struct.unpack("<Q", data[72:80])[0]  # Little-endian u64
flag_u8 = data[80]                      # Single byte flag
bump = data[-1]                         # Bump seed (usually last byte)
```

### 8. Analyze Transaction History

```bash
# Get recent signatures
curl -X POST https://testnet.fogo.io -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"getSignaturesForAddress",
       "params":["<PROGRAM_ID>",{"limit":50}]}'

# Get full transaction
curl -X POST https://testnet.fogo.io -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"getTransaction",
       "params":["<SIGNATURE>",{"encoding":"jsonParsed","maxSupportedTransactionVersion":0}]}'
```

Map instruction discriminators from transactions to the names found via brute-forcing and string extraction.

## Tips

- **Most common account type** is often mint records, player states, or positions
- **Singleton accounts** (1 instance) are usually global state, config, or protocol settings
- **Variable-size accounts** often contain vectors or dynamic-length data
- **Error messages** are the richest source of business logic insight
- **PDA seeds** in strings reveal the program's address derivation scheme
- Fogo's 40ms block times mean more transactions to analyze in the same time window

## Tools

- **Fogoscan:** https://fogoscan.com — block explorer
- **Solana JSON-RPC:** all standard methods work on Fogo RPC endpoints
- **Python + hashlib:** for discriminator brute-forcing
- **curl / httpie:** for RPC calls
- Standard binary analysis tools (strings, hexdump, readelf) work on the BPF ELF

