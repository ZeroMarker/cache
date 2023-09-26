///     
Class dbo.SYSTask Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_Task, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKSYSTASK On RowID [ PrimaryKey, SqlName = PK_SYS_TASK, Type = index, Unique ];

/// Foreign Key SystemTaskUser created via DDL
ForeignKey SystemTaskUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = SystemTaskUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property ProgName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property ClassName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property MethodName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 8 ];

Property InParam As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 9 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property ExecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property ExecRate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="SYSTaskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>ProgName</Value>
</Value>
<Value name="6">
<Value>ClassName</Value>
</Value>
<Value name="7">
<Value>MethodName</Value>
</Value>
<Value name="8">
<Value>InParam</Value>
</Value>
<Value name="9">
<Value>StartDate</Value>
</Value>
<Value name="10">
<Value>EndDate</Value>
</Value>
<Value name="11">
<Value>ExecTime</Value>
</Value>
<Value name="12">
<Value>ExecRate</Value>
</Value>
<Value name="13">
<Value>AddDate</Value>
</Value>
<Value name="14">
<Value>AddTime</Value>
</Value>
<Value name="15">
<Value>AddUserDR</Value>
</Value>
<Value name="16">
<Value>Sequence</Value>
</Value>
<Value name="17">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSTaskD</DataLocation>
<DefaultData>SYSTaskDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSTaskD</IdLocation>
<IndexLocation>^dbo.SYSTaskI</IndexLocation>
<StreamLocation>^dbo.SYSTaskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
