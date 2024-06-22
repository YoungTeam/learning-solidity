// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasGolf{


    uint256 public total;

    function optimizeGasUsage(uint[] memory arr) external view returns(uint){ //memory->calldata 

        for(uint i = 0;i<arr.length;i+=1){ 
            if(arr[i]<100 && arr[i]%2==0){  //short circle
                total+=arr[i]; 
            }
        }

        return total;

        /*
        uint _total = total; //load to memory
        for(uint i = 0;i<arr.length;i++){  //i+=1 -> i++
            uint thisNum = arr[i];              //cache arr[i]
            if(thisNum%2==0 && thisNum<100){  //short circle
                _total+=thisNum; 
            }
        }

        return _total;*/

    }

}