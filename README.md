crystalize.dev

Oct 24 to Oct 29,2022.

### This work includes

- An article about Solidity's `delegatecall` function.

- A simple implementation of `delegatecall`.

cd-research-w3-delegatecall

----

# Diving-into-delegatecall

## Problem

Recently, I stumbled apon the max contract size problem. My contract reached roughly 27KB and I tried downsizing it by optimizing state variables and even attempted to split it into smaller contracts. In the process, I discovered EIP-2535 Diamonds, Multi-Facet Proxy and the use of `delegatecall`. This article acts as an important piece in building a solid knowledge base, helps to prepare for the study of advanced smart contract architectures.

## Definition

When ContractA calls ContractB, ContractA executes its logic with functions from ContractB within ContractA’s context. More specifically, reads and writes to states variables happen to ContractA only, never to ContractB, and functions executed with `delegatecall` have `address(this)`, `msg.sender`, `msg.value` unchanged.

> delegatecall affects the state variables of the contract that calls a function with delegatecall. The state variables of the contract that holds the functions that are borrowed are not read or written.

## Code explanation

![image](https://user-images.githubusercontent.com/48362877/199665052-e144a806-60de-4034-ad21-2cc468848340.png)
![image](https://user-images.githubusercontent.com/48362877/199664660-2c61ddd2-ebc5-4a6d-87b0-9f7564fc05a4.png)


## Common pitfall

### `delegatecall` in `fallback()` function

![image](https://user-images.githubusercontent.com/48362877/199662022-57e6b77c-bd3b-4129-ad08-23722f7a5d99.png)
![image](https://user-images.githubusercontent.com/48362877/199662087-9ddb82ff-08ac-4eae-9e72-73934bd56c59.png)


### Wrong layout between the caller and the callee contracts

![image](https://user-images.githubusercontent.com/48362877/199662152-8012ce53-c987-4ef2-8a56-1fa2b455abbc.png)
![image](https://user-images.githubusercontent.com/48362877/199662518-e05a9a92-a786-4cef-84f6-af1309c8918c.png)


## Best practice

1. Do not execute untrusted malicious code. Since ContractB has the ability to modify state vars of ContractA, function code from ContractB could destroy ContractA by calling `selfdestruct`

2. Do not call empty contract does not revert and will lead to bugs.

3. The layout of both proxy and logic contracts must be the same. 

- If ContractA has uint at slot 0 and string at slot 1, while ContractB has a string at slot 0 and byte32 at slot 1, the data will be updated incorrectly
- Make sure to have a thorough understanding of the storage layouts.

## Use cases

There are currently two smart contracts architectures that use delegatecall.

### 1. OpenZeppelin Proxy Contracts

### 2. EIP-2535 Diamonds

## Summary

`delegatecall` opens smart contracts to loading code from other libraries during run time.

`delegatecall` makes contract’s storage implementation of reusable library code possible, allowing the development of a more complex data structure.

## Sources

https://eips.ethereum.org/EIPS/eip-2535

https://coinsbench.com/unsafe-delegatecall-part-2-hack-solidity-5-94dd32a628c7

https://coinsbench.com/unsafe-delegatecall-part-1-hack-solidity-5-81d5f295edb6

