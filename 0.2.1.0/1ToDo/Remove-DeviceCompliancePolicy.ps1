<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Remove-DeviceCompliancePolicy() {
	
		<#
	.SYNOPSIS
	This function is used to delete a device configuration policy from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and deletes a device compliance policy
	.EXAMPLE
	Remove-DeviceConfigurationPolicy -id $id
	Returns any device configuration policies configured in Intune
	.NOTES
	NAME: Remove-DeviceConfigurationPolicy
	#>
	
		[cmdletbinding()]
	
		param
		(
			$id
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/deviceCompliancePolicies"
	
		try {
	
			if ($id -eq "" -or $id -eq $null) {
	
				write-host "No id specified for device compliance, can't remove compliance policy..." -f Red
				write-host "Please specify id for device compliance policy..." -f Red
				break
	
			}
	
			else {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)/$id"
				Invoke-RestMethod -Uri $uri -Headers $authToken -Method Delete
	
			}
	
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