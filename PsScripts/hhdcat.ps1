<#
.SYNOPSIS
powershell_ise에서 라인넘버 넣어서 파일열기
.PARAMETER FileName
파일이름
.EXAMPLE
Hhd-Open-File test.txt
Hhd-Open-File test.txt -Encoding UTF8
#>
param
(
    [string] $FileName,
    [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding] $Encoding = 'Default'
)
$strList = (gc $FileName -Encoding $Encoding | Out-String) -split '\n';
$strList | sls '[\w\n\s]*' | ft -Wrap -AutoSize @{l='#'; e={$_.LineNumber}}, Line;