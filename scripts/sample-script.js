// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
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

  console.log("LASM deployed to:", lasm.address);
  console.log("nftPreSale deployed to:", nftPreSale.address);
  console.log("nftPubSale deployed to:", nftPubSale.address);
  console.log("nft deployed to:", nft.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
