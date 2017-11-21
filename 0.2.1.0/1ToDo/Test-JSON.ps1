<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Test-JSON() {
	
		<#
	.SYNOPSIS
	This function is used to test if the JSON passed to a REST Post request is valid
	.DESCRIPTION
	The function tests if the JSON passed to the REST Post is valid
	.EXAMPLE
	Test-JSON -JSON $JSON
	Test if the JSON is valid before calling the Graph REST interface
	.NOTES
	NAME: Test-JSON
	#>
	
		param (
	
			$JSON
	
		)
	
		try {
	
			$TestJSON = ConvertFrom-Json $JSON -ErrorAction Stop
			$validJson = $true
	
		}
	
		catch {
	
			$validJson = $false
			$_.Exception
	
		}
	
		if (!$validJson) {
	
			Write-Host "Provided JSON isn't in valid JSON format" -f Red
			break
	
		}
	
	}