<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function New-DeviceNonComplianceAction
{
  <#
      .SYNOPSIS
      This function is used to create a new Andoroid app definition as a PSObject 
      .DESCRIPTION
      The function creates a new Android app definition object. 
      .EXAMPLE
      New-DeviceNonComplianceAction -DisplayName $DisplayName -Publisher $Publisher -AppstoreUrl $AppStoreUrl -MinimumOsVersion $MinimumOsVersion -IconUrl $IconUrl
      Adds an iOS application into Intune from itunes store
      .NOTES
      NAME = New-DeviceNonComplianceAction
  #>
	
  [cmdletbinding()]
	
  param
  (
    [String]
    $RuleName = 'PasswordReguired',
    
    [String]
    $ActionType = 'block',
    
    [int]
    $GracePeriodHours = 0,
    
    [Guid]
    $NotificationTemplateId = '00000000-0000-0000-0000-000000000000'

  )

  Write-Verbose ('{0}: Creating PSObject for NonCompliance Action, rule name "{1}"' -F $MyInvocation.MyCommand.Name, $RuleName)
  
  New-Object -TypeName PSObject -Property @{
    ruleName = $RuleName
    scheduledActionConfigurations = New-Object -TypeName PSObject -Property @{
      actionType = $ActionType
      gracePeriodHours = $GracePeriodHours
      notificationTemplateId = $NotificationTemplateId
    }
  }
}