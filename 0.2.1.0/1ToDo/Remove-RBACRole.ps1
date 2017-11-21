<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Remove-RBACRole() {
	
		<#
	.SYNOPSIS
	This function is used to delete an RBAC Role Definition from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and deletes an RBAC Role Definition
	.EXAMPLE
	Remove-RBACRole -roleDefinitionId $roleDefinitionId
	Returns any RBAC Role Definitions configured in Intune
	.NOTES
	NAME: Remove-RBACRole
	#>
	
		[cmdletbinding()]
	
		param
		(
			$roleDefinitionId
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/roleDefinitions/$roleDefinitionId"
	
		try {
	
			if ($roleDefinitionId -eq "" -or $roleDefinitionId -eq $null) {
	
				Write-Host "roleDefinitionId hasn't been passed as a paramater to the function..." -ForegroundColor Red
				write-host "Please specify a valid roleDefinitionId..." -ForegroundColor Red
				break
	
			}
	
			else {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
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