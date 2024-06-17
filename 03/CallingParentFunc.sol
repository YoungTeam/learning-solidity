// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 基础合约
contract Base {
    event Log(string message);

    function foo() public virtual {
        emit Log("Base foo");
    }

    function bar() public virtual {
        emit Log("Base bar");
    }
}

// 子合约 F 继承自 Base
contract F is Base {
    function foo() public virtual override {
        emit Log("F foo");
        Base.foo();
    }

    function bar() public virtual override {
        emit Log("F bar");
        super.bar();
    }
}

// 子合约 G 继承自 Base
contract G is Base {
    function foo() public virtual override {
        emit Log("G foo");
        Base.foo();
    }

    function bar() public virtual override {
        emit Log("G bar");
        super.bar();
    }
}

// 子合约 G 继承自 Base
contract H is F,G {
    function foo() public virtual override(F,G){
        F.foo();
    }

    function bar() public virtual override(F,G) {      
        super.bar();
    }
}