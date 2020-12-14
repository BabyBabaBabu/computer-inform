$DaysInactive = 150

$time = (Get-Date).Adddays(-($DaysInactive))

Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 200 -resultSetSize $null -Properties Name, OperatingSystem | Export-CSV "C:\Users\itsupport\Desktop\inactive-computers.csv" –NoTypeInformation