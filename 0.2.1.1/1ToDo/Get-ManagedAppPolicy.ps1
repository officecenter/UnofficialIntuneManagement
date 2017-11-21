<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-ManagedAppPolicy() {
	
		<#
	.SYNOPSIS
	This function is used to get managed app policies from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets any managed app policies
	.EXAMPLE
	Get-ManagedAppPolicy
	Returns any managed app policies configured in Intune
	.NOTES
	NAME: Get-ManagedAppPolicy
	#>
	
		[cmdletbinding()]
	
		param
		(
			$Name
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceAppManagement/managedAppPolicies"
	
		try {
	
			if ($Name) {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
				(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value | Where-Object { ($_.'displayName').contains("$Name") }
	
			}
	
			else {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
				(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
	
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