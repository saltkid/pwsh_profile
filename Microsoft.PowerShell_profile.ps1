New-Alias -Name ff -Value firefox

Function ffs
{
    $SearchQuery = $args -join ' '
    Start-Process "firefox" "--search `"$SearchQuery`""
}

$themeName = "bubblesextra"
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$themeName.omp.json" | Invoke-Expression
