# Cross-Chain Bridge Logic

This repository provides a robust foundation for building cross-chain bridges between EVM-compatible networks. It utilizes a "Lock and Mint" or "Lock and Release" mechanism secured by cryptographic signatures from off-chain validators.

## Features
* **Secure Locking**: Users lock original assets in a vault on the source chain.
* **Signature Verification**: Implements ECDSA verification to ensure only authorized bridge validators can trigger actions on the destination chain.
* **Nonce Tracking**: Prevents replay attacks by tracking transaction nonces for every user.
* **Emergency Stop**: Pausable functionality for security during network upgrades or incidents.

## Workflow
1. **Deposit**: User calls `bridgeAsset` on Chain A, locking their tokens.
2. **Attestation**: Validators detect the event and provide a signed message.
3. **Claim**: User (or relayer) calls `releaseAsset` on Chain B with the validator's signature to receive funds.



## Safety Note
This is a logic implementation. In production, ensure you use a decentralized validator set (MPC or Multi-sig) to avoid centralization risks.
