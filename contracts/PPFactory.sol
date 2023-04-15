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
        address hasher_,
        uint32 levels_
    ) external returns (address) {
        address clone = Clones.clone(poolImpl);
        PPPool(clone).initialize(
            hasher_,
            levels_
        );
        emit PoolCreated(clone);
        return clone;
    }
}