// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Sign{

    function  getSign() public pure returns (bytes4){

            return bytes4(keccak256("transfer(address,uint256)"));
    }

}