// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract S{
    string public name;
    constructor(string memory _name){
        name = _name;
    }
}

contract T{
    string public text;
    constructor(string memory _text){
        text = _text;
    }
}

contract U is S,T{

    constructor(string memory _name,string memory _text) S(_name) T(_text){

    }

}

contract BB is S("s"),T{

    constructor(string memory _text) T(_text){

    }

}

contract B0 is S,T{
    constructor(string memory _name,string memory _text) S(_name) T(_text){

    }
}

contract B2 is T,S{
    constructor(string memory _name,string memory _text) S(_name) T(_text){

    }
}