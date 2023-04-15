// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./PPPool.sol";

contract PPFactory {
    address immutable poolImpl;

    event PoolCreated(address poolAddress);


    constructor() public {
        poolImpl = address(new PPPool());
    }

    function createPool(
        string calldata name,
        string calldata symbol,
        uint256 initialSupply
    ) external returns (address) {
        address clone = Clones.clone(poolImpl);
        PPPool(clone).initialize();
        emit PoolCreated(clone);
        return clone;
    }
}