<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>
  
Function Get-DeviceCompliancePolicy 
{
	
  <#
      .SYNOPSIS
      This function is used to get device compliance policies from the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and gets any device compliance policies
      .EXAMPLE
      Get-DeviceCompliancePolicy
      Returns any device compliance policies configured in Intune
      .EXAMPLE
      Get-DeviceCompliancePolicy -Android
      Returns any device compliance policies for Android configured in Intune
      .EXAMPLE
      Get-DeviceCompliancePolicy -iOS
      Returns any device compliance policies for iOS configured in Intune
      .NOTES
      NAME: Get-DeviceCompliancePolicy
  #>
	
  [cmdletbinding()]
	
  param
  (
    [Parameter(Position = 0)]    
    [String]
    $DisplayName,
    
    [ValidateSet('macOS','Windows10','Android','iOS')]
    [String]
    $Platform = '*'
  )
	
  $Method = 'GET'
  $Entity = "deviceManagement/deviceCompliancePolicies"
  Write-Verbose -Message ('{0}: Base entity "{1}", method {2}' -F $MyInvocation.MyCommand.Name, $Entity, $Method)
  	
 
  
  If ($DisplayName)
  {
    $Resource = "{0}?`$filter=displayName eq '{1}' and " -F $DisplayName
  }
  Else 
  {
    $Resource = $Entity
  }
  
  Write-Verbose ('{0}: Invoking API with resource "{1}"' -F $MyInvocation.MyCommand.Name, $Resource)	  
  
  Invoke-GraphAPI -Resource $Resource -Method $Method | Where-Object {$_.'@odata.type' -like "*$Platform*"}
}