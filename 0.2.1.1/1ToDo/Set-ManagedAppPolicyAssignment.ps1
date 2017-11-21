<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Set-ManagedAppPolicyAssignment () {
	
		<#
	.SYNOPSIS
	This function is used to assign an AAD group to a Managed App Policy using the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and assigns a Managed App Policy with an AAD Group
	.EXAMPLE
	Set-ManagedAppPolicyAssignment -Id $Id -TargetGroupId $TargetGroupId -OS Android
	Assigns an AAD Group assignment to an Android App Protection Policy in Intune
	.EXAMPLE
	Set-ManagedAppPolicyAssignment -Id $Id -TargetGroupId $TargetGroupId -OS iOS
	Assigns an AAD Group assignment to an iOS App Protection Policy in Intune
	.NOTES
	NAME: Set-ManagedAppPolicyAssignment
	#>
	
		[cmdletbinding()]
	
		param
		(
			$Id,
			$TargetGroupId,
			$OS
		)
	
		$graphApiVersion = "Beta"
			
		try {
	
			if (!$Id) {
	
				write-host "No Policy Id specified, specify a valid Application Id" -f Red
				break
	
			}
	
			if (!$TargetGroupId) {
	
				write-host "No Target Group Id specified, specify a valid Target Group Id" -f Red
				break
	
			}
	
	
			$JSON = @"
	
	{
	"targetedSecurityGroups":[{"id":"https://graph.microsoft.com/v1.0/groups/$TargetGroupId"}]
	}
	
"@
	
			if ($OS -eq "" -or $OS -eq $null) {
	
				write-host "No OS parameter specified, please provide an OS. Supported value Android or iOS..." -f Red
					
				break
	
			}
	
			elseif ($OS -eq "Android") {
	
				$uri = "https://graph.microsoft.com/beta/deviceAppManagement/iosManagedAppProtections('$ID')/updateTargetedSecurityGroups"
				Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body $JSON -Headers $authToken
	
			}
	
			elseif ($OS -eq "iOS") {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/deviceAppManagement/iosManagedAppProtections('$ID')/updateTargetedSecurityGroups"
				Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body $JSON -Headers $authToken
	
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