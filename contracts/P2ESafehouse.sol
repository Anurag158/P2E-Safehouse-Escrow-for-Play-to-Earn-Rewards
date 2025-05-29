// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract P2ESafehouse {
    address public gameAdmin;

    struct Reward {
        address player;
        uint256 amount;
        bool claimed;
    }

    uint256 public rewardCounter;
    mapping(uint256 => Reward) public rewards;

    event RewardDeposited(uint256 rewardId, address indexed player, uint256 amount);
    event RewardClaimed(uint256 rewardId, address indexed player);

    constructor() {
        gameAdmin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == gameAdmin, "Only game admin");
        _;
    }

    function depositReward(address player) external payable onlyAdmin returns (uint256) {
        require(msg.value > 0, "Reward must be > 0");

        rewards[rewardCounter] = Reward({
            player: player,
            amount: msg.value,
            claimed: false
        });

        emit RewardDeposited(rewardCounter, player, msg.value);
        return rewardCounter++;
    }

    function claimReward(uint256 id) external {
        Reward storage reward = rewards[id];
        require(msg.sender == reward.player, "Not your reward");
        require(!reward.claimed, "Already claimed");

        reward.claimed = true;
        payable(msg.sender).transfer(reward.amount);

        emit RewardClaimed(id, msg.sender);
    }

    function rewardInfo(uint256 id) external view returns (Reward memory) {
        return rewards[id];
    }
}
