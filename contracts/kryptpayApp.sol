// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20MintableBurnable is IERC20 {
    function mint(address, uint256) external;

    function burnFrom(address, uint256) external;
}

contract Kryptpay is Ownable {
    uint256 public purchaseRatio;
    IERC20MintableBurnable public paymentToken;

    mapping(address => string) public email;

    constructor (
        uint256 _purchaseRatio,
        address _paymentToken
    ) {
        purchaseRatio = _purchaseRatio;
        paymentToken = IERC20MintableBurnable(_paymentToken);
    }

    function transfer (address _to, uint256 _amount) public {
        uint amount =  _amount;
        address to = _to;
        require(paymentToken.balanceOf(msg.sender) > amount, "You dont have enough balance");
        paymentToken.transferFrom(msg.sender, to, amount);
    }

    function purchaseTokens() public payable {
        paymentToken.mint(msg.sender, msg.value * purchaseRatio);
    }

    function swapTokens(uint256 amount) public {
        paymentToken.burnFrom(msg.sender, amount);
        payable(msg.sender).transfer(amount / purchaseRatio);
    }

    function withdraw(uint256 _amount) public onlyOwner {
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to withdraw Matic");
    }
}
