//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/token/ERC20"
import "hardhat/console.sol";

import "./AggregatorV3Interface.sol";

contract SaleToken is ERC20Upgradeable, OwnableUpgradeable {
    address private ownerAddress;

    uint256 private _tokenPriceInUSD;

    uint256 private _ratioDecimal;

    // Mapping Table List
    
    mapping(string => mapping(string => address)) oracleAddressList;

    string _currentNet;
    string _tokenCurrency;

    AggregatorV3Interface internal priceFeed;

    function initialize(
        address _sellerAddres,
        address _ownerAddres,
        string memory _networkName,
        string memory _currency
    ) public initializer {
        __ERC20_init("SaleToken","SUT");
        __Ownable_init();

        _ratioDecimal = 8;

        require(_sellerAddres != address(0), "Seller not zero address");
        require(_ownerAddres != address(0), "Owner not zero address");

        _initOracleContractList();

        require(oracleAddressList[_networkName][_currency] != address(0), "Incorrect Network or Currency");
        _currentNet = _networkName;
        _tokenCurrency = _currency;

        uint256 initialSupply = 10 ** 9 * 10 ** decimals();
        _mint(address(this), initialSupply);
        approve(_sellerAddres, initialSupply);

        transferOwnership(_ownerAddres);

        priceFeed = AggregatorV3Interface(oracleAddressList[_currentNet][_tokenCurrency]);
    }

    function _initOracleContractList() private {
        // Table contains BNB - XX exchange contract address
        // bnbToUsdContracAddress = 0x14e613AC84a31f709eadbdF89C6CC390fDc9540A;

        oracleAddressList["ETH"]["ETH"] = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
        oracleAddressList["ETH"]["BNB"] = 0x8993ED705cdf5e84D0a3B754b5Ee0e1783fcdF16;
        oracleAddressList["ETH"]["MATIC"] = 0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676;

        oracleAddressList["BSC"]["ETH"] = 0x9ef1B8c0E4F7dc8bF5719Ea496883DC6401d5b2e;
        oracleAddressList["BSC"]["BNB"] = 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE;
        oracleAddressList["BSC"]["MATIC"] = 0x7CA57b0cA6367191c94C8914d7Df09A57655905f;

        oracleAddressList["MATIC"]["ETH"] = 0xF9680D99D6C9589e2a93a78A04A279e509205945;
        oracleAddressList["MATIC"]["BNB"] = 0x82a6c4AF830caa6c97bb504425f6A66165C2c26e;
        oracleAddressList["MATIC"]["MATIC"] = 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function setTokenPrice(
        uint256 _newPrice
    ) public onlyOwner {
        _tokenPriceInUSD = _newPrice;
    }

    function getTokenPrice() public view returns(uint256) {
        uint256 rateToUSD = getLatestRatio();

        uint256 valueInDestCurrency = _tokenPriceInUSD * 10 ** _ratioDecimal / rateToUSD;

        return valueInDestCurrency;
    }

    function saleCompleted() public onlyOwner{
        (bool sent, ) = payable(ownerAddress).call{value: address(this).balance}("");
        require(sent, "Failed to send balance");
        // selfdestruct(payable(ownerAddress)); // Not allowed in upgradeable contracts.
    }

    function getLatestRatio() private view returns (uint256) {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return uint256(price);
    }
}
