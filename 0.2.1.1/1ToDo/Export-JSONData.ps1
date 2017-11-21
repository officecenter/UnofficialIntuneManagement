<#

.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See https://github.com/microsoftgraph/powershell-intune-samples/blob/master/LICENSE  for license information.

#>

Function Export-JSONData() {
	
		<#
	.SYNOPSIS
	This function is used to export JSON data returned from Graph
	.DESCRIPTION
	This function is used to export JSON data returned from Graph
	.EXAMPLE
	Export-JSONData -JSON $JSON
	Export the JSON inputted on the function
	.NOTES
	NAME: Export-JSONData
	#>
	
		param (
	
			$JSON,
			$ExportPath
	
		)
	
		try {
	
			if ($JSON -eq "" -or $JSON -eq $null) {
	
				write-host "No JSON specified, please specify valid JSON..." -f Red
	
			}
	
			elseif (!$ExportPath) {
	
				write-host "No export path parameter set, please provide a path to export the file" -f Red
	
			}
	
			elseif (!(Test-Path $ExportPath)) {
	
				write-host "$ExportPath doesn't exist, can't export JSON Data" -f Red
	
			}
	
			else {
	
				$JSON1 = ConvertTo-Json $JSON
	
				$JSON_Convert = $JSON1 | ConvertFrom-Json
	
				$displayName = $JSON_Convert.displayName
	
				$Properties = ($JSON_Convert | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name
	
				$displayName = $JSON_Convert.displayName
	
				$FileName_CSV = "$DisplayName" + "_" + $(get-date -f dd-MM-yyyy-H-mm-ss) + ".csv"
				$FileName_JSON = "$DisplayName" + "_" + $(get-date -f dd-MM-yyyy-H-mm-ss) + ".json"
	
				$Object = New-Object System.Object
	
				foreach ($Property in $Properties) {
	
					$Object | Add-Member -MemberType NoteProperty -Name $Property -Value $JSON_Convert.$Property
	
				}
	
				write-host "Export Path:" "$ExportPath"
	
				$Object | Export-Csv "$ExportPath\$FileName_CSV" -Delimiter "," -NoTypeInformation -Append
				$JSON1 | Out-File "$ExportPath\$FileName_JSON"
				write-host "CSV created in $ExportPath\$FileName_CSV..." -f cyan
				write-host "JSON created in $ExportPath\$FileName_JSON..." -f cyan
							
			}
	
		}
	
		catch {
	
			$_.Exception
	
		}
	
	}