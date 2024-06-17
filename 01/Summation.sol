// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Summation{

    function sum(uint n) external pure returns (uint){

        uint total = 0;
        for(uint i=1;i<=n;i++){
                total+=i;
        }

        return total;
    }

}