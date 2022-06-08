//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./Stakeable.sol";

contract Token is
    Initializable,
    ERC20Upgradeable,
    OwnableUpgradeable,
    Stakeable
{
    function initialize() external initializer {
        __ERC20_init("RAIZZEN", "RZN");
        __Ownable_init();
        __Stakeable_init();
    }

    function mint(uint256 _amount) external onlyOwner {
        _mint(msg.sender, _amount);
    }

    function withdrawStake(uint256 _amount, uint256 _stake_index) public {
        uint256 total_withdraw = _withdrawStake(_amount, _stake_index);
        _mint(msg.sender, total_withdraw);
    }

    function redeem(uint256 _amount) public {
        require(
            _amount <= balanceOf(msg.sender),
            "Raizzen Token: Cannot redeem more than you own"
        );

        _burn(msg.sender, _amount);
    }

    function stake(uint256 _amount) public {
        require(
            _amount <= balanceOf(msg.sender),
            "Raizzen Token: Cannot stake more than you own"
        );

        _stake(_amount);

        _burn(msg.sender, _amount);
    }

    function setRate(uint256 _amount) external onlyOwner {
        _setRate(_amount);
    }

    function getRate() external view returns (uint256) {
        return _getRate();
    }
}
