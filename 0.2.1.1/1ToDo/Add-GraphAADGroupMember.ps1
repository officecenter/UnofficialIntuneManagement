<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>


Function Add-GraphAADGroupMember 
{
	
		<#
	.SYNOPSIS
	This function is used to add an member to an AAD Group from the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and adds a member to an AAD Group registered with AAD
	.EXAMPLE
	Add-AADGroupMember -GroupId $GroupId -AADMemberID $AADMemberID
	Returns all users registered with Azure AD
	.NOTES
	NAME: Add-AADGroupMember
	#>
	
		[cmdletbinding()]
	
		param
		(
			$GroupId,
			$AADMemberId
		)
	
		# Defining Variables
		$graphApiVersion = "v1.0"
		$Resource = "groups"
			
		try {
	
			$uri = "https://graph.microsoft.com/$graphApiVersion/$Resource/$GroupId/members/`$ref"
	
		$JSON = @"

{
		"@odata.id": "https://graph.microsoft.com/v1.0/directoryObjects/$AADMemberId"
}

"@
	
			Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $Json -ContentType "application/json"
	
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
	