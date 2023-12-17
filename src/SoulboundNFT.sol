// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.23;

contract SoulboundNFT {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
