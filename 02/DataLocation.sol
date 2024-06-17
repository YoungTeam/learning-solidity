// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataLocation{
    event Log(DataStruct ds);

    struct DataStruct{
        string str;
        uint256[] arr;
    }

    DataStruct public dataStruct;
        
    constructor(){
        dataStruct.str = "test";
        dataStruct.arr = [1,2,3,4,5];

    }
    
    function setStr(string calldata _str) public {
        DataStruct storage ds = dataStruct;
        ds.str = _str;
    }


    function setArr(uint[] calldata _arr) private {
        dataStruct.arr = _arr;
    }

    function test(uint[] calldata _arr) public{

        emit Log(dataStruct);
        setArr(_arr);
        emit Log(dataStruct);
    }
}