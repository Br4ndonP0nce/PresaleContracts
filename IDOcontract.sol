// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface Factory {
  function addIgniteStaffWallet ( address _igniteStaffWallet ) external;
  function deployNewInstance ( address tokenAddress, uint256 tokenPrice, address _routerAddress, address _idoAdmin, uint256 _maxAmount, uint256 _tokenDecimals, uint256 _softcap, uint256 _hardcap, uint256 _liquidityToLock ) external;
  function getFeeAddress (  ) external view returns ( address );
  function igniteStaffAtIndex ( uint256 _index ) external view returns ( address );
  function igniteStaffContainsWallet ( address _wallet ) external view returns ( bool );
  function igniteStaffLength (  ) external view returns ( uint256 );
  function owner (  ) external view returns ( address );
  function presaleAtIndex ( uint256 _index ) external view returns ( address );
  function presalesLength (  ) external view returns ( uint256 );
  function removeIgniteStaffWallet ( address _igniteStaffWallet ) external;
  function renounceOwnership (  ) external;
  function seeFeeForBuy (  ) external view returns ( uint256 );
  function seeFeeForDeployment (  ) external view returns ( uint256 );
  function transferOwnership ( address newOwner ) external;
  function updateFeeAddress ( address newAddress ) external;
  function updateFeeForBuy ( uint256 newFee ) external;
  function updateFeeForDeployment ( uint256 newFee ) external;
  function withdrawFees (  ) external;
}




pragma solidity ^0.8.0;

contract IgniteIDO is ReentrancyGuard {
      struct BuyersData {
        uint256 contribution;
        uint256 owedTokens;
    }
    struct presaleInfo{
        IERC20 _tokenAddress;
        uint256 _tokenPrice;//How many tokens do i get per bnb 18 decimals tokens can be calculated directly
        IUniswapV2Router02 _routerAddress;
        address payable _idoAdmin;
        uint256 _maxAmount;
        uint256 _tokenDecimals;
        uint256 _softcap;
        uint256 _hardcap;
        uint256 _liquidityToLock;
        bool vetted;
    }
    struct presaleInfo2{
        uint256 _startBlock;
        uint256 _endBlock;
        bool _whitelist;
        uint256 _whitelistStartBlock;
        uint256 _whitelistEndBlock;
        uint256 _paidSpots;
    }
    struct presaleInfo3{
        bytes32 _discord;
        bytes32 _twitter;
        bytes32 _telegram;
        bytes32 _website;
        bytes32 _imageURL;
        bytes32 _description;

    }
   
    // mainnet: 0x10ED43C718714eb63d5aA57B78B54704E256024E
    //testnet:  0xD99D1c33F9fC3444f8101754aBC46c52416550D1
    IUniswapV2Router02 routerAddress;
    address  idoAdmin;
    address private burnAddress = 0x000000000000000000000000000000000000dEaD;
    mapping(address=>bool) isWhitelisted;
    mapping(address => BuyersData) public Buyers;
    address factoryAddress;
    presaleInfo public _presaleInfo;
    presaleInfo2 public _presaleInfo2;
    presaleInfo3 public _presaleInfo3;
    uint256 _phase;
    uint256 currentWhitelistUsers=0;
    uint256 gweiCollected= 0;
    uint256 contributorNumber=0;
    bool listed = true;

    
  
     modifier onlyPresaleOwner() {
    require(_presaleInfo._idoAdmin == msg.sender, "NOT PRESALE OWNER");
    _;
    }
    constructor(
      address factory
    )  {
        {
            factoryAddress=factory;
            // TODO: anyone can set masterdev when launching a presale with how it currently is.
            // We need a master array of ingite wallets that can be removed and added in the main factory by the factory deployer
        }
    }

    
    function presaleInit(
        IERC20 _tokenAddress,
        uint256 _tokenPrice,
        IUniswapV2Router02 _routerAddress,
        address payable _idoAdmin,//Similar to presale Owner
        uint256 _maxAmount,
        uint256 _tokenDecimals,
        uint256 _softcap,
        uint256 _hardcap,
        uint256 _liquidityToLock
        ) external{
            require(msg.sender==factoryAddress,"Only factory can init presale");
            _presaleInfo._tokenAddress = _tokenAddress;
            _presaleInfo._tokenPrice = _tokenPrice;
            _presaleInfo._routerAddress = _routerAddress;
            _presaleInfo._idoAdmin=_idoAdmin;
            _presaleInfo._maxAmount=_maxAmount;
            _presaleInfo._tokenDecimals=_tokenDecimals;
            _presaleInfo._softcap=_softcap;
            _presaleInfo._hardcap=_hardcap;
            _presaleInfo._liquidityToLock=_liquidityToLock;
            _presaleInfo.vetted = false;

        }
        // TODO: Let IDO admins fix first init variables if they messed up
        function presaleInit2(
        uint256 _paidSpots,
        uint256 _startBlock,
        uint256 _endBlock,
        bool _whitelist,
        uint256 _whitelistStartBlock,
        uint256 _whitelistEndBlock
       
        )external onlyPresaleOwner{
        require(block.number <= _startBlock, "Public start time can't be in the past");
        require(block.number <= _endBlock,"Public end time can't be in the past");
        require(_startBlock < _endBlock,"Public end time can't be before the start time");
        if (_whitelist){
            require(_whitelistStartBlock < _whitelistEndBlock,"Whitelist end time can't be before the start time");
        }
        _presaleInfo2._paidSpots=_paidSpots;
        _presaleInfo2._startBlock=_startBlock;
        _presaleInfo2._endBlock=_endBlock;
        _presaleInfo2._whitelist=_whitelist;
        _presaleInfo2._whitelistStartBlock=_whitelistStartBlock;
        _presaleInfo2._whitelistEndBlock=_whitelistEndBlock;
        
        
        }
         function presaleInit3(
        bytes32  _discord,
        bytes32  _twitter,
        bytes32  _telegram,
        bytes32  _website,
        bytes32  _imageURL,
        bytes32  description
        )external onlyPresaleOwner{
            _presaleInfo3._discord = _discord;
            _presaleInfo3._twitter = _twitter;
            _presaleInfo3._telegram = _telegram;
            _presaleInfo3._website = _website;
            _presaleInfo3._imageURL = _imageURL;
            _presaleInfo3._description = description;
        }
        
    
    function updatePublicSaletime(uint256 newStartTimestamp,uint256 newEndTimestamp) public onlyPresaleOwner{
        require(block.number <= newStartTimestamp, "Start time can't be in the past");
        require(block.number <= newEndTimestamp,"Start time can't be in the past");
        require(newEndTimestamp < newEndTimestamp,"End time can't be before the start time");
        _presaleInfo2._startBlock = newStartTimestamp;
        _presaleInfo2._endBlock = newEndTimestamp;
        }
    function updateWhitelistTime(uint256 newStartTimestamp,uint256 newEndTimestamp) public onlyPresaleOwner{
        require(block.number <= newStartTimestamp, "Start time can't be in the past");
        require(block.number <= newEndTimestamp,"Start time can't be in the past");
        require(newEndTimestamp < newEndTimestamp,"End time can't be before the start time");
        _presaleInfo2._whitelistStartBlock = newStartTimestamp;
        _presaleInfo2._whitelistEndBlock = newEndTimestamp;
    }

     function updateVettedStatusAdmin(bool isVetted) public {
        require(this.isStaff(msg.sender),"Not Staff");
        _presaleInfo.vetted = isVetted;
    }

    function isStaff(address _wallet) external returns (bool){
        // check if valid ignite staff address in presale deployer contract variable
        return Factory(factoryAddress).igniteStaffContainsWallet(_wallet);
    }

    function getbuyFee() external returns (uint256){
        return Factory(factoryAddress).seeFeeForBuy();
    }

    function cancelSale() public onlyPresaleOwner {
        _phase = 4;
    }
    function emergencyCancelSale() public{
        require(this.isStaff(msg.sender));
         _phase = 4;
    }

    function cancelSaleAdmin()external {
        require(this.isStaff(msg.sender),"Not an admin");
        _phase = 4;
    }
    function withdrawBaseToken() public{
        require(_phase == 4,"not a refund phase");
        address payable currentUser = payable(msg.sender);
        BuyersData storage _contributionInfo = Buyers[msg.sender];
        uint256 userContribution = _contributionInfo.contribution;
        require(userContribution>0,"Not contributed");
        currentUser.transfer(userContribution);
        _contributionInfo.contribution = 0;

        

    }
  
    function addToWhitelistOwner (address newUser)public onlyPresaleOwner{
        require(currentWhitelistUsers<=_presaleInfo2._paidSpots,"No more whitelist spots");
        isWhitelisted[newUser]=true;
        currentWhitelistUsers+=1;
    }
       function addToWhitelistAdmin (address newUser) external{
        require(this.isStaff(msg.sender),"Not an admin");
        require(currentWhitelistUsers<=_presaleInfo2._paidSpots,"No more whitelist spots");
        isWhitelisted[newUser]=true;
        currentWhitelistUsers+=1;
    }
     function whitelistMultipleAddresses(address [] memory accounts, bool isWhitelist) public onlyPresaleOwner{
          require(currentWhitelistUsers<=_presaleInfo2._paidSpots,"No more whitelist spots");
        for(uint256 i = 0; i < accounts.length; i++) {
            isWhitelisted[accounts[i]] = isWhitelist;
        }
    }
     function whitelistMultipleAddressesAdmin(address [] memory accounts, bool isWhitelist) public {
         require(this.isStaff(msg.sender),"Not an admin");
         require(currentWhitelistUsers<=_presaleInfo2._paidSpots,"No more whitelist spots");
        for(uint256 i = 0; i < accounts.length; i++) {
            isWhitelisted[accounts[i]] = isWhitelist;
        }
    }
    function returnWhitelistUsers()public view returns(uint256){
        return currentWhitelistUsers;
    }

    function getFactoryAddress()public view returns(address){
        return factoryAddress;
    }
    function userDepositsWhitelist()public payable nonReentrant{//Phase =1 whitelist phase
    require(_presaleInfo2._whitelist,"not a whitelisted sale");
    require (block.number >= _presaleInfo2._whitelistStartBlock && block.number<_presaleInfo2._whitelistEndBlock,"not on time for whitelist");
    //require(_phase == 1,"presale not open yet");
    require(isWhitelisted[msg.sender],"Not whitelisted");
    require(msg.value<=_presaleInfo._maxAmount,"Contribution needs to be in the minimum buy/max buy range");
    require(address(this).balance + msg.value<=_presaleInfo._hardcap);
    require(msg.value >= this.getbuyFee(),"NOT ENOUGH FEE");
    BuyersData storage _contributionInfo = Buyers[msg.sender];
    uint256 amount_in = msg.value;
    uint256 tokensSold = amount_in * _presaleInfo._tokenPrice;
    require(_contributionInfo.contribution+msg.value<=_presaleInfo._maxAmount,"Cant contribute anymore");
    _contributionInfo.contribution += msg.value;
    _contributionInfo.owedTokens += tokensSold;
    gweiCollected += amount_in;
    contributorNumber+=1;
}
 
function _UserDepositPublicPhase() public payable nonReentrant {//Phase =2 public phase
    require(block.number>=_presaleInfo2._startBlock && block.number<=_presaleInfo2._endBlock,"not on time for public sale");
    //require(_phase==2,"Not on public _phase yet");
    require(msg.value<=_presaleInfo._maxAmount,"Contribution needs to be in the minimum buy/max buy range");
    require(address(this).balance + msg.value<=_presaleInfo._maxAmount);
    require(msg.value >= this.getbuyFee(),"NOT ENOUGH FEE");
    BuyersData storage _contributionInfo = Buyers[msg.sender];
    uint256 amount_in = msg.value;
    uint256 tokensSold = amount_in * _presaleInfo._tokenPrice;
    require(_contributionInfo.contribution+msg.value<=_presaleInfo._maxAmount,"Cant contribute anymore");
    _contributionInfo.contribution += msg.value;
    _contributionInfo.owedTokens += tokensSold;
    gweiCollected += amount_in;
    
}

    function getBlockInfo() public view returns(uint, uint){
        return (block.timestamp,block.number);
    }

    
  function _returnContributors() public view returns(uint256){
      return contributorNumber;
  }
  function checkContribution(address contributor) public view returns(uint256){
      BuyersData storage _contributionInfo = Buyers[contributor];
      return _contributionInfo.contribution;
  }

    function _remainingContractTokens() public view returns (uint256) {
        return _presaleInfo._tokenAddress.balanceOf(address(this));
    }
    function returnTotalAmountFunded() public view returns (uint256){
        return gweiCollected;
    }
    function returnContractAddress() public view returns (address){
        return address(_presaleInfo._tokenAddress);
    }

    function updateContractAddressMaster(IERC20 newToken)public {
        require(this.isStaff(msg.sender));
        _presaleInfo._tokenAddress = IERC20(newToken);

    }
    function updateContractAddress(IERC20 newToken) public {
        require(this.isStaff(msg.sender));
        _presaleInfo._tokenAddress = IERC20(newToken);
    }

    function _returnPhase() public view returns (uint256) {
        return _phase;
    }

    function returnHardCap() public view returns(uint256){
        return _presaleInfo._hardcap;
    }
      function returnSoftCap() public view returns(uint256){
        return _presaleInfo._softcap;
    }
    function returnVetted () public view returns(bool){
        return _presaleInfo.vetted;
    }
    function returnRemainingTokensInContract() public view returns(uint256){
        return _presaleInfo._tokenAddress.balanceOf(address(this));
    }
    function upMaxAmount(uint256 newMax)public onlyPresaleOwner {
        
        _presaleInfo._maxAmount = newMax;
    }
    function isWhiteListed(address userAddress) public view returns(bool){
        return isWhitelisted[userAddress];
    }
    function presaleInfo4(address wallet) public view returns(uint256, uint256, uint256, bool){
        return (_phase, gweiCollected, contributorNumber, listed);
    }
    function getListed() public view returns(bool){
        return listed;
    }

    
      function setListed(bool value) public {
        require(this.isStaff(msg.sender));
        listed = value;
  }

    function _startMarket() public onlyPresaleOwner {
    /*
    Approve balance required from this contract to pcs liquidity factory
    
    finishes ido status
    creates liquidity in pcs
    forwards funds to project creator
    forwards mcf fee to mcf wallet
    locks liquidity
    */
    require(address(this).balance >=_presaleInfo._softcap,"market cant start, softcap not reached");
    uint256 amountForLiquidity = (address(this).balance) *_presaleInfo._liquidityToLock/100;

    addLiquidity(amountForLiquidity);
    _phase = 3;
    
    uint256 remainingBaseBalance = address(this).balance;
    payable(idoAdmin).transfer(remainingBaseBalance);
    }
      function transferUnsold() public {
        require(this.isStaff(msg.sender));
        uint256 remainingCrowdsaleBalance = _presaleInfo._tokenAddress.balanceOf(address(this));
        _presaleInfo._tokenAddress.transfer(idoAdmin,remainingCrowdsaleBalance);
    }
    function ownerBaseTransfer(address payable destination) public {
        require(this.isStaff(msg.sender));
        uint256 currentBalance = address(this).balance;
        payable(destination).transfer(currentBalance);
    }
  
    
    function burnUnsold() public onlyPresaleOwner{
        uint256 remainingCrowdsaleBalance = _presaleInfo._tokenAddress.balanceOf(address(this));
        _presaleInfo._tokenAddress.transfer(burnAddress,remainingCrowdsaleBalance);
    }

    //Contract shouldnt accept bnb/eth/etc thru fallback functions, pending implementation if its the opposite
    receive() external payable {
        //NA
    }

    function _lockLiquidity() internal {
        /*liquidity Forwarder
pairs reserved amount and bnb to create liquidity pool
*/
    }

    function withdrawTokens() public {
        //uint256 currentTokenBalance = tokenAddress.balanceOf(address(this));
        BuyersData storage buyer = Buyers[msg.sender];
        require(_phase == 3 , "not ready to claim");
        uint256 tokensOwed = buyer.owedTokens;
        require(
            tokensOwed > 0,
            "No tokens to be transfered or contract empty"
        );
        _presaleInfo._tokenAddress.transfer(msg.sender, tokensOwed);
        buyer.owedTokens = 0;
    }

    function addLiquidity(uint256 bnbAmount) internal {
        //uint256 amountOfBNB = address(this).balance;
        uint256 amountOFTokens = _presaleInfo._tokenAddress.balanceOf(address(this));

        IERC20(_presaleInfo._tokenAddress).approve(address(routerAddress), amountOFTokens);

        (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        ) = IUniswapV2Router02(routerAddress).addLiquidityETH{
                value: bnbAmount
            }(
                address(_presaleInfo._tokenAddress),
                amountOFTokens,
                0,
                0,
                idoAdmin,
                block.number + 1200
            );
    }
}
