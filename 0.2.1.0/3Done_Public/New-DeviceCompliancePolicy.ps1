<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function New-DeviceCompliancePolicy
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
      NAME = New-DeviceCompliancePolicy
  #>
	
  [cmdletbinding(DefaultParameterSetName = 'Windows10')]
	
  param
  (
    [Parameter(ParameterSetName = 'macOS')]
    [Switch]
    $macOS,
    
    [Parameter(ParameterSetName = 'windows10')]
    [Switch]
    $Windows10,

    [Parameter(ParameterSetName = 'Android')]
    [Switch]
    $Android,
    
    [Parameter(ParameterSetName = 'iOS')]
    [Switch]
    $iOS,
    
    [Parameter(
        Mandatory = $true,
        HelpMessage="Enter the name of the compliance policy",
        Position = 0,
        ParameterSetName = 'macOS'
    )]    
    [Parameter(
        Mandatory = $true,
        HelpMessage="Enter the name of the compliance policy",
        Position = 0,
        ParameterSetName = 'windows10'
    )]    
    [Parameter(
        Mandatory = $true,
        HelpMessage="Enter the name of the compliance policy",
        Position = 0,
        ParameterSetName = 'Android'
    )]    
    [Parameter(
        Mandatory = $true,
        HelpMessage="Enter the name of the compliance policy",
        Position = 0,
        ParameterSetName = 'iOS'
    )]
    [String]
    $displayName,

    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Parameter(ParameterSetName = 'iOS')]
    [String]
    $description = $DisplayName,
    
    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Parameter(ParameterSetName = 'iOS')]
    [int]
    $version = 1,

    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Parameter(ParameterSetName = 'iOS')]
    [String]
    $lastModifiedDateTime = $(Get-Date -Format O),
    
    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $passwordRequired,

    [Parameter(ParameterSetName = 'iOS')]
    [Boolean]
    $passcodeRequired,
    
    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Boolean]
    $passwordBlockSimple= $true,
    
    [Parameter(ParameterSetName = 'iOS')]
    [Boolean]
    $passcodeBlockSimple= $true,
    
    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [ValidateRange(1,255)]
    [Int]
    $passwordExpirationDays,
    
    [Parameter(ParameterSetName = 'iOS')]
    [ValidateRange(1,255)]
    [Int]
    $passcodeExpirationDays,

    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [ValidateRange(4,16)]
    [Int]
    $passwordMinimumLength = 6,

    [Parameter(ParameterSetName = 'iOS')]
    [ValidateRange(4,16)]
    [Int]
    $passcodeMinimumLength = 6,
    
    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Int]
    $passwordMinutesOfInactivityBeforeLock,
    
    [Parameter(ParameterSetName = 'iOS')]
    [Int]
    $passcodeMinutesOfInactivityBeforeLock,
    
    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Int]
    $passwordPreviousPasswordBlockCount = 5,

    [Parameter(ParameterSetName = 'iOS')]
    [Int]
    $passcodePreviousPasswordBlockCount = 5,
        
    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [ValidateSet('deviceDefault','alphanumeric','numeric')]
    [String]
    $passwordRequiredType = 'deviceDefault',

    [Parameter(ParameterSetName = 'iOS')]
    [ValidateSet('','alphanumeric','numeric')]
    [String]
    $passcodeRequiredType = 'deviceDefault',
      
    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Int]
    $passwordMinimumCharacterSetCount,

    [Parameter(ParameterSetName = 'iOS')]
    [Int]
    $passcodeMinimumCharacterSetCount,
        
    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Parameter(ParameterSetName = 'iOS')]
    [String]
    $osMinimumVersion,
    
    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Parameter(ParameterSetName = 'iOS')]
    [String]
    $osMaximumVersion,

    [Parameter(ParameterSetName = 'macOS')]
    [Boolean]
    $systemIntegrityProtectionEnabled,

    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Parameter(ParameterSetName = 'iOS')]
    [Boolean]
    $deviceThreatProtectionEnabled,

    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Parameter(ParameterSetName = 'iOS')] 
    [ValidateSet('notset','unavailable','Secured','Low','Medium','High')]
    [String]
    $deviceThreatProtectionRequiredSecurityLevel = 'notset',       

    [Parameter(ParameterSetName = 'macOS')]
    [Parameter(ParameterSetName = 'windows10')]
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $storageRequireEncryption,
    
    [Parameter(ParameterSetName = 'Android')]
    [Parameter(ParameterSetName = 'iOS')]
    [Boolean]
    $securityBlockJailbrokenDevices,    
 
    [Parameter(ParameterSetName = 'iOS')]
    [Boolean]
    $managedEmailProfileRequired,    
    
    [Parameter(ParameterSetName = 'windows10')]
    [Boolean]
    $passwordRequiredToUnlockFromIdle,    
    
    [Parameter(ParameterSetName = 'windows10')]
    [Boolean]
    $requireHealthyDeviceReport,    
    
    [Parameter(ParameterSetName = 'windows10')]
    [Int]
    $mobileOsMaximumVersion,       
    
    [Parameter(ParameterSetName = 'windows10')]
    [Int]
    $mobileOsMinimumVersion,    
    
    [Parameter(ParameterSetName = 'windows10')]
    [Boolean]
    $earlyLaunchAntiMalwareDriverEnabled,    
    
    [Parameter(ParameterSetName = 'windows10')]
    [Boolean]
    $bitLockerEnabled ,    
    
    [Parameter(ParameterSetName = 'windows10')]
    [Boolean]
    $secureBootEnabled ,    
    
    [Parameter(ParameterSetName = 'windows10')]
    [Boolean]
    $codeIntegrityEnabled ,    
    
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $securityPreventInstallAppsFromUnknownSources ,    
    
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $securityDisableUsbDebugging ,    
    
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $requireAppVerify ,    
    
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $minAndroidSecurityPatchLevel,    
    
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $requireSafetyNetAttestationBasicIntegrity,    
    
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $requireSafetyNetAttestationCertifiedDevice,    
    
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $requireGooglePlayServices,    
    
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $requireUpToDateSecurityProviders,    
    
    [Parameter(ParameterSetName = 'Android')]
    [Boolean]
    $requireCompanyPortalAppIntegrity ,    
    
    [Parameter(ParameterSetName = 'Android')]
    [String]
    $conditionStatementId
        
  )

  
  Write-Verbose ('{0}: Creating PSObject for Compliance Policy "{1}"' -F $MyInvocation.MyCommand.Name, $PSCmdlet.ParameterSetName)

  $odata = '#microsoft.graph.{0}CompliancePolicy' -F $PSCmdlet.ParameterSetName

  $Policy = New-Object -TypeName PSObject -Property @{
    "@odata.type" = $odata
  }
  
  $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters 
  Foreach ($Parameter in $ParameterList.GetEnumerator() )
  {
    If (($Parameter.Value.ParameterSets.Keys.Contains($PSCmdlet.ParameterSetName)) -and -not ($Parameter.Value.SwitchParameter))
    {
      $Property = Get-Variable -Scope Private -Name $Parameter.Key -ValueOnly
      
      If (($Property -is [Int]) -and $Property -eq 0)
      {
        Add-Member -InputObject $Policy -MemberType NoteProperty -Name $Parameter.Key  -Value $null
      }
      Else
      {
         Add-Member -InputObject $Policy -MemberType NoteProperty -Name $Parameter.Key -Value $Property
      }
    }
  }
  
  Write-Verbose ('{0}: Returning policy object' -F $MyInvocation.MyCommand.Name)
  Return $Policy
}