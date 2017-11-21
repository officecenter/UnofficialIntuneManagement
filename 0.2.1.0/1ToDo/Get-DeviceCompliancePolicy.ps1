<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>
  
Function Get-DeviceCompliancePolicy() {
	
		<#
	.SYNOPSIS
	This function is used to get device compliance policies from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets any device compliance policies
	.EXAMPLE
	Get-DeviceCompliancePolicy
	Returns any device compliance policies configured in Intune
	.EXAMPLE
	Get-DeviceCompliancePolicy -Android
	Returns any device compliance policies for Android configured in Intune
	.EXAMPLE
	Get-DeviceCompliancePolicy -iOS
	Returns any device compliance policies for iOS configured in Intune
	.NOTES
	NAME: Get-DeviceCompliancePolicy
	#>
	
		[cmdletbinding()]
	
		param
		(
			$Name,
			[switch]$Android,
			[switch]$iOS,
			[switch]$Win10
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/deviceCompliancePolicies"
	
		try {
	
			$Count_Params = 0
	
			if ($Android.IsPresent) { $Count_Params++ }
			if ($iOS.IsPresent) { $Count_Params++ }
			if ($Win10.IsPresent) { $Count_Params++ }
			if ($Name.IsPresent) { $Count_Params++ }
	
			if ($Count_Params -gt 1) {
	
				write-host "Multiple parameters set, specify a single parameter -Android -iOS or -Win10 against the function" -f Red
	
			}
	
			elseif ($Android) {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
				(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value | Where-Object { ($_.'@odata.type').contains("android") }
	
			}
	
			elseif ($iOS) {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
				(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value | Where-Object { ($_.'@odata.type').contains("ios") }
	
			}
	
			elseif ($Win10) {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
				(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value | Where-Object { ($_.'@odata.type').contains("windows10CompliancePolicy") }
	
			}
	
			elseif ($Name) {
	
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