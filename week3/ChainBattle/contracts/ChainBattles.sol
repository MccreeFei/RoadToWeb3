// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Attribute {
        uint256 level;
        uint256 strength;
        uint256 hp;
    }

    mapping(uint256 => Attribute) public tokenIdToAttribute;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function getAttribute(uint256 tokenId)
        public
        view
        returns (Attribute memory)
    {
        return tokenIdToAttribute[tokenId];
    }

    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getAttribute(tokenId).level.toString(),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Stength: ",
            getAttribute(tokenId).strength.toString(),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "HP: ",
            getAttribute(tokenId).hp.toString(),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _safeMint(msg.sender, tokenId);
        tokenIdToAttribute[tokenId] = Attribute(0, 0, 0);
        _setTokenURI(tokenId,  getTokenURI(tokenId));
    }

     function random(uint256 num) public view returns (uint8) {
        uint8 randomNumber = uint8(
            uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % num
        );
        return randomNumber;
    }

    function train(uint256 tokenId) public {
        
        require(_exists(tokenId), "Token not exists!");
        require(msg.sender == ownerOf(tokenId), "you must own this nft to train");

        tokenIdToAttribute[tokenId].level += 1;
        tokenIdToAttribute[tokenId].strength += random(50);
        tokenIdToAttribute[tokenId].hp += random(30);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    } 
}
