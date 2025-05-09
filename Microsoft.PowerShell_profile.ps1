Invoke-Expression (&starship init powershell)

Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-Alias -Name np -Value notepad++
Set-Alias -Name g -Value git
Set-Alias -Name open -Value start
Remove-Alias ls -Force -ErrorAction SilentlyContinue
function ls { & "eza" --icons @args }

Remove-Alias rm -Force -ErrorAction SilentlyContinue
function rm { & "C:\Program Files\Git\usr\bin\rm.exe" @args }

Remove-Alias cp -Force -ErrorAction SilentlyContinue
function cp { & "C:\Program Files\Git\usr\bin\cp.exe" @args }

Remove-Alias mv -Force -ErrorAction SilentlyContinue
function mv { & "C:\Program Files\Git\usr\bin\mv.exe" @args }

Function Start-WslDocker {
    wsl docker $args
}

Function Start-WslDockerCompose {
    wsl docker-compose $args
}

Set-Alias -Name docker -Value Start-WslDocker

Set-Alias -Name docker-compose -Value Start-WslDockerCompose
