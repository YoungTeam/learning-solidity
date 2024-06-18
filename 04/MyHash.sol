// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyHash {
    function hashFunction(
        string memory text,
        uint256 num,
        address addr
    ) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text, num, addr));
    }

    function encodeFunction(string memory text0, string memory text1)
        external
        pure
        returns (bytes memory)
    {
        return abi.encode(text0, text1);
    }

    function encodePackedFunction(string memory text0, string memory text1)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodePacked(text0, text1);
    }

    function collisionFunction(
        string memory text0,
        uint256 num,
        string memory text1
    ) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text0, num, text1));
    }
}
