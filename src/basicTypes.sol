// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract BasicTypes {

    // 1. uint = unsigned integer (positif only)
    uint256 public myBigNumber = 1000; // uint256 = 2^256 - 1, max: 115792089237316195423570985008687907853269984665640564039457584007913129639935
    uint public anotherNumber = 500; // uint = uint256, default 256 bit

    uint8 public smallNumber = 255; // max: 255
    uint16 public mediumNumber = 65535; // max: 65,535
    

    // 2. int = signed integer ( negatif and positif)

    int256 public temperature = -10;
    int public score = 95;
    int8 public smallInt = -50; // Range: -128 to 127

    // 3. boolean = true or false

    bool public isActive = true;
    bool public isCompleted = false;
    bool public isPublic;

    // 4, string

    string public name = "Syahlevi aldarna";
    string public message = "hello world";
    string public emptyString;

    // address = alamat wallet/contract ethereum (20bytes)

    address public owner = 0x742D35CC6634C0532925A3B8d5c3E36D9C2E15c7;
    address public zeroAddress = address(0);
    address payable public payableWallet; // bisa terima ethereum

    //  Bytes = bytes32 data biner 32 (fixed size)

    bytes32 public dataHash = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    bytes32 public secretKey;

    // bytes = dynamic byte array
    bytes public dynamicBytes = "hello";

    // fixed - size bytes
    bytes1 public singleByte = 0xff;
    bytes4 public functionSelector = 0x12345678;

    // constructor

    constructor() {
        owner = msg.sender; // set owner yang deploy contract
        payableWallet = payable(msg.sender);
    }

    // function for testing

    function updateValues(
        uint256 _number,
        int _temp,
        bool _active,
        string memory _name
    ) external {
        myBigNumber = _number;
        temperature = _temp;
        isActive = _active;
        name = _name;
    }

    // look default values

    function getDefaultValues() external pure returns (
        uint256,
        int256,
        bool,
        string memory,
        address
     ) {
        return (
            0,
            0,
            false,
            "",
            address(0)
        );
    }

    function demonstrateBitsBytes() external pure returns (
        uint8,
        uint16,
        uint256,
        bytes1,
        bytes32
    ) {
        return (
            uint8(255),
            uint16(65535),
            type(uint256).max,
            bytes1(0xff),
            bytes32("hello world!")
        );
    }

    function getContractInfo() external view returns (
        address contractAddress,
        address contractOwner,
        uint256 blockNumber,
        uint256 timestamp,
        address caller
    ) {
        return (
            address(this), // address this contract
            owner, // address owner
            block.number, // uint256 block number
            block.timestamp, // uint256 timestamp
            msg.sender // address caller
        );
    }

    function processString(string memory input) external pure returns (
        uint256 length,
        bytes memory bytesData,
        bytes32 hashedData
    ) {
        length = bytes(input).length;
        bytesData = bytes(input);
        hashedData = keccak256(bytesData);
    }

    function isContract(address addr) external view returns (bool) {
        return addr.code.length > 0; // check if address has code
    }

    receive() external payable {
        // this function will be called when the contract receives ether without data
    }

    fallback() external payable {
        // this function will be called when the contract receives ether with data or when a function is not found
    }

}