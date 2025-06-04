// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";

import {NCOIN} from "../src/NCOIN.sol";

contract NCOINTest is Test {
    NCOIN public ncoin;

    function setUp() public {
        ncoin = new NCOIN();
    }

    function testMint() public {
        ncoin.mint(0x015a239874606A99Edb2dcAB3025fBCd286731b4, 18);
        assertEq(ncoin.balanceOf(0x015a239874606A99Edb2dcAB3025fBCd286731b4), 18);

        ncoin.burn(0x015a239874606A99Edb2dcAB3025fBCd286731b4, 9);
        assertEq(ncoin.balanceOf(0x015a239874606A99Edb2dcAB3025fBCd286731b4), 9);
    }
}
