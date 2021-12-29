// const { expect } = require("chai");
// const { ethers } = require("hardhat");

// describe("LASM",  function ()  {

//   let LASM
//   let lasm
//   let Manager
//   let manager
//   let NFT
//   let nft
//   let NFTCrowdsale
//   let nftPreSale
//   let nftPubSale
//   let [_,per1,per2,per3] = [1,1,1,1]

//   it("Should return the new greeting once it's changed", async function () {
//     [_,per1,per2,per3] = await ethers.getSigners()
//      LASM = await ethers.getContractFactory("LASM");
//      lasm = await LASM.deploy();
//     await lasm.deployed();

//     let manager_addr = await lasm.manager_addr()
//     console.log(manager_addr)

//     NFTCrowdsale = await ethers.getContractFactory("NFTCrowdsale");
//     nftPreSale = await NFTCrowdsale.deploy();
//      await nftPreSale.deployed();

//      nftPubSale = await NFTCrowdsale.deploy();
//      await nftPubSale.deployed();

    

//       NFT = await ethers.getContractFactory("NFT");
//       nft = await NFT.deploy(nftPreSale.address,nftPubSale.address);
//       await nft.deployed();

//      Manager = await ethers.getContractFactory("Manager");
//      manager = await Manager.attach(manager_addr)

//      let bal = await lasm.balanceOf(manager_addr);
  
//      console.log("balance of manager :",bal.toString())
//      bal = await lasm.balanceOf(lasm.team());
//      console.log("balance of team :",bal.toString())

//     //  let tx = await lasm.balanceOf(_.address)
//     //  console.log("balance of my :",tx.toString())

//     //  let tx = await lasm.transfer(per1.address,100000000);
//     //  await tx.wait()
//      let  aabal = await lasm.balanceOf(per1.address);
//      await console.log("balance of team :",aabal.toString())
//      aabal = await lasm.balanceOf(per1.address);
//      await console.log("balance of per1 :",aabal.toString())
//      aabal = await lasm.balanceOf(lasm.Marketing());
//      await console.log("balance of mar :",aabal.toString())
//     //  aabal = await lasm.balanceOf(per1.address);
//     //  await console.log("balance of team :",aabal.toString())

//       let total = await lasm.totalSupply()
//       console.log(total.toString())
//       let createsale = await manager.create_TokenSale(300,1,10,_.address,1);
//       await createsale.wait()

//       bal = await lasm.balanceOf(manager_addr);
  
//     await console.log("balance of manager :",bal.toString())
//      let icoAddr = await manager.ico_addr();
//      Crowdsale = await ethers.getContractFactory("Crowdsale");
//      let ico = await Crowdsale.attach(icoAddr)
//      let _value = await ethers.utils.parseEther('0.5')
//       // let buy = await ico.connect(per3).buyTokens({value:_value})
//       // await buy.wait()
//       await new Promise(resolve => setTimeout(resolve, 3000));
//      let Finalize = await ico.Finalize();
//     await Finalize.wait()
//     bal = await lasm.balanceOf(manager_addr);
  
//     await console.log("balance of manager :",bal.toString())
//     createsale = await manager.create_TokenSale(300,2,10,_.address,1);
//     await createsale.wait()
//     bal = await lasm.balanceOf(manager_addr);
  
//    await console.log("balance of manager :",bal.toString())
//   });
//   it("Should return the new greeting once it's changed", async function () {

//     let tx = await nftPreSale.startSale([per1.address,per2.address],_.address,nft.address)
//     await tx.wait()
//      tx = await nftPubSale.startSale([],_.address,nft.address)
//     await tx.wait()
    
    
   

//  });
//  it("Should return the new greeting once it's changed", async function () {
//    for(i=0;i<1;i++){
//     let _value = await ethers.utils.parseEther('0.2')
//     console.log(await _.getBalance())
//     let tx = await nftPreSale.connect(per1).buyNFT({value:_value})
//    await tx.wait()
//    console.log(await _.getBalance())
//    }
  
// });
// it("Should return the new greeting once it's changed", async function () {
//   for(i=0;i<2;i++){
//    let _value = await ethers.utils.parseEther('0.3')
//    console.log(await _.getBalance())
//    let tx = await nftPubSale.connect(per1).buyNFT({value:_value})
//   await tx.wait()
//   console.log(await _.getBalance())
//   }
 
// });
// it("Should return the new greeting once it's changed", async function () {
//   for(i=0;i<3;i++){
//    let _value = await ethers.utils.parseEther('0.3')
//    console.log(await _.getBalance())
//    let tx = await nftPubSale.connect(per3).buyNFT({value:_value})
//   await tx.wait()
//   console.log(await _.getBalance())
//   }
 
// });
// });
