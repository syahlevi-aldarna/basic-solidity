// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract SimpleGame {

    error playerAlreadyRegistered();
    error playerNotRegistered();
    error insufficientGold();
    error invalidAmount();
    error emptyName();

    struct player {
        string name;
        uint256 level;
        uint256 experience;
        uint256 health;
        uint256 gold;
    }

    mapping (address => player) public players;
    mapping (address => bool) public isPlayerRegistered;
    mapping (address => mapping (uint256 => uint256)) public playerScores; // address => (gameId => score)

    event PlayerRegistered(address indexed playerAddress, string name);
    event PlayerLevelUp(address indexed playerAddress, uint256 newLevel);
    event ExperienceGained(address indexed playerAddress, uint256 experience);
    event ItemPurchased(address indexed playerAddress, uint256 itemId, uint256 quantity);

    function registerPlayer(string memory name) external {
        if (isPlayerRegistered[msg.sender]) {
            revert playerAlreadyRegistered();
        }
        if (bytes(name).length == 0) {
            revert emptyName();
        }

        players[msg.sender] = player({
            name: name,
            level: 1,
            experience: 0,
            health: 100, // Default health
            gold: 50 // Starting gold
        });
        isPlayerRegistered[msg.sender] = true;

        emit PlayerRegistered(msg.sender, name);
    }

    function gainExperience(uint256 amount) external {
        if (!isPlayerRegistered[msg.sender]) {
            revert playerNotRegistered();
        }
        if (amount == 0) {
            revert invalidAmount();
        }

        player storage p = players[msg.sender];
        uint256 oldLevel = p.level;
        p.experience += amount;

        uint256 newLevel = (p.experience / 100) + 1; // Fixed: level starts at 1 and increments per 100 exp
        // Level up logic
        if (newLevel > oldLevel) {
            p.level = newLevel;

            uint256 levelDiff = newLevel - oldLevel;
            p.gold += 20 * levelDiff; // Increase gold based on levels gained
            emit PlayerLevelUp(msg.sender, p.level);
        }

        emit ExperienceGained(msg.sender, amount);
    }

    function buyItem(uint256 itemId, uint256 quantity) external {
        if (!isPlayerRegistered[msg.sender]) {
            revert playerNotRegistered();
        }
        if (quantity == 0) {
            revert invalidAmount();
        }
        
        uint256 basePrice = getItemPrice(itemId);
        uint256 cost = basePrice * quantity; // Simplified cost calculation

        player storage p = players[msg.sender];
        if (p.gold < cost) {
            revert insufficientGold();
        }

        p.gold -= cost; // Deduct the cost from the player's gold
        playerScores[msg.sender][itemId] += quantity; // Increment the score for the item

        emit ItemPurchased(msg.sender, itemId, quantity);
    }

    function getPlayerStats() external view returns (
        string memory name,
        uint256 level,
        uint256 experience,
        uint256 gold,
        uint256 health
    ) {
        if (!isPlayerRegistered[msg.sender]) {
            revert playerNotRegistered();
        }
        
        player storage p = players[msg.sender];
        return (p.name, p.level, p.experience, p.gold, p.health);
    }

    function getPlayerInfo(address playerAddr) external view returns (string memory name, uint256 level) {
        if (!isPlayerRegistered[playerAddr]) {
            return ("", 0);
        }
        player storage p = players[playerAddr];
        return (p.name, p.level);
    }

    function getItemPrice(uint256 itemId) internal pure returns (uint256) {
        if (itemId <= 10) return itemId * 10; // Example price calculation for items 1-10
        if (itemId <= 20) return itemId * 20; // Example price calculation for items 11-20
        if (itemId <= 30) return itemId * 30; // Fixed missing multiplication and semicolon
        return 100;
    }
}