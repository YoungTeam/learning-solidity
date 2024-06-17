// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage{
    uint public storedData;

    constructor (uint val){
        storedData = val;

    }

}