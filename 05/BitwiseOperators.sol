// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BitwiseOperators{

    function getLastNBits(uint x, uint n) public pure returns(uint){
            uint mask =  (1<< n)-1;
            return x & mask; 
    }


}