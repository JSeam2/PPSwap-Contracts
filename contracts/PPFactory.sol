// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./PPPool.sol";

contract PPFactory {
    address immutable poolImpl;

    event PoolCreated(address poolAddress);

    constructor() {
        poolImpl = address(new PPPool(address(this)));
    }

    function createPool(
        address reputation_,
        address hasher_,
        uint32 levels_,
        address tokenA_,
        address tokenB_
    ) external returns (address) {
        address clone = Clones.clone(poolImpl);
        PPPool(clone).initialize(
            reputation_,
            hasher_,
            levels_,
            tokenA_,
            tokenB_
        );
        emit PoolCreated(clone);
        return clone;
    }
}