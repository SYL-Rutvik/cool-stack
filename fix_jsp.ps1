$filePath = "Z:\Java Project\cool-stack\src\main\webapp\employee\manager\view_products.jsp"
$lines = [System.IO.File]::ReadAllLines($filePath)
# Remove lines 347 to 411 (0-indexed: 346 to 410) — the orphaned duplicate block
$keep = $lines[0..345] + $lines[410..($lines.Length - 1)]
[System.IO.File]::WriteAllLines($filePath, $keep, [System.Text.Encoding]::UTF8)
Write-Host "Done. Lines remaining: $($keep.Length)"
