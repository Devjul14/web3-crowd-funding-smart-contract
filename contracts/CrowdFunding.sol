// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 targetAmount;
        uint256 deadline;
        uint256 amountRaised;
        string imageUrl;
        uint256[] donations;
        address[] donators;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public campaignCount = 0;

    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _targetAmount,
        uint256 _deadline,
        string memory _imageUrl
    ) public returns (uint256) {
        require(_deadline > block.timestamp, "Deadline must be in the future");

        Campaign storage newCampaign = campaigns[campaignCount];
        newCampaign.owner = msg.sender;
        newCampaign.title = _title;
        newCampaign.description = _description;
        newCampaign.targetAmount = _targetAmount;
        newCampaign.amountRaised = 0;
        newCampaign.deadline = _deadline;
        newCampaign.imageUrl = _imageUrl;

        campaignCount++;

        return campaignCount - 1; // Return the ID of the newly created campaign
    }

    function donateToCampaign(uint256 _campaignId) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.deadline > block.timestamp, "Campaign has ended");
        require(amount > 0, "Donation must be greater than zero");

        campaign.donations.push(amount);
        campaign.donators.push(msg.sender);
        
        (bool success, ) = campaign.owner.call{value: amount}("");

        if (success) {
            campaign.amountRaised += amount;
        } else {
            revert("Transfer failed");
        }
    }

    

    function getDonators(uint256 _campaignId) public view returns (address[] memory, uint256[] memory) {
        return (campaigns[_campaignId].donators, campaigns[_campaignId].donations);
    }

    function getCampains() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](campaignCount);
        for (uint256 i = 0; i < campaignCount; i++) {
            Campaign storage campaign = campaigns[i];

            allCampaigns[i] = campaign;
        }
        return allCampaigns;
    }
}