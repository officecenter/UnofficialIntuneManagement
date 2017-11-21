<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-ManagedDeviceOverview() {
	
		<#
	.SYNOPSIS
	This function is used to get Managed Device Overview from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets the Managed Device Overview
	.EXAMPLE
	Get-ManagedDeviceOverview
	Returns Managed Device Overview configured in Intune
	.NOTES
	NAME: Get-ManagedDeviceOverview
	#>
	
		[cmdletbinding()]
	
	
		$graphApiVersion = "Beta"
		$Resource = "managedDeviceOverview"
	
		try {
	
	
	
	
			$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
			Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get
	
	
	
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