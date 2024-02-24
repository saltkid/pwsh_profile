### aliases
New-Alias -Name ff -Value firefox
New-Alias -Name lg -Value lazygit

### custom commands
Function ffs
{
    $SearchQuery = $args -join ' '
    Start-Process "firefox" "--search `"$SearchQuery`""
}

### ensure installed
if (-not (Get-Command 'choco' -ErrorAction SilentlyContinue))
{
    Write-Host "Chocolatey not installed, installing..."
    # from official chocolatey docs
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex
    Write-Host "Chocolatey installed"
}

$ensure_installed_packages = @(
    "yt-dlp", "mpv", "git", "ffmpeg"
    "fzf". "grep", "ripgrep", "sed", "fd",
    "lazygit", "neovim", "oh-my-posh")

foreach ($package in $ensure_installed_packages)
{
    if (-not (Get-Command $package -ErrorAction SilentlyContinue))
    {
        Write-Host "$package not installed, installing..."
        choco install $package
        Write-Host "$package installed"
    }
}

$themeName = "bubblesextra"
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$themeName.omp.json" | Invoke-Expression

function Invoke-SearchGitRepos
{
    $searchPaths = @(
        "$env:userprofile/projects",
        "$env:userprofile/work",
        "$env:localappdata/nvim",
        "$env:userprofile/documents/powershell",
        "$env:userprofile/music")

    $selected = $(fd -u -i -t d -F '.git' $searchPaths | sed 's/\\.git//' | fzf)
    if ($selected)
    {
        Set-Location $selected
    }
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait("{Enter}")
}
Set-PSReadLineKeyHandler -Key "Ctrl+d" -ScriptBlock { Invoke-SearchGitRepos }
