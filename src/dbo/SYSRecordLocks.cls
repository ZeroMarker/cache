///     
Class dbo.SYSRecordLocks Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_RecordLocks, StorageStrategy = Default ]
{

Index IndexDataMaster On (RecordType, RecordNo) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index IndexDateTime On (AddDate, AddTime) [ SqlName = Index_DateTime, Type = index ];

/// DDL Primary Key Specification
Index PKSYSRECORDLOCKS On RowID [ PrimaryKey, SqlName = PK_SYS_RECORDLOCKS, Type = index, Unique ];

/// Foreign Key FKSystemLocsUser created via DDL
ForeignKey FKSystemLocsUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_SystemLocsUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property RecordType As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property RecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 2147483647) [ Required, SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property ClientIPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="SYSRecordLocksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordType</Value>
</Value>
<Value name="3">
<Value>RecordNo</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>ClientIPAddress</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSRecordLocksD</DataLocation>
<DefaultData>SYSRecordLocksDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSRecordLocksD</IdLocation>
<IndexLocation>^dbo.SYSRecordLocksI</IndexLocation>
<StreamLocation>^dbo.SYSRecordLocksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
