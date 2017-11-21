
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Invoke-GraphAPI
{
  <#
      .SYNOPSIS
      This function is used to GET or POST to the graph API and capture any exceptions
      .DESCRIPTION
      The function connects to the Graph API Interface and tries to complete an action passed as an argument.
      The function is meant to be called by the wrapper functions in this module.
      .EXAMPLE
      $Resource = "SomeIntuneResource"
      Invoke-GraphAPI
      Invokes the content of variable $Resource with method GET to Microsoft Graph API
      .EXAMPLE
      Invoke-GraphAPI -Resource groups
      Returns all groups registered with Azure AD
      .EXAMPLE
      Invoke-GraphAPI -Resource 'deviceAppManagement/mobileAppCategories' -Method POST -Body $JSON
      Adds a new application category defined as json in $JSON
      .EXAMPLE
      Invoke-GraphAPI -Resource 'deviceAppManagement/mobileAppCategories/<object id>' -Method DELETE
      Deletes the application category with the object id of <object id>
      .NOTES
      NAME: Invoke-GraphAPI
  #>

  [cmdletbinding(DefaultParameterSetName = 'GET')]

  param
  (
    [ValidateSet('v1.0','beta')]
    [String]
    $graphApiVersion = 'beta',

    [Parameter(ParameterSetName = 'BODY', Position = 0, Mandatory = $false)]
    [Parameter(ParameterSetName = 'GET', Position = 0, Mandatory = $false)]
    [String]
    $Resource=$Resource,

    [Parameter(ParameterSetName = 'BODY', Mandatory = $true)]
    [String]
    $Body,

    [Parameter(ParameterSetName = 'BODY', Mandatory = $true)]
    [Parameter(ParameterSetName = 'GET')]    
    [ValidateSet('GET','POST','PATCH','DELETE')]
    [String]
    $Method = 'GET'


  )

  If ($PSCmdlet.ParameterSetName -eq 'GET')
  {
    $Method = 'GET'
  }

  try 
  {
    $authToken = Get-AuthToken
    
    $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource"

    Write-Verbose ('{0}: Invoking API with URI "{1}"' -F $MyInvocation.MyCommand.Name, $uri)	  

    If ($PSCmdlet.ParameterSetName -eq 'BODY')
    {
      $Result = Invoke-RestMethod -Uri $uri -Headers $authToken -Method $Method -Body $Body -ContentType 'application/json'
    }
    Else
    {
      $Result = Invoke-RestMethod -Uri $uri -Headers $authToken -Method $Method
    }
  }

  catch 
  {
    Throw $_
    
    break
  }

  If ($Result.Result)
  {
    Return $Result.Result
  }
  ElseIf ($Result.Value)
  {
    Return $Result.Value
  }
  Else
  {
    Return $Result
  }
}
