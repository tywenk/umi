const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Umi', () => {
  let umi;
  let owner = [];

  beforeEach(async () => {
    const Umi = await ethers.getContractFactory('Umi');
    umi = await Umi.deploy();
    await umi.deployed();
    [owner] = await ethers.getSigners();
  });

  it('Owner should be same as signer', async () => {
    // await console.log(umi.getOwner());
    expect(await umi.getOwner()).to.equal(await owner.address);
  });

  it('Minting a token gets back an expected token id', async () => {
    const token = await umi.create();
    expect(token).to.equal(1);
  });
});
