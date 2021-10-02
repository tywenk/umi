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

    expect(await umi.umi()).to.equal(owner.address);
  });

  it('Does creating NFT return a URI token', async () => {
    for (i = 0; i < 2; i++) {
      await umi.createNFT();
    }
    let tokenuri = await umi.tokenURI(1);
    console.log(`You can view the tokenURI here ${tokenuri}`);
    // let tokenuri20 = await umi.tokenURI(20);
    // console.log(`You can view the tokenURI here ${tokenuri20}`);
    // let tokenuri21 = await umi.tokenURI(21);
    // console.log(`You can view the tokenURI here ${tokenuri21}`);
    // let tokenuri22 = await umi.tokenURI(22);
    // console.log(`You can view the tokenURI here ${tokenuri22}`);
    // let tokenuri99 = await umi.tokenURI(99);
    // console.log(`You can view the tokenURI here ${tokenuri99}`);
    // let tokenuri100 = await umi.tokenURI(100);
    // console.log(`You can view the tokenURI here ${tokenuri100}`);
    expect(tokenuri).to.be.ok;
  });
});
