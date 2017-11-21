<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Add-DeviceCompliancePolicyAssignment
{
  <#
      .SYNOPSIS
      This function is used to add a device compliance policy assignment using the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and adds a device compliance policy assignment
      .EXAMPLE
      Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CompliancePolicyId -TargetGroupId $TargetGroupId
      Adds a device compliance policy assignment in Intune
      .NOTES
      NAME: Add-DeviceCompliancePolicyAssignment
  #>
	
  [cmdletbinding()]
	
  param
  (
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Enter the object id of the application to be assigned.'
    )]
    [Guid]
    $CompliancePolicyId,
    
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Enter the object id of the target group of the assignment.'
    )]
    [Guid[]]    
    $TargetGroupId
  )
	
  $Method = 'POST'
  $Entity = 'deviceManagement/deviceCompliancePolicies/{0}/assign'
  Write-Verbose -Message ('{0}: Base entity "{1}", method {2}' -F $MyInvocation.MyCommand.Name, $Entity, $Method)
    
  Foreach ($PolicyId in $CompliancePolicyId.Guid)
  { 
  
    $Resource = $Entity -F $PolicyId
    Write-Verbose -Message ('{0}: Base entity "{1}", method {2}' -F $MyInvocation.MyCommand.Name, $Resource, $Method)
  
    $GroupAssignment = @()       
    Foreach ($GroupId in $TargetGroupId.Guid)
    {
      Write-Verbose -Message ('{0}: Creating group assignment for "{1}"' -F $MyInvocation.MyCommand.Name, $GroupId)	
      $ComPolAssign = '{0}_{1}' -F $CompliancePolicyId.Guid, $GroupId
  
      $GroupAssignment += New-Object -TypeName PSObject -Property @{
        '@odata.type' = '#microsoft.graph.deviceCompliancePolicyGroupAssignment'
        'id'          = $ComPolAssign
        'targetGroupId' = $GroupId
      }
    }

    Write-Verbose -Message ('{0}: Converting group assignments to JSON' -F $MyInvocation.MyCommand.Name)	
  
    $Assignment += New-Object -TypeName PSObject -Property @{
      'deviceCompliancePolicyGroupAssignments' = $GroupAssignment
    }
    $JSON = ConvertTo-Json -InputObject $Assignment
  
    Write-Verbose -Message ('{0}: Invoking API with resource "{1}"' -F $MyInvocation.MyCommand.Name, $Resource)	    
  
    Invoke-GraphAPI -Resource $Resource -Method $Method -Body $JSON
  }
  
  Write-Verbose -Message ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
}
