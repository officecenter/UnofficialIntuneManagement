<# 
This file is the root module of UnofficialIntuneManagement, put together by Hugo Klemmestad and Kristoffer Ryeng at Office Center Hønefoss AS. 

Many functions are based on the Intunes PowerShell Samples written by Dave Falkus (Microsoft), found at https://github.com/microsoftgraph/powershell-intune-samples, those are still licenced with Microsoft's MIT Licence.
#>

[CmdletBinding()]

$Functions = @(Get-ChildItem -Path $PSScriptRoot\*\*.ps1 -ErrorAction SilentlyContinue) # Public functions can be called by user after module import

#$PublicFunction  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue ) # Public functions can be called by user after module import
#$PrivateFunction = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue ) # Private functions can only be called internally in other functions in the module 
#$Functions = @($PublicFunction + $PrivateFunction)

foreach ($Import in $Functions)
{
    Write-Verbose "Importing $Import"
    try
    {
        . $Import.fullname
    }
    catch
    {
        throw "Could not import function $($Import.fullname): $_"
    }
}

Export-ModuleMember -Function $Functions.Basename # During development will all functions be exported. 
#Export-ModuleMember -Function $PublicFunction.Basename # Only public functions will be exported.
