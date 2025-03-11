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
