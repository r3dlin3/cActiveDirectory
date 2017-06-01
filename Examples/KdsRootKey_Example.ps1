Configuration Example {
    Import-DscResource -ModuleName cActiveDirectory

    node localhost {
        KdsRootKey AD {
            Ensure = "Present"
        }

    }
}
Example -OutputPath $env:TEMP
Start-DscConfiguration -ComputerName localhost -Path $env:TEMP -Wait -Verbose