
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
        $id = "lm9ncYGXpU-D86fYQntSbJYAFlhu"
		$Resource = "planner/plans/$id/tasks"
		$t = Invoke-GraphAPI -Method GET -Resource $Resource
	}

	catch {
		throw  $_.Exception.Message
	}
}