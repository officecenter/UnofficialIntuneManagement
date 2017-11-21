<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Add-TermsAndConditions() {
	
		<#
	.SYNOPSIS
	This function is used to add Terms and Conditions using the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and adds Terms and Conditions Statement
	.EXAMPLE
	Add-TermsAndConditions -JSON $JSON
	Adds Terms and Conditions into Intune
	.NOTES
	NAME: Add-TermsAndConditions
	#>
	
		[cmdletbinding()]
	
		param
		(
			$JSON
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/termsAndConditions"
	
		try {
	
			if ($JSON -eq "" -or $JSON -eq $null) {
	
				write-host "No JSON specified, please specify valid JSON for the Android Policy..." -f Red
	
			}
	
			else {
	
				Test-JSON -JSON $JSON
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
				Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $JSON -ContentType "application/json"
	
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