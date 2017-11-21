<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function New-IntuneiOSApplication
{
  <#
      .SYNOPSIS
      This function is used to add an iOS application using the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and adds an iOS application from the itunes store. Input 
      is a PSObject created by Get-ItunesApplication.
      .EXAMPLE
      New-IntuneiOSApplication -iTunesApp $iTunesApp
      Adds an iOS application into Intune from itunes store
      .NOTES
      NAME: New-IntuneiOSApplication
  #>
	
  [cmdletbinding()]
	
  param
  (
    [Parameter(
      ValueFromPipeLine = $true,
      Position = 0,
      Mandatory = $True
    )]
    [PSObject[]]
    $iTunesApp
  )
  Begin
  {
    $Result = @()
  }
  Process
  { 
    Foreach ($App in $iTunesApp)
    { 
      try 
      {
        Write-Verbose -Message $App
								
        # Step 1 - Downloading the icon for the application
        $iconUrl = $App.artworkUrl60
	
        if ($iconUrl -eq $null) 
        {
          Write-Verbose -Object '60x60 icon not found, using 100x100 icon'
          $iconUrl = $App.artworkUrl100
        }
					
        if ($iconUrl -eq $null) 
        {
          Write-Verbose -Object '60x60 icon not found, using 512x512 icon'
          $iconUrl = $App.artworkUrl512
        }
	
        $iconResponse = Invoke-WebRequest -Uri $iconUrl
        $base64icon = [System.Convert]::ToBase64String($iconResponse.Content)
        $iconType = $iconResponse.Headers['Content-Type']
	
        if (($App.minimumOsVersion.Split('.')).Count -gt 2) 
        {
          $Split = $App.minimumOsVersion.Split('.')
	
          $MOV = $Split[0] + '.' + $Split[1]
	
          [Double]$osVersion = $MOV
        }
	
        else 
        {
          [Double]$osVersion = $App.minimumOsVersion
        }
	
        # Setting support Operating System Devices
        if ($App.supportedDevices -match 'iPadMini') 
        {
          $iPad = $True
        }
        else 
        {
          $iPad = $false
        }
        if ($App.supportedDevices -match 'iPhone6') 
        {
          $iPhone = $True
        }
        else 
        {
          $iPhone = $false
        }
	
        # Step 2 - Create the Object of the application
        $description = $App.description -replace '[^\x00-\x7F]+', ''
	
        $Result  += New-Object -TypeName PSObject -Property @{
          '@odata.type'                   = '#microsoft.graph.iosStoreApp'
          displayName                     = $App.trackName
          publisher                       = $App.artistName
          description                     = $description
          largeIcon  = New-Object -TypeName PSObject -Property @{
            type  = $iconType
            value = $base64icon
          }
          isFeatured                      = $false
          appStoreUrl                     = $App.trackViewUrl
          applicableDeviceType = New-Object -TypeName PSObject -Property @{
            iPad          = $iPad
            iPhoneAndIPod = $iPhone
          }
          minimumSupportedOperatingSystem = New-Object -TypeName PSObject -Property @{
            v8_0  = $osVersion -lt 9.0
            v9_0  = $osVersion -eq 9.0
            v10_0 = $osVersion -gt 9.0
          }
        }
      }
			
      catch 
      {
        $ex = $_.Exception
        Write-Host -Object "Request to $uri failed with HTTP Status $([int]$ex.Response.StatusCode) $($ex.Response.StatusDescription)" -ForegroundColor Red
	
        $errorResponse = $ex.Response.GetResponseStream()
			
        $ex.Response.GetResponseStream()
	
        $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList ($errorResponse)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd()
        Write-Host -Object "Response content:`n$responseBody" -ForegroundColor Red
        Write-Error -Message "Request to $uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
			
        break
      }
    }
  }
  End
  { 
    Return $Result
  }
}
