const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LASM",  function ()  {

  let LASM
  let lasm
  let Manager
  let manager
  let NFT
  let nft
  let NFTCrowdsale
  let nftPreSale
  let nftPubSale
  let [_,per1,per2,per3] = [1,1,1,1]

  it("Should return the new greeting once it's changed", async function () {
    [_,per1,per2,per3] = await ethers.getSigners()
     LASM = await ethers.getContractFactory("LASM");
     lasm = await LASM.deploy();
    await lasm.deployed();

    let manager_addr = await lasm.manager_addr()
    console.log(manager_addr)

    NFTCrowdsale = await ethers.getContractFactory("NFTCrowdsale");
    nftPreSale = await NFTCrowdsale.deploy();
     await nftPreSale.deployed();

     nftPubSale = await NFTCrowdsale.deploy();
     await nftPubSale.deployed();

    

      NFT = await ethers.getContractFactory("NFT");
      nft = await NFT.deploy(nftPreSale.address,nftPubSale.address);
      await nft.deployed();

     Manager = await ethers.getContractFactory("Manager");
     manager = await Manager.attach(manager_addr)

  
     


   //  create_NftPreSale
  });
  it("Should return the new greeting once it's changed", async function () {

    let tx = await nftPreSale.startSale([per1.address,per2.address],_.address,nft.address)
    await tx.wait()
     tx = await nftPubSale.startSale([],_.address,nft.address)
    await tx.wait()
    
    
   

 });
 it("Should return the new greeting once it's changed", async function () {
   for(i=0;i<1;i++){
    let _value = await ethers.utils.parseEther('0.2')
    console.log(await _.getBalance())
    let tx = await nftPreSale.connect(per1).buyNFT({value:_value})
   await tx.wait()
   console.log(await _.getBalance())
   }
  
});
it("Should return the new greeting once it's changed", async function () {
  for(i=0;i<2;i++){
   let _value = await ethers.utils.parseEther('0.3')
   console.log(await _.getBalance())
   let tx = await nftPubSale.connect(per1).buyNFT({value:_value})
  await tx.wait()
  console.log(await _.getBalance())
  }
 
});
it("Should return the new greeting once it's changed", async function () {
  for(i=0;i<3;i++){
   let _value = await ethers.utils.parseEther('0.3')
   console.log(await _.getBalance())
   let tx = await nftPubSale.connect(per3).buyNFT({value:_value})
  await tx.wait()
  console.log(await _.getBalance())
  }
 
});
});
