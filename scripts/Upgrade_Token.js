const {ethers,upgrades} = require("hardhat");

const PROXY = "0x3959e5A3491191568C37424D0f219023d889dab8";

async function main() {
    const Token = await ethers.getContractFactory("Token")
    await upgrades.upgradeProxy(PROXY, Token) 
}
main();