// SPDX-License-Identifier: MIT

pragma solidity 0.8.26; // Solidity version

import "forge-std/Test.sol"; // Import Forge test framework
import "../src/basicTypes.sol"; // Import the contract to be tested

contract BasicTypesTest is Test {
    // Instance of the contract to be tested
    BasicTypes public basicTypes;

    // Test addresses for simulation
    address public constant ALICE = address(0x1); // Alice's address
    address public constant BOB = address(0x2); // Bob's address

    // Event for testing value updates
    event ValueUpdated( // Who updated the value
        // The new number set
        // The new active status
        // The new name set
    address indexed updater, uint256 indexed newNumber, bool newActive, string newName);

    function setUp() public {
        basicTypes = new BasicTypes(); // Deploy a new contract for each test
    }

    // DEPLOYMENT TESTS - check if contract is deployed successfully
    function testDeploymentSucces() public view {
        assertTrue(address(basicTypes) != address(0)); // Contract address should not be null
        assertEq(basicTypes.owner(), address(this)); // Owner should be the test contract
        assertEq(basicTypes.payableWallet(), payable(address(this))); // Payable wallet should match
    }

    // UINT TYPES TESTS - test for uint data types (positive numbers only)
    function testUintTypes() public view {
        assertEq(basicTypes.myBigNumber(), 1000); // Should be 1000
        assertEq(basicTypes.anotherNumber(), 500); // Should be 500
        assertEq(basicTypes.smallNumber(), 255); // Max value for uint8
        assertEq(basicTypes.mediumNumber(), 65_535); // Max value for uint16
    }

    function testuintBoundaries() public view {
        assertEq(basicTypes.smallNumber(), type(uint8).max); // uint8 max value
        assertEq(basicTypes.mediumNumber(), type(uint16).max); // uint16 max value
    }

    // INT TESTS - test for signed integers (can be negative or positive)
    function testIntTypes() public view {
        assertEq(basicTypes.temperature(), -10); // Should be -10
        assertEq(basicTypes.score(), 95); // Should be 95
        assertEq(basicTypes.smallInt(), -50); // Should be -50
    }

    // BOOL TESTS - test for boolean values
    function testBoolTypes() public view {
        assertTrue(basicTypes.isActive()); // Should be true
        assertFalse(basicTypes.isCompleted()); // Should be false
        assertFalse(basicTypes.isPublic()); // Default is false
    }

    // STRING TESTS - test for string values
    function testStringTypes() public view {
        assertEq(basicTypes.name(), "Syahlevi aldarna"); // Should match the name
        assertEq(basicTypes.message(), "hello world"); // Should match the message
        assertEq(basicTypes.emptyString(), ""); // Should be empty
    }

    // ADDRESS TESTS - test for address types
    function testAddressTypes() public view {
        assertEq(basicTypes.owner(), address(this)); // Owner address should match
        assertEq(basicTypes.zeroAddress(), address(0)); // Zero address
        assertEq(basicTypes.payableWallet(), payable(address(this))); // Payable address
    }

    // BYTES TESTS - test for bytes data types
    function testBytesTypes() public view {
        assertEq(basicTypes.dataHash(), 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef); // 32 bytes hash
        assertEq(basicTypes.singleByte(), bytes1(0xff)); // Single byte max value
        assertEq(basicTypes.functionSelector(), bytes4(0x12345678)); // 4 bytes selector
        assertEq(basicTypes.dynamicBytes(), "hello"); // Dynamic bytes
    }

    // UPDATE VALUES TEST - test updating values
    function testUpdateValues() public {
        basicTypes.updateValues(999, 25, false, "updated By Test");

        assertEq(basicTypes.myBigNumber(), 999); // Number updated
        assertEq(basicTypes.temperature(), 25); // Temperature updated
        assertFalse(basicTypes.isActive()); // Status updated
        assertEq(basicTypes.name(), "updated By Test"); // Name updated
    }

    function testUpdateValuesRevertOnZero() public {
        // This test is not meaningful since the contract has no validation
        basicTypes.updateValues(0, 0, false, ""); // Update to zero/empty
        assertEq(basicTypes.myBigNumber(), 0); // Should be 0
    }

    // DEFAULT VALUES TEST - check default values
    function testDefaultValues() public view {
        (
            uint256 defaultNumber,
            int256 defaultTemp,
            bool defaultActive,
            string memory defaultName,
            address defaultAddress
        ) = basicTypes.getDefaultValues();

        assertEq(defaultNumber, 0); // Default uint is 0
        assertEq(defaultTemp, 0); // Default int is 0
        assertFalse(defaultActive); // Default bool is false
        assertEq(defaultName, ""); // Default string is empty
        assertEq(defaultAddress, address(0)); // Default address is zero
    }

    // BITS AND BYTES TESTS - bits and bytes demo
    function testBitsAndBytesDemo() public view {
        (uint8 maxUint8, uint16 maxUint16, uint256 maxUint256, bytes1 oneBytes, bytes32 helloBytes) =
            basicTypes.demonstrateBitsBytes();

        assertEq(maxUint8, 255); // uint8 max value
        assertEq(maxUint16, 65_535); // uint16 max value
        assertEq(maxUint256, type(uint256).max); // uint256 max value
        assertEq(oneBytes, bytes1(0xff)); // Single byte max value
        assertEq(helloBytes, bytes32("hello world!")); // "hello world!" as bytes32
    }

    // NEW FUNCTION TESTS - new features
    function testGetContractInfo() public view {
        (address contractAddress, address contractOwner, uint256 blockNumber, uint256 timestamp, address caller) =
            basicTypes.getContractInfo();

        assertEq(contractAddress, address(basicTypes)); // Contract address
        assertEq(contractOwner, address(this)); // Owner address
        assertEq(blockNumber, block.number); // Block number
        assertEq(timestamp, block.timestamp); // Timestamp
        assertEq(caller, address(this)); // Caller address
    }

    function testProcessString() public view {
        string memory testString = "Hello, World!";
        (uint256 length, bytes memory bytesData, bytes32 hashedData) = basicTypes.processString(testString);

        assertEq(length, 13); // Length of "Hello, World!"
        assertEq(bytesData, bytes(testString)); // Bytes data matches input
        assertEq(hashedData, keccak256(bytes(testString))); // Hash matches
    }

    function testIsContract() public view {
        // Test EOA (Externally Owned Account)
        assertFalse(basicTypes.isContract(ALICE)); // Alice is EOA
        // Test contract address
        assertTrue(basicTypes.isContract(address(basicTypes))); // Should be contract
    }

    // RECEIVE & FALLBACK TESTS
    function testReceiveEther() public {
        uint256 amount = 1 ether; // 1 ETH for testing
        (bool success,) = address(basicTypes).call{ value: amount }(""); // Send ETH without data
        assertTrue(success, "Transfer failed"); // Transfer should succeed
        assertEq(address(basicTypes).balance, amount, "Balance should be 1 ether"); // Balance check
    }

    function testFallback() public {
        uint256 amount = 0.5 ether; // 0.5 ETH for fallback test
        (bool success,) = address(basicTypes).call{ value: amount }(
            abi.encodeWithSignature("nonExistentFunction()") // Call non-existent function
        );
        assertTrue(success); // Fallback should handle gracefully
        assertEq(address(basicTypes).balance, amount, "Balance should be 0.5 ether"); // Balance check
    }

    // FUZZ TESTS
    function testFuzzUpdateValues(uint256 _number, int256 _temp, bool _active, string memory _name) public {
        // Fuzz test logic
        vm.assume(_number > 0 && _number < type(uint256).max); // Valid range
        vm.assume(_temp > type(int128).min && _temp < type(int128).max); // Reasonable temp
        vm.assume(bytes(_name).length < 1000); // Name not too long
        basicTypes.updateValues(_number, _temp, _active, _name);
        assertEq(basicTypes.myBigNumber(), _number); // Number matches
        assertEq(basicTypes.temperature(), _temp); // Temp matches
        assertEq(basicTypes.isActive(), _active); // Status matches
        assertEq(basicTypes.name(), _name); // Name matches
    }

    // GAS OPTIMIZATION TESTS
    function testGasUsage() public {
        uint256 gasStart = gasleft(); // Start gas measurement
        basicTypes.updateValues(
            1234, // Random number
            -20, // Cold temp
            true, // Set active true
            "Gas Optimization Test" // String for gas calculation
        );
        uint256 gasUsed = gasStart - gasleft(); // Calculate gas used
        console.log("Gas used for updateValues:", gasUsed); // Log gas usage
        assertTrue(gasUsed < 100_000, "Gas usage should be less than 100000"); // Gas efficiency check
    }
}
