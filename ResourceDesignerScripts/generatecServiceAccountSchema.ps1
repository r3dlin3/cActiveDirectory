$properties = @()
$properties += New-xDscResourceProperty -Name Ensure -Type String -Attribute Write -ValidateSet "Present", "Absent"
$properties += New-xDscResourceProperty -Name Name -Type String -Attribute Key
$properties += New-xDscResourceProperty -Name DNSName -Type String -Attribute Required
$properties += New-xDscResourceProperty -Name SPNs -Type String[] -Attribute Write
$properties += New-xDscResourceProperty -Name PrincipalsAllowedToRetrieveManagedPassword -Type String[] -Attribute Write
$properties += New-xDscResourceProperty -Name PrincipalsAllowedToRetrieveManagedPasswordToInclude -Type String[] -Attribute Write
$properties += New-xDscResourceProperty -Name PrincipalsAllowedToRetrieveManagedPasswordToExclude -Type String[] -Attribute Write

New-xDscResource -ModuleName "cActiveDirectory" -Name cServiceAccount -FriendlyName cServiceAccount -Force -Property $properties -Path  'C:\Program Files\WindowsPowerShell\Modules' -verbose -ClassVersion 1.0 
