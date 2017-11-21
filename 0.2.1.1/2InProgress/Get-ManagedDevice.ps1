<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-ManagedDevice() {

	<#
.SYNOPSIS
This function is used to get Intune Managed Devices from the Graph API REST interface
.DESCRIPTION
The function connects to the Graph API Interface and gets any Intune Managed Device
.EXAMPLE
Get-ManagedDevice
Returns all managed devices but excludes EAS devices registered within the Intune Service
.EXAMPLE
Get-ManagedDevice -IncludeEAS
Returns all managed devices including EAS devices registered within the Intune Service
.NOTES
NAME: Get-ManagedDevice
#>

	[cmdletbinding()]

	param
	(
		[switch]$IncludeEAS,
		[switch]$ExcludeMDM
	)

	# Defining Variables
	$graphApiVersion = "beta"
	$Resource = "managedDevices"

	try {

		$Count_Params = 0

		if ($IncludeEAS.IsPresent) { $Count_Params++ }
		if ($ExcludeMDM.IsPresent) { $Count_Params++ }
				
		if ($Count_Params -gt 1) {

			write-warning "Multiple parameters set, specify a single parameter -IncludeEAS, -ExcludeMDM or no parameter against the function"
				
			break

		}
				
		elseif ($IncludeEAS) {

			$uri = "https://graph.microsoft.com/$graphApiVersion/$Resource"

		}

		elseif ($ExcludeMDM) {

			$uri = "https://graph.microsoft.com/$graphApiVersion/$Resource`?`$filter=managementAgent eq 'eas'"

		}
				
		else {
		
			$uri = "https://graph.microsoft.com/$graphApiVersion/$Resource`?`$filter=managementAgent eq 'mdm' and managementAgent eq 'easmdm'"
			Write-Warning "EAS Devices are excluded by default, please use -IncludeEAS if you want to include those devices"
				

		}

		(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
		
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