function Read-YesNo ([string] $Prompt){
    $exitCheck = $null;
    while($exitCheck -ne "y" -and $exitCheck -ne "n"){
        Write-Host -NoNewline "$Prompt [Y/n] ";
        $exitKey = [Console]::ReadKey();
        if($exitKey.Key -eq [ConsoleKey]::Enter){
            $exitCheck = "y";
        }else{
            $exitCheck = [System.Char]::ToLower($exitKey.KeyChar);
        }
            Write-Host            
        switch ($exitCheck) {
            "y" { return $true; }
            "n" { return $false; }
            Default { 
                Write-Host "Invalid Entry";
                continue; 
            }
        }
    }
}

# Create Reloader
function Start-ReloadableSession([Switch]$Here){
    if(-Not $Here){
        Start-Process powershell -ArgumentList @("-NoExit", "-NoLogo", "-Command", "Start-ReloadableSession -Here");
        return;
    }
    function Restart-ReloadableSession{
        exit;
    }
    $reloadFunction = Get-Item -Path "function:Restart-ReloadableSession"
    $reloadDefinition = $reloadFunction.Definition
    while($true){
        powershell.exe -NoExit -NoLogo -Command "Set-Item -Force -Path Function:reload -Value '$reloadDefinition'" ;
        $exitCode = $LASTEXITCODE;
        Write-Host "You are in a reloadable session."
        $exitCheck = Read-YesNo -Prompt "Would you like to reload?"
        if(-Not $exitCheck){
            exit $exitCode
        }
    }
}

Export-ModuleMember -Function Start-ReloadableSession
