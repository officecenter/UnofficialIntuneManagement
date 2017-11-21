<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Set-ApplicationAssignment
{
  [cmdletbinding()]

  param
  (
    [Parameter(Mandatory = $true)]
    [Guid]
    $ApplicationId,

    [Parameter(Mandatory = $true)]
    [PSObject[]]
    $Assignment
  )
  $Resource = "deviceAppManagement/mobileApps/$ApplicationId/assign"

  $JSON = New-Object -TypeName PSObject -Property @{
    'mobileAppGroupAssignments' = $Assignment
  } | ConvertTo-Json

  Invoke-GraphAPI -Resource $Resource -Method POST -Body $JSON
}

