<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Set-TermsAndConditionsAssignment () {
	
		<#
	.SYNOPSIS
	This function is used to assign Terms and Conditions from Intune to a Group using the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and assigns terms and conditions to a group
	.EXAMPLE
	Set-ManagedAppPolicyAssignment -id $id -TargetGroupId
	.NOTES
	NAME: Set-ManagedAppPolicyAssignment
	#>   
	
		[cmdletbinding()]
	
		param
		(
			$id,
			$TargetGroupId
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/termsAndConditions/$id/groupAssignments"
	
		try {
	
			if (!$id) {
	
				Write-Host "No Terms and Conditions ID was passed to the function, specify a valid terms and conditions ID" -ForegroundColor Red
					
				break
	
			}
	
			if (!$TargetGroupId) {
	
				write-host "No Target Group Id specified, specify a valid Target Group Id" -f Red
					
				break
	
			}
	
			else {
	
				$JSON = @"
	
	{
			"targetGroupId":"$TargetGroupId"
	}
	
"@
	
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