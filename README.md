# Project Description
- ERC20Upgradeable, OwnableUpgradeable
Upgradeable ERC20 token using @openzepplin library

- Oracle interaction
Interact with oracle contracts from chainlink:
https://docs.chain.link/docs/

This contract can be deployed on Ethereum, Binance, or Polygon.
Used oracle contracts on these nets.
3 oracle contracts per each chain : ETH / USD, BNB / USD, MATRIC / USD.

Initialize at deployment.
4 arguments : sellerAddres, ownerAddress, networkName, currency
networkname can be one of ETH, BSC, and MATIC
currency can be one of ETH, BNB and MATIC

hardhat deployment script example:
const contractFactory = await ethers.getContractFactory('SaleContract');
const contract = await upgrades.deployProxy(contractFactory,["0x59...48", "0x4E...7D", "ETH", "BNB"], { initializer: 'initialize'})
await contract.deployed();



# Hardhat Shells

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

```shell
hardhat run --network ropsten scripts/sample-script.ts
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```




