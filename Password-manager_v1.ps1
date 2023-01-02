############################################################################################################
#  Password Manager v1                                                                                     #
#  Created by John Lavery                                                                                  #
#  Year of 2019                                                                                            #
#  Written in Powershell                                                                                   #
#  Description:                                                                                            #
#  Takes user input such as site name, username, password you want to use and stores it in a csv file      #
#  based on specified path output                                                                          #
############################################################################################################

## Declare functions

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

## for user input about account info

$UN = Read-Host "Please enter account username"
$PW = Read-Host "Enter Password" -AsSecureString
$site = Read-Host "Enter website this is used for"

ConvertTo-SecureString $PW -AsPlainText -Force
$plain = ConvertToPlainText

Write-Output "Site: $site" | Out-File "<path to>passwordfile.txt" -Append -Encoding unicode
Write-Output "Username: $UN" | Out-File "<path to>passwordfile.txt" -Append -Encoding unicode
Write-Output "Password: $plain" | Out-File "<path to>passwordfile"

## puts through converttoexcel function and pushes out password file csv to specified path
Converttoexcel
remove-item -path "<path to>passwordfile.txt" -Recurse 
