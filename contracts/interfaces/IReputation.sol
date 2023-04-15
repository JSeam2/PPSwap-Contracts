// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

interface IReputation {
  function checkReputation(address account, uint256[12] memory worldIdParams) external view;
}