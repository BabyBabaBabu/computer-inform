<#
.SYNOPSIS
	Name: computer-info.ps1
Script to retrieve computer information for inventory purposes

.DESCRIPTION


.NOTES
  Release Date: 10-05-2019

  Author: Alex Kyalo

 .EXAMPLE
 	computer-info.ps1 C:\Users\Kitaa\Desktop\comps.csv C:\Users\Kitaa\Desktop\comps-info.csv
#>

Param(
  [Parameter(Mandatory=$true, position=0)][string]$infile,
  [Parameter(Mandatory=$true, position=1)][string]$outfile  
)




<# $Cred = Get-Credential $Cred = Get-Credential -Credential domain\username #>

#Column header in input CSV file that contains the host name 
$ColumnHeader = "ComputerName"
$HostList = import-csv $infile | select-object $ColumnHeader
$out = @()

foreach($object in $HostList) {
	$comp = Get-WmiObject -computername $object.("ComputerName") -class Win32_ComputerSystem
	$mont = Get-WmiObject -computername $object.("ComputerName") WmiMonitorID -NameSpace root\wmi
	$bios = Get-WmiObject -computername $object.("ComputerName") -class Win32_BIOS
	$os = Get-WmiObject -computername $object.("ComputerName") -class Win32_OperatingSystem
	$proc = Get-WmiObject -computername $object.("ComputerName") -class Win32_Processor
	$net = Get-WmiObject -computername $object.("ComputerName") -class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null }
$DeviceInfo= @{
	'Computer Name' = $comp.Name
	'Make' = $comp.Manufacturer
	'Model' = $comp.Model
	'Serial Number' = $bios.SerialNumber
	'Monitor Make' = ($mont.ManufacturerName -notmatch 0 | ForEach-Object {[char]$_}) -join ""
	<#'Monitor Model' = ($mont.UserFriendlyName -notmatch 0 | ForEach {[char]$_}) -join ""#>
	'Monitor Serial' = ($mont.SerialNumberID -notmatch 0 | ForEach-Object {[char]$_}) -join ""
	'Memory' = (([math]::round($comp.TotalPhysicalMemory / 1GB)))
	'Operating System' = $os.Caption
	'Version' = $os.Version
	'O.S Serial Number' = $os.SerialNumber
	'Architecture' = $os.OSArchitecture
	'Processor' = $proc.Name
	'IP Address' = ($net.IPAddress -join ", ")
	'MAC Address' = $net.MACAddress
}

$out += New-Object PSObject -Property $DeviceInfo
$out | Sort | Export-CSV $outfile -NoTypeInformation

}
