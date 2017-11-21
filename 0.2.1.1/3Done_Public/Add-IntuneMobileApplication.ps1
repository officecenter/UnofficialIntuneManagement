<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>
Function Add-IntuneMobileApplication
{
  <#
      .SYNOPSIS
      This function is used to add mobile applications using the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and adds mobile applications for management under Intune.
      .EXAMPLE
      Add-MobileApplication -MobileApp $MobileApp
      Adds one or more mobile application(s) into Intune.
      .NOTES
      NAME: Add-MobileApplication
  #>
	
  [cmdletbinding()]
	
  param
  (
    [Parameter(Mandatory = $True)]
    [PSObject[]]
    $MobileApp
  )
  Begin
  {
    $Resource = 'deviceAppManagement/mobileApps'
    Write-Verbose ('{0}: Base resource "{1}"' -F $MyInvocation.MyCommand.Name, $Resource)	          
  }
  Process
  {
    Foreach ($App in $MobileApp)
    { 
      $JSON = ConvertTo-Json -InputObject $App
	
      Write-Verbose ('{0}: Invoking API with resource "{1}"' -F $MyInvocation.MyCommand.Name, $Resource)	  

      Invoke-GraphAPI -Resource $Resource -Method POST -Body $JSON
    }
  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }
}
