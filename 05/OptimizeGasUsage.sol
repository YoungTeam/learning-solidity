// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasGolf{


    uint256 public total;

    function optimizeGasUsage(uint[] calldata arr) external returns(uint){ //memory->calldata   57489->55762       
        uint _total; //load to memory         54558 ->  54298
        for(uint i = 0;i<arr.length;i++){  //i+=1 -> i++   55762->54761
            uint thisNum = arr[i];              //cache arr[i] 54298->54146
            if(thisNum%2==0  && thisNum<100 ){  //short circle  54761->54558
                _total+=thisNum; 
            }
        }

        total = _total;
        return total;

    }

}