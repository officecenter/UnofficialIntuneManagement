<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Remove-IntuneApplication() {
	
		<#
	.SYNOPSIS
	This function is used to remove an application from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and removes and application
	.EXAMPLE
	Remove-IntuneApplication -id $id
	Removes an application configured in Intune
	.NOTES
	NAME: Remove-IntuneApplication
	#>
	
		[cmdletbinding()]
	
		param
		(
			$id
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceAppManagement/mobileApps"
	
		try {
	
			if ($id -eq "" -or $id -eq $null) {
	
				write-host "No id specified for application, can't remove application..." -f Red
				write-host "Please specify id for application..." -f Red
				break
	
			}
	
			else {
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)/$id"
				Invoke-RestMethod -Uri $uri -Headers $authToken -Method Delete
	
			}
	
		}
	
		catch {
	
			$ex = $_.Exception
			Write-Host "Request to $Uri failed with HTTP Status $([int]$ex.Response.StatusCode) $($ex.Response.StatusDescription)" -f Red
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