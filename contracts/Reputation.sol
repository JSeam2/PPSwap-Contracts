// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "./interfaces/IReputation.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./interfaces/IWorldID.sol";

contract Reputation is IReputation {
    // https://mumbai.polygonscan.com/address/0x7582177F9E536aB0b6c721e11f383C326F2Ad1D5
    IERC721 public immutable lensHub;
    // https://mumbai.polygonscan.com/address/0xABB70f7F39035586Da57B3c8136035f87AC0d2Aa
    IWorldID public immutable worldId;

    error NotLensUser();
    error NotWorldIDUser();

    constructor(
        address lensHub_,
        address worldId_
    ) {
        lensHub = IERC721(lensHub_);
        worldId = IWorldID(worldId_);
    }

    function checkReputation(
        address account,
        uint256[12] memory worldIdParams
    ) public view override {
        if (lensHub.balanceOf(account) == 0) revert NotLensUser();

        uint256[8] memory proof = [
            worldIdParams[4],
            worldIdParams[5],
            worldIdParams[6],
            worldIdParams[7],
            worldIdParams[8],
            worldIdParams[9],
            worldIdParams[10],
            worldIdParams[11]
        ];

        // reverts if unverified
        worldId.verifyProof(
            worldIdParams[0],     // root
            worldIdParams[1],     // signalHash
            worldIdParams[2],     // nullifierHash
            worldIdParams[3],     // externalNullifierHash
            proof    // proof
        );
    }
}