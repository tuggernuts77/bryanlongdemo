$connectionName = "AzureRunAsConnection"
try {
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         
        "Logging in to Azure..."
        Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch 
    {
        if (!$servicePrincipalConnection){
            $ErrorMessage = "Connection $connectionName not found."
            throw $ErrorMessage
        }       
        else {
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
}
#######################################################################################################################
#Get CSV
$resourceGroup="BryanLong"
$storageAccountName="bryanlongsa1"
$storageAccount=Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup `
                                          -Name $storageAccountName
$ctx=$storageAccount.Context
$csvpath=".\"
$containername="sqlcsv"
$blobname="file.csv"
Get-AzureStorageBlobContent -Blob $blobname `
                            -Container $containername `
                            -Destination $csvpath `
                            -Context $ctx `

Import-CSV ".\file.csv" | ForEach-Object {
    $a=$_.PurchaseOrderID
    $b=$_.LineNumber
    $c=$_.ProductID
    $d=$_.UnitPrice
    $e=$_.OrderQty
    $f=$_.ReceivedQty
    $g=$_.RejectedQty
    $h=$_.DueDate
    $table="test"
	$connectionstring="Server=tcp:bryanlongsql1.database.windows.net,1433;Initial Catalog=bryanlongvgdemo;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
	$myCredential=Get-AutomationPSCredential -Name 'vgdemosql'
	$SQLUser= $myCredential.UserName
	($SQLUserPassword= $myCredential.Password).MakeReadOnly()
	$query="Select * from test"
    $query2="INSERT INTO $table VALUES ('$a','$b','$c','$d','$e','$f','$g','$h')"
	$Connection=New-Object System.Data.SQLClient.SQLConnection
	$connection.ConnectionString = $connectionstring
	$sqlcred=New-Object -TypeName System.Data.SqlClient.SqlCredential($SQLUser, $SQLUserPassword)
	$connection.Credential = $sqlCred
	$connection.Open()
	$command=$connection.CreateCommand()
	$command.CommandText=$query
	$command.ExecuteReader()
	$connection.Close()
    $connection.Open()
    $command=$connection.CreateCommand()
	$command.CommandText=$query2
	$command.ExecuteReader()
    $connection.Close()
}