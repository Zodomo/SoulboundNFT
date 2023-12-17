// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {SoulboundNFT} from "../src/SoulboundNFT.sol";

contract SoulboundNFTTest is Test {
    SoulboundNFT public nft;

    function setUp() public {
        nft =
            new SoulboundNFT(address(this), 333, "Test", "TEST", "https://test.wtf/", "https://test.wtf/contract.json");
    }

    function testMint() public {
        address[] memory addresses = new address[](333);
        for (uint256 i; i < 333; ++i) {
            addresses[i] = vm.addr((i + 1) * 7777777);
        }
        nft.mint(addresses);
    }

    function testSoulbind() public {
        address[] memory addr = new address[](1);
        addr[0] = address(this);
        nft.mint(addr);
        vm.expectRevert(SoulboundNFT.Soulbound.selector);
        nft.transferFrom(address(this), address(69), 1);
        vm.expectRevert(SoulboundNFT.Soulbound.selector);
        nft.safeTransferFrom(address(this), address(69), 1);
        vm.expectRevert(SoulboundNFT.Soulbound.selector);
        nft.safeTransferFrom(address(this), address(69), 1, bytes(""));
    }
}
