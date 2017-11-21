<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>
Function Get-GooglePlayApplication
{
  [CmdLetBinding()]
  Param(
    [Parameter(Mandatory = $true)]
    [String[]]
    $BundleId,

    [String]
    $Country = 'no'
  )

  Begin
  {}
  
  Process
  {
    Foreach ($Id in $BundleId)
    { 
      $appStoreUrl = 'https://play.google.com/store/apps/details?id={0}&hl={1}' -F $Id, $Country

      Write-Verbose ('{0}: Scraping App info from URL: {1}' -F $Id, $appStoreUrl)

      $appStorePage = Invoke-WebRequest -Uri $appStoreUrl

      $IconUrl = 'https:' + ($appStorePage.images | Where-Object -FilterScript {
          $_.alt -eq 'Cover art'
      }).src

      Write-Verbose ('{0}: Will try to download App ion from: {1}' -F $Id, $IconUrl)

      $DisplayName = ($appStorePage.ParsedHtml.getElementsByTagName('h1') | Where-Object -FilterScript {
          $_.classname -eq 'document-title'
      }).InnerText

      Write-Verbose ('{0}: Name: {1}' -F $Id, $DisplayName)
      
      $Description = $appStorePage.ParsedHtml.title

      Write-Verbose ('{0}: Description: {1}' -F $Id, $Description)

      $Publisher = ($appStorePage.ParsedHtml.getElementsByTagName('a') | Where-Object -FilterScript {
          $_.classname -eq 'document-subtitle primary'
      }).TextContent

      Write-Verbose ('{0}: Publisher: {1}' -F $Id, $Publisher)

      $operatingSystems = ($appStorePage.ParsedHtml.getElementsByTagName('div') | Where-Object -FilterScript {
          $_.classname -eq 'content' -and $_.OuterHTML -like '*operatingSystems*'
      }).InnerText

      If ($operatingSystems -match '(\d+\.)+\d+\b')
      {
        $osVersion = 'v{0}'-F $Matches[0] -replace '\.', '_'
      }

      Write-Verbose ('{0}: Minimum Operating system scraped as: {1}, Parsed as: {2}' -F $Id, $Matches[0], $osVersion)

      Write-Verbose ('{0}: Calling function New-AndroidApplication with the scraped information' -F $Id)

      New-AndroidApplication -DisplayName $DisplayName -Description $Description -Publisher $Publisher -IconUrl $IconUrl -AppstoreUrl $appStoreUrl -IsFeatured -MinimumOsVersion $osVersion
    }
  }

  End 
  {}
}
