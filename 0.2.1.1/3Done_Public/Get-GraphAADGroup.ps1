
<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>
Function Get-GraphAADGroup 
{
  <#
      .SYNOPSIS
      This function is used to get AAD Groups from the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and gets any Groups registered with AAD
      .EXAMPLE
      Get-GraphAADGroup -All
      Returns all groups registered with Azure AD
      .EXAMPLE
      Get-GraphAADGroup -GroupName NameOfGroup
      Searches for and retrieves any Azure AD group by name of NameOfGroup
      .EXAMPLE
      Get-GraphAADGroup NameOfGroup
      Searches for and retrieves any Azure AD group by name of NameOfGroup
      .EXAMPLE
      Get-GraphAADGroup -Id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
      Searches for and retrieves Azure AD group with this object id
      .EXAMPLE
      Get-GraphAADGroup -Id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -Members
      Returns the members of a group
      .EXAMPLE
      Get-GraphAADGroup -GroupName NameOfGroup -Members
      Returns the members of a group
      .NOTES
      NAME: Get-AADGroup
  #>
	
  [cmdletbinding(
      DefaultParameterSetName = 'By_Name'
  )]
	
  param
  (
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Enter a groupname to search for.',
        ParameterSetName = 'By_Name',
        Position = 0
    )]
    [String]
    $GroupName,

    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Enter object id of a group to retrieve.',
        ParameterSetName = 'By_Id'
    )]
    [Guid]
    $Id,

    [Parameter(
        ParameterSetName = 'By_Name'
    )]
    [Parameter(
        ParameterSetName = 'By_Id'
    )]
    [switch]
    $Members,

    [Parameter(
        ParameterSetName = 'All'
    )]
    [Switch]$All
  )
	
  # Defining Variables
  $graphApiVersion = 'v1.0'
  $Entity = 'groups'

  If ($PSCmdlet.ParameterSetName -eq 'By_Name')
  {
    $Resource = "{0}?`$filter=displayname eq '{1}'" -F $Entity, $GroupName
    $local:Group = Invoke-GraphAPI -graphApiVersion $graphApiVersion -Resource $Resource
    If (-not ($local:Group))
    {
      Throw [Management.Automation.ItemNotFoundException] "No Azure AD group by name '$GroupName' has been found."
      Break
    }
    [Guid]$Id = $local:Group.Id
  }
  ElseIf ($PSCmdlet.ParameterSetName -eq 'By_Id')
  {
    $Resource = "{0}?`$filter=id eq '{1}'" -F $Entity, $Id.Guid
  }
  ElseIf ($PSCmdlet.ParameterSetName -eq 'All')
  {
    $Resource = $Entity
  }
  

  If ($Members)
  {
    $Resource = "{0}/{1}/members" -F $Entity, $Id.Guid
  }
  ElseIf ($Local:Group)
  {
    Return $Local:Group
  }

  Invoke-GraphAPI -graphApiVersion $graphApiVersion -Resource $Resource
}
