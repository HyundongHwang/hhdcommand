<#
.SYNOPSIS
powershell_ise로 파일열기
.PARAMETER FileName
파일이름
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
        Write-Host $_ "파일을 오픈합니다."
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
        Write-Host $FileName "을 생성합니다.";
    }

    Write-Host $FileName "파일을 오픈합니다."
    powershell_ise $FileName;
}