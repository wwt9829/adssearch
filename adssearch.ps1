<#
.SYNOPSIS
    Searches alternate data streams of a file for text.

.TODO
    Table output
    Command-line input
    Multiple files/directory search
    Split into functions

#>

$pattern = Read-Host "Enter pattern to search for"
$case = Read-Host "Case sensitive? (y or n)"
$file = Read-Host "Enter file to search"
$streams = Get-item -Path $file -stream * | select Stream | Out-String

"`nSearching alternate data streams in $file for `"$pattern`""

$nameList = $streams.Split("`n")
$matchList = New-Object System.Collections.ArrayList($null)
$matchContent = New-Object System.Collections.ArrayList($null)

for ($i = 3; $i -lt $nameList.Length; $i++) {
    $streamName = $namelist[$i].Trim()
    $streamValue = Get-Content -Path $file -stream $streamName
    if ($streamValue -ne $null) {
        if (($streamValue -match $pattern) -and ($case = "y")) {
            $matchList += $streamName
            $matchContent += $streamValue
        } elseif (($streamValue.ToLower() -match $pattern.ToLower()) -and ($case = "n")) {
            $matchList += $streamName
            $matchContent += $streamValue
        }
    }
}

$count = $matchList.Length
"Found $count matches.`n"
for ($i = 0; $i -lt $matchList.Length; $i++) {
    $idx = $i + 1;
    $name = $matchList[$i]
    $match = $matchContent[$i]
    "$idx`: Stream `"$name`" `Content: `"$match`""
}