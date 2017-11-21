<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Set-ManagedDeviceProperty() {
	
	<#
.SYNOPSIS
This function is used to set Managed Device property from the Graph API REST interface
.DESCRIPTION
The function connects to the Graph API Interface and sets a Managed Device property
.EXAMPLE
Set-ManagedDeviceProperty -id $id -ownerType company
Returns Managed Devices configured in Intune
.NOTES
NAME: Set-ManagedDevice
#>

	[cmdletbinding()]

	param
	(
		$id,
		$ownertype
	)



	$Resource = "managedDevices"

	try {

		if ($id -eq "" -or $id -eq $null) {

			write-host "No Device id specified, please provide a device id..." -f Red
			break

		}
				
		if ($ownerType -eq "" -or $ownerType -eq $null) {

			write-host "No ownerType parameter specified, please provide an ownerType. Supported value personal or company..." -f Red
						
			break

		}

		elseif ($ownerType -eq "company") {

			$JSON = @"

{
	ownerType:"company"
}

"@
							
	write-host "Are you sure you want to change the device ownership to 'company' on this device? Y or N?"
	$Confirm = read-host

	if ($Confirm -eq "y" -or $Confirm -eq "Y") {
				
		# Send Patch command to Graph to change the ownertype
		$uri = "https://graph.microsoft.com/beta/managedDevices('$ID')"
		Invoke-RestMethod -Uri $uri -Headers $authToken -Method Patch -Body $Json -ContentType "application/json"

	}

	else {

		Write-Host "Change of Device Ownership for the device $ID was cancelled..." -ForegroundColor Yellow
						

	}
				
}

elseif ($ownerType -eq "personal") {

	$JSON = @"

{
	ownerType:"personal"
}

"@

								
	write-host "Are you sure you want to change the device ownership to 'personal' on this device? Y or N?"
	$Confirm = read-host

	if ($Confirm -eq "y" -or $Confirm -eq "Y") {
				
		# Send Patch command to Graph to change the ownertype
		$uri = "https://graph.microsoft.com/beta/managedDevices('$ID')"
		Invoke-RestMethod -Uri $uri -Headers $authToken -Method Patch -Body $Json -ContentType "application/json"

	}

	else {

		Write-Warning "Change of Device Ownership for the device $ID was cancelled..." -ForegroundColor Yellow
						

	}

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