// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MathContract{

    uint status = 2;

    function multiply(uint x ,uint y) public pure returns(uint){
        return x*y;
    }

    function getStatus() public view returns(uint){
        return status;
    }

}