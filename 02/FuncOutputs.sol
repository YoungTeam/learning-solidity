// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FuncOutputs{

    uint _uint;
    bool _bool;
    string _string;

    function returnMultiple() public pure returns (uint ,bool ,string memory){
       return (1,true,"hello world!");
    }

    function captureOutputs() public {
            (_uint,_bool,_string) = returnMultiple();
    }

    function displayOutputs() public view returns (uint ,bool ,string memory){
         return (_uint,_bool,_string);
    }
}