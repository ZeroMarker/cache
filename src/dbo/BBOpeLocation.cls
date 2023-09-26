Class dbo.BBOpeLocation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_OpeLocation ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBOpeLocation On RowID [ PrimaryKey, SqlName = PK_BB_OpeLocation, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBOpeLocationDefaultData">
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
<DataLocation>^dbo.BBOpeLocationD</DataLocation>
<DefaultData>BBOpeLocationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBOpeLocationD</IdLocation>
<IndexLocation>^dbo.BBOpeLocationI</IndexLocation>
<StreamLocation>^dbo.BBOpeLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
