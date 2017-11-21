
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>
Function Get-IntuneBrand() {
<#
.SYNOPSIS
This function is used to get the Company Intune Branding resources from the Graph API REST interface
.DESCRIPTION
The function connects to the Graph API Interface and gets the Intune Branding Resource
.EXAMPLE
Get-IntuneBrand
Returns the Company Intune Branding configured in Intune
.NOTES
NAME: Get-IntuneBrand
#>
	[cmdletbinding()]
	param(
	)
		
	try {
		$Resource = "deviceManagement/intuneBrand"
		Invoke-GraphAPI -Method PATCH
	}

	catch {
		throw  $_.Exception.Message
	}
}