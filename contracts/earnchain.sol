// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

contract Owned {
    address payable owner;
    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
}

contract Freezable is Owned {
    bool private _frozen = false;

    modifier notFrozen() {
        require(!_frozen, "Inactive Contract.");
        _;
    }

    function freeze() internal {
        if (msg.sender == owner) _frozen = true;
    }
}

contract Earnchain is Freezable {
    uint private lastBucketId = 10_000;

    enum BucketStatus {
        Open,
        Closed,
        Canceled
    }

    struct StructBucket {
        uint256 id;
        address owner;
        uint256 lockDays;
        BucketStatus status;
        uint256 entryAmount;
        uint256 totalAmount;
        uint256 limitParticipants;
        uint256 subscriptionStartTime;
        uint256 subscriptionEndTime;
    }

    mapping(uint256 => StructBucket) public bucketsCreated;

    constructor() payable {}

    function shutdown() external onlyOwner notFrozen {
        freeze();
        payable(msg.sender).transfer(address(this).balance);
    }

    function createBucket(
        uint256 _lockDays,
        uint256 _limitParticipants,
        uint256 _subscriptionStartTime,
        uint256 _subscriptionEndTime
    ) external payable returns (uint256) {

        //TODO:

        //require -> msg.value > 0
        // require(msg.value > 0, "You must send ETH to create a bucket");
        // require(msg.value >= 0.01 ether, "Entry amount too low");
        // require(msg.value <= 100 ether, "Entry amount too high");

        //require -> _lockDays > 30 (1month)
        // require(_lockDays >= 30, "Lock period must be at least 30 days");
        // require(_lockDays <= 365, "Lock period cannot exceed 365 days");

        //require -> _limitParticipants > 1
        // require(_limitParticipants > 1, "Must have at least 2 participants");
        // require(_limitParticipants <= 1000, "Too many participants");

        //require -> _subscriptionStartTime >= today
        //require -> _limitParticipants > _subscriptionStartTime
        // require(_subscriptionStartTime >= block.timestamp, "Start time must be in the future");
        // require(_subscriptionEndTime > _subscriptionStartTime, "End time must be after start time");
        // require(_subscriptionEndTime <= block.timestamp + 365 days, "Bucket duration too long");

        // require(msg.sender != address(0), "Invalid owner");

        uint256 bucketId = lastBucketId++;

        bucketsCreated[bucketId] = StructBucket({
            id: bucketId,
            owner: msg.sender,
            lockDays: _lockDays,
            status: BucketStatus.Open,
            entryAmount: msg.value,
            totalAmount: msg.value,
            limitParticipants: _limitParticipants,
            subscriptionStartTime: _subscriptionStartTime,
            subscriptionEndTime: _subscriptionEndTime
        });

        return bucketId;
    }
}
