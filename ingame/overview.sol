// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./gloves.sol";


// Inheriate the functions 

contract Import is  {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Testona", "BOXING Testona") {}

    function mintTestona() public {
        address to = msg.sender; 
        uint256 tokenid = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        mintBoxingGlove();
    }
}