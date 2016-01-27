Write-Host "æ»≥Á«œººø‰" $env:USERNAME"¥‘";
Set-Item Env:\Path ((Get-Content Env:\Path) + ";c:\hhdcommand\PsScripts\;c:\Program Files (x86)\Git\bin\;")
$OutputEncoding = New-Object -TypeName System.Text.UTF8Encoding
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
Set-Alias vim "c:\hhdcommand\vim74\vim.exe"
Set-Alias sublime "c:\hhdcommand\Sublime Text 2.0.2\sublime.exe"
Set-Alias lsforce Get-ChildItem -Force



Function cdpsscripts
{
    cd c:\hhdcommand\PsScripts\
}

Function cdtemp
{
    cd c:\temp
}

Function cdproject
{
    cd c:\project
}

Function sublimeprofileps1
{
    sublime c:\hhdcommand\PsScripts\profile.ps1
}

Function catprofileps1
{
    cat c:\hhdcommand\PsScripts\profile.ps1
}

Function cpprofileps1
{
    xcopy /Y c:\hhdcommand\PsScripts\profile.ps1 C:\Windows\System32\WindowsPowerShell\v1.0
}

Function cd2($keyword)
{
    cd *$keyword*
}

Function cd3($keyword)
{
    $result = ls *$keyword* | ? { $_.GetType().ToString().Contains("Directory") }

    if(!$result)
    {
        Write-Host "no items!"
        return
    }



    if($result.Length -eq 1)
    {    
        Write-Host "Goto directory $result.Item(0) ..."
        cd $result.Item(0)
        return
    }



    Write-Host "Multiful directories were found!"
    Write-Host "Select the number : "

    while(1 -eq 1)
    {
        $i = 1;

        foreach ($dir in $result)
        {
            Write-Host "($i) $dir"
            $i++;
        }

        $sel = Read-Host;

        if($sel -ge 1 -and $sel -le $result.Length)
        {
            $selDir = $result.Item($sel - 1)
            Write-Host "Goto directory $selDir ..."
            cd $selDir
            return
        }
        else
        {
            Write-Host "You entered wrong number!"
        }
    }
}

Function ps2()
{
    ps | sort WS -Descending | select Id, Name, @{l="WS(M)"; e={[int]($_.WS / 1024 / 1024)}}, Path -First 10 | ft -AutoSize -Wrap
}

Function gitgraph
{
    git log --pretty=format:"%h %s - %an %ar" --graph
}