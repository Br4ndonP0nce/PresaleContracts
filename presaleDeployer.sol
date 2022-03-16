import "./IDOcontract.sol";
import "./enumerableSet.sol";
import "./ownable.sol";
pragma solidity ^0.8.4;
// SPDX-License-Identifier: Unlicensed


contract mainFactory is Ownable, ReentrancyGuard{
     using EnumerableSet for EnumerableSet.AddressSet;
     EnumerableSet.AddressSet private presales;
     EnumerableSet.AddressSet private presaleDeployers;
     EnumerableSet.AddressSet private igniteStaff;
    address payable feesAddress;
    IgniteIDO[] public existingContracts;
    uint256 feeForDeployment = 1000000000000000000;

    function deployNewInstance(
      IERC20 tokenAddress,
      uint256 tokenPrice,
      IUniswapV2Router02 _routerAddress,
      address payable _idoAdmin,
      uint256 _maxAmount,
      uint256 _tokenDecimals,
      uint256 _softcap,
      uint256 _hardcap,
      uint256 _liquidityToLock) public payable{
          require(msg.value >= feeForDeployment,"NOT ENOUGH FEE");
        IgniteIDO newInstance = new IgniteIDO(address(this));
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

    function igniteStaffContainsWallet(address _wallet) external view returns (bool) {
        return igniteStaff.contains(_wallet);
    }

    function igniteStaffLength() external view returns (uint256) {
        return igniteStaff.length();
    }

     function igniteStaffAtIndex(uint256 _index) external view returns (address) {
        return igniteStaff.at(_index);
    }

    function seeFees() external view returns (uint256) {
        return feeForDeployment;
    }

    function getFeeAddress() external view returns (address) {
        return feesAddress;
    }

    function withdrawFees() public onlyOwner{
        uint256 currentContractBalance = address(this).balance;
        feesAddress.transfer(currentContractBalance);

    }

    function addIgniteStaffWallet(address _igniteStaffWallet) public onlyOwner{
        igniteStaff.add(_igniteStaffWallet);
    }

    function removeIgniteStaffWallet(address _igniteStaffWallet) public onlyOwner{
        igniteStaff.remove(_igniteStaffWallet);
    }

    function updateFeeAddress(address payable newAddress) public onlyOwner{
        feesAddress=newAddress;
    }
    function updateFeeForDeployment(uint256 newFee) public onlyOwner{
        feeForDeployment = newFee;
    }
}
