workflow bryanlongsqldemo {
	inlineScript {
		$connectionstring="Server=tcp:bryanlongsql1.database.windows.net,1433;Initial Catalog=bryanlongvgdemo;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
		$myCredential=Get-AutomationPSCredential -Name 'vgdemosql'
		$SQLUser= $myCredential.UserName
		($SQLUserPassword= $myCredential.Password).MakeReadOnly()
		$query="Select * from test"
        $query2="ALTER TABLE [bryanlongvgdemo].[dbo].[test] ALTER COLUMN [DueDate] varchar(200) NOT NULL"
		$Connection=New-Object System.Data.SQLClient.SQLConnection
		$connection.ConnectionString = $connectionstring
		$sqlcred=New-Object -TypeName System.Data.SqlClient.SqlCredential($SQLUser, $SQLUserPassword)
		$connection.Credential = $sqlCred
		$connection.Open()
		$command=$connection.CreateCommand()
		$command.CommandText=$query
		$command.ExecuteReader()
        $command.CommandText=$query2
		$command.ExecuteReader()
		$connection.Close()
	}
}