//SPDX-License-Identifier: AGPL-3.0-only
pragma solidity <0.9.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "hardhat/console.sol";
import "../roles/IRolesManager.sol";

contract BaseAccessListUpgradeable is Initializable {
    using AddressUpgradeable for address;

    address public rolesManager;
    bytes32 public constant ACCESS_CONTROL = keccak256("ACCESS_CONTROLLER_ROLE");

    /* Constructor */
    function initialize(address rolesManagerAddress) public virtual {
<<<<<<< HEAD
        // TODO: Follow up with Ivan to fix error: VM Exception while processing transaction: reverted with reason string 'ROLEMANAGER_ALREADY_INITIALIZED'
        // require(
        //     rolesManagerAddress != address(0x0),
        //     "ROLEMANAGER_ALREADY_INITIALIZED"
        // );
        //require(roleManagerAddress.isContract(), "ROLEMANAGER_MUST_BE_CONTRACT");
=======
        // Validates RoleManager is Contract
>>>>>>> user/simore/access_list_upgradeable
        require(msg.sender == tx.origin);
        rolesManager = rolesManagerAddress;
    }

    function _rolesManager() internal view returns (IRolesManager) {
        return IRolesManager(rolesManager);
    }

    function _requireHasRole(
        bytes32 role,
        address account,
        string memory message
    ) internal view {
        console.log("BaseAccessListUpgradeable");
        console.logBytes32(role);
        IRolesManager rolesManager = _rolesManager();
        rolesManager.requireHasRole(role, account, message);
    }

    modifier onlyAccessListAdmin(address account) {
        _requireHasRole(
            ACCESS_CONTROL,
            account,
            "SENDER_ISNT_ACCESS_CONTROLLER"
        );
        _;
    }
}
