///     
Class dbo.BTMCMethodResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_MethodResult ]
{

/// Foreign Key FKBTMCMethodResultMCMethodDR created via DDL
ForeignKey FKBTMCMethodResultMCMethodDR(MCMethodDR) References dbo.BTMCMethod(PKBTMCMETHOD) [ SqlName = FK_BTMCMethodResultMCMethodDR ];

Index IndexMaster On (MCMethodDR, Sequence) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBTMCMETHODRESULT On RowID [ PrimaryKey, SqlName = PK_BTMC_METHODRESULT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MCMethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTMCMethodResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MCMethodDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCMethodResultD</DataLocation>
<DefaultData>BTMCMethodResultDefaultData</DefaultData>
<IdLocation>^dbo.BTMCMethodResultD</IdLocation>
<IndexLocation>^dbo.BTMCMethodResultI</IndexLocation>
<StreamLocation>^dbo.BTMCMethodResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
