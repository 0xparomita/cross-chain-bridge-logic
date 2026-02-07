// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeBase is Ownable {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    IERC20 public token;
    address public validator;
    mapping(bytes32 => bool) public processedMessages;

    event BridgeDeposit(address indexed user, uint256 amount, uint256 nonce);
    event BridgeRelease(address indexed user, uint256 amount, uint256 nonce);

    constructor(address _token, address _validator) Ownable(msg.sender) {
        token = IERC20(_token);
        validator = _validator;
    }

    /**
     * @notice Locks tokens on the current chain to be moved to another chain.
     */
    function bridgeAsset(uint256 amount, uint256 nonce) external {
        token.transferFrom(msg.sender, address(this), amount);
        emit BridgeDeposit(msg.sender, amount, nonce);
    }

    /**
     * @notice Releases tokens on this chain based on a valid validator signature.
     */
    function releaseAsset(
        address user,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external {
        bytes32 messageHash = keccak256(abi.encodePacked(user, amount, nonce));
        bytes32 ethSignedMessageHash = messageHash.toEthSignedMessageHash();

        require(processedMessages[ethSignedMessageHash] == false, "Transfer already processed");
        require(ethSignedMessageHash.recover(signature) == validator, "Invalid validator signature");

        processedMessages[ethSignedMessageHash] = true;
        token.transfer(user, amount);

        emit BridgeRelease(user, amount, nonce);
    }
}
