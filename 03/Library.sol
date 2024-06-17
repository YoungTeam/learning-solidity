
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library MathLib{

    function min(uint x,uint y) public pure returns(uint){
            return x<y?x:y;
    }

}

library ArrayUtils{

    function sum(uint[] calldata arr) public pure returns(uint){
        uint total;
        for(uint i = 0;i<arr.length;i++){
            total+= arr[i];
        }
        return total;
    }

}

contract TestLibraries{

    function testMin(uint x,uint y) public pure returns(uint){
            return MathLib.min((x), y);
    }

    function testSum(uint[] calldata arr) public pure returns(uint){
            return ArrayUtils.sum(arr);
    }

}
