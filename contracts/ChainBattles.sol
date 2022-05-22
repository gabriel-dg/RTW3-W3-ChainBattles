// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 initialNumber;

    struct Stats {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }
    mapping(uint256 => Stats) public tokenIdToLevels;

    // mapping(uint256 => uint256) public tokenIdToLevels;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId) public returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="20%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Level: ",
            getLevels(tokenId),
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed: ",
            getSpeed(tokenId),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Strength: ",
            getStrength(tokenId),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Life: ",
            getLife(tokenId),
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

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevels[tokenId].level;
        return levels.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 speed = tokenIdToLevels[tokenId].speed;
        return speed.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdToLevels[tokenId].strength;
        return strength.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        uint256 life = tokenIdToLevels[tokenId].life;
        return life.toString();
    }

    function getTokenURI(uint256 tokenId) public returns (string memory) {
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


    function randomNbr(uint256 number) public returns (uint256) {
        return uint256(keccak256(abi.encodePacked(initialNumber++))) % number;
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId].level = 0;
        tokenIdToLevels[newItemId].speed = 0;
        tokenIdToLevels[newItemId].strength = 0;
        tokenIdToLevels[newItemId].life = 10;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this NFT to train it!"
        );
        uint256 currentLevel = tokenIdToLevels[tokenId].level;
        tokenIdToLevels[tokenId].level = currentLevel + randomNbr(12);

        uint256 currentSpeed = tokenIdToLevels[tokenId].speed;
        tokenIdToLevels[tokenId].speed = currentSpeed + randomNbr(12);

        uint256 currentStrength = tokenIdToLevels[tokenId].strength;
        tokenIdToLevels[tokenId].strength = currentStrength + randomNbr(12);

        uint256 currentLife = tokenIdToLevels[tokenId].life;
        tokenIdToLevels[tokenId].life = currentLife + randomNbr(12);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    // ===========================================================================
    // function fight(uint256 tokenId) public {
    //         require(_exists(tokenId));
    //         require(ownerOf(tokenId) == msg.sender, "You must own this NFT to fight with it!");
    //         uint256 oponentStrength = randomNbr(12);
    //         uint256 currentLevel = tokenIdParameters[tokenId].Level;
    //         if (oponentStrength > tokenIdParameters[tokenId].Strength) {
    //             uint256 oponentSpeed = randomNbr(12);
    //             if (oponentSpeed > tokenIdParameters[tokenId].Speed) {
    //                 tokenIdParameters[tokenId].Life = tokenIdParameters[tokenId].Life - 1;
    //             }
    //             if (currentLevel > 0) {
    //                 tokenIdParameters[tokenId].Level = currentLevel - 1;
    //             }
    //         }
    //         else {

    //             tokenIdParameters[tokenId].Level = currentLevel + 1;
    //         }
    //         _setTokenURI(tokenId, getTokenURI(tokenId));
    //     }
    // ===========================================================================
}
