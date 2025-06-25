// SPDX-License-Identifier: MIT

pragma solidity 0.8.26; // versi solidity yang lagi hits banget

import "forge-std/Test.sol"; // import testing framework biar bisa unit test
import "../src/mapping.sol"; // import contract yang mau di test

contract SimpleGameTest is Test {
    SimpleGame public game;

    address public alice = address(0x1);
    address public bob = address(0x2);
    address public charlie = address(0x3);

    event PlayerRegistered(address indexed playerAddress, string name);
    event PlayerLevelUp(address indexed playerAddress, uint256 newLevel);
    event ExperienceGained(address indexed playerAddress, uint256 experience);
    event ItemPurchased(address indexed playerAddress, uint256 itemId, uint256 quantity);

    function setUp() public {
        game = new SimpleGame(); // inisialisasi contract SimpleGame
    }

    function testPlayerRegisttration() public {
        vm.expectEmit(true, false, false, true);
        emit PlayerRegistered(alice, "Alice");

        vm.prank(alice);
        game.registerPlayer("Alice");
        assertTrue(game.isPlayerRegistered(alice));

        vm.prank(alice);
        (string memory name, uint256 level, uint256 experience, uint256 gold, uint256 health) = game.getPlayerStats();

        assertEq(name, "Alice");
        assertEq(level, 1);
        assertEq(experience, 0);
        assertEq(health, 100);
        assertEq(gold, 50);
    }

    function testCannotRegisterTwice() public {
        vm.prank(alice);
        game.registerPlayer("Alice");

        vm.prank(alice);
        vm.expectRevert(SimpleGame.playerAlreadyRegistered.selector);
        game.registerPlayer("Alice");
    }

    function testCannotRegisterWithEmptyName() public {
        vm.expectRevert(SimpleGame.emptyName.selector);
        vm.prank(alice);
        game.registerPlayer("");
    }

    function testExperienceAndLevelUp() public {
        vm.startPrank(alice);
        game.registerPlayer("Alice");

        vm.expectEmit(true, false, false, true);
        emit ExperienceGained(alice, 100);

        game.gainExperience(100);

        (, uint256 level, uint256 experience, uint256 gold, uint256 health) = game.getPlayerStats();
        assertEq(experience, 100);
        assertEq(level, 2); // Level up after gaining 100 experience
        assertEq(health, 100);
        assertEq(gold, 70); // 50 starting + 20 for level up

        vm.stopPrank();
    }

    function testBuyItem() public {
        vm.startPrank(alice);
        game.registerPlayer("Alice");

        vm.expectEmit(true, false, false, true);
        emit ItemPurchased(alice, 1, 2);

        game.buyItem(1, 2);

        (,,, uint256 gold,) = game.getPlayerStats();
        assertEq(gold, 50 - (2 * 10)); // Assuming item costs 10 gold each

        vm.stopPrank();
    }

    function testInsufficientGold() public {
        vm.startPrank(alice);
        game.registerPlayer("Alice");

        // Try to buy expensive item (ID 101, price = 100 each)
        vm.expectRevert(SimpleGame.insufficientGold.selector);
        game.buyItem(101, 1); // Costs 100, but only have 50

        vm.stopPrank();
    }

    function testUnregisteredPlayerActions() public {
        vm.startPrank(alice);

        vm.expectRevert(SimpleGame.playerNotRegistered.selector);
        game.gainExperience(50);

        vm.expectRevert(SimpleGame.playerNotRegistered.selector);
        game.buyItem(1, 1);

        vm.expectRevert(SimpleGame.playerNotRegistered.selector);
        game.getPlayerStats();

        vm.stopPrank();
    }

    function testGetPlayerInfo() public {
        // Check unregistered player
        (string memory name, uint256 level) = game.getPlayerInfo(alice);
        assertEq(bytes(name).length, 0);
        assertEq(level, 0);

        // Register and check again
        vm.prank(alice);
        game.registerPlayer("Alice");

        (name, level) = game.getPlayerInfo(alice);
        assertEq(name, "Alice");
        assertEq(level, 1);
    }

    function testMultiplePlayersIndependence() public {
        // Register two players
        vm.prank(alice);
        game.registerPlayer("Alice");

        vm.prank(bob);
        game.registerPlayer("Bob");

        // Alice gains experience
        vm.prank(alice);
        game.gainExperience(200);

        // Check Alice is level 3
        vm.prank(alice);
        (, uint256 aliceLevel,,,) = game.getPlayerStats();
        assertEq(aliceLevel, 3);

        // Check Bob is still level 1
        vm.prank(bob);
        (, uint256 bobLevel,,,) = game.getPlayerStats();
        assertEq(bobLevel, 1);
    }

    function testFuzzPlayerRegistration(string memory name) public {
        vm.assume(bytes(name).length > 0);
        vm.assume(bytes(name).length < 100); // Reasonable limit

        vm.prank(alice);
        game.registerPlayer(name);

        assertTrue(game.isPlayerRegistered(alice));

        vm.prank(alice);
        (string memory retrievedName,,,,) = game.getPlayerStats();
        assertEq(retrievedName, name);
    }

    function testFuzzExperienceGain(uint256 exp) public {
        vm.assume(exp > 0);
        vm.assume(exp < 10_000); // Reasonable limit to avoid overflow

        vm.prank(alice);
        game.registerPlayer("Alice");

        vm.prank(alice);
        game.gainExperience(exp);

        vm.prank(alice);
        (, uint256 level, uint256 totalExp,,) = game.getPlayerStats();

        assertEq(totalExp, exp);
        assertEq(level, (exp / 100) + 1);
    }
}
