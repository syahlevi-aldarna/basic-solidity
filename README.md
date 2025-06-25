# Simple Counter Smart Contract

A minimal Solidity smart contract example for learning and testing.

## Structure

- `src/Counter.sol` — Main contract
- `test/SimpleCounter.t.sol` — Tests
- `script/Deploy.s.sol` — Deployment script

## Features

- Increment, decrement, and reset counter
- Owner-only reset
- Utility: check even/odd, double a number

## Usage

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Build & test
forge build
forge test

# Deploy (local)
anvil
forge script script/Deploy.s.sol --broadcast
```

---
Simple, clean, and ready to use.