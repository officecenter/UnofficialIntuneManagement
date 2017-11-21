<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-AADUserManagedAppRegistrations() {
	
		<#
	.SYNOPSIS
	This function is used to get an AAD User Managed App Registrations from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets a users Managed App Registrations registered with AAD
	.EXAMPLE
	Get-AADUser
	Returns all Managed App Registration for a User registered with Azure AD
	.EXAMPLE
	Get-AADUserManagedAppRegistrations -id $id
	Returns specific user by id registered with Azure AD
	.NOTES
	NAME: Get-AADUserManagedAppRegistrations
	#>
	
		[cmdletbinding()]
	
		param
		(
			$id
		)
	
		# Defining Variables
		$graphApiVersion = "beta"
		$User_resource = "users/$id/managedAppRegistrations"
			
		try {
					
			if (!$id) {
	
				Write-Host "No AAD User ID was passed to the function, specify a valid AAD User ID" -ForegroundColor Red
					
				break
	
			}
	
			else {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$User_resource"
	
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