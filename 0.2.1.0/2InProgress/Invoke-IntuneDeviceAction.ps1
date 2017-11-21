Function Invoke-IntuneDeviceAction {
	
	<#
		.SYNOPSIS
		This function is used to invoke actions against Intune devices from the Graph API REST interface
		.DESCRIPTION
		The function connects to the Graph API Interface and sets a generic Intune Resource
		Based on code from Jan Egil Ring (Crayon), originally created based on examples from 
		https://github.com/microsoftgraph/powershell-intune-samples 
		.EXAMPLE
		Invoke-IntuneDeviceAction -DeviceID $DeviceID -remoteLock
		Resets a managed device passcode
		.NOTES
		NAME: Invoke-IntuneDeviceAction
	#>

	[cmdletbinding()]
	param
	(
		[Parameter(Mandatory = $true, HelpMessage = "DeviceId (guid) for the Device you want to take action on must be specified:", ValueFromPipelineByPropertyName=$true)]
		$DeviceID,

		[Parameter(Mandatory = $true, HelpMessage = "Action for the device you want to take action on must be specified:")]
		[ValidateSet("RemoteLock", "ResetPassword", "RemoveCompanyData","FactoryReset","RebootNow")]
		$Action
	)
	
	try {
		# Setting correct $Resource based in $Action input ()
		if($Action -eq "RemoveCompanyData") {
			$Resource = "managedDevices/$DeviceID/retire"
		}
		elseif ($Action -eq "FactoryReset") {
			$Resource = "managedDevices/$DeviceID/wipe"
		}
		elseif ($Action -eq "ResetPassword") {
			$Resource = "managedDevices/$DeviceID/resetPasscode"
		}
		else{
			$Resource = "managedDevices/$DeviceID/$Action"
		}

		# Invoking device action to Intune with GraphAPI
		Invoke-GraphAPI -Method Post -ErrorAction Stop 
		$verbosemessage = "Sending $Action command to device $DeviceID"
		Write-Verbose = $verbosemessage
	}

	catch {
		throw  $_.Exception.Message
	}

}