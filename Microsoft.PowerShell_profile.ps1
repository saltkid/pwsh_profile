New-Alias -Name ff -Value firefox
New-Alias -Name lg -Value lazygit

Function ffs
{
    $SearchQuery = $args -join ' '
    Start-Process "firefox" "--search `"$SearchQuery`""
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

