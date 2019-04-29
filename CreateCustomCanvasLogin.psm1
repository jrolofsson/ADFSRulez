function CreateCustomCanvasLogin {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true )]
        [String]$CustomLoginName,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true )]
        [String]$StaffSID,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true )]
        [String]$StaffSIS,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true )]
        [String]$StudentSID,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true )]
        [String]$StudentSIS
    )

    try 
    {
        # Export Path
        $ExportPath = ".\CustomCanvasLogin.csv"

        $customClaimRulesStudent = '@RuleName = "StudentToCanvasLogin"
        c1:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid", Value == "'+$StudentSID+'", Issuer == "AD AUTHORITY"]
        && c2:[Type == "'+$StudentSID+'"]
        => issue(Type = "'+$CustomLoginName+'", Value = c2.Value, Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");'

        $customClaimRulesStaff = '@RuleName = "StaffToCanvasLogin"
        c1:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid", Value == "'+$StaffSID+'", Issuer == "AD AUTHORITY"]
        && c2:[Type == "'+$StaffSIS+'"]
        => issue(Type = "'+$CustomLoginName+'", Value = c2.Value, Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");' 

        $customClaimRulesStudent +"`n`n"+ $customClaimRulesStaff | Out-File -Path $ExportPath
        
        Write-Host "Created ADFS custom claim rule"
    }
    catch [System.Exception]
    {
        Write-Error "Something went wrong when creating the file"
    }
    

}