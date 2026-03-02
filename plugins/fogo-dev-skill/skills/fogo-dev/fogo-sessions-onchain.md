# Fogo Sessions — On-Chain Program Integration (Rust)

## Overview

To make your on-chain program compatible with Fogo Sessions, use the `fogo-sessions-sdk` Rust crate. It allows your program to transparently handle both direct wallet signers and session keys.

## Installation

```toml
# Cargo.toml
[dependencies]
fogo-sessions-sdk = "0.1"
```

## Core Pattern: Dual-Path Signer

Your program should accept both direct wallet signatures and session-based signatures:

```rust
use fogo_sessions_sdk::Session;

pub fn process_instruction(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8],
) -> ProgramResult {
    let signer_or_session = &accounts[0];

    // Transparently handles both direct signers and session keys
    let user = Session::extract_user_from_signer_or_session(
        signer_or_session,
        program_id,
    )?;

    // `user` is the original wallet pubkey regardless of signing method
    msg!("User: {}", user);

    Ok(())
}
```

## Anchor Pattern

```rust
use anchor_lang::prelude::*;
use fogo_sessions_sdk::Session;

#[derive(Accounts)]
pub struct GameAction<'info> {
    /// The signer — either the user's wallet directly or a session key
    pub signer_or_session: Signer<'info>,

    /// Optional: program signer PDA for session token transfers
    /// CHECK: validated by session SDK
    pub program_signer: Option<AccountInfo<'info>>,

    #[account(mut)]
    pub player_state: Account<'info, PlayerState>,
}

pub fn game_action(ctx: Context<GameAction>) -> Result<()> {
    let user = Session::extract_user_from_signer_or_session(
        &ctx.accounts.signer_or_session,
        ctx.program_id,
    )?;

    // Verify the player state belongs to this user
    require_keys_eq!(ctx.accounts.player_state.owner, user);

    // Your game logic here...

    Ok(())
}
```

## Program Signer PDA

When a session needs to transfer tokens on behalf of the user, it uses a program signer PDA:

```rust
// Seed for the program signer PDA
const PROGRAM_SIGNER_SEED: &[u8] = b"fogo_session_program_signer";

// Derive the PDA
let (program_signer, bump) = Pubkey::find_program_address(
    &[PROGRAM_SIGNER_SEED],
    program_id,
);
```

## Token Transfers in Sessions

The SDK provides drop-in replacements for SPL token instructions that work with sessions:

```rust
use fogo_sessions_sdk::{transfer, transfer_checked, burn, burn_checked};

// For session-based transfers, use invoke_signed with the program signer PDA
fn transfer_with_session(
    accounts: &TransferAccounts,
    amount: u64,
    is_session: bool,
) -> ProgramResult {
    if is_session {
        // Session path: invoke_signed with program signer PDA
        let signer_seeds = &[PROGRAM_SIGNER_SEED, &[bump]];
        invoke_signed(
            &transfer(source, destination, authority, amount)?,
            &[source_info, dest_info, authority_info],
            &[signer_seeds],
        )
    } else {
        // Direct wallet path: plain invoke
        invoke(
            &spl_token::instruction::transfer(
                &spl_token::id(), source, destination, authority, &[], amount,
            )?,
            &[source_info, dest_info, authority_info],
        )
    }
}
```

## Checking if Session

```rust
use fogo_sessions_sdk::is_session;

let signer = &ctx.accounts.signer_or_session;

if is_session(signer) {
    // Session key is signing — use invoke_signed for token ops
} else {
    // Direct wallet — use plain invoke
}
```

## Domain Registration

For your program to work with Fogo Sessions, register your domain with the paymaster:

1. Register your program ID with the Domain Registry
2. The paymaster will only sponsor transactions for registered domains
3. Use `variation` hints in client SDK to help paymaster filter matching

## Checklist

- [ ] Accept `signer_or_session: Signer` in account structs
- [ ] Use `Session::extract_user_from_signer_or_session()` to get the real user
- [ ] Add optional `program_signer: Option<AccountInfo>` for token operations
- [ ] Branch on `is_session()` for invoke vs invoke_signed
- [ ] Register your domain with the paymaster
- [ ] Test with both direct wallet and session key signing
