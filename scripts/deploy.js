// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const { json } = require("hardhat/internal/core/params/argumentTypes");

  // This is a script for deploying your contracts. You can adapt it to deploy
// yours, or create new ones.
async function main() {
  // This is just a convenience check
  // if (network.name === "hardhat") {
  //   console.warn(
  //     "You are trying to deploy a contract to the Hardhat Network, which" +
  //       "gets automatically created and destroyed every time. Use the Hardhat" +
  //       " option '--network localhost'"
  //   );
  // }

  // ethers is avaialble in the global scope
  const [deployer] = await ethers.getSigners();
  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );

  console.log("Account balance:", (await deployer.getBalance()).toString());

  LASM = await ethers.getContractFactory("LASM");
  lasm = await LASM.deploy();
   await lasm.deployed();

  //  let manager_addr = await lasm.manager_addr()
  //  console.log(manager_addr)

  NFTCrowdsale = await ethers.getContractFactory("NFTCrowdsale");
  nftPreSale = await NFTCrowdsale.deploy();
  await nftPreSale.deployed();

  nftPubSale = await NFTCrowdsale.deploy();
  await nftPubSale.deployed();

 

   NFT = await ethers.getContractFactory("NFT");
   nft = await NFT.deploy(nftPreSale.address,nftPubSale.address);
   await nft.deployed();

  // Manager = await ethers.getContractFactory("Manager");
  // manager = await Manager.attach(manager_addr)

  console.log("LASM deployed to:", lasm.address);
  console.log("nftPreSale deployed to:", nftPreSale.address);
  console.log("nftPubSale deployed to:", nftPubSale.address);
  console.log("nft deployed to:", nft.address);

  // We also save the contract's artifacts and address in the frontend directory
  saveFrontendFiles(lasm,nftPreSale,nftPubSale,nft);
}
//,nftPreSale,nftPubSale,nft

function saveFrontendFiles(lasm,nftPreSale,nftPubSale,nft) {
  const fs = require("fs");
  const contractsDir = __dirname + "/../frontend/src/contracts";

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }
let config = `
 const LASM_addr = "${lasm.address}"
 const nftPreSale_addr = "${nftPreSale.address}"
 const nftPubSale_addr = "${nftPubSale.address}"
 const nft_addr = "${nft.address}"
`
let data =  JSON.stringify(config)
fs.writeFileSync(
  contractsDir + '/addresses.js', JSON.parse(data)
  
);
  // fs.writeFileSync(
  //   contractsDir + "/contract-address.json",
  //   JSON.stringify({ LASM: lasm.address ,  nftPreSale: nftPreSale.address ,nftPubSale: nftPubSale.address ,nft: nft.address }
  //     , undefined, 2)
    
  // );
  // fs.writeFileSync(
  //   contractsDir + "/contract-address.json",
  //    JSON.stringify({ nftPreSale: nftPreSale.address }, undefined, 2)
  // );
  // fs.writeFileSync(
  //   contractsDir + "/contract-address.json",
  //   JSON.stringify({ nftPubSale: nftPubSale.address }, undefined, 2)
  // );
  // fs.writeFileSync(
  //   contractsDir + "/contract-address.json",
  //   JSON.stringify({ nft: nft.address }, undefined, 2)
  // );

  const LasmArtifact = artifacts.readArtifactSync("LASM");
  const nftPreSaleArtifact = artifacts.readArtifactSync("NFTCrowdsale");
  const nftArtifact = artifacts.readArtifactSync("NFT");
  const managerArtifact = artifacts.readArtifactSync("Manager");
  const CrowdsaleArtifact = artifacts.readArtifactSync("Crowdsale");


  let abi  = `const LASM  = ${JSON.stringify(LasmArtifact)}`

  data = JSON.stringify(abi,null,2)

  fs.writeFileSync(
    contractsDir + '/LASM.js', JSON.parse(data)
    
  );

  abi  = `const NFTCrowdsale  = ${JSON.stringify(nftPreSaleArtifact)}`

  data = JSON.stringify(abi,null,2)

  fs.writeFileSync(
    contractsDir + '/NFTCrowdsale.js', JSON.parse(data)
    
  );

  abi  = `const NFT  = ${JSON.stringify(nftArtifact)}`

  data = JSON.stringify(abi,null,2)

  fs.writeFileSync(
    contractsDir + '/NFT.js', JSON.parse(data)
    
  );
  abi  = `const Manager  = ${JSON.stringify(managerArtifact)}`

  data = JSON.stringify(abi,null,2)

  fs.writeFileSync(
    contractsDir + '/Manager.js', JSON.parse(data)
    
  );
  abi  = `const Crowdsale  = ${JSON.stringify(CrowdsaleArtifact)}`

  data = JSON.stringify(abi,null,2)

  fs.writeFileSync(
    contractsDir + '/Crowdsale.js', JSON.parse(data)
    
  );

  // fs.writeFileSync(
  //   contractsDir + "/LASM.json",
  //   JSON.stringify(LasmArtifact, null, 2)
  // );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


// npx hardhat run scripts\deploy.js --network rinkeby