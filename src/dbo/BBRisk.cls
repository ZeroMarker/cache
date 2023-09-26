///     
Class dbo.BBRisk Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_Risk, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBRISK On RowID [ PrimaryKey, SqlName = PK_BB_RISK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBRiskDefaultData">
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
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBRiskD</DataLocation>
<DefaultData>BBRiskDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBRiskD</IdLocation>
<IndexLocation>^dbo.BBRiskI</IndexLocation>
<StreamLocation>^dbo.BBRiskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}