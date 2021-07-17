# URLShortner
Step1: Getting Rinkeby Test tokens. \
Follow instructions here: https://faucet.rinkeby.io/. 

Step2: Deploying SmartContract on Rinkeby Test Net. \
a. launch Remix ide: https://remix.ethereum.org/. \
b. Copy UrlShortner code and paste it. \
c. Compile. \
d. To deploy choose injected web3 environment from drop down. \
e. Deploy smart contract. \
f. copy smart contract address. 

Step3: Monitor Contract Transactions  \
a. Go to https://rinkeby.etherscan.io/. \
b. Copy paste your smart contract address. \
c. In Remix.ide after deploying it gives a nice interface to interact with the contract. \
d. Observe transactions in Rinkeby. 

Step4: Use Python client to interact with the deployed smart contract. \
a. Get your infura url (ethereum node as a service): https://infura.io/. \
b. Set environment variables in python environment accordingly. \
c. Run python interactor. \
d. Observer printed hash for your URL. 
