// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Receiver{


    event Log(bytes data);
    //0xa9059cbb
    //0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4
    //000000000000000000000000000000000000000000000000000000000000006f
    function transfer(address _to,uint amount) external{
        emit Log(msg.data);
    }
    
}

contract FuncSel{
    //0xa9059cbb
    function getSelector(string calldata _func) external pure returns(bytes4){
            return bytes4(keccak256(bytes(_func)));
    }
}