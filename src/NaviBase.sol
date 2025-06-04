// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface NCOIN is IERC20 {
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

contract NaviBase is Ownable {
    address public tokenAddress;

    event Burned(address indexed depositor, uint256 amount);

    mapping(address => uint256) private pendingMintings;

    constructor(address _tokenaddress) Ownable(msg.sender) {
        tokenAddress = _tokenaddress;
    }

    function mint(NCOIN _tokenaddress, uint256 _amount) public {
        require(_tokenaddress == NCOIN(tokenAddress), "Invalid token address");
        require(_amount > 0, "Amount must be greater than zero");

        require(pendingMintings[msg.sender] >= _amount, "Insufficient pending mintings");
        _tokenaddress.mint(msg.sender, _amount);
        pendingMintings[msg.sender] -= _amount;
    }

    function burn(NCOIN _tokenaddress, uint256 _amount) public {
        require(_tokenaddress == NCOIN(tokenAddress), "Invalid token address");
        require(_amount > 0, "Amount must be greater than zero");

        _tokenaddress.burn(msg.sender, _amount);
        emit Burned(msg.sender, _amount);
    }

    function lockedOnOtherSide(address _user, uint256 _amount) public onlyOwner {
        require(_amount > 0, "Amount must be greater than zero");
        pendingMintings[_user] += _amount;
    }
}
