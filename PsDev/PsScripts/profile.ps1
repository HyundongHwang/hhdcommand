Write-Host "�ȳ��ϼ���" $env:USERNAME"��"
$oldPath = Get-Content Env:\Path

Set-Item Env:\Path "
    $oldPath;
    c:\Program Files (x86)\Git\bin\;
"

$OutputEncoding = New-Object -TypeName System.Text.UTF8Encoding
$DebugPreference = "continue"
Set-ExecutionPolicy Unrestricted -Scope CurrentUser



##############################################################################################
# update custom profile.ps1, dlls ... 
##############################################################################################
if (Test-Path C:\hhdcommand\PsDev\PsScripts\profile.ps1)
{
    Write-Debug "profile.ps1 ������Ʈ ..."
    cp -Force C:\hhdcommand\PsDev\PsScripts\profile.ps1 $PSHOME
}
else
{
    Write-Debug "profile.ps1 ������Ʈ ��ŵ ..."
}

if (Test-Path "C:\hhdcommand\PsDev\HPsUtils\bin\Debug\HPsUtils.dll")
{
    Write-Debug "HPsUtils.dll ������Ʈ ..."
    cp -Force -Recurse C:\hhdcommand\PsDev\HPsUtils\bin\Debug\* $PSHOME
    Add-Type -Path "$PSHOME\HPsUtils.dll"
}
else
{
    Write-Debug "HPsUtils.dll ������Ʈ ��ŵ ..."
}


##############################################################################################
# alias ... 
##############################################################################################
Set-Alias vim "c:\hhdcommand\vim74\vim.exe"
Set-Alias sublime "c:\hhdcommand\Sublime Text 2.0.2\sublime.exe"



##############################################################################################
# simple functions ... 
##############################################################################################
function lsforce
{
    Get-ChildItem -Force
}

function cdpsscripts
{
    cd c:\hhdcommand\PsScripts\
}

function cdtemp
{
    cd c:\temp
}

function cdproject
{
    cd c:\project
}

function sublimeprofileps1
{
    sublime c:\hhdcommand\PsScripts\profile.ps1
}

function catprofileps1
{
    cat c:\hhdcommand\PsScripts\profile.ps1
}

function cd2($keyword)
{
    cd *$keyword*
}

function ps2()
{
    ps | sort WS -Descending | select Id, Name, @{l="WS(M)"; e={[int]($_.WS / 1024 / 1024)}}, Path -First 10 | ft -AutoSize -Wrap
}

function gitgraph
{
    git log --pretty=format:"%h %s - %an %ar" --graph
}

function catlog($path)
{
    cat -Wait $path
}

function rmforce($path)
{
    rm -Recurse -Force $path
}

function vspsdev()
{
    Start-Process devenv.exe -Verb runAs -ArgumentList c:\hhdcommand\PsDev\PsDev.sln
}

<#
.SYNOPSIS
    rm -Recurse -Force $path
.PARAMETER path
    ����, ���丮 ���
.EXAMPLE
    rmforce aaa
#>
function rmforce($path)
{
    rm -Recurse -Force $path
}



##############################################################################################
# complex functions ... 
##############################################################################################

<#
.SYNOPSIS
    mycomplexfunc ���ž���.
.PARAMETER process
    ���μ��� ��ü
.PARAMETER prefix
    �Ϲ� ���ڿ� ��ü
.PARAMETER strArray
    ���ڿ� �迭
.EXAMPLE
    PS C:\temp> ps | where {$_.Name -eq "chrome"} | mycomplexfunc -prefix "�����Ƚ�" -strArray @("��", "��", "��")
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��

    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 1
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 1
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 0
    �����: randValue : ��
    prefix   ProcessName ProcessId randValue
    ------   ----------- --------- ---------
    �����Ƚ� chrome           8924 ��
    �����Ƚ� chrome          12980 ��
    �����Ƚ� chrome          13816 ��
    �����Ƚ� chrome          14596 ��
    �����Ƚ� chrome          16776 ��
    �����Ƚ� chrome          18068 ��
    �����Ƚ� chrome          18172 ��
    �����Ƚ� chrome          18404 ��
    �����Ƚ� chrome          20244 ��
    �����Ƚ� chrome          20324 ��
    �����Ƚ� chrome          21784 ��
    �����Ƚ� chrome          22216 ��
    �����Ƚ� chrome          22412 ��
#>
function mycomplexfunc
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.Diagnostics.Process]
        $process,

        [System.String]
        $prefix,

        [System.String[]]
        $strArray
    )
    begin
    {
    }
    process
    {
        $obj = New-Object -typename PSObject

        $obj | Add-Member -MemberType NoteProperty -Name prefix -Value $prefix
        $obj | Add-Member -MemberType NoteProperty -Name ProcessName -Value $process.Name
        $obj | Add-Member -MemberType NoteProperty -Name ProcessId -Value $process.Id

        Write-Debug ("strArray.Length : " + $strArray.Length)

        if ($strArray.Length -gt 0) 
        {
            $rand = New-Object -TypeName System.Random
            $idx = $rand.Next($strArray.Length)

            Write-Debug ("idx : " + $idx)

            $randValue = $strArray[$idx]

            Write-Debug ("randValue : " + $randValue)

            $obj | Add-Member -MemberType NoteProperty -Name randValue -Value $randValue
        }

        Write-Output $obj
    }
}