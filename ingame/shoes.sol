// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./base64.sol";

contract shoesNft is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => Attr) public attrShoes;

    struct Attr {
        string model;
        string color;
        string sec_color;
        uint256 speed;
    }
    string[] models = ["Galactic", "Everfirst", "Venom", "Insigni", "Classic"];
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
    string[] sec_colors = [
        "crimson",
        "deeppink",
        "coral",
        "limegreen",
        "deepskyblue",
        "darkmagenta",
        "darkviolet",
        "aliceblue",
        "seashell",
        "goldenrod",
        "darkorchid"
    ];
    uint256[] speed = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    constructor() ERC721("Boxing Shoes", "BOXING Shoes") {}

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

    function mintBoxingGlove() public {
        address to = msg.sender;
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        uint256 _speed = pickRandomSpeed(tokenId);
        string memory _model = pickRandomModel(tokenId);
        _safeMint(to, tokenId);
        attrShoes[tokenId] = Attr(_model, "_color", "_sec_color", _speed);
        updateColor(tokenId);
        updateSecColor(tokenId);
    }

    function getSvg(uint256 tokenId) public view returns (string memory) {
        string memory svg;
        string memory svg_1;
        string memory svg_2;
        string memory color = string(attrShoes[tokenId].color);
        string memory sec_color = string(attrShoes[tokenId].sec_color);
        string
            memory svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 512 512' style='enable-background:new 0 0 512 512' xml:space='preserve'><path style='fill:";
        string
            memory svgPartTwo = "' d='M461.913 456.348H50.087C22.468 456.348 0 433.88 0 406.261V372.87c0-9.223 7.479-16.696 16.696-16.696h478.609c9.217 0 16.696 7.473 16.696 16.696v33.391c-.001 27.619-22.469 50.087-50.088 50.087z'/><path style='fill:";
        string
            memory svgPartThree = "' d='M495.304 356.174H256v100.174h205.913c27.619 0 50.087-22.468 50.087-50.087V372.87c0-9.223-7.479-16.696-16.696-16.696z'/><path style='fill:";
        string
            memory svgPartFour = "' d='M280.71 266.017c-10.239-7.68-18.364-15.694-24.71-24.153-29.94-39.847-22.261-91.715-22.261-186.212H16.696A16.673 16.673 0 0 0 0 72.348v317.217h367.304V289.391c-16.584 0-51.311 3.006-86.594-23.374z'/><path style='fill:";
        string
            memory svgPartFive = "' d='M367.304 389.565V289.391c-16.584 0-51.311 3.005-86.595-23.374-10.239-7.68-18.364-15.694-24.71-24.153v147.701h111.305z'/><path style='fill:#dbe1e5' d='M350.609 322.783c-82.858 0-150.261-67.408-150.261-150.261V72.348c0-9.223 7.479-16.696 16.696-16.696h66.783c9.217 0 16.696 7.473 16.696 16.696v100.174c0 27.619 22.468 50.087 50.087 50.087 9.217 0 16.696 7.473 16.696 16.696v66.783c-.002 9.222-7.48 16.695-16.697 16.695z'/><path style='fill:#dbe1e5' d='M350.609 222.609c-27.619 0-50.087-22.468-50.087-50.087V72.348c0-9.223-7.479-16.696-16.696-16.696H256v233.462c25.854 21.018 58.769 33.668 94.609 33.668 9.217 0 16.696-7.473 16.696-16.696v-66.783c-.001-9.221-7.479-16.694-16.696-16.694z'/><path style='fill:#000' d='M283.826 155.826h-66.783c-9.217 0-16.696-7.473-16.696-16.696s7.479-16.696 16.696-16.696h66.783c9.217 0 16.696 7.473 16.696 16.696s-7.479 16.696-16.696 16.696z'/><path style='fill:";
        string
            memory svgPartSix = "' d='M283.826 122.435H256v33.391h27.826c9.217 0 16.696-7.473 16.696-16.696s-7.479-16.695-16.696-16.695zm-27.664 161.229a16.639 16.639 0 0 1-11.804-4.892c-6.521-6.521-6.521-17.092 0-23.609l47.229-47.223c6.521-6.521 17.087-6.521 23.609 0s6.521 17.092 0 23.609l-47.229 47.223a16.643 16.643 0 0 1-11.805 4.892z'/><path style='fill:";
        string
            memory svgPartSeven = "' d='M291.587 207.94 256 243.523v40.109c.056.001.107.032.162.032 4.272 0 8.544-1.631 11.804-4.892l47.229-47.223c6.521-6.516 6.521-17.087 0-23.609s-17.086-6.521-23.608 0z'/><path style='fill:#edf0f2' d='M116.87 222.609c-27.619 0-50.087-22.468-50.087-50.087s22.468-50.087 50.087-50.087 50.087 22.468 50.087 50.087-22.468 50.087-50.087 50.087z'/><path style='fill:#dae1e6' d='M395.13 222.609h-27.826c-16.211 0-22.261.892-33.391-3.076v170.033H512v-50.087c0-64.546-52.324-116.87-116.87-116.87z'/></svg>";

        svg_1 = string(
            abi.encodePacked(
                svgPartOne,
                sec_color,
                svgPartTwo,
                sec_color,
                svgPartThree,
                color
            )
        );
        svg_2 = string(
            abi.encodePacked(
                svgPartFour,
                color,
                svgPartFive,
                sec_color,
                svgPartSix,
                sec_color,
                svgPartSeven
            )
        );
        svg = string(abi.encodePacked(svg_1, svg_2));
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
                        attrShoes[tokenId].model,
                        '",',
                        '"image_data": "',
                        getSvg(tokenId),
                        '",',
                        '"attributes": [{"trait_type": "Speed", "value": ',
                        uint2str(attrShoes[tokenId].speed),
                        "},",
                        '{"trait_type": "Color", "value": "',
                        attrShoes[tokenId].color,
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

    function pickRandomSpeed(uint256 tokenId) internal view returns (uint256) {
        uint256 rand = random(
            string(
                abi.encodePacked(
                    "Speed",
                    Strings.toString(tokenId),
                    block.coinbase,
                    blockhash(block.number - tokenId)
                )
            )
        );
        rand = rand % speed.length;
        return speed[rand];
    }

    function incrementSpeed(uint256 tokenId)
        public
        onlyOwner
        returns (uint256)
    {
        uint256 curStr = attrShoes[tokenId].speed;
        if (curStr < 10) {
            attrShoes[tokenId].speed = curStr + 1;
            updateColor(tokenId);
        } else {
            attrShoes[tokenId].speed = curStr;
        }
        return attrShoes[tokenId].speed;
    }

    function deductSpeed(uint256 tokenId) public onlyOwner returns (uint256) {
        uint256 curStr = attrShoes[tokenId].speed;
        if (curStr > 0) {
            attrShoes[tokenId].speed = curStr - 1;
            updateColor(tokenId);
        } else {
            attrShoes[tokenId].speed = curStr;
        }
        return attrShoes[tokenId].speed;
    }

    function updateColor(uint256 tokenId) internal {
        attrShoes[tokenId].color = colors[attrShoes[tokenId].speed];
    }

    function updateSecColor(uint256 tokenId) internal {
        attrShoes[tokenId].sec_color = sec_colors[attrShoes[tokenId].speed];
    }

    function getSpeed(uint256 tokenId) public view returns (uint256) {
        return attrShoes[tokenId].speed;
    }

    function pickRandomModel(uint256 tokenId) internal returns (string memory) {
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
