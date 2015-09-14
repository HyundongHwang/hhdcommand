<#
.EXAMPLE
PS ~> @('a', 'b') | .\hhd-test-pipeline-script.ps1 | % { Write-Output ($_ + '안녕하세요') }
ahello안녕하세요
bhello안녕하세요
#>
[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
    [string[]]$strList
)
BEGIN 
{
}
PROCESS 
{
    Foreach ($str in $strList) 
    {
        Write-Output ($str + 'hello');
    }
}