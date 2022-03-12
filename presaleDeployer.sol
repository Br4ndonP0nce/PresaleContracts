import "./IDOcontract.sol";
import "./enumerableSet.sol";
import "./ownable.sol";
pragma solidity ^0.8.4;
// SPDX-License-Identifier: Unlicensed


contract mainFactory is Ownable, ReentrancyGuard{
     using EnumerableSet for EnumerableSet.AddressSet;
     EnumerableSet.AddressSet private presales;
     EnumerableSet.AddressSet private presaleDeployers;
    address payable feesAddress;
    IgniteIDO[] public existingContracts;

    function deployNewInstance(
      address payable masterDevAddress,
      IERC20 tokenAddress,
      uint256 tokenPrice,
      IUniswapV2Router02 _routerAddress,
      address payable _idoAdmin,
      uint256 _maxAmount,
      uint256 _tokenDecimals,
      uint256 _softcap,
      uint256 _hardcap,
      uint256 _liquidityToLock) public payable{
        IgniteIDO newInstance = new IgniteIDO(address(this),masterDevAddress);
        //PresalesData storage newPresaleInfo = presalesMapping[address(newInstance)];
        registerPresale(address(newInstance));

        existingContracts.push(newInstance);
        newInstance.presaleInit(tokenAddress,tokenPrice,_routerAddress,_idoAdmin,_maxAmount,_tokenDecimals,_softcap,_hardcap,_liquidityToLock);
    }

    function registerPresale (address _presaleAddress) internal {
        presales.add(_presaleAddress);
    }
    function presalesLength() external view returns (uint256) {
        return presales.length();
    }
     function presaleAtIndex(uint256 _index) external view returns (address) {
        return presales.at(_index);
    }
    function withdrawFees() public onlyOwner{
        uint256 currentContractBalance = address(this).balance;
        feesAddress.transfer(currentContractBalance);

    }
    function updateFeeAddress(address payable newAddress) public onlyOwner{
        feesAddress=newAddress;
    }
   
  


}