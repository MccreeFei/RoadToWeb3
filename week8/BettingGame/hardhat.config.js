require("@nomiclabs/hardhat-waffle");
require('dotenv').config()

 const GOERLI_URL = process.env.GOERLI_URL;
 const PRIVATE_KEY = process.env.PRIVATE_KEY;
module.exports = {
  solidity: "0.8.4",

  networks: {
    "op-goerli": {
       url: GOERLI_URL,
       accounts: [PRIVATE_KEY]
    }
  }
/*
  networks: {
    "local-devnode": {
       url: "http://localhost:8545",
       accounts: { mnemonic: "test test test test test test test test test test test junk" }
    },
    "optimistic-kovan": {
       url: "https://kovan.optimism.io",
       accounts: { mnemonic: process.env.MNEMONIC }
    },
    "optimism": {
       url: "https://mainnet.optimism.io",
       accounts: { mnemonic: process.env.MNEMONIC }
    }
  }
*/
};
