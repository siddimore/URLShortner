//SPDX-License-Identifier: AGPL-3.0-only
pragma solidity <0.9.0;

interface IAccessList {
    // ListTypes from UI
    enum AccessListType {
        allowedList,
        deniedList
    }

    // ActionType from UI
    enum ActionType {
        addAddress,
        removeAddress
    }

    // AccessAddressType from UI
    enum AccessAddressType {
        partnerAddress,
        ethAccountAddress
    }

    struct AccessListStruct {
        address inputAddress;
        AccessAddressType clientAddressType;
        address addressOfRequestor;
        bool exists;
    }

    // Add Address To List
    function addAddressToList(
        address inputAddress,
        AccessAddressType inputAddressType,
        AccessListType accessListType
    ) external;

    // Is Address Present in List
    function isAddressInList(
        address inputAddress,
        AccessListType accessListType
    ) external view returns (bool);

    // Removec Address From List
    function removeAddressFromList(
        address inputAddress,
        AccessAddressType inputAddressType,
        AccessListType accessListType
    ) external;

    // Emit Events
    event PartnerAddressAddedToList(
        address indexed partnerAddress,
        AccessListType indexed accessListType
    );
    event PartnerAddressRemovedFromList(
        address indexed partnerAddress,
        AccessListType indexed accessListType
    );
    event EthAccountAddressAddedToList(
        address indexed partnerAddress,
        AccessListType indexed accessListType
    );
    event EthAccountAddressRemovedFromList(
        address indexed partnerAddress,
        AccessListType indexed accessListType
    );
}
