<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Set-DeviceEnrollmentRestrictions() {
	
		<#
	.SYNOPSIS
	This function is used to set Device Enrollment Restrictions resource from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and sets Device Enrollment Restrictions Resource
	.EXAMPLE
	Set-DeviceEnrollmentRestrictions -id $id -JSON $JSON
	Sets device enrollment restrictions configured in Intune
	.NOTES
	NAME: Set-DeviceEnrollmentRestrictions
	#>
	
		[cmdletbinding()]
	
		param
		(
			$id,
			$JSON
		)
	
		$graphApiVersion = "Beta"
		$Resource = "organization('$id')"
	
		try {
	
			if (!$id) {
				write-host "Organization Id hasn't been specified, please specify Id..." -f Red
				break
			}
	
			elseif (!$JSON) {
				write-host "No JSON has been passed to the function, please specify JSON metadata..." -f Red
				break
			}
	
			else {
	
				Test-JSON -JSON $JSON
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
				Invoke-RestMethod -Uri $uri -Headers $authToken -Method Patch -Body $Json -ContentType "application/json"
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