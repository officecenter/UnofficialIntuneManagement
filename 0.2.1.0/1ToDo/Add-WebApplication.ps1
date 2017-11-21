<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Add-WebApplication() {
	
		<#
	.SYNOPSIS
	This function is used to add a Web application using the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and adds a Web application
	.EXAMPLE
	Add-WebApplication -JSON $JSON -IconURL pathtourl
	Adds a Web application into Intune using an icon from a URL
	.NOTES
	NAME: Add-WebApplication
	#>
	
		[cmdletbinding()]
	
		param
		(
			$JSON,
			$IconURL
		)
	
		$graphApiVersion = "Beta"
		$App_resource = "deviceAppManagement/mobileApps"
	
		try {
	
			if (!$JSON) {
	
				write-host "No JSON was passed to the function, provide a JSON variable" -f Red
				break
	
			}
	
	
			if ($IconURL) {
	
				write-verbose "Icon specified: $IconURL"
	
				if (!(test-path "$IconURL")) {
	
					write-host "Icon Path '$IconURL' doesn't exist..." -ForegroundColor Red
					Write-Host "Please specify a valid path..." -ForegroundColor Red
							
					break
	
				}
	
				$iconResponse = Invoke-WebRequest "$iconUrl"
				$base64icon = [System.Convert]::ToBase64String($iconResponse.Content)
				$iconExt = ([System.IO.Path]::GetExtension("$iconURL")).replace(".", "")
				$iconType = "image/$iconExt"
	
				Write-Verbose "Updating JSON to add Icon Data"
	
				$U_JSON = ConvertFrom-Json $JSON
	
				$U_JSON.largeIcon.type = "$iconType"
				$U_JSON.largeIcon.value = "$base64icon"
	
				$JSON = ConvertTo-Json $U_JSON
	
				Write-Verbose $JSON
	
				Test-JSON -JSON $JSON
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($App_resource)"
				Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body $JSON -Headers $authToken
	
			}
	
			else {
	
				Test-JSON -JSON $JSON
	
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($App_resource)"
				Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body $JSON -Headers $authToken
	
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