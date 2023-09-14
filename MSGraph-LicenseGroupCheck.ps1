# Connect to Microsoft Graph
Connect-MgGraph

# Get the license SKU ID
$Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SKUIDPLACEHODER'

# Get all users with the certain license
$LicensedUsers = Get-MgUser -Filter "assignedLicenses/any(x:x/skuId eq $($sku.SkuId))" -ConsistencyLevel eventual -All

# Get the Group Object
$group = Get-MgGroup -Filter "displayName eq 'GROUPNAMEPLACEHOLDER'"

# Get all members of the group (including nested groups)
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

# Filter licensed users who are not in the group or its subgroups and select only DisplayName and Mail
$usersNotInGroup = $LicensedUsers | Where-Object { $_.Id -notin $groupMembers.Id } | Select-Object DisplayName, Mail

# Export the results to a CSV file
$usersNotInGroup | Export-Csv -Path "C:\path\to\output.csv" -NoTypeInformation

Write-Host "Found $($usersNotInGroup.Count) licensed users not in the group."

