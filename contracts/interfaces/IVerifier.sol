// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

interface IVerifier {
  function verifyProof(bytes memory _proof, uint256[7] memory _input) external view returns (bool);

  function verifyProof(bytes memory _proof, uint256[21] memory _input) external view returns (bool);
}