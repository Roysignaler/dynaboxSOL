// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./base64.sol";

contract ringNft is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => Attr) public attrRing;

    struct Attr {
        string model;
        string color;
        uint256 advantages;
    }
    string[] models = ["My Boxing Ring"];
    string[] colors = [
        "red",
        "pink",
        "orange",
        "green",
        "blue",
        "violet",
        "purple",
        "black",
        "silver",
        "gold",
        "indigo"
    ];
    uint256[] rings = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    constructor() ERC721("Boxing Ring", "BOXING RING") {}

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function mintBoxingRing() public {
        address to = msg.sender;
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        uint256 _rings = pickRandomRing(tokenId);
        string memory _color = colors[attrRing[tokenId].advantages];
        string memory _model = pickRandomModel(tokenId);
        _safeMint(to, tokenId);
        attrRing[tokenId] = Attr(_model, _color, _rings);
        updateColor(tokenId);
    }

    function getSvg(uint256 tokenId) public view returns (string memory) {
        string memory svg;
        string
            memory svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 511.989 511.989' style='enable-background:new 0 0 511.989 511.989' xml:space='preserve'><path style='fill:#ccd1d9' d='M159.997 256.007c-5.891 0-10.664-4.781-10.664-10.672V117.338c0-5.891 4.773-10.672 10.664-10.672s10.664 4.781 10.664 10.672v127.997c0 5.89-4.773 10.672-10.664 10.672zm191.995 0c-5.891 0-10.655-4.781-10.655-10.672V117.338c0-5.891 4.765-10.672 10.655-10.672s10.656 4.781 10.656 10.672v127.997c0 5.89-4.765 10.672-10.656 10.672z'/><path style='fill:#e6e9ed' d='M469.334 128.01H42.664c-5.891 0-10.664-4.781-10.664-10.672s4.773-10.672 10.664-10.672h426.67c5.875 0 10.656 4.781 10.656 10.672s-4.781 10.672-10.656 10.672zm0 42.655H42.664c-5.891 0-10.664-4.766-10.664-10.656 0-5.906 4.773-10.672 10.664-10.672h426.67c5.875 0 10.656 4.766 10.656 10.672 0 5.89-4.781 10.656-10.656 10.656zm0 42.671H42.664c-5.891 0-10.664-4.781-10.664-10.672s4.773-10.656 10.664-10.656h426.67c5.875 0 10.656 4.766 10.656 10.656s-4.781 10.672-10.656 10.672zm0 42.671H42.664c-5.891 0-10.664-4.781-10.664-10.672s4.773-10.672 10.664-10.672h426.67c5.875 0 10.656 4.781 10.656 10.672s-4.781 10.672-10.656 10.672z'/><path style='fill:#5d9cec' d='M42.664 85.339h-32A10.659 10.659 0 0 0 0 96.01v191.988c0 5.875 4.773 10.656 10.664 10.656h32c5.89 0 10.671-4.781 10.671-10.656V96.01c0-5.906-4.781-10.671-10.671-10.671z'/><path style='fill:#ed5564' d='M501.333 85.339h-31.999c-5.906 0-10.688 4.765-10.688 10.671v191.988c0 5.875 4.781 10.656 10.688 10.656h31.999c5.875 0 10.656-4.781 10.656-10.656V96.01c0-5.906-4.781-10.671-10.656-10.671z'/><path style='fill:#656d78' d='M501.333 277.341H10.664C4.773 277.341 0 282.091 0 287.997v127.997c0 5.875 4.773 10.656 10.664 10.656h490.668c5.875 0 10.656-4.781 10.656-10.656V287.997c.001-5.906-4.78-10.656-10.655-10.656z'/><path style='fill:";
        string memory color = string(attrRing[tokenId].color);
        string
            memory svgPartTwo = "' d='M312.463 419.12a10.599 10.599 0 0 0-3.125 7.531h21.312c0-2.719-1.031-5.438-3.109-7.531-4.173-4.156-10.922-4.156-15.078 0zm63.998 0a10.599 10.599 0 0 0-3.125 7.531h21.312c0-2.719-1.031-5.438-3.109-7.531-4.172-4.156-10.922-4.156-15.078 0zm79.076 0c-4.172-4.156-10.922-4.156-15.078 0a10.599 10.599 0 0 0-3.125 7.531h21.312c.016-2.719-1.031-5.437-3.109-7.531zm-401.233 0a10.666 10.666 0 0 0-3.125 7.531h21.336a10.63 10.63 0 0 0-3.125-7.531c-4.165-4.156-10.922-4.156-15.086 0zm63.999 0a10.666 10.666 0 0 0-3.125 7.531h21.335a10.63 10.63 0 0 0-3.125-7.531c-4.164-4.156-10.921-4.156-15.085 0zm63.998 0a10.666 10.666 0 0 0-3.125 7.531h21.335a10.63 10.63 0 0 0-3.125-7.531c-4.163-4.156-10.921-4.156-15.085 0zm15.086-134.248a10.632 10.632 0 0 0 3.125-7.531h-21.335c0 2.719 1.047 5.438 3.125 7.531 4.163 4.157 10.921 4.157 15.085 0zm-63.999 0a10.632 10.632 0 0 0 3.125-7.531h-21.335c0 2.719 1.047 5.438 3.125 7.531 4.164 4.157 10.921 4.157 15.085 0zm-79.084 0c4.164 4.156 10.921 4.156 15.085 0a10.632 10.632 0 0 0 3.125-7.531H51.179c0 2.719 1.047 5.438 3.125 7.531zm401.233 0c2.078-2.094 3.125-4.812 3.109-7.531h-21.312c0 2.719 1.031 5.438 3.125 7.531 4.156 4.157 10.906 4.157 15.078 0zm-63.998 0a10.649 10.649 0 0 0 3.109-7.531h-21.312c0 2.719 1.031 5.438 3.125 7.531 4.156 4.157 10.906 4.157 15.078 0zm-63.999 0a10.649 10.649 0 0 0 3.109-7.531h-21.312c0 2.719 1.031 5.438 3.125 7.531 4.157 4.157 10.906 4.157 15.078 0z'/><path style='fill:";
        string
            memory svgPartThree = "' d='M310.963 338.652a10.679 10.679 0 0 0-8.625-7.281l-25.406-3.688-11.375-23.031c-1.797-3.655-5.5-5.937-9.562-5.937s-7.766 2.281-9.562 5.937l-11.367 23.031-25.421 3.688a10.68 10.68 0 0 0-8.609 7.281 10.61 10.61 0 0 0 2.695 10.906l18.398 17.937-4.344 25.312c-.688 4 .961 8.062 4.242 10.438 3.289 2.375 7.641 2.719 11.234.812l22.734-11.938 22.733 11.938a10.75 10.75 0 0 0 4.953 1.219 10.72 10.72 0 0 0 6.281-2.031 10.676 10.676 0 0 0 4.25-10.438l-4.344-25.312 18.391-17.937a10.628 10.628 0 0 0 2.704-10.906zm-150.966 24H53.335c-5.891 0-10.671-4.781-10.671-10.656 0-5.906 4.781-10.656 10.671-10.656h106.662c5.891 0 10.664 4.75 10.664 10.656 0 5.876-4.773 10.656-10.664 10.656zm298.649 0H351.992c-5.891 0-10.655-4.781-10.655-10.656a10.639 10.639 0 0 1 10.655-10.656h106.654c5.906 0 10.688 4.75 10.688 10.656 0 5.876-4.781 10.656-10.688 10.656z'/></svg>";
        svg = string(
            abi.encodePacked(svgPartOne, color, svgPartTwo, color, svgPartThree)
        );
        return svg;
    }

    function showSvg(uint256 tokenId) public view returns (string memory) {
        string memory show = getSvg(tokenId);
        return show;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        attrRing[tokenId].model,
                        '",',
                        '"image_data": "',
                        getSvg(tokenId),
                        '",',
                        '"attributes": [{"trait_type": "ring", "value": ',
                        uint2str(attrRing[tokenId].advantages),
                        "},",
                        '{"trait_type": "Color", "value": "',
                        attrRing[tokenId].color,
                        '"}',
                        "]}"
                    )
                )
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomRing(uint256 tokenId) public view returns (uint256) {
        uint256 rand = random(
            string(
                abi.encodePacked(
                    "Ring",
                    Strings.toString(tokenId),
                    block.coinbase,
                    blockhash(block.number - tokenId)
                )
            )
        );
        rand = rand % rings.length;
        return rings[rand];
    }

    function incrementRing(uint256 tokenId) public onlyOwner returns (uint256) {
        uint256 curChr = attrRing[tokenId].advantages;
        if (curChr < 10) {
            attrRing[tokenId].advantages = curChr + 1;
            updateColor(tokenId);
        } else {
            attrRing[tokenId].advantages = curChr;
        }
        return attrRing[tokenId].advantages;
    }

    function deductRing(uint256 tokenId) public onlyOwner returns (uint256) {
        uint256 curStr = attrRing[tokenId].advantages;
        if (curStr > 0) {
            attrRing[tokenId].advantages = curStr - 1;
            updateColor(tokenId);
        } else {
            attrRing[tokenId].advantages = curStr;
        }
        return attrRing[tokenId].advantages;
    }

    function updateColor(uint256 tokenId) internal {
        attrRing[tokenId].color = colors[attrRing[tokenId].advantages];
    }

    function getRing(uint256 tokenId) public view returns (uint256) {
        return attrRing[tokenId].advantages;
    }

    function pickRandomModel(uint256 tokenId)
        internal
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(
                abi.encodePacked(
                    "Model",
                    Strings.toString(tokenId),
                    block.coinbase,
                    blockhash(block.number - tokenId)
                )
            )
        );
        rand = rand % models.length;
        return models[rand];
    }
}
