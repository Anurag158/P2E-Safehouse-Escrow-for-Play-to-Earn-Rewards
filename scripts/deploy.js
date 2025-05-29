const hre = require("hardhat");

async function main() {
  const P2ESafehouse = await hre.ethers.getContractFactory("P2ESafehouse");
  const p2e = await P2ESafehouse.deploy();

  await p2e.deployed();
  console.log("P2E Safehouse contract deployed to:", p2e.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
