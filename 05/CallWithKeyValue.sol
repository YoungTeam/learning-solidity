// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KeyValueFunc{

    function sumFunc(uint x,uint y,uint z,address a,bool b ,string memory c) private pure{

    }

    function callWithKeyValue() public pure {

        sumFunc({
                x:1,
                y:2,
                z:3,
                a:address(0),
                b:true,
                c:"test"
        });

    }

}