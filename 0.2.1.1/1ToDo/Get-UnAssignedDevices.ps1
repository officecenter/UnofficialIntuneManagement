<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-UnAssignedDevice() {
	
		<#
	.SYNOPSIS
	This function is used to get all un-assigned bulk devices using the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets all un-assigned bulk devices
	.EXAMPLE
	Get-UnAssignedDevice
	Gets all un-assigned bulk devices
	.NOTES
	NAME: Get-UnAssignedDevice
	#>
	
		[cmdletbinding()]
	
		param
		(
		)
	
		$graphApiVersion = "Beta"
		$ResourceSegment = "deviceManagement/importedAppleDeviceIdentities?`$filter=discoverySource eq 'deviceEnrollmentProgram'"
	
		try {
	
			[System.String]$devicesNextLink = ''
			[System.String[]]$unAssignedDevices = @()
			[System.Uri]$uri = "https://graph.microsoft.com/$graphApiVersion/$($ResourceSegment)"
	
			DO {
				$response = Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get -ContentType "application/json"
				$devicesNextLink = $response."@odata.nextLink"
				$uri = $devicesNextLink
	
				foreach ($device in $response.value) {
					write-host "SerialNumber: " $device.SerialNumber "RequestedEnrollmentProfileId: " $device.RequestedEnrollmentProfileId "`n"
	
					if ([string]::IsNullOrEmpty($device.RequestedEnrollmentProfileId)) {
						$unAssignedDevices += $device.SerialNumber
					}
	
					if ($unAssignedDevices.Count -ge 1000) {
						$devicesNextLink = ''
						break
					}
				}
			}While (![string]::IsNullOrEmpty($devicesNextLink))
	
			Write-Host $unAssignedDevices -f Yellow
	
			return $unAssignedDevices
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