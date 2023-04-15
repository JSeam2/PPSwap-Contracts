#!/bin/bash -e

# compiles circuit for use

# TODO: DO NOT USE IN PRODUCTION, FOR TESTING PURPOSES
# USE A HIGHER POWERS OF TAU IN PRODUCTION
# THIS WILL INCREASE TESTING TIMES

# Download powers of tau
POWERS_OF_TAU=16; # circuit will support max 2^POWERS_OF_TAU constraints
mkdir -p artifacts/circuits;
if [ ! -f artifacts/circuits/ptau$POWERS_OF_TAU ]; then
  echo "Downloading powers of tau file";
  curl -L https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_$POWERS_OF_TAU.ptau --create-dirs -o artifacts/circuits/ptau$POWERS_OF_TAU;
fi

# compile transaction2

circom --verbose \
  --output artifacts/circuits \
  --r1cs --wasm --sym \
  circuits/transaction2.circom;

# setup groth16 pkey file
npx snarkjs groth16 setup \
  artifacts/circuits/transaction2.r1cs \
  artifacts/circuits/ptau$POWERS_OF_TAU \
  artifacts/circuits/tmp_transaction2.zkey;

# create zkey file with new contribution
# TODO: use qwe entropy (this is not secure, for testing only!)
echo "qwe" | npx snarkjs zkey contribute \
  artifacts/circuits/tmp_transaction2.zkey \
  artifacts/circuits/transaction2.zkey;

# export solidity verifier
npx snarkjs zkey export solidityverifier \
  artifacts/circuits/transaction2.zkey \
  artifacts/circuits/Verifier2.sol;

sed -i.bak "s/contract Verifier/contract Verifier2/g" artifacts/circuits/Verifier2.sol;

# Show snark info
npx snarkjs info -r artifacts/circuits/transaction2.r1cs;


# compile transaction16

circom --verbose \
  --output artifacts/circuits \
  --r1cs --wasm --sym \
  circuits/transaction16.circom;

# setup groth16 pkey file
npx snarkjs groth16 setup \
  artifacts/circuits/transaction16.r1cs \
  artifacts/circuits/ptau$POWERS_OF_TAU \
  artifacts/circuits/tmp_transaction16.zkey;

# create zkey file with new contribution
# TODO: use qwe entropy (this is not secure, for testing only!)
echo "qwe" | npx snarkjs zkey contribute \
  artifacts/circuits/tmp_transaction16.zkey \
  artifacts/circuits/transaction16.zkey;

# export solidity verifier
npx snarkjs zkey export solidityverifier \
  artifacts/circuits/transaction16.zkey \
  artifacts/circuits/Verifier16.sol;

sed -i.bak "s/contract Verifier/contract Verifier16/g" artifacts/circuits/Verifier16.sol;

# Show snark info
npx snarkjs info -r artifacts/circuits/transaction16.r1cs;