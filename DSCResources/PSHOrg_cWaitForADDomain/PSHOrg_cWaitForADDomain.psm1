function Get-TargetResource
{
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[Parameter(Mandatory)]
		[String]$DomainName,

		[Parameter(Mandatory)]
		[PSCredential]$DomainUserCredential,

		[UInt64]$RetryIntervalSec = 10,

		[UInt32]$RetryCount = 5
	)

	$returnValue = @{
		Name = $Name
        DomainUserCredential = $DomainUserCredential.UserName
		RetryIntervalSec = $RetryIntervalSec
		RetryCount = $RetryCount
	}
	$returnValue
}


function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[String]$DomainName,

		[Parameter(Mandatory)]
		[PSCredential]$DomainUserCredential,

		[UInt64]$RetryIntervalSec = 10,

		[UInt32]$RetryCount = 5
	)

    $domainFound = $false
    Write-Verbose -Message "Checking for domain $Name ..."

    for($count = 0; $count -lt $RetryCount; $count++)
    {
        try
        {
            $domain = Get-ADDomain -Identity $DomainName -Credential $DomainUserCredential
            Write-Verbose -Message "Found domain $DomainName"
            $domainFound = $true
            break;
        }
        Catch
        {
            Write-Verbose -Message "Domain $DomainName not found. Will retry again after $RetryIntervalSec sec"
            Start-Sleep -Seconds $RetryIntervalSec
        }
    }

    if(! $domainFound) {throw "Domain $DomainName not found after $count attempts with $RetryIntervalSec sec interval"}
}

function Test-TargetResource
{
	[OutputType([System.Boolean])]
	param
	(
		[Parameter(Mandatory)]
		[String]$DomainName,

		[Parameter(Mandatory)]
		[PSCredential]$DomainUserCredential,

		[UInt64]$RetryIntervalSec = 10,

		[UInt32]$RetryCount = 5
	)

    Write-Verbose -Message "Checking for domain $Name ..."
    try
    {
        $domain = Get-ADDomain -Identity $DomainName -Credential $DomainUserCredential
        Write-Verbose -Message "Found domain $DomainName"
        $true
    }
    Catch
    {
        Write-Verbose -Message "Domain $DomainName not found"
        $false
    }
}
