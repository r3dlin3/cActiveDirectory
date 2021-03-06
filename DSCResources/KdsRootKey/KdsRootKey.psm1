function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."
    [System.String] $result = "";
    $key = Get-KdsRootKey
    if ($key) { $result = "Present" } else {$result = "Absent"}

    
    $returnValue = @{
        Ensure =  $result 
    }

    $returnValue
    
}


function Set-TargetResource
{
     [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )
    # AD cmdlets generate non-terminating errors.
    $ErrorActionPreference = 'Stop'
    try {
        if ($Ensure -eq "Present") {
            $Forest = Get-ADForest
            If (($Forest.ForestMode -as [int]) -lt 5) {
                Write-Verbose -Message "Forest functionality level $($Forest.ForestMode) does not meet minimum requirement of Windows2012R2Forest or greater."
                Throw "Forest functionality level $($Forest.ForestMode) does not meet minimum requirement of Windows2012R2Forest or greater."
            }
            If ($PSCmdlet.ShouldProcess($Forest.RootDomain, " Add Kds Root Key")) {     
                Add-KdsRootKey –EffectiveTime ((get-date).addhours(-10)) -Verbose
            }
        } else {
            throw "Absent not implemented"
        }

    } Finally {
        $ErrorActionPreference = 'Continue'
    }

}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )

    # AD cmdlets generate non-terminating errors.
    $ErrorActionPreference = 'Stop'
    try {
        $key = Get-KdsRootKey
        Write-Verbose "KdsRootKey = $key"
        if ($Ensure -eq "Present") {
            $key -ne $null
        } else {
            $key -eq $null
        }
    } Finally {
        $ErrorActionPreference = 'Continue'
    }
}


Export-ModuleMember -Function *-TargetResource

<#
Test syntax:

Test-TargetResource -Ensure "Present"
Set-TargetResource -Ensure "Present" -WhatIf

#>

