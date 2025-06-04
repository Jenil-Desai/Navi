// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NaviETH is Ownable {
    address public tokenAddress;

    event Locked(address indexed depositor, uint256 amount);

    mapping(address => uint256) private pendingWithdrawals;

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function lock(IERC20 _tokenaddress, uint256 _amount) public {
        require(_tokenaddress == IERC20(tokenAddress), "Invalid token address");
        require(_amount > 0, "Amount must be greater than zero");

        require(_tokenaddress.allowance(msg.sender, address(this)) >= _amount, "Insufficient allowance");
        require(_tokenaddress.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        emit Locked(msg.sender, _amount);
    }

    function unlock(IERC20 _tokenaddress, uint256 _amount) public {
        require(_tokenaddress == IERC20(tokenAddress), "Invalid token address");
        require(_amount > 0, "Amount must be greater than zero");

        require(pendingWithdrawals[msg.sender] >= _amount, "Insufficient pending withdrawals");

        require(_tokenaddress.transfer(msg.sender, _amount), "Transfer failed");
        pendingWithdrawals[msg.sender] -= _amount;
    }

    function burnedOnOtherSide(address _user, uint256 _amount) public onlyOwner {
        pendingWithdrawals[_user] += _amount;
    }
}
