require('@nomiclabs/hardhat-waffle');
require('dotenv').config();
require('hardhat-deploy');
require('@nomiclabs/hardhat-etherscan');
require('hardhat-gas-reporter');

const RINKEBY_RPC_URL = process.env.RINKEBY_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_API = process.env.ETHERSCAN_API;
const POLYGON_MUMBAI_RPC_URL = process.env.POLYGON_MUMBAI_RPC_URL;
const COINMKTCAP = process.env.COINMKTCAP;
const POLYSCAN_API = process.env.POLYSCAN_API;

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

module.exports = {
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {},
    rinkeby: {
      url: RINKEBY_RPC_URL,
      accounts: [PRIVATE_KEY],
    },
    matic: {
      url: POLYGON_MUMBAI_RPC_URL,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    // apiKey: POLYSCAN_API,
    apiKey: ETHERSCAN_API,
  },
  gasReporter: {
    currency: 'ETH',
    gasPrice: 50, //in gwei
    enabled: true,
    coinmarketcap: COINMKTCAP,
    optimizer: true,
  },
  solidity: '0.8.4',
  settings: {
    optimizer: {
      enabled: true,
      runs: 1000,
    },
  },
  namedAccounts: {
    deployer: {
      default: 0,
      1: 0,
    },
    umiAddress: {
      default: 1,
      1: '0x86eaa925c689337b50bf1dab5e7078daab5a0325', //Umi's wallet :)
    },
  },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts',
  },
  mocha: {
    timeout: 20000,
  },
};
