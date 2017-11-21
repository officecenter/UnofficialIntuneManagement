<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-ManagedAppPolicyMobileApps() {
	
		<#
	.SYNOPSIS
	This function is used to get managed app policy Mobile Apps from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets any managed app policy mobile apps
	.EXAMPLE
	Get-ManagedAppPolicyMobileApps -id $id
	Returns any managed app policy mobile apps configured in Intune
	.NOTES
	NAME: Get-ManagedAppPolicyMobileApps
	#>
	
		[cmdletbinding()]
	
		param
		(
			$id,
			$OS
	
		)
	
		$graphApiVersion = "Beta"
	
		try {
	
			if ($id -eq "" -or $id -eq $null) {
	
				write-host "No Managed App Policy id specified, please provide a policy id..." -f Red
				break
	
			}
	
			else {
	
				if ($OS -eq "" -or $OS -eq $null) {
	
					write-host "No OS parameter specified, please provide an OS. Supported value Android or iOS..." -f Red
							
					break
	
				}
	
				elseif ($OS -eq "Android") {
	
					$Resource = "deviceAppManagement/androidManagedAppProtections('$id')/?`$Expand=mobileAppIdentifierDeployments"
	
					$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
					Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get | select mobileAppIdentifierDeployments
	
				}
	
				elseif ($OS -eq "iOS") {
	
					$Resource = "deviceAppManagement/iosManagedAppProtections('$id')/?`$Expand=mobileAppIdentifierDeployments"
	
					$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
					Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get | select mobileAppIdentifierDeployments
	
	
				}
	
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
	