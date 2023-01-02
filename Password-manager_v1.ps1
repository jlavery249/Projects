function ConvertToExcel
{
    $data = (Get-Content '<path to>passwordfile.txt') -replace ':', '=' |
            # Select-Object -Skip 2 |
            Out-String |
            ConvertFrom-StringData
    [PSCustomObject]$data | Export-Csv '<path to output passwd file>.csv'-Append -NoType
}

function ConvertToPlainText
{
    $Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($PW)
    $result = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)
    $result 
}

$UN = Read-Host "Please enter account username"
$PW = Read-Host "Enter Password" -AsSecureString
$site = Read-Host "Enter website this is used for"

ConvertTo-SecureString $PW -AsPlainText -Force
$plain = ConvertToPlainText

Write-Output "Site: $site" | Out-File "<path to>passwordfile.txt" -Append -Encoding unicode
Write-Output "Username: $UN" | Out-File "<path to>passwordfile.txt" -Append -Encoding unicode
Write-Output "Password: $plain" | Out-File "<path to>passwordfile"

Converttoexcel
remove-item -path "<path to>passwordfile.txt" -Recurse 
