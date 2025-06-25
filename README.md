# Simple Counter Smart Contract

A beginner-friendly Solidity smart contract for learning basics.

## Files

- `src/Counter.sol` - Main smart contract
- `test/SimpleCounter.t.sol` - Tests 
- `script/Deploy.s.sol` - Deployment script

## Contract Features

```solidity
contract Counter {
    uint256 public counter;     // Current count
    address public owner;       // Contract owner
    
    // Functions
    increment()                 // Add 1
    incrementBy(amount)         // Add custom amount  
    decrement()                 // Subtract 1
    reset()                     // Reset to 0 (owner only)
    getCounter()                // Get current value
    isEven()                    // Check if even
    doubleNumber(number)        // Double a number
}
```

## Quick Start

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Run tests
forge test

# Deploy locally
forge script script/Deploy.s.sol -vv

# Build project
forge build
```

## Learning Topics

- State variables (`uint256`, `address`)
- Function types (`external`, `view`, `pure`)
- Events (`CounterIncremented`, etc.)
- Custom errors (`NotOwner`, `InvalidValue`)
- Access control (`onlyOwner` modifier)
- Basic safety (underflow protection)

## Example Usage

```bash
# Run all tests
forge test

# Run with gas report
forge test --gas-report

# Deploy to local testnet
anvil                                              # Terminal 1
forge script script/Deploy.s.sol --broadcast      # Terminal 2
```

That's it! Simple, clean, and ready to learn from.

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
