// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract Earnchain {
    address public owner;

    enum BucketStatus { Open, Closed, Cancelled }

    struct StructBucket {
        address owner;
        BucketStatus status;
        uint256 entryAmount;
        uint256 totalAmount;
        uint limitParticipants;
        uint subscriptionStartTime;
        uint subscriptionEndTime;
    }

    mapping(uint => StructBucket) public buckets;

    constructor() {
        owner = msg.sender;
    }
}