<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Add-RBACRole() {
	
		<#
	.SYNOPSIS
	This function is used to add an RBAC Role Definitions from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and adds an RBAC Role Definitions
	.EXAMPLE
	Add-RBACRole -JSON $JSON
	.NOTES
	NAME: Add-RBACRole
	#>
	
		[cmdletbinding()]
	
		param
		(
			$JSON
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/roleDefinitions"
	
		try {
	
			if (!$JSON) {
				$errormessage = "No JSON was passed to the function, provide a JSON variable"
				write-error -Message $errormessage
				break
	
			}
	
			Test-JSON -JSON $JSON
	
			$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
			Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $Json -ContentType "application/json"
	
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