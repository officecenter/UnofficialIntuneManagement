
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>
Function Get-PlannerPlan {
<#
.SYNOPSIS
https://graph.microsoft.com/beta/planner/tasks/gcrYAaAkgU2EQUvpkNNXLGQAGTtu/details
.DESCRIPTION
The function connects to the Graph API Interface and gets the 
.EXAMPLE
.NOTES
NAME: Get-IntuneBrand
#>
	[cmdletbinding()]
	param(
	)
		
	try {
        $id = "5LQAj5A6hkOqHu1zNwN6uZYAH9yV"
		$Resource = "planner/plans/$id/tasks"
		Invoke-GraphAPI -Method GET
	}

	catch {
		throw  $_.Exception.Message
	}
}