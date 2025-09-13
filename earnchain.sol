// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract Earnchain {
    address public owner;

    constructor() {
        owner = msg.sender;
    }
}