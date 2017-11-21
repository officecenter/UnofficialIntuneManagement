<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-IntuneAppCategory 
{
	
  <#
      .SYNOPSIS
      This function is used to get application categories from the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and gets any application category
      .INPUTS
      Array of strings to search for
      .OUTPUTS
      JSON. The function returns application categories formatted as JSON
      .EXAMPLE
      Get-ApplicationCategory
      Returns any application categories configured in Intune
      .EXAMPLE
      Get-IntuneAppCategory -DisplayName Business, productivity
      Returns any application categories configured in Intune by the names provided
      .EXAMPLE
      'Business', 'productivity' | Get-IntuneAppCategory
      Returns any application categories configured in Intune by the names provided
      .NOTES
      NAME: Get-IntuneAppCategory
  #>
	
  [cmdletbinding()]
	
  param
  (
    [Parameter(
        ValueFromPipeLine = $true,
        Position = 0,
        ValueFromPipelinebyPropertyName = $true
    )]
    [String[]]
    $DisplayName
  )
	  
  Begin
  {
    $Method = 'GET'
    $Entity = "deviceAppManagement/mobileAppCategories"
    Write-Verbose ('{0}: Base entity "{1}", method {2}' -F $MyInvocation.MyCommand.Name, $Entity, $Method)	          
  }
	
  Process
  { 
	  
    $Categories = Invoke-GraphAPI -Resource $Entity -Method $Method
    
    If ($DisplayName)
    {
      $Categories | Where-Object {$_.displayName -in $DisplayName}
    }
    Else
    {
      $Categories
    }
  }
  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  } 

	
  }
	