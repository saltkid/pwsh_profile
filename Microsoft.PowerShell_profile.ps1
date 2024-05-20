### aliases
New-Alias -Name ff -Value firefox
New-Alias -Name lg -Value lazygit
New-Alias -Name vim -Value nvim

### custom commands
Function ffs
{
    $SearchQuery = $args -join ' '
    Start-Process "firefox" "--search `"$SearchQuery`""
}

### ensure installed
Write-Host "Installing Chocolatey..."
if (-not (Get-Command 'choco' -ErrorAction SilentlyContinue))
{
    Write-Host "Chocolatey not installed, installing..."
    # from official chocolatey docs
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-WebRequest https://community.chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
    Write-Host "Chocolatey installed"
} else
{
    Write-Host "Chocolatey already installed"
}

# key:val = package_name:command
Write-Host "Installing packages..."
$ensure_installed_packages = @{
    "yt-dlp" = "yt-dlp";
    "mpv" = "mpv";
    "git" = "git";
    "ffmpeg" = "ffmpeg";
    "fzf" = "fzf";
    "grep" = "grep";
    "ripgrep" = "rg";
    "sed" = "sed";
    "es" = "es";
    "lazygit" = "lazygit";
    "neovim" = "nvim";
    "oh-my-posh" = "oh-my-posh";
}

$ensure_installed_packages.GetEnumerator() | ForEach-Object {
    if (-not (Get-Command $_.Value -ErrorAction SilentlyContinue))
    {
        Write-Host "'$($_.Key)' not installed, installing..."
        choco install $($_.Key) -y
        Write-Host "'$($_.Key)' installed"
    } else
    {
        Write-Host "'$($_.Key)' already installed"
    }
}

### setting theme
$themeName = "bubblesextra"
Write-Host "Setting $themeName as theme..."
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$themeName.omp.json" | Invoke-Expression

### custom functions and keybinds
# quick cd to searched git repo
function Invoke-SearchGitRepos
{
    $selected = $(es -w .git /a[DH] | sed 's/\\.git//' | fzf)
    if ($selected)
    {
        Set-Location $selected
    }
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait("{Enter}")
}
Set-PSReadLineKeyHandler -Key "Ctrl+f" -ScriptBlock { Invoke-SearchGitRepos }
