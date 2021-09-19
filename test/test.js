const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Umi', () => {
  let umi;
  let owner = [];

  beforeEach(async () => {
    const Umi = await ethers.getContractFactory('Umi');
    umi = await Umi.deploy('0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266');
    await umi.deployed();
    [owner] = await ethers.getSigners();
  });

  it('Owner should be same as signer', async () => {
    // await console.log(umi.getOwner());

    expect(await umi.umi()).to.equal(await owner.address);
  });

  // it('Does creating NFT return a URI token', async () => {
  //   let created = await umi.createNFT();
  //   let tokenuri = await umi.tokenURI(1);
  //   console.log(`You can view the tokenURI here ${tokenuri}`);
  //   expect(tokenuri).to.be.ok;
  // });

  it('I want to see tokenuri', async () => {
    const UmiContract = await ethers.getContractFactory('Umi');
    const accounts = await hre.ethers.getSigners();
    const signer = accounts[0];
    const umiContract = new ethers.Contract(
      UmiContract.address,
      UmiContract.interface,
      signer
    );

    //this auto-creates an nft on deploy
    log("Let's create an NFT now!");
    tx = await umiContract.createNFT({ gasLimit: 2000000 });
    await tx.wait(1);
    await log(`You can view the tokenURI here ${await umi.tokenURI(1)}`);
  });
});
