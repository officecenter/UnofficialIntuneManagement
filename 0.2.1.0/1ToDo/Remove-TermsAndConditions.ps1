<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Remove-TermsAndConditions() {
	
		<#
	.SYNOPSIS
	This function is used to delete a Terms and Condition Definition from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and deletes a Terms and Condition Definition
	.EXAMPLE
	Remove-TermsAndConditions -termsAndConditionsId $termsAndConditionsId
	Removes a Terms and Condition Definition configured in Intune
	.NOTES
	NAME: Remove-TermsAndConditions
	#>
	
		[cmdletbinding()]
	
		param
		(
			$termsAndConditionId
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/termsAndConditions/$termsAndConditionId"
	
		try {
	
			if ($termsAndConditionId -eq "" -or $termsAndConditionId -eq $null) {
	
				Write-Host "termsAndConditionId hasn't been passed as a paramater to the function..." -ForegroundColor Red
				write-host "Please specify a valid termsAndConditionsId..." -ForegroundColor Red
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
	