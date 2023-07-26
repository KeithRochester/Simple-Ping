[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True)]
	[string]$DisplayName,
	[Parameter(Mandatory = $True)]
	[String]$Address,
	[Parameter(Mandatory = $True)]
    [ValidateSet("UP","DOWN")]
	[String]$ExpectedStatus,    
	[Parameter(Mandatory = $false)]
	[String]$ManagementServer = '.'

)

<#
$DisplayName = "Testing"
$Address = '127.0.0.1'
$ExpectedStatus = "UP"
$MatchCount = 1
$FrequencySeconds = 300
$ManagementServer = '.'
#>

Add-PSSnapin Microsoft.EnterpriseManagement.OperationsManager.Client
New-SCOMManagementGroupConnection -ComputerName $ManagementServer
$MG = Get-SCOMManagementGroup


$EntityClass = Get-SCOMClass -Name System.Entity
$PingTargetClass = Get-SCOMClass -Name Simple.Ping.Target

$Connector = Get-SCOMConnector -DisplayName "Simple Ping Connector"
if(!$Connector){
    Add-SCOMConnector -Name "Simple Ping Connector" -DisplayName "Simple Ping Connector" -Description "Connector used to submit discovery data"
    $Connector = Get-SCOMConnector -DisplayName "Simple Ping Connector"
    }


$DiscoveryData = New-Object Microsoft.EnterpriseManagement.ConnectorFramework.IncrementalDiscoveryData

$PingTarget = New-Object Microsoft.EnterpriseManagement.Common.CreatableEnterpriseManagementObject($mg,$PingTargetClass)

$PingTarget[$PingTargetClass,"Address"].Value = $Address
$PingTarget[$PingTargetClass,"ExpectedStatus"].Value = $ExpectedStatus
$PingTarget[$EntityClass,"DisplayName"].Value = $DisplayName

$DiscoveryData.Remove($PingTarget)
$DiscoveryData.Commit($Connector)