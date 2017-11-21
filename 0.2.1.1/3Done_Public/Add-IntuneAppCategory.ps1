<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>


Function Add-IntuneAppCategory 
{
  <#
      .SYNOPSIS
      This function is used to add an application category using the Graph API REST interface
      .DESCRIPTION
      The function connects to the Graph API Interface and adds a application category
      .EXAMPLE
      Add-IntuneAppCategory -AppCategoryName $AppCategoryName
      Adds an application category in Intune
      .NOTES
      NAME: Add-IntuneAppCategory
  #>
	
  [cmdletbinding()]
	
  param
  (
    [Parameter(
        Mandatory = $True,
        HelpMessage = 'Enter a name for the new Intune application category.',
        ValueFromPipeline = $true,
        Position = 0
    )]
    [String[]]
    $AppCategoryName
  )
  Begin
  { 
    $Resource = 'deviceAppManagement/mobileAppCategories'
    Write-Verbose ('{0}: Base resource "{1}"' -F $MyInvocation.MyCommand.Name, $Resource)	      
  }
  Process
  {
    Foreach ($Category in $AppCategoryName)
    {

      Write-Verbose ('{0}: Creating PSObject for application category name "{1}"' -F $MyInvocation.MyCommand.Name, $Category)

      $Body = New-Object -TypeName PSObject -Property @{
        "@odata.type" = "#microsoft.graph.mobileAppCategory"
        "displayName" = "$Category"
      }
  
      $JSON = $Body | ConvertTo-Json

      Write-Verbose ('{0}: Invoking API with resource "{1}"' -F $MyInvocation.MyCommand.Name, $Resource)	  

      Invoke-GraphAPI -Resource $Resource -Method POST -Body $JSON
    }
  }
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }

}
