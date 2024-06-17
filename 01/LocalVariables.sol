// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
contract LocalVariables {
    // 声明状态变量
    uint public i = 0;
    bool public b = false;
    address public myAddress = address(0);

    function updateVariables() public {
        // 声明局部变量
        uint x = 123;
        bool f = false;

        // 更新局部变量
        x += 456;
        f = true;

        // 更新状态变量
        i = 123;
        b = true;
        myAddress = address(1);

        // 局部变量在函数执行完毕后不会保留修改
    }
}