// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract SimpleCounterTest is Test {
    Counter counter;

    function setUp() public {
        counter = new Counter();
    }

    function testInitialValue() public view {
        assertEq(counter.getCounter(), 0);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.getCounter(), 1);
    }

    function testIncrementBy() public {
        counter.incrementBy(5);
        assertEq(counter.getCounter(), 5);
    }

    function testDecrement() public {
        counter.increment();
        counter.decrement();
        assertEq(counter.getCounter(), 0);
    }

    function testReset() public {
        counter.incrementBy(10);
        counter.reset();
        assertEq(counter.getCounter(), 0);
    }

    function testIsEven() public {
        assertTrue(counter.isEven());
        counter.increment();
        assertFalse(counter.isEven());
    }

    function testDoubleNumber() public view {
        assertEq(counter.doubleNumber(5), 10);
    }

    function testOwner() public view {
        assertEq(counter.owner(), address(this));
    }
}
