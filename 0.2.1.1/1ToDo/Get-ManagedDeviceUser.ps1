<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-ManagedDeviceUser() {
	
		<#
	.SYNOPSIS
	This function is used to get a Managed Device username from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets a managed device users registered with Intune MDM
	.EXAMPLE
	Get-ManagedDeviceUser -DeviceID $DeviceID
	Returns a managed device user registered in Intune
	.NOTES
	NAME: Get-ManagedDeviceUser
	#>
	
		[cmdletbinding()]
	
		param
		(
			[Parameter(Mandatory = $true, HelpMessage = "DeviceID (guid) for the device on must be specified:")]
			$DeviceID
		)
	
		# Defining Variables
		$graphApiVersion = "beta"
		$Resource = "manageddevices('$DeviceID')?`$select=userId"
	
		try {
	
			$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
			Write-Verbose $uri
			(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).userId
	
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