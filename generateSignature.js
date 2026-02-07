const { ethers } = require("ethers");

/**
 * Utility script for bridge validators to sign cross-chain messages.
 */
async function signBridgeMessage(userAddress, amount, nonce, privateKey) {
    const wallet = new ethers.Wallet(privateKey);
    
    // Create the message hash
    const messageHash = ethers.solidityPackedKeccak256(
        ["address", "uint256", "uint256"],
        [userAddress, amount, nonce]
    );

    // Sign the message
    const signature = await wallet.signMessage(ethers.getBytes(messageHash));
    
    console.log("Message Hash:", messageHash);
    console.log("Signature:", signature);
    return signature;
}
