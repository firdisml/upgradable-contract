const {ethers,upgrades} = require("hardhat");

async function main() {

    const Contract = await ethers.getContractFactory("Token");

    const Token = await upgrades.deployProxy(Contract,{
        initializer: "initialize",
    });
    await Token.deployed();
    console.log("Token Deployed :", Token.address);
}

main();