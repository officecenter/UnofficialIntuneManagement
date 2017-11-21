<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-DeviceCompliancePolicyAssignment() {
	
		<#
	.SYNOPSIS
	This function is used to get device compliance policy assignment from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets a device compliance policy assignment
	.EXAMPLE
	Get-DeviceCompliancePolicyAssignment -id $id
	Returns any device compliance policy assignment configured in Intune
	.NOTES
	NAME: Get-DeviceCompliancePolicyAssignment
	#>
	
		[cmdletbinding()]
	
		param
		(
			[Parameter(Mandatory = $true, HelpMessage = "Enter id (guid) for the Device Compliance Policy you want to check assignment")]
			$id
		)
	
		$graphApiVersion = "Beta"
		$DCP_resource = "deviceManagement/deviceCompliancePolicies"
	
		try {
	
			$uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)/$id/groupAssignments"
			(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
	
		}
	
		catch {
	
			$ex = $_.Exception
			$errorResponse = $ex.Response.GetResponseStream()
			$reader = New-Object System.IO.StreamReader($errorResponse)
			$reader.BaseStream.Position = 0
			$reader.DiscardBufferedData()
			$responseBody = $reader.ReadToEnd();
			Write-Host "Response content:`n$responseBody" -f Red
			Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
			
			break
	
		}
	
	}
			 