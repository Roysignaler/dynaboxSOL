// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./base64.sol";

contract glovesNft is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => Attr) public attrGloves;

    struct Attr {
        string model;
        string color;
        uint256 strength;
    }
    string[] models = ["Galactic", "Everfirst", "Venom", "Insigni", "Classic"];
    string[] colors = [
        "red",
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
    uint256[] strength = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    constructor() ERC721("Boxing Gloves", "BOXING GLOVES") {}

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
        uint256 _strength = pickRandomStrength(tokenId);
        string memory _color = colors[attrGloves[tokenId].strength];
        string memory _model = pickRandomModel(tokenId);
        _safeMint(to, tokenId);
        attrGloves[tokenId] = Attr(_model, _color, _strength);
        _color = colors[attrGloves[tokenId].strength];
        attrGloves[tokenId] = Attr(_model, _color, _strength);
    }

    function getSvg(uint256 tokenId) public view returns (string memory) {
        string memory svg;
        string
            memory svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 383.998 383.998' style='enable-background:new 0 0 383.998 383.998' xml:space='preserve'><path style='fill:#5a3392' d='M204.937 1020.42c-19.624.416-44.152 8.355-65.437 16.406-28.066 10.615-46.651 42.721-45 72.156l1.187 22.563-7.094-.16c-22.251-.305-40.625 17.811-40.625 40.064v5.188c0 10.662 4.354 20.941 12.031 28.344l31.906 30.719v.688c0 29.787 18.203 55.402 44.063 66.314v49.563h19.781v24.031h-19.781v4.094c-.001 13.16 10.933 23.969 24.094 23.969h111.969c13.16 0 23.969-10.811 23.969-23.969v-34.5h-15.937v-24.031H296v-21.375c23.608-11.822 40.031-35.965 40.031-64.094v-125.656c0-30.643-21.069-63.111-50.531-73.125-25.802-8.77-56.771-17.686-80.437-17.219h-.128l.002.03z' transform='translate(0 -1020.36)'/><path style='fill:";
        string memory color = string(attrGloves[tokenId].color);
        string
            memory svgPartTwo = "' d='M205.281 1036.483h.03c19.098-.367 49.891 7.75 75 16.281 21.032 7.148 39.656 35.299 39.656 58v125.656c0 31.025-24.945 56-55.968 56H163.843c-31.024 0-56-24.975-56-56v-4.123a8 8 0 0 0-2.467-5.781l-34.25-33.063c-4.554-4.391-7.094-10.455-7.094-16.783v-5.189c0-13.535 10.809-24.262 24.344-24.094l76.063.943c6.9 0 13.471 2.363 18.187 6.625 4.554 4.111 5.654 9.219 5.654 14.281v24.438c0 6.395-2.51 12.527-6.969 16.656-4.699 4.348-10.492 5.563-15.812 5.563h-8.5c-6.407 0-12.637-2.395-17.25-6.844a2255.491 2255.491 0 0 1-8.031-7.813 8.024 8.024 0 0 0-11.094 11.594s5.352 5.066 8.031 7.656c7.59 7.316 17.798 11.469 28.344 11.469h8.5c8.036 0 18.29-2.164 26.687-9.938 7.288-6.746 11.215-16.029 11.876-25.625h62.656c10.603.002 20.71-4.203 28.218-11.686l6.625-6.5a8.002 8.002 0 0 0-5.781-13.813h-.032a7.995 7.995 0 0 0-5.406 2.467l-6.625 6.5c-4.511 4.5-10.626 7.094-17 7.094h-62.375v-11.219c0-7.854-2.316-18.271-10.968-26.094-8.032-7.26-18.434-10.623-28.718-10.75l-52.907-.721-1.282-23.623c-1.203-21.463 15.119-48.807 34.718-56.219 20.6-7.793 44.794-15.02 60.094-15.344l.002-.001z' transform='translate(0 -1020.36)'/><path style='fill:";
        string
            memory svgPartThree = "' d='M204.064 1048.211h.027c17.348-.305 45.319 7.039 68.127 14.789 19.105 6.492 36.022 32.064 36.022 52.686v114.141c0 28.182-22.66 50.869-50.84 50.869h-90.978c-28.181 0-50.868-22.688-50.868-50.869v-3.742a7.268 7.268 0 0 0-2.237-5.25l-31.111-30.031c-4.136-3.992-6.445-9.498-6.445-15.244v-4.717c0-12.297 9.819-22.039 22.114-21.887l69.092.848c6.268 0 12.237 2.146 16.52 6.021 4.136 3.73 5.134 8.375 5.134 12.975v22.197c0 5.805-2.28 11.379-6.33 15.129-4.269 3.953-9.53 5.055-14.363 5.055h-7.722c-5.817 0-11.479-2.176-15.669-6.217-2.437-2.346-7.296-7.096-7.296-7.096a7.288 7.288 0 1 0-10.146 10.465l.07.066s4.862 4.607 7.295 6.955c6.895 6.646 16.167 10.418 25.747 10.418h7.722c7.299 0 16.614-1.967 24.24-9.027 6.621-6.129 10.188-14.561 10.788-23.277h56.914c9.631 0 18.812-3.816 25.632-10.615l6.023-5.902a7.267 7.267 0 0 0-5.249-12.546h-.029a7.263 7.263 0 0 0-4.91 2.238l-6.023 5.9c-4.1 4.088-9.653 6.445-15.442 6.445h-56.66v-10.189c0-7.135-2.104-16.598-9.963-23.703-7.296-6.594-16.745-9.65-26.087-9.766l-48.058-.656-1.167-21.459c-1.095-19.494 13.734-44.334 31.537-51.066 18.712-7.078 40.689-13.641 54.587-13.938h.002z' transform='translate(0 -1020.36)'/><path style='fill:#29a3ec' d='M152.031 1308.36h60.75l-18.344 18.438a8 8 0 0 0-.029 11.314l.029.029 26.219 26.219-23.969 24.094h-36.625c-4.511-.002-8.031-3.518-8.031-8.031v-72.063z' transform='translate(0 -1020.36)'/><path style='fill:#3cdef6' d='M235.312 1308.36h44.751v72.063c0 4.512-3.52 8.031-8.031 8.031h-52.813l18.313-18.438a8.001 8.001 0 0 0 0-11.219l-26.094-26.342 23.875-24.094-.001-.001z' transform='translate(0 -1020.36)'/><path style='fill:#fff' d='M257.165 1067.951a8 8 0 0 0-2.007 15.473c14.372 5.752 20.703 14.291 27.638 27.992a8.002 8.002 0 1 0 14.291-7.205c-7.648-15.111-17.677-28.326-36.023-35.668a8.017 8.017 0 0 0-3.894-.607l-.005.015zM303 1131.92a8 8 0 1 1-16 0 8 8 0 0 1 16 0z' transform='translate(0 -1020.36)'/><path style='fill:#5a3392' d='M204.967 1020.442c-19.625.416-44.245 8.355-65.531 16.406-28.066 10.615-46.651 42.658-45 72.094l1.25 22.531-7.094-.16c-22.251-.271-40.625 17.871-40.625 40.125v5.188a39.292 39.292 0 0 0 12 28.281l31.875 30.75v.688c0 39.67 32.33 72 72 72h100.125c39.67 0 72-32.33 72-72v-125.686c0-30.645-21.069-63.082-50.531-73.094-25.803-8.77-56.807-17.648-80.469-17.188v.065zm.313 15.968c19.102-.367 49.892 7.844 75 16.377 21.032 7.146 39.688 35.236 39.688 57.938v125.686c0 31.021-24.977 56-56 56H163.842c-31.023 0-56-24.979-56-56v-4.094c0-2.168-.88-4.242-2.437-5.75l-34.313-33.094a23.26 23.26 0 0 1-7.125-16.75v-5.188c0-13.535 10.872-24.293 24.406-24.125l76 .943c6.967.16 13.551 2.41 18.25 6.656 4.55 4.113 5.656 9.154 5.656 14.219v24.5c0 6.393-2.509 12.463-6.969 16.594-4.699 4.352-10.49 5.625-15.813 5.625h-8.563c-6.407 0-12.574-2.459-17.188-6.906-2.677-2.58-8.031-7.748-8.031-7.748a8.002 8.002 0 0 0-11.315.055 8 8 0 0 0 .19 11.445s5.382 5.166 8.063 7.75a40.763 40.763 0 0 0 28.281 11.406h8.563c8.034 0 18.29-2.1 26.688-9.875 7.972-7.385 12.094-17.789 12.094-28.344v-24.5c0-7.854-2.286-18.271-10.938-26.094-8.05-7.277-18.469-10.561-28.687-10.75h-.032l-52.906-.656-1.312-23.594c-1.204-21.463 15.088-48.838 34.687-56.252 20.59-7.787 44.886-15.076 60.188-15.406l.001-.068z' transform='translate(0 -1020.36)'/><path style='fill:#5a3392' d='M295.748 1164.41a8.005 8.005 0 0 0-5.5 2.406l-6.594 6.563a24.081 24.081 0 0 1-17 7.031h-66.563a8.001 8.001 0 1 0 0 16h66.563a40.13 40.13 0 0 0 28.313-11.686l6.563-6.563a8 8 0 0 0-5.782-13.751z' transform='translate(0 -1020.36)'/></svg>";
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
                        attrGloves[tokenId].model,
                        '",',
                        '"image_data": "',
                        getSvg(tokenId),
                        '",',
                        '"attributes": [{"trait_type": "Strength", "value": ',
                        uint2str(attrGloves[tokenId].strength),
                        "},",
                        '{"trait_type": "Color", "value": "',
                        attrGloves[tokenId].color,
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

    function pickRandomStrength(uint256 tokenId)
        internal
        view
        returns (uint256)
    {
        uint256 rand = random(
            string(
                abi.encodePacked(
                    "Strength",
                    Strings.toString(tokenId),
                    block.coinbase,
                    blockhash(block.number - tokenId)
                )
            )
        );
        rand = rand % strength.length;
        return strength[rand];
    }

    function incrementStrength(uint256 tokenId)
        public
        onlyOwner
        returns (uint256)
    {
        uint256 curStr = attrGloves[tokenId].strength;
        if (curStr < 10) {
            attrGloves[tokenId].strength = curStr + 1;
            updateColor(tokenId);
        } else {
            attrGloves[tokenId].strength = curStr;
        }
        return attrGloves[tokenId].strength;
    }

    function deductStrength(uint256 tokenId)
        public
        onlyOwner
        returns (uint256)
    {
        uint256 curStr = attrGloves[tokenId].strength;
        if (curStr > 0) {
            attrGloves[tokenId].strength = curStr - 1;
            updateColor(tokenId);
        } else {
            attrGloves[tokenId].strength = curStr;
        }
        return attrGloves[tokenId].strength;
    }

    function updateColor(uint256 tokenId) internal {
        attrGloves[tokenId].color = colors[attrGloves[tokenId].strength];
    }

    function getStrength(uint256 tokenId) public view returns (uint256) {
        return attrGloves[tokenId].strength;
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
