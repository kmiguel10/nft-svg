//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "base64-sol/base64.sol";

contract DynamicSvgNft is ERC721 {
    //mint an NFT based on price of ETH
    //if ETH someNumber: Smile
    //otherwise: Frown

    uint public s_tokenCounter;

    //Pass SVG files and convert those files to base64 format
    constructor(string memory lowSvg, string memory highSvg)
        ERC721("Dynamic SVG NFT", "DSN")
    {
        s_tokenCounter = 0;
    }

    //returns imageURIs
    function svgToImageURI(string memory svg)
        public
        pure
        returns (string memory)
    {
        string memory baseImageURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );

        return string(abi.encodePacked(baseImageURL, svgBase64Encoded));
    }

    function mintNft() external {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
    }

    //Returns string to be used from converting svg -> base64
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json";
    }

    //override tokenURI inherited function from ERC721
    //"virtual" means function can be overriden
    function tokenURI(uint tokenId)
        public
        view
        override
        returns (string memory)
    {
        //How do we base64 encode this string -> URL/URI
        //How do we get the image?
        string
            memory metaDataTemplate = '{"name":"Dynamic SVG", "description": "a cool NFT", "attributes":[{"trait_type":"coolness","value":100}], "image":"????????"}';

        bytes memory metaDataTemplateinBytes = bytes(metaDataTemplate);
        string memory encodedMetadata = Base64.encode(metaDataTemplateinBytes);

        return (string(abi.encodePacked(_baseURI(), encodedMetadata))); //concatenate string
    }
}
