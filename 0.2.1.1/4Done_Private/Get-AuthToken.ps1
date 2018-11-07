<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

function Get-AuthToken 
{
  <#
      .SYNOPSIS
      This function is used to authenticate with the Graph API REST interface
      .DESCRIPTION
      The function authenticate with the Graph API Interface with the tenant name
      .EXAMPLE
      Get-AuthToken
      Authenticates you with the Graph API interface
      .NOTES
      NAME: Get-AuthToken
  #>
	
  [cmdletbinding()]
	
  param
  (
    [PSCredential]
    $Credentials = $global:GraphCredentials
  )
  
  # Checking if credentials are passed through pipeline
  If (-not ($Credentials))
  {
    $Credentials = Get-Credential -Message 'Enter Intune Graph API Credentials'
  }	

  # Checking if AuthToken already exists
  If ($AuthToken)
  {
    If ($AuthToken.ExpiresOn -gt (Get-Date))
    {
      return $AuthToken
    }
  }

  $userUpn = New-Object -TypeName 'System.Net.Mail.MailAddress' -ArgumentList $Credentials.UserName
	
  $tenant = $userUpn.Host
	$verbosemessage = "Checking for AzureAD module."
  Write-Verbose $verbosemessage
	
  $AadModule = Get-Module -Name 'AzureAD' -ListAvailable
	
  if ($AadModule -eq $null) 
  {
    $warningmessage = 'AzureAD PowerShell module not found, looking for AzureADPreview'
    Write-Warning -Message $warningmessage
    $AadModule = Get-Module -Name 'AzureADPreview' -ListAvailable
  }
	
  if ($AadModule -eq $null) 
  {
    $errormessage = "AzureAD Powershell module not installed. Install by running 'Install-Module AzureAD' from an elevated PowerShell prompt. Script can not continue."
		Write-Error -Message $errormessage
    exit
  }
	
  # Getting path to ActiveDirectory Assemblies
  # If the module count is greater than 1 find the latest version
	
  if($AadModule.count -gt 1)
  {
    $Latest_Version = ($AadModule |
      Select-Object -Property version |
    Sort-Object)[-1]
	
    $AadModule = $AadModule | Where-Object -FilterScript {
      $_.version -eq $Latest_Version.version 
    }
	
    # Checking if there are multiple versions of the same module found
	
    if($AadModule.count -gt 1)
    {
      $AadModule = $AadModule | Select-Object -Unique
    }
	
    $adal = Join-Path -Path $AadModule.ModuleBase -ChildPath 'Microsoft.IdentityModel.Clients.ActiveDirectory.dll'
    $adalforms = Join-Path -Path $AadModule.ModuleBase -ChildPath 'Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll'
  }
	
  else 
  {
    $adal = Join-Path -Path $AadModule.ModuleBase -ChildPath 'Microsoft.IdentityModel.Clients.ActiveDirectory.dll'
    $adalforms = Join-Path -Path $AadModule.ModuleBase -ChildPath 'Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll'
  }
	
  $null = [System.Reflection.Assembly]::LoadFrom($adal)
	
  $null = [System.Reflection.Assembly]::LoadFrom($adalforms)
	
  # InTune Graph API Client ID
  $clientId = 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547'
	
	
  $resourceAppIdURI = 'https://graph.microsoft.com'
	
  $authority = "https://login.microsoftonline.com/$tenant"
	
  try 
  {
    $authContext = New-Object -TypeName 'Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext' -ArgumentList $authority
	
    # https://msdn.microsoft.com/en-us/library/azure/microsoft.identitymodel.clients.activedirectory.promptbehavior.aspx
    # Change the prompt behaviour to force credentials each time: Auto, Always, Never, RefreshSession

    $platformParameters = New-Object -TypeName 'Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters' -ArgumentList 'Auto'

             
    $userCredentials = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.UserPasswordCredential -ArgumentList $Credentials.Username, $Credentials.Password
      
    $authResult = [Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContextIntegratedAuthExtensions]::AcquireTokenAsync($authContext, $resourceAppIdURI, $clientId, $userCredentials)

    If ($authResult.Exception.InnerException.ErrorCode -eq 'interaction_required')
    {
      $redirectUri = 'urn:ietf:wg:oauth:2.0:oob'

      $userId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($Credentials.Username, "OptionalDisplayableId")

      $authResult = $authContext.AcquireTokenAsync($resourceAppIdURI,$clientId,$redirectUri,$platformParameters,$userId)      
    }
    ElseIf ($authResult.Exception.InnerException)
    {
      Throw $authResult.Exception.InnerException
    }
    # If the accesstoken is valid then create the authentication header
	
    if($authResult.Result.AccessToken)
    {
      # Creating header for Authorization token
	
      $global:AuthToken = @{
        'Content-Type' = 'application/json'
        'Authorization' = 'Bearer ' + $authResult.Result.AccessToken
      }
      
      $verbosemessage =  'Returns $global:AuthToken for user ' + $Credentials.UserName.ToString()
      Write-Verbose -Message $verbosemessage
      $global:GraphCredentials = $Credentials	
      return $global:AuthToken
    }
	
    else 
    {
      Write-Error -Message "Authorization Access Token is null, please re-run authentication."
      break
    }
  }
	
  catch 
  {
    Write-Error -Exception $_.Exception.Message
    Write-Error -Exception $_.Exception.ItemName
			
    break
  }
}