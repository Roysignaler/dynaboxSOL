// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract PlayerGen is ERC721URIStorage, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public constant baseFee = 0.03 ether;
//global level
//set function
//get level
    address payable withdrawAddress;
    address payable _owner;

    event WithdrawAddressTransferred(
        address indexed previousWithdrawAddress,
        address indexed newWithdrawAddress
    );

    event NewPractice(
        string name,
        uint256 tokenId,
        uint256 timestamp,
        uint256 pracShot,
        uint256 pracPassing,
        uint256 pracTackling,
        uint256 pracSaves,
        uint256 pracPractice
        uint256 xp;
    );

    struct Levels {
        uint256 level2 = 100;
        uint256 level3 = 200;
        uint256 level4 = 300;
        uint256 level5 = 400;
        uint256 level6 = 500;
        uint256 level7 = 600;
        uint256 level8 = 700;
        uint256 level9 = 800;
        uint256 level10 = 900;
    }
    struct Practice {
        string name;
        uint256 tokenId;
        uint256 timestamp;
        uint256 pracShot;
        uint256 pracPassing;
        uint256 pracTackling;
        uint256 pracSaves;
        uint256 pracPractice;
        uint256 level;
    }

    Practice[] practices;

    struct Abilities {
        string Name;
        uint256 Level;
        uint256 RequiredXP;
        /*uint256 Shooting;
        uint256 Passing;
        uint256 Tackling;
        uint256 Saves;
        uint256 Practice; */
        uint256 XP;
    }

    uint256 AllPrac = 3;
    uint256 SpecPrac = 1;

    mapping(uint256 => Abilities) public tokenIdToAbilities;

    constructor() ERC721("FB Players", "FBPLAYER") {
        // Store the address of the deployer as a payable address.
        // When we withdraw funds, we'll withdraw here.
        _owner = payable(msg.sender);
        withdrawAddress = payable(msg.sender);
    }

    function generatePlayer(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.name { fill: white; font-family: serif; font-size: 40px; }</style>"
            "<style>.base { fill: white; font-family: serif; font-size: 24px; }</style>",
            '<rect width="100%" height="100%" fill="green" />',
            '<text x="50%" y="25%" class="name" dominant-baseline="middle" text-anchor="middle">',
            getName(tokenId),
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', //level
            "Level: ",
            getLevel(tokenId),
            "</text>",
       /*   '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Shooting: ",
            getShooting(tokenId),
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Passing: ",
            getPassing(tokenId),
            "</text>"
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Tackling: ",
            getTackling(tokenId),
            "</text>"
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Saves: ",
            getSaves(tokenId),
            "</text>"   */
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

    function getName(uint256 tokenId) public view returns (string memory) {
        string memory name = tokenIdToAbilities[tokenId].Name;
        return name;
    }

    function getShooting(uint256 tokenId) public view returns (string memory) {
        uint256 shot = tokenIdToAbilities[tokenId].Shooting;
        return shot.toString();
    }

    function getPassing(uint256 tokenId) public view returns (string memory) {
        uint256 pass = tokenIdToAbilities[tokenId].Passing;
        return pass.toString();
    }

    function getTackling(uint256 tokenId) public view returns (string memory) {
        uint256 tackling = tokenIdToAbilities[tokenId].Tackling;
        return tackling.toString();
    }

    function getSaves(uint256 tokenId) public view returns (string memory) {
        uint256 save = tokenIdToAbilities[tokenId].Saves;
        return save.toString();
    }

    function getPractice(uint256 tokenId) public view returns (string memory) {
        uint256 practice = tokenIdToAbilities[tokenId].Practice;
        return practice.toString();
    }

    //getLevel
    function getLevel(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToAbilities[tokenId].Level;
        return level.toString();
    }

    function getXP(uint256 tokenId) public view returns (string memory) {
        uint256 xp = tokenIdToAbilities[tokenId].XP;
        return xp.toString();
    }

    function getPriceAllPractice(uint256 tokenId)
        public
        view
        returns (uint256)
    {
        uint256 _pracprice = pracPrice(tokenId, AllPrac);
        return _pracprice;
    }

    function getPriceSpecPractice(uint256 tokenId)
        public
        view
        returns (uint256)
    {
        uint256 _pracprice = pracPrice(tokenId, SpecPrac);
        return _pracprice;
    }

    function getWithdrawAddress() public view virtual returns (address) {
        return withdrawAddress;
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        string memory dataURI = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        "{",
                        '"name": "FB Battles #',
                        tokenId.toString(),
                        '",',
                        '"description": "FB on chain",',
                        '"image": "',
                        generatePlayer(tokenId),
                        '"',
                        '"attributes": [  // TODO: add level, multiply for attributes(gloves, etc). Remove everything else.
                        {"trait_type": "Level", "value": ',
                        uint2str(tokenIdToAbilities[tokenId].Level),
                        "},",
                      /*  {"trait_type": "Shooting", "value": ',
                        uint2str(tokenIdToAbilities[tokenId].Shooting),
                        "},",
                        '{"trait_type": "Passing", "value": ',
                        uint2str(tokenIdToAbilities[tokenId].Passing),
                        "},",
                        '{"trait_type": "Tackling", "value": ',
                        uint2str(tokenIdToAbilities[tokenId].Tackling),
                        "},",
                        '{"trait_type": "Saves", "value": ',
                        uint2str(tokenIdToAbilities[tokenId].Saves),
                        "},",
                        '{"trait_type": "Practice", "value": "',
                        uint2str(tokenIdToAbilities[tokenId].Practice),
                        '"}', */
                        "]}"
                    )
                )
            )
        );
        return
            string(abi.encodePacked("data:application/json;base64,", dataURI));
    }

    // Add name // String memory // _name
    function mint(string memory _name) public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToAbilities[newItemId].Name = _name;
        tokenIdToAbilities[newItemId].Level = 1;
        tokenIdToAbilities[newItemId].XP = 0;
    }

    function _levelUp(uint256 tokenId) internal returns (uint256) {
        require(tokenIdToAbilities[tokenId].XP >= tokenIdToAbilities[tokenId].RequiredXP);

            uint256 currentLevel = tokenIdToAbilities[tokenId].Level;
            uint256 oldRequiredXP = tokenIdToAbilities[tokenId].RequiredXP;
            uint256 currentXP = tokenIdToAbilities[tokenId].XP;
            tokenIdToAbilities[tokenId].XP = currentXP - RequiredXP;
            tokenIdToAbilities[tokenId].RequiredXP = RequiredXP + 100;
            tokenIdToAbilities[tokenId].Level = currentLevel + 1; 
    }    

  /*  function _practiceShooting(uint256 tokenId) internal returns (uint256) {
        uint256 currentShooting = tokenIdToAbilities[tokenId].Shooting;
        uint256 oldShooting = currentShooting;
        tokenIdToAbilities[tokenId].Shooting = currentShooting + random(3);
        uint256 changeInShooting = currentShooting - oldShooting;
        return changeInShooting;
    }
    
    function _XP(uint256 tokenId) internal returns (uint256) {
        uint256 currentXP = tokenIdToAbilities[tokenId].xp;
        uint256 oldXP = currentXP;
        tokenIdToAbilities[tokenId].xp = currentXP + 100;
        uint256 changeInXP = currentXP - oldXP;
        return changeInXP;
    }*/

    // Practice All
    function practiceAll(uint256 tokenId) public payable {
        require(_exists(tokenId), "Please use an existing player-token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to practice it on all abilities"
        );
        uint256 _pracprice = pracPrice(tokenId, AllPrac);
        require(msg.value >= _pracprice, "not enough provided for practice");
        string memory name = getName(tokenId);
        uint256 pracShoot = _practiceShooting(tokenId);
        uint256 pracPass = _practicePassing(tokenId);
        uint256 pracTack = _practiceTackling(tokenId);
        uint256 pracSaves = _practiceSaves(tokenId);

        uint256 pracPractice = practiceInc(tokenId, AllPrac);
        _setTokenURI(tokenId, getTokenURI(tokenId));
        // Add the practice to storage history
        practices.push(
            Practice(
                name,
                tokenId,
                block.timestamp,
                pracShoot,
                pracPass,
                pracTack,
                pracSaves,
                pracPractice
            )
        );

        emit NewPractice(
            name,
            tokenId,
            block.timestamp,
            pracShoot,
            pracPass,
            pracTack,
            pracSaves,
            pracPractice
        );
    }

  /*  // Practice Shooting
    function _practiceShooting(uint256 tokenId) internal returns (uint256) {
        uint256 currentShooting = tokenIdToAbilities[tokenId].Shooting;
        uint256 oldShooting = currentShooting;
        tokenIdToAbilities[tokenId].Shooting = currentShooting + random(3);
        uint256 changeInShooting = currentShooting - oldShooting;
        return changeInShooting;
    } */

   /* function practiceShooting(uint256 tokenId) public payable {
        require(_exists(tokenId), "Please use an existing player-token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this player-token to practice shooting"
        );
        uint256 _pracprice = pracPrice(tokenId, SpecPrac);
        require(msg.value >= _pracprice, "not enough provided for practice");
        _practiceShooting(tokenId);
        practiceInc(tokenId, SpecPrac);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    // Practice Passing
    function _practicePassing(uint256 tokenId) internal returns (uint256) {
        uint256 currentPassing = tokenIdToAbilities[tokenId].Passing;
        uint256 oldPassing = currentPassing;
        tokenIdToAbilities[tokenId].Passing = currentPassing + random(3);  
        uint256 changeInPassing = tokenIdToAbilities[tokenId].Passing -
            oldPassing;
        return changeInPassing;
    }

    function practicePassing(uint256 tokenId) public payable {
        require(_exists(tokenId), "Please use an existing player-token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to practice passing"
        );
        uint256 _pracprice = pracPrice(tokenId, SpecPrac);
        require(msg.value >= _pracprice, "not enough provided for practice");
        _practicePassing(tokenId);
        practiceInc(tokenId, SpecPrac);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    // Practice Tackling
    function _practiceTackling(uint256 tokenId) internal returns (uint256) {
        uint256 currentTackling = tokenIdToAbilities[tokenId].Tackling;
        uint256 oldTackling = currentTackling;
        tokenIdToAbilities[tokenId].Tackling = currentTackling + 1;
        uint256 changeInTackling = tokenIdToAbilities[tokenId].Tackling -
            oldTackling;
        return changeInTackling;
    }

    function practiceTackling(uint256 tokenId) public payable {
        require(_exists(tokenId), "Please use an existing player-token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to practice tackling"
        );
        uint256 _pracprice = pracPrice(tokenId, SpecPrac);
        require(msg.value >= _pracprice, "not enough provided for practice");
        _practiceTackling(tokenId);
        practiceInc(tokenId, SpecPrac);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    // Practice Saves
    function _practiceSaves(uint256 tokenId) internal returns (uint256) {
        uint256 currentSaves = tokenIdToAbilities[tokenId].Saves;
        uint256 oldSaves = currentSaves;
        tokenIdToAbilities[tokenId].Saves = currentSaves + 1;
        uint256 changeInTacking = tokenIdToAbilities[tokenId].Saves - oldSaves;
        return changeInTacking;
    }

    function practiceSaves(uint256 tokenId) public payable {
        require(_exists(tokenId), "Please use an existing player-token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to practices saves"
        );
        uint256 _pracprice = pracPrice(tokenId, SpecPrac);
        require(msg.value >= _pracprice, "not enough provided for practice");
        _practiceSaves(tokenId);
        practiceInc(tokenId, SpecPrac);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    // Increase Practice Function Practice
    function practiceInc(uint256 tokenId, uint256 pracType)
        internal
        returns (uint256)
    {
        uint256 currentPractice = tokenIdToAbilities[tokenId].Practice;
        uint256 oldPractice = currentPractice;
        tokenIdToAbilities[tokenId].Practice = currentPractice + pracType;
        uint256 changeInPractice = tokenIdToAbilities[tokenId].Practice -
            oldPractice;
        return changeInPractice;
    }

    function pracPrice(uint256 tokenId, uint256 pracType)
        public
        view
        returns (uint256)
    {
        uint256 currentPractice = tokenIdToAbilities[tokenId].Practice;
        uint256 _pracPrice = (currentPractice * pracType) * baseFee;
        return _pracPrice;
    } */

    function _changeWithdrawAddress(address payable newWithdrawAddress)
        public
        onlyOwner
    {
        address oldWithdrawAddress = withdrawAddress;
        withdrawAddress = newWithdrawAddress;
        emit OwnershipTransferred(oldWithdrawAddress, newWithdrawAddress);
    }

    function withdraw() public onlyOwner {
        require(_owner.send(address(this).balance));
    }

    // Random numbers

    function random(uint256 number) public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        msg.sender
                    )
                )
            ) % number;
    }

    // Random numbers
    uint256 initialNumber;

    function createRandom(uint256 number) public returns (uint256) {
        return uint256(keccak256(abi.encodePacked(initialNumber++))) % number;
    }

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
}
