// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLock {
    uint public MIN_DELAY = 10;
    uint public MAX_DELAY = 1000;
    uint public GRACE_PERIOD = 1000;

    address public owner;
    mapping(bytes32 => bool) public queued;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function getTxId(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) public pure returns (bytes32) {
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }

    error AlreadyQueuedError(bytes32 txId);
    error NotQueuedError(bytes32 txId);
    error NotInRangeError(uint currTime, uint expectTime);
    error NotExecTimeError(uint currTime, uint expectTime);
    error ExpiredTimeError(uint currTime, uint expectTime);
    error ExecError();

    event QueueLog(
        bytes32 indexed _txId,
        address indexed _target,
        uint _value,
        string _func,
        bytes _data,
        uint _timestamp
    );
    event ExecLog(
        bytes32 indexed _txId,
        address indexed _target,
        uint _value,
        string _func,
        bytes _data,
        uint _timestamp
    );
    event CancelLog(bytes32 indexed _txId);

    modifier OnlyOwner() {
        require(owner == msg.sender, "Not Owner");
        _;
    }

    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        if (queued[txId]) {
            revert AlreadyQueuedError(txId);
        }

        if (
            _timestamp < block.timestamp + MIN_DELAY ||
            _timestamp < block.timestamp + MAX_DELAY
        ) {
            revert NotInRangeError(block.timestamp, _timestamp);
        }

        queued[txId] = true;
        emit QueueLog(txId, _target, _value, _func, _data, _timestamp);
    }

    function execute(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external payable OnlyOwner {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        if (!queued[txId]) {
            revert NotQueuedError(txId);
        }

        if (block.timestamp < _timestamp) {
            revert NotExecTimeError(block.timestamp, _timestamp);
        }

        if (block.timestamp > _timestamp + GRACE_PERIOD) {
            revert ExpiredTimeError(block.timestamp, _timestamp + GRACE_PERIOD);
        }

        bytes memory data;
        if (bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
        } else {
            data = _data;
        }

        (bool succ, bytes memory res) = _target.call{value: _value}(data);

        if (!succ) {
            revert ExecError();
        }
        emit ExecLog(txId, _target, _value, _func, _data, _timestamp);
    }

    function cancel(bytes32 txId) external OnlyOwner {
        if (!queued[txId]) {
            revert NotQueuedError(txId);
        }
        queued[txId] = false;
        emit CancelLog(txId);
    }
}


contract Test{
    address public timeLock;
    constructor(address _timeLock){
        timeLock = _timeLock;
    }

    function test() external{
        require(msg.sender == timeLock);
        //
    }

    function getTimestamp() external view returns(uint){
        return block.timestamp+100;
    }
}
