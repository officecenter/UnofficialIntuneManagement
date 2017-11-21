<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Set-DeviceProfileAssignment() {
	<#
.SYNOPSIS
This function is used to assign a profile to given devices using the Graph API REST interface
.DESCRIPTION
The function connects to the Graph API Interface and assigns a profile to given devices
.EXAMPLE
Set-DeviceProfileAssignment
Assigns a profile to given devices in Intune
.NOTES
NAME: Set-DeviceProfileAssignment
#>

	[cmdletbinding()]

	param
	(
		$Devices,
		$ProfileId
	)

	$graphApiVersion = "Beta"
	$ResourceSegment = "deviceManagement/enrollmentProfiles('{0}')/updateDeviceProfileAssignment"

	try {

		if ([string]::IsNullOrWhiteSpace($ProfileId)) {

			$ProfileId = Read-Host -Prompt "Please specify profile Id to assign to devices"
        

		}

		$id = [Guid]::NewGuid();
		if ([string]::IsNullOrWhiteSpace($ProfileId) -or ![Guid]::TryParse($ProfileId, [ref]$id)) {

			write-host "Invalid ProfileId specified, please specify valid ProfileId to assign to devices..." -f Red

		}
		elseif ($Devices -eq $null -or $Devices.Count -eq 0) {

			write-host "No devices specified, please specify a list of devices to assign..." -f Red
		}
		else {

			$Resource = "deviceManagement/enrollmentProfiles('$ProfileId')/updateDeviceProfileAssignment"

			$DevicesArray = $Devices -split "," 

			$JSON = @{ "deviceIds" = $DevicesArray } | ConvertTo-Json

			Test-JSON -JSON $JSON

			$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
			Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $JSON -ContentType "application/json"

			Write-Host "Devices assigned!" -f Green
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