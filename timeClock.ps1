$fortiPath = "C:\Program Files (x86)\Fortinet\FortiClient\FortiClient.exe"

$timeFile = "C:\Users\Hayden Woods\Desktop\time.txt"

$Running = Get-Process forticlient -ErrorAction SilentlyContinue
$data = $null
if(!(Test-path $timeFile))
{
     New-Item -Path $timeFile  
     $data = "0"
}
else
{
$data = Get-Content -Path $timeFile 
}
$data += ','


while ($Running -ne $null)
{
    $id = (Get-Process forticlient -ErrorAction SilentlyContinue).Id

    Stop-process -Id $id
    Start-sleep -seconds 3
    $Running = Get-Process forticlient -ErrorAction SilentlyContinue
 }

 $startTime = $null
 $startedClient = $null

 $endTime = $null
 
try{
    Start-Process -FilePath $fortiPath
    Start-sleep -seconds 1
    $startedClient = get-process forticlient

    $startTime = New-TimeSpan  $startedClient.StartTime

    while(1)
    {
        Start-sleep -Seconds 5
        $endTime = New-TimeSpan (get-process forticlient -ErrorAction SilentlyContinue).StartTime -ErrorAction SilentlyContinue 
        Write-host($endTime)
    }
}
finally
{
    $endTimeTemp = New-TimeSpan (get-process forticlient -ErrorAction SilentlyContinue).StartTime -errorAction SilentlyContinue
    if ($endTimeTemp.minutes -gt $endTime.Minutes)
    {
        $endTime = $endTimeTemp
    }
    Write-host("finally")
    Write-host($endTime.Seconds)
    $data += ($endTime.Hours * 60)
    $data += $endTime.Minutes

    Write-host($data)
    $data | Out-File -FilePath $timeFile 
    Stop-process -Id $startedClient.Id -ErrorAction SilentlyContinue
}



