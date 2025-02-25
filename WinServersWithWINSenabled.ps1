# This script finds all servers with WINS settings enabled/set

foreach ($srv in (Get-ADComputer -Filter * -Properties * | Where-Object {$_.OperatingSystem -like "*server*"} | Sort-Object Name | Select-Object -expandproperty Name)){
	if (Test-Connection -ComputerName $srv -Count 1 -Quiet -ErrorAction SilentlyContinue){
		$status = $false
		foreach ($nic in (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "WINSPrimaryServer != NULL" -ComputerName $srv)){
			foreach ($wins in $nic){
				$status = $true
			}
		}
		if ($status){
			Write-Host "$srv has WINS enabled/set."
		}
	}
}