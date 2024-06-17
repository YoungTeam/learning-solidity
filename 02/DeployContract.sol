// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Simple{

    address owner = msg.sender;

    uint public num;

    constructor(){
        num = 100;
    }

    function set(uint val) external{
        num = val;
    }

    function get() external view returns(uint){
        return num;
    }
}

contract deploy{
    event Deploy(address);
    
    event Response(bool,bytes);
    receive() external payable{} 
    function deployAssembly(bytes memory _code) external payable returns(address addr){ 
        assembly {
            //param1:callvalue(), // wei sent with current call
            //param2:存储位置(从32开始)和需要的长度(bytecode)
            //param3:存储在memory中
            addr := create(callvalue(),add(_code, 0x20),mload(_code))
        }

        require(addr!=address(0),"deploy failed");
        emit Deploy(addr);
    }

    function exec(address _target,bytes memory _data) public payable returns(bool,bytes memory){
        (bool success,bytes memory data) = _target.call{value:msg.value}(_data);
        require(success == true,"err");
        emit Response(success, data); //释放事件

        return (success,data);
    }
}

contract test{

    function getSimpleCode() external  pure returns (bytes memory){

        return type(Simple).creationCode;
        //return abi.encodePacked(byteCodes,abi.encode((x,y))););
    }

    function retSetCode(uint x) external  pure returns (bytes memory){
        return abi.encodeWithSignature("set(uint256)", x);
    }


    function retGetCode()  external pure returns (bytes memory){
        return abi.encodeWithSignature("get()");
    }

}