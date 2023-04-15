pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "./merkleProof.circom";
include "./keypair.circom";

/*
Utxo structure:
{
    amountTokenA,         // tokenA input
    amountTokenB,         // tokenB input
    pubkey,               // public key
    blinding,             // random number for obfuscation
}
input_commitment = hash(
    inA,
    inB,
    amount,
    pubKey,
    blinding,
    isTrade
)
nullifier = hash(
    commitment,
    merklePath,
    sign(privKey, commitment, merklePath)
)
*/

// Universal JoinSplit transaction with nIns inputs and 2 outputs
template Transaction(levels, nIns, nOuts, zeroLeaf) {
    signal input root;

    // extAmount = external amount used for deposits and withdrawals
    // correct extAmount range is enforced on the smart contract
    // publicAmount = extAmount - fee

    // assume no fee for simplicity in this case
    signal input publicAmountA;
    signal input publicAmountB;
    signal input extDataHash;
    signal input isTrade;

    // data for transaction inputs
    signal input inputNullifier[nIns];
    signal input inAmountA[nIns];
    signal input inAmountB[nIns];
    signal input inPrivateKey[nIns];
    signal input inBlinding[nIns];
    signal input inPathIndices[nIns];
    signal input inPathElements[nIns][levels];

    // data for transaction outputs
    signal input outputCommitment[nOuts];
    signal input outAmountA[nOuts];
    signal input outAmountB[nOuts];
    signal input outPubkey[nOuts];
    signal input outBlinding[nOuts];

    component inKeypair[nIns];
    component inSignature[nIns];
    component inCommitmentHasher[nIns];
    component inNullifierHasher[nIns];
    component inTree[nIns];
    component inCheckRoot[nIns];
    component inAmountSumGreaterThanZero[nIns];

    var sumInsA = 0;
    var sumInsB = 0;

    component inAmountACheck[nOuts];
    component inAmountBCheck[nOuts];

    // verify correctness of transaction inputs
    for (var tx = 0; tx < nIns; tx++) {
        inKeypair[tx] = Keypair();
        inKeypair[tx].privateKey <== inPrivateKey[tx];

        inCommitmentHasher[tx] = Poseidon(5);
        inCommitmentHasher[tx].inputs[0] <== inAmountA[tx];
        inCommitmentHasher[tx].inputs[1] <== inAmountB[tx];
        inCommitmentHasher[tx].inputs[2] <== inKeypair[tx].publicKey;
        inCommitmentHasher[tx].inputs[3] <== inBlinding[tx];
        inCommitmentHasher[tx].inputs[4] <== isTrade;

        inSignature[tx] = Signature();
        inSignature[tx].privateKey <== inPrivateKey[tx];
        inSignature[tx].commitment <== inCommitmentHasher[tx].out;
        inSignature[tx].merklePath <== inPathIndices[tx];

        inNullifierHasher[tx] = Poseidon(3);
        inNullifierHasher[tx].inputs[0] <== inCommitmentHasher[tx].out;
        inNullifierHasher[tx].inputs[1] <== inPathIndices[tx];
        inNullifierHasher[tx].inputs[2] <== inSignature[tx].out;
        inNullifierHasher[tx].out === inputNullifier[tx];

        inTree[tx] = MerkleProof(levels);
        inTree[tx].leaf <== inCommitmentHasher[tx].out;
        inTree[tx].pathIndices <== inPathIndices[tx];
        for (var i = 0; i < levels; i++) {
            inTree[tx].pathElements[i] <== inPathElements[tx][i];
        }

        // check merkle proof only if amount A and B is non-zero
        inAmountSumGreaterThanZero[tx] = GreaterThan(128);
        inAmountSumGreaterThanZero[tx].in[0] <== inAmountA[tx] + inAmountB[tx];
        inAmountSumGreaterThanZero[tx].in[1] <== 0;

        inCheckRoot[tx] = ForceEqualIfEnabled();
        inCheckRoot[tx].in[0] <== root;
        inCheckRoot[tx].in[1] <== inTree[tx].root;
        inCheckRoot[tx].enabled <== inAmountSumGreaterThanZero[tx].out;

        sumInsA += inAmountA[tx];
        sumInsB += inAmountB[tx];

        // Omit checks, assume inputs are less than 248 bits
        // to be enforced on frontend
        // ~~Check that both amount fits into 248 bits to prevent overflow~~
        // inAmountACheck[tx] = Num2Bits(248);
        // inAmountACheck[tx].in <== sumInsA;
        // inAmountBCheck[tx] = Num2Bits(248);
        // inAmountBCheck[tx].in <== sumInsB;
    }

    component outCommitmentHasher[nOuts];
    component outAmountACheck[nOuts];
    component outAmountBCheck[nOuts];
    var sumOutsA = 0;
    var sumOutsB = 0;

    // verify correctness of transaction outputs
    for (var tx = 0; tx < nOuts; tx++) {
        outCommitmentHasher[tx] = Poseidon(4);
        outCommitmentHasher[tx].inputs[0] <== outAmountA[tx];
        outCommitmentHasher[tx].inputs[1] <== outAmountB[tx];
        outCommitmentHasher[tx].inputs[2] <== outPubkey[tx];
        outCommitmentHasher[tx].inputs[3] <== outBlinding[tx];
        outCommitmentHasher[tx].out === outputCommitment[tx];

        sumOutsA += outAmountA[tx];
        sumOutsB += outAmountB[tx];

        // Check that both amount fits into 248 bits to prevent overflow
        outAmountACheck[tx] = Num2Bits(248);
        outAmountACheck[tx].in <== sumOutsA;
        outAmountBCheck[tx] = Num2Bits(248);
        outAmountBCheck[tx].in <== sumOutsB;
    }

    // check that there are no same nullifiers among all inputs
    component sameNullifiers[nIns * (nIns - 1) / 2];
    var index = 0;
    for (var i = 0; i < nIns - 1; i++) {
      for (var j = i + 1; j < nIns; j++) {
          sameNullifiers[index] = IsEqual();
          sameNullifiers[index].in[0] <== inputNullifier[i];
          sameNullifiers[index].in[1] <== inputNullifier[j];
          sameNullifiers[index].out === 0;
          index++;
      }
    }

    // verify amount invariant
    sumInsA + publicAmountA === sumOutsA;
    sumInsB + publicAmountB === sumOutsB;

    // optional safety constraint to make sure extDataHash cannot be changed
    signal extDataSquare <== extDataHash * extDataHash;
}