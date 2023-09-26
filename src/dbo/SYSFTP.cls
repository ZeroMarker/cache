///     
Class dbo.SYSFTP Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_FTP, StorageStrategy = Default ]
{

/// Foreign Key FKUploaderSYSFTP created via DDL
ForeignKey FKUploaderSYSFTP(UploaderDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_UploaderSYSFTP ];

Index IndexFileName On FileName [ SqlName = Index_FileName, Type = index ];

Index IndexMaster On (BusinessType, Path) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexUploadDate On UploadDate [ SqlName = Index_UploadDate, Type = index ];

Index IndexUploader On UploaderDR [ SqlName = Index_Uploader, Type = index ];

/// DDL Primary Key Specification
Index PKSYSFTP On RowID [ PrimaryKey, SqlName = PK_SYS_FTP, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property BusinessType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ InitialExpression = "OTH", Required, SqlColumnNumber = 3 ];

Property Path As %Library.String(COLLATION = "Exact", MAXLEN = 260) [ Required, SqlColumnNumber = 4 ];

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

Property Size As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property IsRemoved As %Library.Boolean [ InitialExpression = 0, Required, SqlColumnNumber = 7 ];

Property UploaderDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property UploadDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property UploadTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Storage Default
{
<Data name="SYSFTPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BusinessType</Value>
</Value>
<Value name="3">
<Value>Path</Value>
</Value>
<Value name="4">
<Value>FileName</Value>
</Value>
<Value name="5">
<Value>Size</Value>
</Value>
<Value name="6">
<Value>IsRemoved</Value>
</Value>
<Value name="7">
<Value>UploaderDR</Value>
</Value>
<Value name="8">
<Value>UploadDate</Value>
</Value>
<Value name="9">
<Value>UploadTime</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSFTPD</DataLocation>
<DefaultData>SYSFTPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSFTPD</IdLocation>
<IndexLocation>^dbo.SYSFTPI</IndexLocation>
<StreamLocation>^dbo.SYSFTPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
