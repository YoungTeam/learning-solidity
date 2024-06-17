// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Base{
    uint private x;
    uint internal y;
    uint public z;

    function privateFunc() private pure returns(uint){
        return 0;
    }

    function internalFunc() internal  pure returns(uint){
        return 1;
    }


    function publicFunc() public pure returns(uint){
        return 10;
    }


    function externalFunc() external pure returns(uint){
        return 100;
    }

    function example() external view returns (uint){
        
        privateFunc();
        internalFunc();
        publicFunc();
        return x+y+z;
        //this.externalFunc();
    }
}


contract Child is Base{


    function example2() external view returns (uint){
       
        internalFunc();
        publicFunc();
        //this.externalFunc();
        return  y+z;
    }


}