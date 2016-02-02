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
if (Test-Path "C:\hhdcommand\PsDev\PsScripts")
{
    Write-Debug "PsDev ���� ���� ..."
    rm -Force C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1
    cp -Force C:\hhdcommand\PsDev\PsScripts\profile.ps1 C:\Windows\System32\WindowsPowerShell\v1.0
    Add-Type -Path "C:\hhdcommand\PsDev\HPsUtils\bin\Debug\HPsUtils.dll"
}
else
{
    Write-Debug "PsDev ���� ���� ..."
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

function piprofileps1()
{
    powershell_ise c:\hhdcommand\PsScripts\profile.ps1
}



##############################################################################################
# complex functions ... 
##############################################################################################

<#
.SYNOPSIS
    �ó�ý�
.PARAMETER prefix
    �����Ƚ�
.EXAMPLE
    PS C:\WINDOWS\system32> $DebugPreference = "continue"
    PS C:\WINDOWS\system32> ps | select -First 5 | getcustomprocessinfo -prefix �����Ƚ� -strArray @("�ϳ�", "��", "��")
    �����: strArray.Length : 3
    �����: idx : 0
    �����: randValue : �ϳ�

    �����: strArray.Length : 3
    �����: idx : 1
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
    prefix   ProcessName          ProcessId randValue
    ------   -----------          --------- ---------
    �����Ƚ� ApplicationFrameHost     14912 �ϳ�
    �����Ƚ� ccSvcHst                  3508 ��
    �����Ƚ� chrome                    2220 ��
    �����Ƚ� chrome                    3076 ��
    �����Ƚ� chrome                    6288 ��
#>
function getcustomprocessinfo
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

<#
.SYNOPSIS
    ����
.PARAMETER zipdir
    ����������
.PARAMETER zipfile
    ����������
.EXAMPLE
    PS C:\project> zip -zipdir mygittest -zipfile my.zip
    �����: zipdir : mygittest
    �����: zipfile : my.zip
    �����: zipRealDir : C:\project\mygittest
    �����: zipRealFile : C:\project\my.zip

    zipdir    zipfile
    ------    -------
    mygittest my.zip
#>
function zip
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $zipdir,

        [Parameter(Mandatory=$true)]
        [System.String]
        $zipfile
    )
    begin
    {
    }
    process
    {
        $oldDebugPreference = $DebugPreference
        $DebugPreference = "continue"
        $obj = New-Object -typename PSObject

        Write-Debug ("zipdir : " + $zipdir)
        Write-Debug ("zipfile : " + $zipfile)

        Add-Type -AssemblyName System.IO.Compression.FileSystem

        $zipRealDir = [System.IO.Path]::Combine($PWD, $zipdir)
        $zipRealDir = $zipRealDir.TrimEnd([char[]]@('.', '\'))
        $zipRealFile = [System.IO.Path]::Combine($PWD, $zipfile)

        Write-Debug ("zipRealDir : " + $zipRealDir)
        Write-Debug ("zipRealFile : " + $zipRealFile)

        if (Test-Path $zipRealFile)
        {
            rm $zipRealFile
        }
        
        [System.IO.Compression.ZipFile]::CreateFromDirectory($zipRealDir, $zipRealFile)

        $obj | Add-Member -MemberType NoteProperty -Name zipdir -Value $zipdir
        $obj | Add-Member -MemberType NoteProperty -Name zipfile -Value $zipfile

        Write-Output $obj
        $DebugPreference = $oldDebugPreference
    }
}