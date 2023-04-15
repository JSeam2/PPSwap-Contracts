# PPSwap

PPSwap is an extension of Tornado Cash Nova which supports Shielded Swaps, Shielded Transfers, Arbitrary Amount Withdrawals, and Deposits within the the contracts.

To improve accountability PPSwap pools uses Worldcoin and Lens as an optional reputation scoring mechanism for reputation gated pools.

With Worldcoin and Lens at the moment it will be possible to offer a reasonable level of privacy and compliance if needed.

In future more onchain identity and reputation mechanisms could be added into the reputation mechanism.

## Structure
1. `circuits`: The circom circuits adapted from Tornado Nova to support Shielded Swaps.
2. `contracts`: Solidity contracts
    - `interfaces`: Interfaces used
    - `utils`: Utility contracts
    - `PPFactory.sol`: Factory contract for PPPools
    - `PPPool.sol`: Implementation of pool clone contracts that arre initialized by PPFactory
    - `Reputation.sol`: Optional reputation gating mechanism using Lens and WorldID
3. `scripts`: Scripts used to generate circuits and deploy contracts
4. `test`: Smart contract tests
5. `utils`: Cryptography utility functions


## Some comments

Interestingly, this might have been Tornado V3 if the devs didn't get arrested. Free Alex Pertsev.

```
"Can the Dev do something?"
Dev got arrested bruh
```

## Hardhat Instructions

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
