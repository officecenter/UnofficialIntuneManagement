<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-DeviceConfigurationPolicy() {
	
		<#
	.SYNOPSIS
	This function is used to get device configuration policies from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets any device configuration policies
	.EXAMPLE
	Get-DeviceConfigurationPolicy
	Returns any device configuration policies configured in Intune
	.NOTES
	NAME: Get-DeviceConfigurationPolicy
	#>
	
		[cmdletbinding()]
	
		$graphApiVersion = "Beta"
		$DCP_resource = "deviceManagement/deviceConfigurations"
			
		try {
			
			$uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
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