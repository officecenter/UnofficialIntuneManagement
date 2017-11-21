<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Add-DeviceConfigurationPolicyAssignment() {
	
		<#
	.SYNOPSIS
	This function is used to add a device configuration policy assignment using the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and adds a device configuration policy assignment
	.EXAMPLE
	Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $ConfigurationPolicyId -TargetGroupId $TargetGroupId
	Adds a device configuration policy assignment in Intune
	.NOTES
	NAME: Add-DeviceConfigurationPolicyAssignment
	#>
	
		[cmdletbinding()]
	
		param
		(
			$ConfigurationPolicyId,
			$TargetGroupId
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/deviceConfigurations/$ConfigurationPolicyId/assign"
			
		try {
	
			if (!$ConfigurationPolicyId) {
	
				write-host "No Configuration Policy Id specified, specify a valid Configuration Policy Id" -f Red
				break
	
			}
	
			if (!$TargetGroupId) {
	
				write-host "No Target Group Id specified, specify a valid Target Group Id" -f Red
				break
	
			}
	
			$ConfPolAssign = "$ConfigurationPolicyId" + "_" + "$TargetGroupId"
	
			$JSON = @"
	
	{
		"deviceConfigurationGroupAssignments": [
			{
				"@odata.type": "#microsoft.graph.deviceConfigurationGroupAssignment",
				"id": "$ConfPolAssign",
				"targetGroupId": "$TargetGroupId"
			}
		]
	}
"@
	
			$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
			Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $JSON -ContentType "application/json"
	
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