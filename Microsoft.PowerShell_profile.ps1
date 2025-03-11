# ALIASES {{{
New-Alias -Name ff -Value firefox
New-Alias -Name lg -Value lazygit
New-Alias -Name v -Value nvim
# }}}

# FUNCTIONS {{{
function ffs
{
    $SearchQuery = $args -join ' '
    Start-Process "firefox" "--search `"$SearchQuery`""
}
function v.
{ nvim . 
}
### setting theme
$themeName = "bubblesextra"
Write-Host "Setting $themeName as theme..."
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$themeName.omp.json" | Invoke-Expression
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
# }}}

# KEYBINDS {{{
# quick cd to searched git repo
Set-PSReadLineKeyHandler -Key "Ctrl+f" -ScriptBlock { Invoke-SearchGitRepos }
# }}}

