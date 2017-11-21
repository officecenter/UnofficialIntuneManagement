<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>


Function Add-IntuneAppAssignment
{
  <#
      .SYNOPSIS
      This function is used to add a new app assignment to an Intune managed application
      .DESCRIPTION
      The function posts the application assignment to the correct group through the Intune
      graph API
      .EXAMPLE
      Add-IntuneAppAssignment -ApplicationId $ApplicationId -Assignment $Assignment
      Adds the app assignment created with New-IntuneAppAssignment to the application 
      with the object id $ApplicationId
      .NOTES
      NAME: Add-IntuneAppAssignmentI
  #>
  [cmdletbinding()]

  param
  (
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Enter the object id of the application to be assigned.'
    )]
    [Guid]
    $ApplicationId,

    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Pass a PSObject created with New-IntuneAppAssignment'
    )]
    [PSObject[]]
    $Assignment
  )
  $Resource = 'deviceAppManagement/mobileApps/{0}/groupAssignments' -F $ApplicationId.Guid
  
  $JSON = ConvertTo-Json -InputObject $Assignment

  Write-Verbose -Message ('{0}: Invoking API with resource "{1}"' -F $MyInvocation.MyCommand.Name, $Resource)	  

  Invoke-GraphAPI -Resource $Resource -Method POST -Body $JSON
  
  Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    
}
