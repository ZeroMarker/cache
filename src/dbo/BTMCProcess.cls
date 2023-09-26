///     
Class dbo.BTMCProcess Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_Process, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTMCPROCESS On RowID [ PrimaryKey, SqlName = PK_BTMC_PROCESS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 5 ];

Property ProcessType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ InitialExpression = 1, SqlColumnNumber = 8 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 4) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTMCProcessDefaultData">
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
<Value>ProcessType</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCProcessD</DataLocation>
<DefaultData>BTMCProcessDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMCProcessD</IdLocation>
<IndexLocation>^dbo.BTMCProcessI</IndexLocation>
<StreamLocation>^dbo.BTMCProcessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
