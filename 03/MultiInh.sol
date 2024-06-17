// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A{
    function functionA()  public pure  virtual returns(string memory){
        return "A";
    }
}

contract B is A{
    function functionA()  public pure virtual override returns(string memory){
        return "B";
    }
}

contract C is A,B{
    
    function functionA()  public pure  override(A,B) returns(string memory){
        return "C";
    }
}
