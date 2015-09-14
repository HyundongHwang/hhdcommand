<#
.SYNOPSIS
powershell_ise�� ���Ͽ���
.PARAMETER FileName
�����̸�
.EXAMPLE
Hhd-Open-FileAsPs -FileName test.ps1
#>
param 
(
    [string] $FileName
)

if($FileName.Contains('*'))
{
    ls $FileName | 
    %{
        Write-Host $_ "������ �����մϴ�."
        powershell_ise $_;
    }
}
else
{
    if (Test-Path $FileName)
    {
    }
    else
    {
        ni $FileName;
        Write-Host $FileName "�� �����մϴ�.";
    }

    Write-Host $FileName "������ �����մϴ�."
    powershell_ise $FileName;
}