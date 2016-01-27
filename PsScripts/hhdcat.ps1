<#
.SYNOPSIS
powershell_ise���� ���γѹ� �־ ���Ͽ���
.PARAMETER FileName
�����̸�
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