Set-ExecutionPolicy Unrestricted
$ErrorActionPreference = 'Stop'

Try { 
	# variables
	$installRootDir = 'c:\cspa\'
	$installDir = Join-Path $installRootDir "cspa_rest"
	
	Set-Location $installDir
	Start-Process node -ArgumentList "server"
	
	Start-Sleep -s 3
	
	$Env:Path += ";C:\Users\Administrator\AppData\Local\Apps\cURL\bin"
	
	function TestService ([string]$ip, [string]$port, [string]$name) {
		Set-Location (Join-Path $installDir (Join-Path $name "example"))
		$cmd = [string]::Format("-i -X POST -d @job.json http://{0}:{1}/{2} --header ""Content-Type:application/json""", $ip, $port, $name)
		Start-Process curl -ArgumentList $cmd
	}
	
	TestService "localhost" "8080" "LRC"
	
	TestService "localhost" "8080" "LEC"
	
	TestService "localhost" "8080" "LEL"	
}
Catch {
	Write-Host 'Caught exception: ' $_.Exception.Message
}

