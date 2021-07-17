import json
import os
import time
from web3 import Web3
from web3_input_decoder import decode_constructor, decode_function

# Get environment variables
contract_address = os.environ.get('CONTRACT_ADDRESS3')
print("Contract Address: {}".format(contract_address))
private_key = os.environ.get('PRIVATE_KEY')
# Get Infura URL aka Address of the Eth node to connect to
infura_url = os.environ.get('INFURA_URL')
print("Infura URL: {}".format(infura_url))

# Create Web3 object
w3 = Web3(Web3.HTTPProvider(infura_url))

# Ethereum MetaMask Wallet Address
wallet_address = os.environ.get('WALLET_ADDRESS')
print("Wallet Address: {}".format(wallet_address))

# LOAD THE ABI aka API identifying the methods in smart contract
# Contract ABI is an interface to interact with EVM bytecode
# smart contract code written in high-level languages needs to be compiled into EVM bytecode to be run. 
# EMV Bytecode is an executable code on EVM and Contract ABI is an interface to interact with EVM bytecode. 
ABI = json.load(open('url_shortner.json'))

# Create contract object to interact with our deployed smart contract
contract = w3.eth.contract(contract_address, abi=ABI)

# Get Noof sent transactions from our wallet
# Increments by 1 each time
nonce = w3.eth.getTransactionCount(wallet_address)

# able to call shortenURL here because of the ABI when creating contract object
# call contract and get data from balanceOf for argument wallet_address
transaction = contract.functions.shortenURL(
    'your_url_here').buildTransaction({
    'gas': 210000, # maximum price per transaction
    'gasPrice': Web3.toWei('10', 'gwei'), # Total gas price will be 10*10^-9 (ETH) * 210000 (Gaslimit) = 0.0021 * 1800 = 3.78(USD)
    'from': wallet_address,
    'nonce': nonce
    }) 

# Create Transaction
signed_txn = w3.eth.account.signTransaction(transaction, private_key=private_key)
# Broadcast Transaction
tx_hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
print("Transcation Hash: {}".format(tx_hash.hex()))

# Create a filter to listen for transactions with our contract address
block_filter = w3.eth.filter({'fromBlock':'latest', 'address':contract_address})

# Event Handler to check if URLShortened event was fired
def handle_event(event):
    receipt = w3.eth.waitForTransactionReceipt(event['transactionHash'])
    result = contract.events.URLShortened().processReceipt(receipt)
    print(result[0]['args'])
    # Get Shortened hash of our URL
    _short = result[0]['args']['_short']
    print("Hash of our input URL: {}".format(_short.hex()))

    # Get URL Back From Contract
    get_url = contract.functions.getURL(_short.hex()).call()
    print("Input URL:{} From Our Hash: {}".format(get_url, _short.hex()))

def log_loop(event_filter, poll_interval):
    while True:
        for event in event_filter.get_new_entries():
            handle_event(event)
            time.sleep(poll_interval)

log_loop(block_filter, 2)
