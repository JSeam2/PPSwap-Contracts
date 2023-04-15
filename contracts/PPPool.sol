// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

contract PPPool {
    address public immutable ppfactory;
    bool public initialized;


    error Initialized();
    error NotFactory();

    constructor(address ppfactory_) {
        ppfactory = ppfactory_;
    }

    function initialize(

    ) public {
        if (msg.sender == ppfactory) {
            if (initialized) {
                revert Initialized();
            } else {
                initialized = true;
                // TODO: add other variables here
            }
        } else {
            revert NotFactory();
        }
    }
}