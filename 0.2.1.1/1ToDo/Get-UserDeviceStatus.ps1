<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Get-UserDeviceStatus() {
	
		[cmdletbinding()]
	
		param
		(
			[switch]$Analyze
		)
	
		Write-Host "Getting User Devices..." -ForegroundColor Yellow
	
	
		$UserDevices = Get-AADUserDevices -UserID $UserID
	
		if ($UserDevices) {
	
			write-host "-------------------------------------------------------------------"
					
	
			foreach ($UserDevice in $UserDevices) {
	
				$UserDeviceId = $UserDevice.id
				$UserDeviceName = $UserDevice.deviceName
				$UserDeviceAADDeviceId = $UserDevice.azureActiveDirectoryDeviceId
				$UserDeviceComplianceState = $UserDevice.complianceState
	
				write-host "Device Name:" $UserDevice.deviceName -f Cyan
				Write-Host "Device Id:" $UserDevice.id
				write-host "Owner Type:" $UserDevice.ownerType
				write-host "Last Sync Date:" $UserDevice.lastSyncDateTime
				write-host "OS:" $UserDevice.operatingSystem
				write-host "OS Version:" $UserDevice.osVersion
	
				if ($UserDevice.easActivated -eq $false) {
					write-host "EAS Activated:" $UserDevice.easActivated -ForegroundColor Red
				}
	
				else {
					write-host "EAS Activated:" $UserDevice.easActivated
				}
	
				Write-Host "EAS DeviceId:" $UserDevice.easDeviceId
	
				if ($UserDevice.aadRegistered -eq $false) {
					write-host "AAD Registered:" $UserDevice.aadRegistered -ForegroundColor Red
				}
	
				else {
					write-host "AAD Registered:" $UserDevice.aadRegistered
				}
					
				write-host "Enrollment Type:" $UserDevice.enrollmentType
				write-host "Management State:" $UserDevice.managementState
	
				if ($UserDevice.complianceState -eq "noncompliant") {
							
					write-host "Compliance State:" $UserDevice.complianceState -f Red
	
					$uri = "https://graph.microsoft.com/beta/managedDevices/$UserDeviceId/deviceCompliancePolicyStates"
									
					$deviceCompliancePolicyStates = (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
	
					foreach ($DCPS in $deviceCompliancePolicyStates) {
	
						if ($DCPS.State -ne "notApplicable") {
	
													
							Write-Host "Non Compliant Policy for device $UserDeviceName" -ForegroundColor Yellow
							write-host "Display Name:" $DCPS.displayName
	
							$SettingStatesId = $DCPS.id.split("_")[2]
	
							$uri = "https://graph.microsoft.com/beta/managedDevices/$UserDeviceId/deviceCompliancePolicyStates/$SettingStatesId/settingStates"
	
							$SettingStates = (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
	
							foreach ($SS in $SettingStates) {
	
								if ($SS.state -eq "nonCompliant") {
	
																			
									Write-Host "Setting:" $SS.setting
									Write-Host "State:" $SS.state -ForegroundColor Red
	
								}
	
							}
	
						}
	
					}
	
					# Getting AAD Device using azureActiveDirectoryDeviceId property
					$uri = "https://graph.microsoft.com/v1.0/devices?`$filter=deviceId eq '$UserDeviceAADDeviceId'"
					$AADDevice = (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
	
					$AAD_Compliant = $AADDevice.isCompliant
	
					# Checking if AAD Device and Intune ManagedDevice state are the same value
	
									
					Write-Host "Compliance State - AAD and ManagedDevices" -ForegroundColor Yellow
					Write-Host "AAD Compliance State:" $AAD_Compliant
					Write-Host "Intune Managed Device State:" $UserDeviceComplianceState
							
				}
							
				else {
	
					write-host "Compliance State:" $UserDevice.complianceState -f Green
	
					# Getting AAD Device using azureActiveDirectoryDeviceId property
					$uri = "https://graph.microsoft.com/v1.0/devices?`$filter=deviceId eq '$UserDeviceAADDeviceId'"
					$AADDevice = (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
	
					$AAD_Compliant = $AADDevice.isCompliant
	
					# Checking if AAD Device and Intune ManagedDevice state are the same value
	
									
					Write-Host "Compliance State - AAD and ManagedDevices" -ForegroundColor Yellow
					Write-Host "AAD Compliance State:" $AAD_Compliant
					Write-Host "Intune Managed Device State:" $UserDeviceComplianceState
							
				}
	
					
				write-host "-------------------------------------------------------------------"
					
	
			}
	
		}
	
		else {
	
			#write-host "User Devices:" -f Yellow
			write-host "User has no devices"
			
	
		}
	
	}
	