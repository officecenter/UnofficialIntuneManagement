<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-RBACRole() {
	
		<#
	.SYNOPSIS
	This function is used to get RBAC Role Definitions from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets any RBAC Role Definitions
	.EXAMPLE
	Get-RBACRole
	Returns any RBAC Role Definitions configured in Intune
	.NOTES
	NAME: Get-RBACRole
	#>
	
		[cmdletbinding()]
	
		param
		(
			$Name
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/roleDefinitions"
	
		try {
	
			if ($Name) {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
				(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value | Where-Object { ($_.'displayName').contains("$Name") -and $_.isBuiltInRoleDefinition -eq $false }
	
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