// Generates Hasher artifact at compile-time using external compilermechanism
const path = require('path')
const fs = require('fs')
const { poseidonContract } = require('circomlibjs');
const outputPath = path.join(__dirname, '..', 'artifacts', 'contracts')
const outputFile = path.join(outputPath, 'Hasher.json')

if (!fs.existsSync(outputPath)) {
  fs.mkdirSync(outputPath, { recursive: true })
}

const contract = {
  _format: 'hh-sol-artifact-1',
  sourceName: 'contracts/Hasher.sol',
  linkReferences: {},
  deployedLinkReferences: {},
  contractName: 'Hasher',
  abi: poseidonContract.generateABI(2),
  bytecode: poseidonContract.createCode(2),
}

fs.writeFileSync(outputFile, JSON.stringify(contract, null, 2))