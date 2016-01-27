<#
.EXAMPLE
PS ~> @('a', 'b') | hhd-test-pipeline-script.ps1 | % { Write-Output ($_ + '12345') }
ahello12345
bhello12345
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