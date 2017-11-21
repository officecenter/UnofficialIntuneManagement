<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>


Function Get-itunesApplication() 
{
  <#
      .SYNOPSIS
      This function is used to get an iOS application from the itunes store using the Apple REST API interface
      .DESCRIPTION
      The function connects to the Apple REST API Interface and returns applications from the itunes store
      .EXAMPLE
      Get-itunesApplication -SearchString "Microsoft Corporation"
      Gets an iOS application from itunes store
      .EXAMPLE
      Get-itunesApplication -SearchString "Microsoft Corporation" -Limit 10
      Gets an iOS application from itunes store with a limit of 10 results
      .NOTES
      NAME: Get-itunesApplication
      https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/
  #>
	
  [cmdletbinding()]
	
  param
  (
    [Parameter(ParameterSetName = 'By_Developer', Mandatory = $true)]
    [String]
    $Developer,

    [Parameter(ParameterSetName = 'By_ID', Mandatory = $true)]
    [String[]]
    $Id,

    [Parameter(ParameterSetName = 'By_Name', Mandatory = $true)]
    [String]
    $Name,

    [Parameter(ParameterSetName = 'By_BundleId', Mandatory = $true)]
    [String[]]
    $BundleId,

    [String]
    $Country = 'no',
    
    [int]
    $Limit = 200
  )
	
  try 
  {
    Write-Verbose -Message $Developer
	
    # Testing if string contains a space and replacing it with a +
    $Developer = $Developer.replace(' ', '+')
	
    Write-Verbose -Message "SearchString variable converted if there is a space in the name $Developer"

    If ($PSCmdlet.ParameterSetName -eq 'By_Developer')
    {
      $iTunesUrl = "https://itunes.apple.com/search?entity=software&term={0}&attribute=softwareDeveloper&country={1}&limit={2}" -F $Developer, $Country, $Limit
    }
    elseIf ($PSCmdlet.ParameterSetName -eq 'By_Name')
    {
      $iTunesUrl = "https://itunes.apple.com/search?entity=software&term={0}&country={1}&limit={2}" -f $Name, $Country, $Limit
    }
    elseIf ($PSCmdlet.ParameterSetName -eq 'By_BundleId')
    {
      $iTunesUrl = "https://itunes.apple.com/lookup?bundleId={0}&country={1}" -f $($BundleId -join ','), $Country
    }	
    else
    {
      $iTunesUrl = "https://itunes.apple.com/lookup?id={0}&entity=software&limit={1}" -f $($Id -join ','), $Limit
    }	

	
    Write-Verbose -Message $iTunesUrl
    $apps = Invoke-RestMethod -Uri $iTunesUrl -Method Get
	
    # Putting sleep in so that no more than 20 API calls to itunes REST API
    # https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/
    Start-Sleep -Seconds 3
	
    return $apps.results
  }
	
  catch 
  {
    Write-Host -Object $_.Exception.Message -ForegroundColor Red
    Write-Host -Object $_.Exception.ItemName -ForegroundColor Red
    Write-Verbose -Message $_.Exception
			
    break
  }
}

