<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Remove-ManagedAppPolicy() {
	
		<#
	.SYNOPSIS
	This function is used to remove Managed App policies from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and removes managed app policies
	.EXAMPLE
	Remove-ManagedAppPolicy -id $id
	Removes a managed app policy configured in Intune
	.NOTES
	NAME: Remove-ManagedAppPolicy
	#>
	
		[cmdletbinding()]
	
		param
		(
			$id
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceAppManagement/managedAppPolicies"
	
		try {
	
			if ($id -eq "" -or $id -eq $null) {
	
				write-host "No id specified for managed app policy, can't remove managed app policy..." -f Red
				write-host "Please specify id for managed app policy..." -f Red
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