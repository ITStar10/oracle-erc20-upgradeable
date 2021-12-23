import { ethers, upgrades } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory('SaleToken');
  
  const contract = await upgrades.deployProxy(
    contractFactory,
    [ "0x31eCabACF1dfE45032916a623059A23C20bDe96B",
      "0x31eCabACF1dfE45032916a623059A23C20bDe96B",
      "ETH",
      "BNB"
    ], 
    { initializer: 'initialize'})
  await contract.deployed();
  console.log('Contract deployed to:', contract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
