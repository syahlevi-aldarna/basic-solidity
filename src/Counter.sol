// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Counter {
    uint256 public counter;
    address public owner;

    error NotOwner();
    error InvalidValue();

    event CounterIncremented(uint256 newValue);
    event CounterDecremented(uint256 newValue);
    event CounterReset();

    constructor() {
        owner = msg.sender;
        counter = 0;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    function increment() external {
        counter++;
        emit CounterIncremented(counter);
    }

    function incrementBy(uint256 amount) external {
        if (amount == 0) revert InvalidValue();
        counter += amount;
        emit CounterIncremented(counter);
    }

    function decrement() external {
        if (counter == 0) revert InvalidValue();
        counter--;
        emit CounterDecremented(counter);
    }

    function reset() external onlyOwner {
        counter = 0;
        emit CounterReset();
    }

    function getCounter() external view returns (uint256) {
        return counter;
    }

    function isEven() external view returns (bool) {
        return counter % 2 == 0;
    }

    function doubleNumber(uint256 number) external pure returns (uint256) {
        return number * 2;
    }
}
