const hre = require("hardhat");
require("dotenv").config();

async function main() {
  console.log("Using RPC URL:", process.env.SEPOLIA_RPC_URL);
  console.log("Using private key:", process.env.PRIVATE_KEY ? "Loaded ✅" : "Missing ❌");

  const CrowdFunding = await hre.ethers.getContractFactory("CrowdFunding");
  const crowdfunding = await CrowdFunding.deploy();

  await crowdfunding.waitForDeployment();

  console.log("CrowdFunding deployed to:", await crowdfunding.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
