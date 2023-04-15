# PPSwap

PPSwap is an extension of Tornado Cash Nova which adds on Shielded Swaps to the existing Shielded Transfers, Arbitrary Amount Withdrawals, and Deposits within the the contracts.

To improve accountability PPSwap pools uses Worldcoin and Lens as an optional reputation scoring mechanism for reputation gated pools.

With Worldcoin and Lens at the moment it will be possible to offer a reasonable level of privacy and compliance if needed.

In future more onchain identity and reputation mechanisms could be added into the reputation mechanism.

## Structure
1. `circuits`: The circom circuits adapted from Tornado Nova to support Shielded Swaps. Updated to circom 2.0.
2. `contracts`: Solidity contracts
    - `interfaces`: Interfaces used
    - `utils`: Utility contracts
    - `PPFactory.sol`: Factory contract for PPPools
    - `PPPool.sol`: Implementation of pool clone contracts that are initialized by PPFactory
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

## Quickstart

1. [Install Circom 2](https://docs.circom.io/). It's recommended that you install the binaries instead of building from source. Once downloaded add the package to path. Rename the file as `circom` so you can call it directly.

2. Install packages `npm i`

3. Compile the hasher `npx hardhat run scripts/compileHasher.js`

4. Compile the circom circuits `sh scripts/compileCircuite.sh`

5. You should now be able to run tests `npx hardhat test`

6. To deploy use `npx hardhat run scripts/deploy.js`

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
