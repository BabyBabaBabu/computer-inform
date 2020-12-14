$computers = (Get-ADComputer -Filter *).Name  | Sort-Object
$up = @()
ForEach ($comp in $computers) 
{
	if(!(Test-Connection -Cn $comp -BufferSize 16 -Count 1 -ea 0 -quiet))
	{
		<#write-host "cannot reach $comp" -f red#>
	}
	else
	{
 		$up += Test-Connection -ComputerName $comp -Count 1 | Select-Object Address,IPV4Address
		$up  | Export-CSV C:\Users\itsupport\Desktop\online-comps.csv  -NoTypeInformation
	}
}