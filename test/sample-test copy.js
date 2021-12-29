const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LASM", function () {

  let LASM
  let lasm
  let Manager
  let manager
  let Crowdsale
  let crowdsale
  let NFT
  let nft
  let NFTCrowdsale
  let nftPreSale
  let nftPubSale
  let [_, per1, per2, per3] = [1, 1, 1, 1]

  it("Should Deploy all contracts", async function () {
    [_, per1, per2, per3] = await ethers.getSigners()
    Manager = await ethers.getContractFactory("Manager");
    manager = await Manager.deploy()
    await manager.deployed()

    Crowdsale = await ethers.getContractFactory("Crowdsale");

    LASM = await ethers.getContractFactory("LASM");
    lasm = await LASM.deploy(manager.address, _.address, 1);
    await lasm.deployed();
    console.log(lasm.address)
    let setToken = await manager.setToken(lasm.address)
    await setToken.wait()
    let tx = await manager.getToken()

    console.log(tx)
  });
  it("Should release token", async function () {

    let bal = await lasm.balanceOf(lasm.address)
    await console.log("balance before realease : ", bal.toString())
    await new Promise(resolve => setTimeout(resolve, 2000));
    let release = await lasm.release();
    await release.wait()
    bal = await lasm.balanceOf(lasm.address)
    await console.log("balance after realease : ", bal.toString())

  });
  it("Should create ico", async function () {
    let bal = await lasm.balanceOf(manager.address)
    await console.log("before balance manager :", bal.toString())
    let amount = await ethers.BigNumber.from('120000000000000000000000000')
    let createSale = await manager.create_TokenSale(2, 1, amount, _.address, 1)
    await createSale.wait()
    bal = await lasm.balanceOf(manager.address)
    await console.log("after balance manager :", bal.toString())
    let ico_addr = await manager.ico_addr()
    crowdsale = await Crowdsale.attach(ico_addr)
    bal = await lasm.balanceOf(ico_addr)
    await console.log("ICO balance :", bal.toString())
  });
  it("Should Buy from ico", async function () {
    let _value = await ethers.utils.parseEther('1')
    let buy = await crowdsale.connect(per1).buyTokens({ value: _value })
    await buy.wait()
  });
  it("fail to create ico while previous not finalized", async function () {
    let bal = await lasm.balanceOf(manager.address)
    await console.log("before balance manager :", bal.toString())
    let amount = await ethers.BigNumber.from('120000000000000000000000000')
    let createSale = await manager.create_TokenSale(2, 1, amount, _.address, 1)
    await createSale.wait()
    bal = await lasm.balanceOf(manager.address)
    await console.log("after balance manager :", bal.toString())
    let ico_addr = await manager.ico_addr()
    crowdsale = await Crowdsale.attach(ico_addr)
    bal = await lasm.balanceOf(ico_addr)
    await console.log("ICO balance :", bal.toString())
  });
  it("fail Buy after time from ico", async function () {
    await new Promise(resolve => setTimeout(resolve, 3000))
    let _value = await ethers.utils.parseEther('1')
    let buy = await crowdsale.connect(per1).buyTokens({ value: _value })
    await buy.wait()
  });
  it("Should finalize ico", async function () {
    await new Promise(resolve => setTimeout(resolve, 3000))

    let Tx = await crowdsale.Finalize()
    await Tx.wait()
    bal = await lasm.balanceOf(manager.address)
    await console.log("after balance manager :", bal.toString())
  });
  it("fail to create 2nd ico with 15% supply", async function () {
    let bal = await lasm.balanceOf(manager.address)
    await console.log("before balance manager :", bal.toString())
    let amount = await ethers.BigNumber.from('120000000000000000000000000')
    let createSale = await manager.create_TokenSale(2, 1, amount, _.address, 1)
    await createSale.wait()
    bal = await lasm.balanceOf(manager.address)
    await console.log("after balance manager :", bal.toString())
    let ico_addr = await manager.ico_addr()
    crowdsale = await Crowdsale.attach(ico_addr)
    bal = await lasm.balanceOf(ico_addr)
    await console.log("ICO balance :", bal.toString())
  });
  it("should create 2nd ico with remainig supply", async function () {
    let bal = await lasm.balanceOf(manager.address)
    await console.log("before balance manager :", bal.toString())
    let amount = await ethers.BigNumber.from(bal)
    let createSale = await manager.create_TokenSale(2, 2, amount, _.address, 1)
    await createSale.wait()
    bal = await lasm.balanceOf(manager.address)
    await console.log("after balance manager :", bal.toString())
    let ico_addr = await manager.ico_addr()
    crowdsale = await Crowdsale.attach(ico_addr)
    bal = await lasm.balanceOf(ico_addr)
    await console.log("ICO balance :", bal.toString())
  });
  it("should claim tokens from round 1", async function () {
    let team = '0xA756262bDF22dDC488BF22c3d4b83EE4493110ee'
    let round1 = await manager.rounds(0)
    let round = await Crowdsale.attach(round1)
    let claim = await round.connect(per1).claim()
    await claim.wait()
    bal = await lasm.balanceOf(per1.address)
    await console.log("person1 balance :", bal.toString())

  });
  it("transfer token to person2 with tax", async function () {
    let team = '0xA756262bDF22dDC488BF22c3d4b83EE4493110ee'
    bal = await lasm.balanceOf(team)
    await console.log("Team Balance before transfer :", bal.toString())
    let amount = await ethers.BigNumber.from('1000000000000000000')
    let transfer = await lasm.connect(per1).transfer(per2.address, amount)
    await transfer.wait()
    bal = await lasm.balanceOf(per1.address)
    await console.log("person1 balance after transfer:", bal.toString())
    bal = await lasm.balanceOf(per2.address)
    await console.log("person2 balance after transfer:", bal.toString())
    bal = await lasm.balanceOf(team)
    await console.log("Team balance after transfer:", bal.toString())

  });

});
