let {
  networkConfig,
  getNetworkIdFromName,
} = require('../helper-hardhat-config');

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy, log } = deployments;
  const { deployer, umiAddress } = await getNamedAccounts();
  const chainId = await getChainId();

  log('----------------------');

  const umi = await deploy('Umi', {
    from: deployer,
    args: ['0x840cAF48A5c5131467423f72CdaeDAC30FD0b4c2'], //change this to be Umi's wallet
    log: true,
  });

  await log(`you have deployed Umi to ${umi.address}`);

  const networkName = networkConfig[chainId]['name'];

  log(
    `Verify with:\n npx hardhat verify --network ${networkName} ${
      umi.address
    } ${umi.args.toString().replace(/,/g, ' ')}`
  );

  // const UmiContract = await ethers.getContractFactory('Umi');
  // const accounts = await hre.ethers.getSigners();
  // const signer = accounts[0];
  // const umiContract = new ethers.Contract(
  //   UmiContract.address,
  //   UmiContract.interface,
  //   signer
  // );

  // //this auto-creates an nft on deploy
  // log("Let's create an NFT now!");
  // tx = await umiContract.createNFT({ gasLimit: 2000000 });
  // await tx.wait(1);
  // await log(`You can view the tokenURI here ${await umi.tokenURI(1)}`);
};
