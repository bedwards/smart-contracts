#!/bin/bash

# A short, straightforward bash script to run a Solitity contract.
#
# Prerequisites (Mac with homebrew)
#
#   * brew tap ethereum/ethereum
#   * brew install ethereum
#   * brew install solidity
#
#
# Example usage
#
#   1. Write a solidity contract.
#
#       $ cat SimpleStorage.sol
#       contract SimpleStorage {
#           uint public data;
#           function setData(uint x) public {data = x;}
#       } 
#
#   2. Run this script which starts a geth console preloaded with the contract
#      in a variable named 'c'.
#
#       $ ./run.sh SimpleStorage.sol
#
#   3. Interact with the contract in the geth console.
#
#       > c.data();
#       0
#       > c.setData(42);
#       > c.data();
#       42
#
#
# References
#
#   * Deploying a smart contract the hard way
#     https://medium.com/@gus_tavo_guim/deploying-a-smart-contract-the-hard-way-8aae778d4f2a
#
#   * go-ethereum (geth): JavaScript-Console
#     https://github.com/ethereum/go-ethereum/wiki/JavaScript-Console
#
#   * Solidity: Introduction to smart contracts
#     https://solidity.readthedocs.io/en/v0.4.21/introduction-to-smart-contracts.html
#
#   * Building a smart contract using the command line
#     https://www.ethereum.org/greeter

set -eu
echo ${1}
contract="${1%.*}"
mkdir -p dist
rm dist/${contract}.* || true
solc -o dist --abi --bin ${contract}.sol
echo "var Contract = eth.contract(JSON.parse('$(cat dist/${contract}.abi)'));" > dist/${contract}.js
echo "var bin = '0x' + '$(cat dist/${contract}.bin)';" >> dist/${contract}.js

cat << EOF >> dist/${contract}.js
miner.start(1);
personal.unlockAccount(eth.coinbase, '');
eth.defaultAccount = eth.coinbase;
var transactionHash = Contract.new({data: bin, gas: 1000000}).transactionHash;
admin.sleep(1);
var contract = Contract.at(eth.getTransactionReceipt(transactionHash).contractAddress);
var c = contract;
loadScript('${contract}.js');
EOF

geth --dev --preload dist/${contract}.js console
