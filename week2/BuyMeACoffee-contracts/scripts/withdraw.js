const hre = require("hardhat");
const abi = require("../artifacts/contracts/BuyMeACoffee.sol/BuyMeACoffee.json");

async function getBalance(provider, address) {
    const balanceBigInt = await provider.getBalance(address);
    return hre.ethers.utils.formatEther(balanceBigInt);
}

async function main() {
      // Get the contract that has been deployed to Goerli.
  const contractAddress="0x515b01cDD1290715a696ecD4665747794aC1Eb02";
  const withdrawAddress="0xFaF40fBDA981397b0d063D8FcdCB9101Ee155154";
  const contractABI = abi.abi;

  // Get the node connection and wallet connection.
  const provider = new hre.ethers.providers.AlchemyProvider("goerli", process.env.GOERLI_API_KEY);

  // Ensure that signer is the SAME address as the original contract deployer,
  // or else this script will fail with an error.
  const signer = new hre.ethers.Wallet(process.env.PRIVATE_KEY, provider);

  // Instantiate connected contract.
  const buyMeACoffee = new hre.ethers.Contract(contractAddress, contractABI, signer);

  // Check starting balances.
  console.log("current balance of owner: ", await getBalance(provider, signer.address), "ETH");
  console.log("current balance of withdraw address: ", await getBalance(provider, withdrawAddress), "ETH");
  const contractBalance = await getBalance(provider, buyMeACoffee.address);
  console.log("current balance of contract: ", contractBalance, "ETH");
  
  //change withdraw address
  console.log("current withdraw address:", await buyMeACoffee.getWithdrawAddress());
  console.log("changing withdraw address to:", withdrawAddress);
  const contractWithdrawAddress = await buyMeACoffee.getWithdrawAddress();
  if (contractWithdrawAddress != withdrawAddress) {
    const changeTx = await buyMeACoffee.connect(signer).changeWithdrawAddress(hre.ethers.utils.getAddress(withdrawAddress));
    await changeTx.wait();
    console.log("after change, current withdraw address:", await buyMeACoffee.getWithdrawAddress());
  } else {
    console.log("no need to change withdraw address!");
  }

  // Withdraw funds if there are funds to withdraw.
  if (contractBalance !== "0.0") {
    console.log("withdrawing funds..")
    const withdrawTxn = await buyMeACoffee.withdrawTips();
    await withdrawTxn.wait();
  } else {
    console.log("no funds to withdraw!");
  }

  // Check ending balance.
  console.log("current balance of owner: ", await getBalance(provider, signer.address), "ETH");
  console.log("current balance of withdraw address: ", await getBalance(provider, withdrawAddress), "ETH");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });