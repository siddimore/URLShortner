pragma solidity ^0.7.0;

contract URLShortner {
  struct URLStruct {
    address owner;
    string url;
    bool exists;
  }
  
  // Generated Hash to URL Struct Mapping
  mapping (bytes => URLStruct) lookupTable;
  
  // User to Shortened Hash mapping
  mapping (address => bytes[]) public shortenedURLs;
  address[] accts;
  address payable owner;
  
  // URL Shortened event
  event URLShortened(string url, bytes _short, address owner);

  constructor() public { owner = msg.sender; }

  // Set URL To Shorten With User Supplied Hash
  function shortenURLWithHash(string memory _url, bytes memory _short) public payable {
    if (!lookupTable[_short].exists){
      lookupTable[_short] = URLStruct(msg.sender, _url, true);
      shortenedURLs[msg.sender].push(_short);
      
      // Emit Event on Blockchain
      emit URLShortened(_url, _short, msg.sender);
    }  
  }

  // Set URL to shorten with Generated Hash
  function shortenURL(string memory url) public payable {
    bytes memory shortHash = getUrlShortHash(url);
    return shortenURLWithHash(url, shortHash);
  }

  // Get URL for input hash
  function getURL(bytes memory _short) public view returns (string memory) {
    URLStruct storage result = lookupTable[_short];
    if(result.exists){
      return result.url;
    }
    return "FAIL";
  }

  // Kill Contract
  function kill() public {
    if (msg.sender == owner) selfdestruct(owner);
  }

  // private method to generate hash
  function getUrlShortHash(string memory str) internal pure returns (bytes memory) {
    bytes32 hash = sha256(abi.encodePacked(str));
    uint main_shift = 15;
    bytes32 mask = 0xffffff0000000000000000000000000000000000000000000000000000000000;
    return abi.encodePacked(bytes3(hash<<(main_shift*6)&mask));
  }
}
