<# 
	This PowerShell script was automatically converted to PowerShell Workflow so it can be run as a runbook.
	Specific changes that have been made are marked with a comment starting with “Converter:”
#>
#AzureReports DB Connection Info
workflow bryanlongsqldemo {
	
	# Converter: Wrapping initial script in an InlineScript activity, and passing any parameters for use within the InlineScript
	# Converter: If you want this InlineScript to execute on another host rather than the Automation worker, simply add some combination of -PSComputerName, -PSCredential, -PSConnectionURI, or other workflow common parameters (http://technet.microsoft.com/en-us/library/jj129719.aspx) as parameters of the InlineScript
	inlineScript {
		$connectionstring="Server=tcp:bryanlongsql1.database.windows.net,1433;Initial Catalog=bryanlongvgdemo;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
		$myCredential=Get-AutomationPSCredential -Name 'vgdemosql'
		$SQLUser= $myCredential.UserName
		($SQLUserPassword= $myCredential.Password).MakeReadOnly()
		$query="Select * from test"
		$Connection=New-Object System.Data.SQLClient.SQLConnection
		$connection.ConnectionString = $connectionstring
		$sqlcred=New-Object -TypeName System.Data.SqlClient.SqlCredential($SQLUser, $SQLUserPassword)
		$connection.Credential = $sqlCred
		$connection.Open()
		$command = $connection.CreateCommand()
		$command.CommandText = $query
		$result = $command.ExecuteReader()
		$connection.Close()
	}
}