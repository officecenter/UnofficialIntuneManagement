<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-TermsAndConditions() {
	
		<#
	.SYNOPSIS
	This function is used to get the Get Terms And Conditions intune resource from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets the Terms and Conditions Intune Resource
	.EXAMPLE
	Get-TermsAndConditions
	Returns the Organization resource configured in Intune
	.NOTES
	NAME: Get-TermsAndConditions
	#>
	
		[cmdletbinding()]
	
		param
		(
			$Name
		)
	
		$graphApiVersion = "Beta"
		$resource = "deviceManagement/termsAndConditions"
	
		try {
	
			if ($Name) {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
				(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value | Where-Object { ($_.'displayName').contains("$Name") }
	
			}
	
			else {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
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