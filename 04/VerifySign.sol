// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
0.message
1.hash(messaeg)
2.sign(hash(message),private key) | offchain
3.ecrecover(hash(message),signature) == singer


验证：
1. getMessageHash（）生成待加密hash
2. ethereum.enable(); ethereum.request({method:"personal_sign",params:[account,hash]}); 得到加密串
3. getEthSignedMessageHash（得到personal_sign）
4. recover()传入第三步的加密值，和第二步的加密串，获取到account账号
5. verify 验证原始加密信息 和 结果加密值 是不是同一个account创建的

*/

contract VerifySign {
    function verify(
        address _signer,
        string memory _message,
        bytes memory _sig
    ) external pure returns (bool) {
        bytes32 msgHash = getMessageHash(_message);
        bytes32 ethSignedMsg = getEthSignedMessageHash(msgHash);
        address signer = recover(ethSignedMsg, _sig);

        return (signer == _signer);
    }

    function getMessageHash(string memory _msg) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_msg));
    }

    //personal_sign 后来加入来解决这个问题。该方法在任何签名数据前加上"\x19Ethereum Signed Message:\n"，这意味着如果有人要签署交易数据，添加的前缀字符串会使其成为无效交易。
    function getEthSignedMessageHash(bytes32 _msgHash)
        public
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _msgHash)
            );
    }

    function recover(bytes32 _enSignMsgHash, bytes memory _sig)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_sig);
        address signer = ecrecover(_enSignMsgHash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
    }

    function splitSignature(bytes memory _sig)
        internal
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(_sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(_sig, 32)) //签名长度
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }
}
