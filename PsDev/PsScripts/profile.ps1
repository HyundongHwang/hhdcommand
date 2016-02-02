Write-Host "안녕하세요" $env:USERNAME"님"
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
    Write-Debug "PsDev 폴더 있음 ..."
    rm -Force C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1
    cp -Force C:\hhdcommand\PsDev\PsScripts\profile.ps1 C:\Windows\System32\WindowsPowerShell\v1.0
    Add-Type -Path "C:\hhdcommand\PsDev\HPsUtils\bin\Debug\HPsUtils.dll"
}
else
{
    Write-Debug "PsDev 폴더 없음 ..."
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
    시놉시스
.PARAMETER prefix
    프레픽스
.EXAMPLE
    PS C:\WINDOWS\system32> $DebugPreference = "continue"
    PS C:\WINDOWS\system32> ps | select -First 5 | getcustomprocessinfo -prefix 프레픽스 -strArray @("하나", "둘", "셋")
    디버그: strArray.Length : 3
    디버그: idx : 0
    디버그: randValue : 하나

    디버그: strArray.Length : 3
    디버그: idx : 1
    디버그: randValue : 둘
    디버그: strArray.Length : 3
    디버그: idx : 1
    디버그: randValue : 둘
    디버그: strArray.Length : 3
    디버그: idx : 1
    디버그: randValue : 둘
    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 셋
    prefix   ProcessName          ProcessId randValue
    ------   -----------          --------- ---------
    프레픽스 ApplicationFrameHost     14912 하나
    프레픽스 ccSvcHst                  3508 둘
    프레픽스 chrome                    2220 둘
    프레픽스 chrome                    3076 둘
    프레픽스 chrome                    6288 셋
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
    압축
.PARAMETER zipdir
    압축대상폴더
.PARAMETER zipfile
    압축대상파일
.EXAMPLE
    PS C:\project> zip -zipdir mygittest -zipfile my.zip
    디버그: zipdir : mygittest
    디버그: zipfile : my.zip
    디버그: zipRealDir : C:\project\mygittest
    디버그: zipRealFile : C:\project\my.zip

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