
pragma solidity ^0.4.19;
import "./SafeMath.sol";
import "./ERC20Token.sol";
import "./DateTime.sol";

contract Crowdsale {
  using SafeMath for uint256;

  // The token being sold
  ERC20Token public token;
  DateTime public dateTime;

  // Address where funds are collected
  address public wallet;

  // How many token units a buyer gets per wei
  uint256 public rate;

  // Amount of wei raised
  uint256 public weiRaised;
  
  uint256 public tokensMinted;
  
  bool isSaleActive;
  uint256 daysSaleStarted;
  
  address public owner;
  
  address[] public validAddresses;
  uint public timeStamp;
  uint8 public curr_month;
  //unit8 public curr_day;
  uint public start;

  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
  
  function Crowdsale(uint256 _rate, address _wallet, ERC20Token _token) public {
    require(_rate > 0);
    require(_wallet != address(0));
    require(_token != address(0));

    rate = _rate;
    wallet = _wallet;
    token = _token;
    owner = msg.sender;
    
    tokensMinted = 0;
    isSaleActive = false;
    daysSaleStarted = 0;
  }
  
  function startTokenSale() public {
      require(owner == msg.sender);
      isSaleActive = true;
      start = now;
  }
  
  function closeTokenSale() public {
      require(owner == msg.sender);
      isSaleActive = false;
  }
  
  function getTokensMinted() public view returns (uint256) {
        return tokensMinted;
    }
    
  function addAddress(address _address) public{
      require(owner == msg.sender);
     validAddresses.push(_address);
  }
  
  function isValidAddress(address _address) view public returns (bool){
      for(uint i=0; i<validAddresses.length; i++){
            if(validAddresses[i] == _address){
                return true;
            }
        }
        return false;
      
  }
  
  function getMonth() public returns (uint8){
        timeStamp = now;
       curr_month = dateTime.getMonth(timeStamp);
 	return curr_month;
  }
  
 // function getDay() view public returns (uint8){
     //   timeStamp = now;
    //    curr_day = dateTime.getDay(timeStamp);
    //    return curr_Day;
  //}

  function getTimeStamp() public returns (uint256){
      timeStamp = now;
      return timeStamp;
  }

  function buyTokens(address _beneficiary) public payable {
    uint256 weiAmount = msg.value;
    require(_beneficiary != address(0));
    require(weiAmount != 0);
    require(isValidAddress(_beneficiary));

    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate);
    
     if (block.timestamp <= start + 1 days) {
        tokens = tokens.add(tokens.mul(25).div(100));
    }
    else if(block.timestamp <= start + 2 days && block.timestamp >= start + 1 days){
        tokens = tokens.add(tokens.mul(10).div(100));
    }

    weiRaised = weiRaised.add(weiAmount);
    
    require(isSaleActive);
    require(tokensMinted.add(tokens) <= token.totalSupply());
    token.mint(_beneficiary, tokens);

    TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);

    wallet.transfer(weiAmount);
    tokensMinted = tokensMinted.add(tokens);
  }

}
