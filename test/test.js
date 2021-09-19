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

  it('Does creating NFT return a URI token', async () => {
    let created = await umi.createNFT();
    let tokenuri = await umi.tokenURI(1);
    console.log(`You can view the tokenURI here ${tokenuri}`);
    expect(tokenuri).to.be.ok;
  });
});
