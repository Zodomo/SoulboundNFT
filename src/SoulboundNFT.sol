// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.23;

import {ERC721} from "../lib/solady/src/tokens/ERC721.sol";
import {Ownable} from "../lib/solady/src/auth/Ownable.sol";
import {LibString} from "../lib/solady/src/utils/LibString.sol";

contract SoulboundNFT is ERC721, Ownable {
    using LibString for uint256;

    error Invalid();
    error Soulbound();

    event ToggleSoulbind();
    event SetBaseURI(string indexed baseURI_);
    event SetContractURI(string indexed contractURI_);

    bool public isSoulbound;
    uint16 public maxSupply;
    uint16 public totalSupply;

    string internal _name;
    string internal _symbol;
    string internal _baseURI;
    string internal _contractURI;

    constructor(
        address owner_,
        uint16 maxSupply_,
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        string memory contractURI_
    ) {
        _initializeOwner(owner_);
        isSoulbound = true;
        maxSupply = maxSupply_;
        _name = name_;
        _symbol = symbol_;
        _baseURI = baseURI_;
        _contractURI = contractURI_;
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function baseURI() public view returns (string memory) {
        return _baseURI;
    }

    function contractURI() external view returns (string memory) {
        return _contractURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!_exists(tokenId)) revert Invalid();
        string memory baseURI_ = baseURI();
        return string(abi.encodePacked(baseURI_, tokenId.toString()));
    }

    function transferFrom(address from, address to, uint256 tokenId) public payable override {
        if (isSoulbound) revert Soulbound();
        super.transferFrom(from, to, tokenId);
    }

    function mint(address[] calldata addresses) external onlyOwner {
        uint256 tokenId = totalSupply + 1;
        if (tokenId + addresses.length - 1 > maxSupply) revert Invalid();
        for (uint256 i; i < addresses.length;) {
            _mint(addresses[i], tokenId);
            unchecked {
                ++tokenId;
                ++i;
            }
        }
        unchecked {
            totalSupply += uint16(addresses.length);
        }
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURI = baseURI_;
        emit SetBaseURI(baseURI_);
    }

    function setContractURI(string memory contractURI_) external onlyOwner {
        _contractURI = contractURI_;
        emit SetContractURI(contractURI_);
    }

    function toggleSoulbind() external onlyOwner {
        isSoulbound = !isSoulbound;
        emit ToggleSoulbind();
    }
}
