<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>


Function Add-DeviceCompliancePolicy
{
  <#
      .SYNOPSIS
      This function is used to add a device compliance policy using the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and adds a device compliance policy
      .INPUTS
      Device Compliancy objects. You can pipe device compliancy objects to Add-DeviceCompliancePolicy
      .OUTPUTS
      JSON. The registered compliance policies are returned as JSON
      .EXAMPLE
      Add-DeviceCompliancePolicy -DeviceCompliancePolicy $DeviceCompliancePolicy
      Adds a device compliance policy in Intune. Use New-DeviceCompliancePolicy to create a new
      compliance policy object
      .EXAMPLE
      Add-DeviceCompliancePolicy -DeviceCompliancePolicy $DeviceCompliancePolicy -DeviceNonComplianceAction $DeviceNonComplianceAction
      Adds a device compliance policy in Intune with a custom non-compliance action. Use New-DeviceCompliancePolicy to create a new
      compliance policy object and New-DeviceNonComplianceAction to create a custom non-compliance action
      .NOTES
      NAME: Add-DeviceCompliancePolicy
      .LINK
      New-DeviceCompliancePolicy
      New-DeviceNonComplianceAction
  #>
	
  [cmdletbinding()]
	
  param
  (
			
    [Parameter(
        Mandatory = $True,
        HelpMessage = 'Pass a new device compliance object to this function',
        ValueFromPipeLine = $True,
        Position =0
    )]
    [PSObject[]]
    $DeviceCompliancePolicy,
    
    [PSObject]
    $DeviceNonComplianceAction = $(New-DeviceNonComplianceAction)
  )
	
  Begin
  { 
    $Method = 'POST'
    $Resource = 'deviceManagement/deviceCompliancePolicies'
    Write-Verbose ('{0}: Base resource "{1}"' -F $MyInvocation.MyCommand.Name, $Resource)	          
  }	
  Process
  {
    Write-Verbose ('{0}: Adding non compliancerule "{1}" to compliancepolicy {2}' -F 
      $MyInvocation.MyCommand.Name, 
      $DeviceNonComplianceAction.ruleName,
      $DeviceCompliancePolicy.displayName
    )
           
    Add-Member -InputObject $DeviceCompliancePolicy -MemberType NoteProperty -Name 'scheduledActionsForRule' -Value $DeviceNonComplianceAction
    
    $JSON = ConvertTo-Json -InputObject $DeviceCompliancePolicy
    
    Write-Verbose ('{0}: Invoking API with resource "{1}" method {2}' -F $MyInvocation.MyCommand.Name, $Resource, $Method)	  
        
    Invoke-GraphAPI -Resource $Resource -Method $Method -Body $JSON
  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name) 
  }
 
}
