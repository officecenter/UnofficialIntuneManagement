<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Set-RBACRoleAssignment () {
	
		<#
	.SYNOPSIS
	This function is used to set an assignment for an RBAC Role using the Graph API REST interface
	.DESCRIPTION
	The function connects to the Graph API Interface and sets and assignment for an RBAC Role
	.EXAMPLE
	Set-RBACRoleAssignment -Id $IntuneRoleID -DisplayName "Assignment" -MemberGroupId $MemberGroupId -TargetGroupId $TargetGroupId
	Creates and Assigns and Intune Role assignment to an Intune Role in Intune
	.NOTES
	NAME: Set-RBACRoleAssignment
	#>
	
		[cmdletbinding()]
	
		param
		(
			$Id,
			$DisplayName,
			$MemberGroupId,
			$TargetGroupId
		)
	
		$graphApiVersion = "Beta"
		$Resource = "deviceManagement/roleAssignments"
			
		try {
	
			if (!$Id) {
	
				write-host "No Policy Id specified, specify a valid Application Id" -f Red
				break
	
			}
	
			if (!$DisplayName) {
	
				write-host "No Display Name specified, specify a Display Name" -f Red
				break
	
			}
	
			if (!$MemberGroupId) {
	
				write-host "No Member Group Id specified, specify a valid Target Group Id" -f Red
				break
	
			}
	
			if (!$TargetGroupId) {
	
				write-host "No Target Group Id specified, specify a valid Target Group Id" -f Red
				break
	
			}
	
	
			$JSON = @"
			{
			"id":"",
			"description":"",
			"displayName":"$DisplayName",
			"members":["$MemberGroupId"],
			"scopeMembers":["$TargetGroupId"],
			"roleDefinition@odata.bind":"https://graph.microsoft.com/beta/deviceManagement/roleDefinitions('$ID')"
			}
"@
	
			$uri = "https://graph.microsoft.com/$graphApiVersion/$Resource"
			Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $JSON -ContentType "application/json"
			
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