<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function New-IntuneAppAssignment 
{
  <#
      .SYNOPSIS
      This function is used to create a new application assignment for using with the Graph API REST interface
      .DESCRIPTION
      The function creates a new custom PowerShell object with the correct properties for an Application Assignment
      .EXAMPLE
      $Assignment = New-IntuneAppAssignment -TargetGroupId $TargetGroupId -InstallIntent $InstallIntent
      Creates a new application assignment object
      .NOTES
      NAME: New-IntuneAppAssignment
  #>

  [cmdletbinding()]

  param
  (

    [Parameter(Mandatory = $true)]
    [Guid]
    $TargetGroupId,

    [ValidateSet('Required','Available','Uninstall','notApplicable','availableWithoutEnrollment')]
    [String]
    $InstallIntent = 'Available'
  )
  
  New-Object -TypeName PSObject -Property @{
    '@odata.type' = '#microsoft.graph.mobileAppGroupAssignment'
    'targetGroupId' = "$TargetGroupId"
    'installIntent' = "$InstallIntent"
  }
}
