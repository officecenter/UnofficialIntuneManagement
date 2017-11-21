<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>
Function Get-GraphAADDevice 
{
	
		<#
	.SYNOPSIS
	This function is used to get an AAD Device from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and gets an AAD Device registered with AAD
	.EXAMPLE
	Get-GraphAADDevice -DeviceID $DeviceID
	Returns an AAD Device from Azure AD
	.NOTES
	NAME: Get-GraphAADDevice
	#>
	
		[cmdletbinding()]
	
		param
		(
      [Parameter(Mandatory = $True)]			
      [Guid]$DeviceID
		)
	
		# Defining Variables
		$graphApiVersion = "v1.0"
		$Resource = "devices?`$filter=deviceId eq '{0}'" -F $DeviceID.Guid
			
    Invoke-GraphAPI -graphApiVersion $graphApiVersion -Resource $Resource
	}
	