 <#
.SYNOPSIS
��ũ�뷮���� ��ũ��Ʈ
.PARAMETER ComputerName
��ǻ���̸�
.EXAMPLE
.\get-diskinventory-with-param.ps1 -ComputerName localhost
#>
param
(
    $ComputerName = 'localhost'
)
Get-WmiObject -Class win32_logicaldisk -ComputerName $ComputerName -Filter "drivetype=3" |
    sort -Property DeviceID |
    ft -Property `
        DeviceID, `
        @{l ='FreeSpace(MB)'; e ={$_.FreeSpace / 1MB -as [ int]}} , `
        @{l ='Size(GB)'; e ={$_.Size / 1GB -as [ int]}} , `
        @{l ='%Free'; e ={$_.FreeSpace / $_.Size * 100 -as [int ]}}
