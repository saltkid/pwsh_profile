New-Alias -Name ff -Value firefox

Function ffs
{
    $SearchQuery = $args -join ' '
    Start-Process "firefox" "--search `"$SearchQuery`""
}
