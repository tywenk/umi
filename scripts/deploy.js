async function main() {
  // We get the contract to deploy
  const Umi = await ethers.getContractFactory('Umi');
  const umi = await Umi.deploy();

  console.log('Umi deployed to:', umi.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
