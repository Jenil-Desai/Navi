// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Coin is Ownable, ERC20 {
    constructor() Ownable(msg.sender) ERC20("Coin", "CIN") {}
}
