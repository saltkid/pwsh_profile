# ALIASES {{{
New-Alias -Name ff -Value firefox
New-Alias -Name lg -Value lazygit
New-Alias -Name v -Value nvim
# }}}

# FUNCTIONS {{{
function AddToPath
{
    param(
        [string]$directoryPath
    )
    
    if ($env:PATH -notcontains $directoryPath)
    {
        $env:PATH = $env:PATH + ";$directoryPath"
    } else
    {
        Write-Host "'$directoryPath' is already in PATH."
    }
}
function ffs
{
    $SearchQuery = $args -join ' '
    Start-Process "firefox" "--search `"$SearchQuery`""
}
function v.
{ nvim . 
}
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

# Setting up credentials for a git repo

function Git-Check
{
    git config user.name
    git config user.email
    git config user.signingkey
}

function Git-Clear
{
    git config user.name ""
    git config user.email ""
    git config user.signingkey ""
}

function Git-Setup
{
    $username = git config --get user.name
    $email = git config --get user.email
    $signingkey = git config --get user.signingkey

    if ($username -and $email -and $signingkey)
    {
        Write-Host "Git configuration already set:"
        Write-Host "user.name: $username"
        Write-Host "user.email: $email"
        Write-Host "user.signingkey: $signingkey"
        Write-Host "No need to reconfigure. Exiting..."
        return
    }

    if ($username)
    {
        Write-Host "Username already set: $username"
    } else
    {
        $remoteUrl = git ls-remote --get-url origin
        $ssh_key_id = ($remoteUrl -split '@')[1] -split ':' | Select-Object -First 1
        $username = ($ssh_key_id -split '-' | Select-Object -Skip 1) -join '-'
        if ($ssh_key_id -match '-(.+)$')
        {
            $username = $Matches[1]
            Write-Host "Username found: $username"
        } else
        {
            Write-Host "No username found in remote.origin.url ($remoteUrl)"
            Write-Host 'Expected format is "gituser@domain-username:repo_owner/repo.git" (e.g., git@github.com-saltkid:saltkid/dotfiles.git)'
            $domain = Read-Host "Please enter a domain (github.com, gitlab.com, etc.)"
            $username = Read-Host "Please enter a username"
            $ssh_key_id = "$domain-$username"
        }
    }

    $ssh_key_file = "$HOME\.ssh\$ssh_key_id.pub"
    if ($email)
    {
        Write-Host "Email already set: $email"
    } else
    {
        if (Test-Path $ssh_key_file)
        {
            $email = (Get-Content $ssh_key_file | Select-Object -Last 1).Split()[-1]
            Write-Host "Email found: $email"
        } else
        {
            Write-Host "No SSH public key found for $ssh_key_id"
            $email = Read-Host "Please enter an email"
        }
    }

    if ($signingkey)
    {
        Write-Host "Signing key already set: $signingkey"
    } else
    {
        $signingkey = $ssh_key_file
        if (Test-Path $ssh_key_file)
        {
            Write-Host "Signing key found: $signingkey"
        } else
        {
            Write-Host "No available SSH keys found."
            Write-Host "Consider manually configuring git config or setting up ssh keys."
            Write-Host "Exiting..."
            return
        }
    }

    git config user.name "$username"
    git config user.email "$email"
    git config user.signingkey "$signingkey"
}

# }}}

# ADD TO PATH {{{
AddToPath("C:\Program Files\PostgreSQL\17\bin")
# }}}


# KEYBINDS {{{
$TBG_PORT=9543
# quick cd to searched git repo
Set-PSReadLineKeyHandler -Chord "Ctrl+f" -ScriptBlock { Invoke-SearchGitRepos }
Set-PSReadLineKeyHandler -Chord "Alt+i" -ScriptBlock {
    tbg.exe next-image -P $TBG_PORT &
}
Set-PSReadLineKeyHandler -Chord "Ctrl+Alt+i" -ScriptBlock {
    tbg.exe quit -P $TBG_PORT &
}
# }}}

# initial start of tbg server, targeting this pwsh profile
Start-Job -Name tbg-server -ArgumentList $TBG_PORT -ScriptBlock {
    param($port)
    tbg.exe run -P $port -p pwsh
} | Out-Null

# setting theme
$themeName = "saltkid"
Write-Host "Setting $themeName as theme..."
oh-my-posh init pwsh --config ~/Documents/Powershell/themes/$themeName.omp.yml | Invoke-Expression
