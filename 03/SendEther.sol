// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SendEther {
    constructor() payable {}

    event Log(uint256 amount, uint256 gas);

    receive() external payable {
        emit Log(msg.value, gasleft());
    }

    // 使用transfer发送ETH
    function sendByTransfer(address payable _to, uint256 _amount) public {
        _to.transfer(_amount);
    }

    // 使用send发送ETH
    function sendBySend(address payable _to, uint256 _amount)
        public
        returns (bool)
    {
        bool sent = _to.send(_amount);
        require(sent, "Send failed");
        return sent;
    }

    // 使用call发送ETH
    function sendByCall(address payable _to, uint256 _amount)
        public
        returns (bool)
    {
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Call failed");
        return success;
    }
}