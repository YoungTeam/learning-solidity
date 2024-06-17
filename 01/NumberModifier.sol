// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NumberModifier{

    uint private number = 1;
    modifier nonZero(){
        require(number != 0, "Number is zero and cannot be processed.");
        _;
    }

    function doubleNumber() public nonZero{
        number *=2;
    }

    function resetNumber() public nonZero{
        number = 0;
    }

}