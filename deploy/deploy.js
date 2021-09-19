module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy, log } = deployments;
  const { deployer, umiAddress } = await getNamedAccounts();
  const chainId = await getChainId();

  log('----------------------');

  const umi = await deploy('Umi', {
    from: deployer,
    args: ['0x22724d4aae7aefec6cd63a71ade0fc929329af46'],
    log: true,
  });

  await log(`you have deployed Umi to ${umi.address}`);

  await log(`You can view the tokenURI here ${await umi.tokenURI(1)}`);
};
