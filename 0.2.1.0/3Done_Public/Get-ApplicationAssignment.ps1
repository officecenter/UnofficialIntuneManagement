<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-ApplicationAssignment
{
  <#
      .SYNOPSIS
      This function is used to get an application assignment from the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and gets an application assignment
      .EXAMPLE
      Get-ApplicationAssignment -ApplicationId $Application.id
      Returns an Application Assignment configured in Intune for the application Id specified
      .NOTES
      NAME: Get-ApplicationAssignment
  #>

  [cmdletbinding()]

  param
  (
    [Parameter(ParameterSetName = 'By_ID', Mandatory = $true)]
    [Guid]
    $ApplicationId,
    [Parameter(ParameterSetName = 'By_Name', Mandatory = $true)]
    [String]
    $ApplicationName,

    [ValidateSet('*','androidStoreApp','iosStoreApp','windowsMobileMSI','windowsStoreForBusinessApp','officeSuiteApp','webApp')]
    [String]
    $Platform = '*'
  )

  If ($PSCmdlet.ParameterSetName -eq 'By_Name')
  {
    $Application = @()
    $Application = Get-IntuneApplication -Name $ApplicationName -Platform $Platform
    If ($Application.Count -gt 1)
    {
      $Application | Select-Object DisplayName, '@odata.type'
      Write-Error "Ambiguous Application name. Name returned more than 1 application."
      Return
    }
    ElseIf ($Application)
    {
      [Guid]$ApplicationId = $Application.Id
    }
    Else
    {
      Write-Error ("No Intune application by the name '{0} was found." -F $ApplicationName)
      Return
    }
  }

  $Resource = "deviceAppManagement/mobileApps/$($ApplicationId.Guid)/groupAssignments"

  Invoke-GraphAPI -Resource $Resource
}
