
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>
Function Get-PlannerTaskChecklist{
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
            $id = "fr8TS3WXqkSM1NwAMnUm-pYAP-tl"
            
            $Resource = "/planner/tasks/$id/details"
            $t = Invoke-GraphAPI -Method PATCH
            $t | Export-Excel C:\Git\Planner.xlsx
            #$Resource = "/planner/tasks/$id/checklist"
            #Invoke-GraphAPI -Method PATCH | select * | ogv
        }
    
        catch {
            throw  $_.Exception.Message
        }
    }