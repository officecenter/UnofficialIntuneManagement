<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Set-IntuneBrand() {
	
		<#
	.SYNOPSIS
	This function is used to set the Company Intune Brand resource using the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and sets the Company Intune Brand Resource
	.EXAMPLE
	Set-IntuneBrand -JSON $JSON
	Sets the Company Intune Brand using Graph API
	.NOTES
	NAME: Set-IntuneBrand
	#>
	
	[cmdletbinding()]

	param
	([Parameter(Mandatory = $true, Position = 0)]
		[json]
		$JSON
	)

	$graphApiVersion = "Beta"
	$App_resource = "deviceManagement"

	try {

		if (!$JSON) {

			write-host "No JSON was passed to the function, provide a JSON variable" -f Red
			break

		}

		else {

			Test-JSON -JSON $JSON

			$uri = "https://graph.microsoft.com/$graphApiVersion/$($App_resource)"
			Invoke-RestMethod -Uri $uri -Method Patch -ContentType "application/json" -Body $JSON -Headers $authToken
		}
	}

	catch {
		throw  $_.Exception.Message
	}

}
	