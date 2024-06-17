// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EfficientRemove{

    function efficientRemove(uint[] memory arr,uint idx) public pure returns (uint[] memory)  {
        require(idx < arr.length,"idx err");
        uint lastValue = arr[arr.length-1]; 
        arr[idx] = lastValue;
        arr.pop();
        return arr;
    }
}