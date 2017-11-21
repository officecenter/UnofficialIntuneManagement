<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-ApplicationCategory() {
	
		<#
	.SYNOPSIS
	This function is used to get application categories from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets any application category
	.EXAMPLE
	Get-ApplicationCategory
	Returns any application categories configured in Intune
	.NOTES
	NAME: Get-ApplicationCategory
	#>
	
		[cmdletbinding()]
	
		param
		(
			$Name
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceAppManagement/mobileAppCategories"
	
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
			Write-Host "Request to $Uri failed with HTTP Status $([int]$ex.Response.StatusCode) $($ex.Response.StatusDescription)" -f Red
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
	