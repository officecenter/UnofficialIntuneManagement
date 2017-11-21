<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-IntuneApplication 
{
  <#
      .SYNOPSIS
      This function is used to get applications from the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and gets any applications added
      .EXAMPLE
      Get-IntuneApplication
      Returns any applications configured in Intune
      .EXAMPLE
      Get-IntuneApplication -Name Word
      Returns any applications configured in Intune that matches the pattern -like "*Word*"
       .EXAMPLE
      Get-IntuneApplication -Name Word -Platform androidStoreApp
      Returns any Android applications configured in Intune that matches the pattern -like "*Word*"
     .NOTES
      NAME: Get-IntuneApplication
  #>

  [cmdletbinding()]

  param
  (
    [String]
    $Name = '*',
    
    [ValidateSet('*','androidStoreApp','iosStoreApp','windowsMobileMSI','windowsStoreForBusinessApp','officeSuiteApp','webApp')]
    [String]
    $Platform = '*'

  )

  $Resource = 'deviceAppManagement/mobileApps'


  Invoke-GraphAPI -Resource $Resource | Where-Object -FilterScript {
    $_.'displayName' -like "$Name" -and $_.'@odata.type' -like "*$Platform"
  }
}


