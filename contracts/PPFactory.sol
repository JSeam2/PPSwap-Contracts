// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./PPPool.sol";

contract PPFactory {
    address immutable poolImpl;

    event PoolCreated(address poolAddress);

    constructor(address v2, address v16) {
        poolImpl = address(new PPPool(
            address(this),
            v2,
            v16
        ));
    }

    function createPool(
        address reputation_,
        address hasher_,
        uint32 levels_,
        address tokenA_,
        address tokenB_,
        uint256 maximumDepositAmount_
    ) external returns (address) {
        address clone = Clones.clone(poolImpl);
        PPPool(clone).initialize(
            reputation_,
            hasher_,
            levels_,
            tokenA_,
            tokenB_,
            maximumDepositAmount_
        );
        emit PoolCreated(clone);
        return clone;
    }
}