<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Remove-IntuneAppCategory 
{
  <#
      .SYNOPSIS
      This function is used to remove an application category from the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and removes an application category
      .EXAMPLE
      Remove-IntuneAppCategory -CategoryId $CategoryId
      Removes an application category configured in Intune
      .NOTES
      NAME: Remove-IntuneAppCategory
  #>
	
  [cmdletbinding()]
	
  param
  (
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Enter the object id of the category to be deleted.',
        ValueFromPipeline = $true,
        ParameterSetName = 'By_Id'
    )]
    [Guid[]]
    $CategoryId,
        
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Enter the object id of the category to be deleted.',
        ValueFromPipeline = $true,
        ParameterSetName = 'By_Name',
        Position = 0
    )]
    [String[]]
    $Name
  )
	
  Begin
  {
    $Entity = 'deviceAppManagement/mobileAppCategories'
    $Method = 'Delete'
    Write-Verbose ('{0}: Base entity "{1}", method {2}' -F $MyInvocation.MyCommand.Name, $Entity, $Method)	      
  }
  Process
  {
    

    Foreach ($Id in $CategoryId)
    { 
      $Resource = '{0}/{1}' -F $Entity, $Id
      
      Write-Verbose ('{0}: Invoking API with resource "{1}" with method {2}' -F $MyInvocation.MyCommand.Name, $Resource, $Method)	  
     
      Invoke-GraphAPI -Resource $Resource -Method $Method
    }
    
  }
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }  

}
	