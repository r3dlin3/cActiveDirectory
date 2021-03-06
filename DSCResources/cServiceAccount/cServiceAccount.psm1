function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."

    # AD cmdlets generate non-terminating errors.
    $ErrorActionPreference = 'Stop'
    try {
        $returnValue = @{
            Ensure = "Absent"
            Name = $Name
            DNSName = $DNSName
            SPNs = [System.String[]]
            PrincipalsAllowedToRetrieveManagedPassword = [System.String[]]
            PrincipalsAllowedToRetrieveManagedPasswordToInclude = [System.String[]]
            PrincipalsAllowedToRetrieveManagedPasswordToExclude = [System.String[]]
            
        }

        $svc = Get-ADServiceAccount -Identity $Name -Properties "msDS-GroupMSAMembership","dNSHostName"
        $principals = @()
        foreach($access in  $svc.'msDS-GroupMSAMembership') {
            $principals += $access.access.IdentityReference.Value.Split('\')[1]
        }
        Get-ADComputer -LDAPFilter "(msDS-HostServiceAccount=$($svc.DistinguishedName))" | ForEach-Object {
            $principals += $_.SamAccountName
        }

        $returnValue = @{
            Ensure = "Present"
            Name = $svc.Name
            DNSName = $svc.DNSHostName
            SPNs = $svc.ServicePrincipalNames
            PrincipalsAllowedToRetrieveManagedPassword = $principals 
            PrincipalsAllowedToRetrieveManagedPasswordToInclude = [System.String[]]
            PrincipalsAllowedToRetrieveManagedPasswordToExclude = [System.String[]]
        }
   
    } Finally {
        $ErrorActionPreference = 'Continue'
    }
    
    return $returnValue
 
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [System.String]
        $DNSName,

        [System.String[]]
        $SPNs,

        [System.String[]]
        $PrincipalsAllowedToRetrieveManagedPassword,

        [System.String[]]
        $PrincipalsAllowedToRetrieveManagedPasswordToInclude,

        [System.String[]]
        $PrincipalsAllowedToRetrieveManagedPasswordToExclude
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."
        # AD cmdlets generate non-terminating errors.
    $ErrorActionPreference = 'Stop'
    
    if ([string ]::IsNullOrEmpty($DNSName)) {
        $DNSName = $Name
    }
    
    if ($Ensure -eq "Present") {
        $svc = Get-ADServiceAccount -Identity $Name -Properties "msDS-GroupMSAMembership","dNSHostName"
        if ($svc) {
            Write-Verbose "Service Account $Name is already present"
        } else {
            Write-Verbose "Service Account $Name is absent. Need to create"
            New-ADServiceAccount -Name $Name -DNSHostName $DNSName

        }
    }


    
    


}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [System.String]
        $DNSName,

        [System.String[]]
        $SPNs,

        [System.String[]]
        $PrincipalsAllowedToRetrieveManagedPassword,

        [System.String[]]
        $PrincipalsAllowedToRetrieveManagedPasswordToInclude,

        [System.String[]]
        $PrincipalsAllowedToRetrieveManagedPasswordToExclude
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    <#
    $result = [System.Boolean]
    
    $result
    #>
}


Export-ModuleMember -Function *-TargetResource

<#
Test syntax:

Test-TargetResource -Ensure "Present" -Name 

Set-TargetResource -Ensure "Present" -WhatIf

#>

