<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-RBACRoleDefinition() {
	
		<#
	.SYNOPSIS
	This function is used to get an RBAC Role Definition from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets any RBAC Role Definition
	.EXAMPLE
	Get-RBACRoleDefinition -id $id
	Returns an RBAC Role Definitions configured in Intune
	.NOTES
	NAME: Get-RBACRoleDefinition
	#>
	
		[cmdletbinding()]
	
		param
		(
			$id
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/roleDefinitions('$id')?`$expand=roleassignments"
			
		try {
	
			if (!$id) {
	
				write-host "No Role ID was passed to the function, provide an ID variable" -f Red
				break
	
			}
			
			$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
			(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).roleAssignments
			
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
	