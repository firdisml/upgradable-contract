// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Stakeable is Initializable {
    uint256 private _rate;

    function __Stakeable_init() internal onlyInitializing {
        __Stakeable_init_unchained();
    }

    function __Stakeable_init_unchained()
        internal
        onlyInitializing
    {
        stakeholders.push();
    }

    struct Stake {
        address user;
        uint256 amount;
        uint256 since;
    }

    struct Stakeholder {
        address user;
        Stake[] address_stakes;
    }

    struct StakingSummary {
        address staker_address;
        uint256 total_amount;
        uint256 time_stake;
        Stake[] stakes;
    }

    Stakeholder[] internal stakeholders;

    mapping(address => uint256) internal stakes;

    event Staked(
        address indexed user,
        uint256 amount,
        uint256 index,
        uint256 timestamp
    );

    function _setRate(uint256 rate_) internal {
        _rate = rate_;
    }

    function _getRate() internal view returns (uint256) {
        return _rate;
    }

    function _addStakeholder(address staker) internal returns (uint256) {
        stakeholders.push();

        uint256 userIndex = stakeholders.length - 1;

        stakeholders[userIndex].user = staker;

        stakes[staker] = userIndex;
        return userIndex;
    }

    function _stake(uint256 _amount) internal {

        require(_amount > 0, "Raizzen Token: Cannot stake nothing");

        uint256 index = stakes[msg.sender];

        uint256 timestamp = block.timestamp;

        if (index == 0) {
            index = _addStakeholder(msg.sender);
        }

        stakeholders[index].address_stakes.push(
            Stake(msg.sender, _amount, timestamp)
        );

        emit Staked(msg.sender, _amount, index, timestamp);

    }

    function calculateStakeReward(Stake memory _current_stake)
        internal
        view
        returns (uint256)
    {
        return
            (((block.timestamp - _current_stake.since) / 1 hours) *
                _current_stake.amount) / _rate;
    }



    function _withdrawStake(uint256 amount, uint256 index)
        internal
        returns (uint256)
    {
        uint256 user_index = stakes[msg.sender];
        Stake memory current_stake = stakeholders[user_index].address_stakes[
            index
        ];
        require(
            current_stake.amount >= amount,
            "Raizzen Token: Cannot withdraw more than you have staked"
        );

        uint256 reward = calculateStakeReward(current_stake);

        delete stakeholders[user_index].address_stakes;

        return amount + reward;
    }


    function hasStake(address _staker)
        public
        view
        returns (StakingSummary memory)
    {
        uint256 totalStakeAmount;
        uint256 timeStake;
        address stakerAddress;

        StakingSummary memory summary = StakingSummary(
            0x0000000000000000000000000000000000000000,
            0,
            0,
            stakeholders[stakes[_staker]].address_stakes
        );

        for (uint256 s = 0; s < summary.stakes.length; s += 1) {
            stakerAddress = summary.stakes[s].user;
            totalStakeAmount = totalStakeAmount + summary.stakes[s].amount;
            timeStake = summary.stakes[s].since;
        }

        summary.staker_address = stakerAddress;
        summary.total_amount = totalStakeAmount;
        summary.time_stake = timeStake;


        return summary;
    }
}
