crystalize.dev

Oct 24 to Oct 29,2022.

### This work includes

- An article about Solidity's `delegatecall` function.

- A simple implementation of `delegatecall`.

cd-research-w3-delegatecall

----

# Diving-into-delegatecall

## Problem

Recently, I stumbled apon the max contract size problem. My contract reached roughly 27KB and I tried downsizing it by optimizing state variables and even attempted to split it into smaller contracts. In the process, I discovered EIP-2535 Diamonds, Multi-Facet Proxy and the use of `delegatecall`. In this article, I’ll go deeper into `delegatecall`.

## Definition

When ContractA calls ContractB, ContractA executes its logic with functions from ContractB within ContractA’s context. More specifically, reads and writes to states variables happen to ContractA only, never to ContractB, and functions executed with `delegatecall` have `address(this)`, `msg.sender`, `msg.value` unchanged.

> delegatecall affects the state variables of the contract that calls a function with delegatecall. The state variables of the contract that holds the functions that are borrowed are not read or written.

## Code explanation

## Common pitfall

### `delegatecall` in `fallback()` function



### Wrong layout between the caller and the callee contracts



## Best practice

1. Do not execute untrusted malicious code. Since contract B has the ability to modify state vars of A, function code from B could destroy A by calling `selfdestruct`

2. Do not call empty contract does not revert and will lead to bugs.

3. The layout of both proxy and logic contracts must be the same. 
- If A has uint at slot 0 and string at slot 1, while B has a string at slot 0 and byte32 at slot 1, the data will be updated incorrectly
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

