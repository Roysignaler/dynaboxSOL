// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./base64.sol";

contract shortsNft is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => Attr) public attrShorts;

    struct Attr {
        string model;
        string color;
        uint256 charm;
    }
    string[] models = ["Galactic", "Everfirst", "Venom", "Insigni", "Classic"];
    string[] colors = ["red", "pink", "orange", "green", "blue", "violet", "purple", "black", "silver", "gold", "indigo"];
    uint256[] charms =[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    constructor() ERC721("Boxing Shorts", "BOXING SHORTS") {}

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
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

    function mintBoxingShorts() 
    public {
        address to = msg.sender;
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        uint256 _charms = pickRandomCharm(tokenId);
        string memory _color = colors[attrShorts[tokenId].charm];
        string memory _model = pickRandomModel(tokenId);
        _safeMint(to, tokenId);
        attrShorts[tokenId] = Attr(_model, _color, _charms);
        updateColor(tokenId);
    }

    function getSvg(uint tokenId) public view returns (string memory) {
        string memory svg;
        string memory svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 431.963 431.963' style='enable-background:new 0 0 431.963 431.963' xml:space='preserve'><path style='fill:#5a3392' d='M55.232 1036.393a8 8 0 0 0-7.187 7.905v46.875L.076 1427.205a8.002 8.002 0 0 0 7.907 9.094h176a8 8 0 0 0 7.656-5.783l24.344-85.154 24.344 85.154a8 8 0 0 0 7.656 5.783h176a8.001 8.001 0 0 0 7.906-9.094l-47.969-336.031v-46.875a8 8 0 0 0-7.906-7.905H55.951a7.497 7.497 0 0 0-.719-.001z' transform='translate(0 -1020.36)'/><path style='fill:#fff' d='M63.983 1052.33h304v32h-304v-32z' transform='translate(0 -1020.36)'/><path style='fill:";
        string memory color = string(attrShorts[tokenId].color);
        string memory svgPartTwo = "' d='M62.92 1100.267h306.125l36.562 256.063H235.701l-12.032-42.156a8 8 0 0 0-15.375 0l-12.031 42.156H26.357l36.563-256.063z' transform='translate(0 -1020.36)'/><path style='fill:#29a3ec' d='M24.076 1372.298H191.67l-13.719 48.064H17.201l6.875-48.064zm216.219 0h167.594l6.875 48.064h-160.75l-13.719-48.064z' transform='translate(0 -1020.36)'/><path style='fill:";
        string memory svgPartThree = "' d='M75.483 1115.736 41.92 1350.767h155.969l11.031-38.686a7.345 7.345 0 0 1 14.125 0l11.031 38.686h155.969l-33.563-235.031H75.483z' transform='translate(0 -1020.36)'/><path style='fill:#fff' d='M84.161 1233.193a8 8 0 0 1 8.559 9.158l-6.319 47.955a8.018 8.018 0 0 1-9.274 6.527 8.019 8.019 0 0 1-6.616-8.596l6.444-47.959a8.001 8.001 0 0 1 7.206-7.088v.003zm-8.709 75.473a8 8 0 1 1 0 16 8 8 0 0 1 0-16z' transform='translate(0 -1020.36)'/><path style='fill:#5a3392' d='M239.013 1088.234a8 8 0 0 0-7.086 8.15v75.826a8.03 8.03 0 0 0 8.081 7.982 8.033 8.033 0 0 0 7.982-7.982v-75.826a7.999 7.999 0 0 0-8.977-8.15zm-32.007 0a8 8 0 0 0-6.969 8.15v43.818a8.001 8.001 0 1 0 15.946 0v-43.818a7.999 7.999 0 0 0-8.977-8.15z' transform='translate(0 -1020.36)'/><path style='fill:#3cdef6' d='m38.542 1373.945 74.627-.01L100.592 1418l-68.353.01 6.303-44.065zm209.453.474h145.729l6.268 43.82H260.503l-12.508-43.82z' transform='translate(0 -1020.36)'/></svg>";
        svg = string(abi.encodePacked(svgPartOne, color, svgPartTwo, color, svgPartThree));
        return svg;
    }    

    function showSvg(uint tokenId) public view returns (string memory) {
        string memory show = getSvg(tokenId);
        return show;
    }

    function tokenURI(uint256 tokenId) override(ERC721) public view returns (string memory) {
        string memory json = Base64.encode(
            bytes(string(
                abi.encodePacked(
                    '{"name": "', attrShorts[tokenId].model, '",',
                    '"image_data": "', getSvg(tokenId), '",',
                    '"attributes": [{"trait_type": "charm", "value": ', uint2str(attrShorts[tokenId].charm), '},',
                    '{"trait_type": "Color", "value": "', attrShorts[tokenId].color, '"}',
                    ']}'
                )
            ))
        );
        return string(abi.encodePacked('data:application/json;base64,', json));
    }    

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomCharm(uint256 tokenId) public view returns (uint256) {
        uint256 rand = random(string(abi.encodePacked("Charm", Strings.toString(tokenId), block.coinbase, blockhash(block.number - tokenId))));
        rand = rand % charms.length;
        return charms[rand];
    }

    function incrementCharm(uint256 tokenId) public onlyOwner returns (uint256) {
        uint256 curChr = attrShorts[tokenId].charm;
        if (curChr < 10) {
            attrShorts[tokenId].charm = curChr + 1;
            updateColor(tokenId);
        } else { 
            attrShorts[tokenId].charm = curChr;
            }
        return attrShorts[tokenId].charm;
    }

    function deductCharm(uint256 tokenId) public onlyOwner returns (uint256) {
        uint256 curStr = attrShorts[tokenId].charm;
        if (curStr > 0) {
            attrShorts[tokenId].charm = curStr - 1;
            updateColor(tokenId);
        } else { 
            attrShorts[tokenId].charm = curStr;
            }
        return attrShorts[tokenId].charm;
    }

    function updateColor(uint256 tokenId) internal {
        attrShorts[tokenId].color = colors[attrShorts[tokenId].charm];
    }

    function getCharm(uint256 tokenId) public view returns (uint256) {
        return attrShorts[tokenId].charm;
    }

    function pickRandomModel(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Model", Strings.toString(tokenId), block.coinbase, blockhash(block.number - tokenId))));
        rand = rand % models.length;
        return models[rand];
    }
}
