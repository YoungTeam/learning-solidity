// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
contract ProcessNumber {

    function processNumber(uint x) external pure returns (string memory){

       /* if(x < 10){
            return "\u5c0f\u4e8e\u0031\u0030";
        }else if(x >= 10 && x <= 20){
            return "\u4ecb\u4e8e\u0031\u0030\u5230\u0032\u0030";
        }else{
            return "\u5927\u4e8e\u0032\u0030";
        }*/


        return x < 10? "\u5c0f\u4e8e\u0031\u0030" : ((x >= 10 && x <=20)? "\u4ecb\u4e8e\u0031\u0030\u5230\u0032\u0030":"\u5927\u4e8e\u0032\u0030");

        


        
    }

}