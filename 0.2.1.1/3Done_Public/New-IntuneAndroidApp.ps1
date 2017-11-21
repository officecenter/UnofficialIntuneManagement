<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>
Function New-IntuneAndroidApp
{
  <#
      .SYNOPSIS
      This function is used to create a new Andoroid app definition as a PSObject 
      .DESCRIPTION
      The function creates a new Android app definition object. 
      .EXAMPLE
      New-IntuneAndroidApp -DisplayName $DisplayName -Publisher $Publisher -AppstoreUrl $AppStoreUrl -MinimumOsVersion $MinimumOsVersion -IconUrl $IconUrl
      Adds an iOS application into Intune from itunes store
      .NOTES
      NAME = New-IntuneAndroidApp
  #>
	
  [cmdletbinding()]
	
  param
  (
    [Parameter(Mandatory = $True,
      HelpMessage="Enter the Display name of the Android app."
    )]
    [String]
    $DisplayName,

    [String]
    $Description = $DisplayName,

    [Parameter(Mandatory = $True,
      HelpMessage="Enter the name of the Publisher of the Android app."
    )]
    [String]
    $Publisher,

    [Parameter(Mandatory = $True,
      HelpMessage="Enter the Google Play Store URL of the application."
    )]
    [Uri]
    $AppstoreUrl,

    [Parameter(Mandatory = $True,
      HelpMessage="Enter minimum OS version the app supports."
    )]
    [ValidateSet('v4_0','v4_0_3','v4_1','v4_2','v4_3','v4_4','v5_0','v5_1')]
    $MinimumOsVersion,

    [Parameter(Mandatory = $True,
      HelpMessage="Enter an URL to an Icon for the application."
    )]
    [Uri]
    $IconUrl,

    [Switch]
    $IsFeatured


  )

  Write-Verbose ('New-IntuneAndroidApp: App name: {0}, downloading icon from: ' -F $DisplayName, $IconUrl)

  $iconResponse = Invoke-WebRequest "$iconUrl"
	$base64icon = [System.Convert]::ToBase64String($iconResponse.Content)
	$iconExt = ([System.IO.Path]::GetExtension("$iconURL")).replace(".", "")
	$iconType = "image/$iconExt"

  Write-Verbose ('New-IntuneAndroidApp: Creating PowerShell Object for App: {0}' -F $DisplayName)

  New-Object -TypeName PSObject -Property @{
    "@odata.type" = "#microsoft.graph.androidStoreApp"
    "displayName" = "$DisplayName"
    "description" = "$Description"
    "publisher" = "$Publisher"
    "isFeatured" = $IsFeatured
    "largeIcon" = New-Object -TypeName PSObject -Property @{
      "@odata.type" = "#microsoft.graph.mimeContent"
      "type" = "$iconType"
      "value" = "$base64icon"
    }
    "appStoreUrl" = "$AppstoreUrl"
    "minimumSupportedOperatingSystem" = New-Object -TypeName PSObject -Property @{
      "@odata.type" = "#microsoft.graph.androidMinimumOperatingSystem"
      "$MinimumOsVersion" = 'true'
    }
  }
}