// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

interface IHasher {
  function poseidon(bytes32[2] calldata inputs) external pure returns (bytes32);
}