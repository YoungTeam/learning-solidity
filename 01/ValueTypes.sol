// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Data types - values and references

contract ValueTypes {


    uint256 public u = 256;
    int public i = -128;
    bool public b = true;
    bytes1 public _b;

    int public minInt = type(int).min;
    int public maxInt = type(int).max;
    mapping(address => uint256) public _balances;

    //address public addr = 0xdfdsfdsfsmdfsdjflsdmfdsfmdsfjdsfmfsdfds;
    //bytes32 public b32 = 0xdfdsfdsfsmdfsdjflsdmfdsfmdsfjdsfmfsdfds;

}
