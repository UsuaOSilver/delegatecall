
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ContractA {
    
    string internal tokenName = "RealityToken";
    
    function initialize() external {
        address contractBAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        (bool success, bytes memory returndata) = contractBAddress.delegatecall(
            abi.encodeWithSelector(ContractB.setTokenName.selector, "HumanToken")
        );
        
        // if the function call reverted
        if (success == false) {
            // if there's a return reason string
            if (returndata.length > 0) {
                // reason for revert
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert("Function call reverted");
            }
        }
    }
}

contract ContractB {
    
    string internal tokenName = "HumanToken";
    
    function setTokenName(string calldata _newName) external {
        tokenName = _newName;
    }
}