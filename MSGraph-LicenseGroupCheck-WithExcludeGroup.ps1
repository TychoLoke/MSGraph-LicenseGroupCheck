# Connect to Microsoft Graph
Connect-MgGraph

# Placeholder for license SKU ID
$licenseSkuPartNumber = "<YOUR_LICENSE_SKU_PARTNUMBER>"

# Get the license SKU ID
$Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq $licenseSkuPartNumber

# Get all users with the certain license
$LicensedUsers = Get-MgUser -Filter "assignedLicenses/any(x:x/skuId eq $($sku.SkuId))" -ConsistencyLevel eventual -All

# Placeholder for the main group name
$mainGroupName = "<YOUR_MAIN_GROUP_NAME>"

# Get the Group Object for the main group
$group = Get-MgGroup -Filter "displayName eq '$mainGroupName'"

# Placeholder for the exclude group name
$excludeGroupName = "<YOUR_EXCLUDE_GROUP_NAME>"

# Get the Group Object for the exclude group
$excludeGroup = Get-MgGroup -Filter "displayName eq '$excludeGroupName'"

# Get all members of a group (including nested groups)
function Get-GroupMembersRecursive {
    param (
        [Parameter(Mandatory=$true)]
        [string]$GroupId
    )

    $members = @()
    $groupMembers = Get-MgGroupMember -GroupId $GroupId

    foreach ($member in $groupMembers) {
        if ($member['@odata.type'] -eq "#microsoft.graph.group") {
            $members += Get-GroupMembersRecursive -GroupId $member.Id
        } else {
            $members += $member
        }
    }

    return $members
}

$groupMembers = Get-GroupMembersRecursive -GroupId $group.Id
$excludeGroupMembers = Get-GroupMembersRecursive -GroupId $excludeGroup.Id

# Filter licensed users who are not in the main group or its subgroups and are not in the exclude group
$usersNotInGroup = $LicensedUsers | Where-Object { $_.Id -notin $groupMembers.Id -and $_.Id -notin $excludeGroupMembers.Id } | Select-Object DisplayName, Mail

# Placeholder for the output path
$outputPath = "<YOUR_OUTPUT_PATH>"

# Export the results to a CSV file
$usersNotInGroup | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host "Found $($usersNotInGroup.Count) licensed users not in the main group and not in the exclude group."
