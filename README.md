# MSGraph-LicenseGroupCheck

This PowerShell script checks for users with a specific license and determines if they are part of a designated group. If the users are not in the group, their details are exported to a CSV file.

## Prerequisites

- **Microsoft Graph PowerShell SDK**: Ensure you have the Microsoft Graph PowerShell SDK installed. [Learn about Microsoft Graph PowerShell Installation](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph
- **Permissions**: You need the appropriate permissions to retrieve user details and group memberships from your Microsoft 365/Azure tenant.

## Usage

1. **Navigate** to the directory containing the script using PowerShell.
2. **Execute** the script:
   ```powershell
   .\MSGraph-LicenseGroupCheck.ps1

## Configuration

### Connect to Microsoft Graph
This script starts by connecting to Microsoft Graph using the `Connect-MgGraph` cmdlet.

### License SKU
Modify the `SKUIDPLACEHODER` in the `$Sku` line with the desired SKU ID of the license you want to check.

### Group Name
The script checks for membership in a group named `GROUPNAMEPLACEHOLDER`. Replace this placeholder with the actual name of the group you want to verify against.

### Recursive Group Membership Check
The script contains a function called `Get-GroupMembersRecursive` that fetches all members from a group, even if the group contains nested groups.

### Export Path
The results (users with the specified license but not in the group) are exported to `C:\path\to\output.csv`. Adjust this path to your preferred location.

### Output
Once the script completes, it will display the number of users with the specified license who are not part of the designated group.

## Contribution
Contributions are welcomed! Feel free to fork this repository, make enhancements, and submit pull requests. Every contribution, regardless of its size, is valued.

## Disclaimer
Always use this script with caution. Before making any modifications to your production environment, ensure you have the necessary backups and fully understand the implications.
