<#

.COPYRIGHT
Copyright (c) Office Center HØnefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>


Function Get-GraphAADUser
{
  <#
      .SYNOPSIS
      This function is used to get AAD Users from the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and gets any users registered with AAD
      .EXAMPLE
      Get-AADUser
      Returns all users registered with Azure AD
      .EXAMPLE
      Get-AADUser -userPrincipleName user@domain.com
      Returns specific user by UserPrincipalName registered with Azure AD
      .NOTES
      NAME: Get-GraphAADUser
  #>
	
  [cmdletbinding()]
	
  param
  (
    [String]
    $UserPrincipalName,

    [String]
    $Property
  )
	  
  Begin
  {

    # Defining Variables
    $graphApiVersion = 'v1.0'
    $Resource = 'users'
  }
  Process
  {

    
	
    If ($UserPrincipalName)
    {
      $Resource = '{0}/{1}' -F $Resource, $UserPrincipalName
    }
	
    If (($UserPrincipalName) -and ($Property))
    {
      $Resource = '{0}/{1}' -F $Resource, $Property
    }

    Write-Verbose ('{0}: Invoking API with resource "{1}"' -F $MyInvocation.MyCommand.Name, $Resource)	  

    Invoke-GraphAPI -graphApiVersion $graphApiVersion -Resource $Resource
  }

  End
  {}
}
