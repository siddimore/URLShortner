//SPDX-License-Identifier: AGPL-3.0-only
pragma solidity <0.9.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "../roles/RolesManagerConsts.sol";
import "hardhat/console.sol";

import "./IAccessList.sol";
import "../roles/IRolesManager.sol";
import "./BaseAccessListUpgradeable.sol";

contract AccessList is IAccessList, BaseAccessListUpgradeable {
    mapping(address => AccessListStruct) deniedList;
    mapping(address => AccessListStruct) allowedList;

    /* Constructor */
    function initialize(address rolesManagerAddress)
        public
        override
        initializer
    {
        BaseAccessListUpgradeable.initialize(rolesManagerAddress);
    }

    function addAddressToList(
        address inputAddress,
        AccessAddressType inputAddressType,
        AccessListType accessListType
    ) external onlyAccessListAdmin(msg.sender) override {
        _addAddressToListHelper(inputAddress, inputAddressType, accessListType);

        _eventEmitterHelper(
            inputAddress,
            inputAddressType,
            ActionType.addAddress,
            accessListType
        );
    }

    function isAddressInList(
        address inputAddress,
        AccessListType accessListType
    ) external view override returns (bool) {
        console.log("InputAddress is %s", inputAddress);
        return _isAddressInListHelper(inputAddress, accessListType);
    }

    function removeAddressFromList(
        address inputAddress,
        AccessAddressType inputAddressType,
        AccessListType accessListType
    ) external onlyAccessListAdmin(msg.sender) override {
        _removeAddressFromListHelper(inputAddress, accessListType);

        _eventEmitterHelper(
            inputAddress,
            inputAddressType,
            ActionType.removeAddress,
            accessListType
        );
    }

    function _eventEmitterHelper(
        address inputAddress,
        AccessAddressType inputAddressType,
        ActionType actionType,
        AccessListType accessListType
    ) internal {
        if (actionType == ActionType.addAddress) {
            if (inputAddressType == AccessAddressType.partnerAddress) {
                emit PartnerAddressAddedToList(inputAddress, accessListType);
            }

            if (inputAddressType == AccessAddressType.ethAccountAddress) {
                emit EthAccountAddressAddedToList(inputAddress, accessListType);
            }
        }

        if (actionType == ActionType.removeAddress) {
            if (inputAddressType == AccessAddressType.partnerAddress) {
                emit PartnerAddressRemovedFromList(
                    inputAddress,
                    accessListType
                );
            }

            if (inputAddressType == AccessAddressType.ethAccountAddress) {
                emit EthAccountAddressRemovedFromList(
                    inputAddress,
                    accessListType
                );
            }
        }
    }

    function _addAddressToListHelper(
        address inputAddress,
        AccessAddressType inputAddressType,
        AccessListType accessListType
    ) internal {
        console.logUint((uint256(inputAddressType)));
        if (
            accessListType == AccessListType.allowedList &&
            !deniedList[inputAddress].exists &&
            !allowedList[inputAddress].exists
        ) {
            allowedList[inputAddress] = AccessListStruct(
                inputAddress,
                inputAddressType,
                msg.sender,
                true
            );
        }

        if (
            accessListType == AccessListType.deniedList &&
            !deniedList[inputAddress].exists
        ) {
            if (allowedList[inputAddress].exists) {
                _removeAddressFromListHelper(
                    inputAddress,
                    AccessListType.allowedList
                );
            }

            deniedList[inputAddress] = AccessListStruct(
                inputAddress,
                inputAddressType,
                msg.sender,
                true
            );
        }
    }

    function _removeAddressFromListHelper(
        address inputAddress,
        AccessListType accessListType
    ) internal {
        if (
            accessListType == AccessListType.allowedList &&
            allowedList[inputAddress].exists
        ) {
            delete allowedList[inputAddress];
        }

        if (
            accessListType == AccessListType.deniedList &&
            deniedList[inputAddress].exists
        ) {
            delete deniedList[inputAddress];
        }
    }

    function _isAddressInListHelper(
        address inputAddress,
        AccessListType accessListType
    ) internal view returns (bool) {
        if (accessListType == AccessListType.allowedList) {
            return allowedList[inputAddress].exists;
        }

        if (accessListType == AccessListType.deniedList) {
            return deniedList[inputAddress].exists;
        }

        return false;
    }
}
