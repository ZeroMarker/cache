///     
Class dbo.SYSBusinessLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_BusinessLog, StorageStrategy = Default ]
{

Index IndexAction On (Action, AddDate, ObjectType) [ SqlName = Index_Action, Type = index ];

Index IndexDateTime On (ObjectType, ObjectID, AddDate, AddTime) [ SqlName = Index_DateTime, Type = index ];

Index IndexUser On (AddUserDR, AddDate, ObjectType) [ SqlName = Index_User, Type = index ];

/// DDL Primary Key Specification
Index PKSYSBUSINESSLOG On RowID [ PrimaryKey, SqlName = PK_SYS_BUSINESSLOG, Type = index, Unique ];

/// Foreign Key FKBusinessLogUser created via DDL
ForeignKey FKBusinessLogUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BusinessLogUser ];

Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

Property ObjectType As %Library.String(COLLATION = "Exact", MAXLEN = 32) [ Required, SqlColumnNumber = 3 ];

Property ObjectID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property Action As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

Property LogData As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 6 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property ClientIPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

Property ActionDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="SYSBusinessLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ObjectType</Value>
</Value>
<Value name="3">
<Value>ObjectID</Value>
</Value>
<Value name="4">
<Value>Action</Value>
</Value>
<Value name="5">
<Value>LogData</Value>
</Value>
<Value name="6">
<Value>AddDate</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>AddUserDR</Value>
</Value>
<Value name="9">
<Value>ClientIPAddress</Value>
</Value>
<Value name="10">
<Value>ActionDesc</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSBusinessLogD</DataLocation>
<DefaultData>SYSBusinessLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSBusinessLogD</IdLocation>
<IndexLocation>^dbo.SYSBusinessLogI</IndexLocation>
<StreamLocation>^dbo.SYSBusinessLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
