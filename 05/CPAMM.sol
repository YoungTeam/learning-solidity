// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CPAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        totalSupply += _amount;
        balanceOf[_to] += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function _update(uint _res0, uint _res1) private {
        reserve0 = _res0;
        reserve1 = _res1;
    }

    function swap(
        address _tokenIn,
        uint _amountIn
    ) external returns (uint amountOut) {
        require(
            _tokenIn == address(token0) || _tokenIn == address(token1),
            "invalid token"
        );

        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint resIn, uint resOut) = isToken0
            ? (token0, token1, reserve0, reserve1)
            : (token1, token0, reserve1, reserve0);

        //transer token in
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);

        //calculate amount out (including fees)
        //y*dx /(x+dx) = dy
        uint amountInWithFee = (amountIn * 997) / 1000;
        amountOut = (resOut * amountInWithFee) / (resIn + amountInWithFee);

        tokenOut.transfer(msg.sender, amountOut);
        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }

    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }

    function addLiquidity(
        uint _amount0,
        uint _amount1
    ) external returns (uint shares) {
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        // dy/dx = y/x
        require(reserve0 * _amount1 == reserve1 * _amount0, "dy/dx != y/x");

        //mint share
        // f(x,y)  = value of liquidity =sqrt(xy)
        //s = dx/x *T = dy/y*T
        if (totalSupply == 0) {
            shares = _sqrt(_amount0 * _amount1);
        } else {
            shares = _min(
                (_amount0 * totalSupply) / reserve0,
                (_amount1 * totalSupply) / reserve1
            );
        }

        require(shares > 0, "shares = 0");

        _mint(msg.sender, shares);
        _update(token0.balanceOf(address(this)),token1.balanceOf(address(this)));
    }

    function removeLiquidity(uint _shares) external returns (uint d0, uint d1) {
        /***
                a = s*L/T
             */

        d0 = (_shares * reserve0) / totalSupply;
        d1 = (_shares * reserve1) / totalSupply;
        _burn(msg.sender, _shares);

        _update(reserve0 - d0, reserve1 - d1);

        if (d0 > 0) {
            token0.transfer(msg.sender, d0);
        }

        if (d1 > 0) {
            token1.transfer(msg.sender, d1);
        }
    }

    // 使用牛顿迭代法计算平方根
    function sqrt(uint256 x) public pure returns (uint256) {
        if (x == 0) return 0;
        if (x <= 3) return 1;

        uint256 z = x;
        uint256 y = (x + 1) / 2;

        // 迭代直到 y 不再变化
        while (y < z) {
            z = y;
            y = (x / y + y) / 2;
        }

        return z;
    }
}
