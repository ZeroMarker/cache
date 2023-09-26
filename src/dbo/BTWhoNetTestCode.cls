///     
Class dbo.BTWhoNetTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WhoNetTestCode ]
{

/// Foreign Key FKBTWhoNetTestCodeTestCodeDR created via DDL
ForeignKey FKBTWhoNetTestCodeTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTWhoNetTestCodeTestCodeDR ];

Index IndexTestCode On TestCodeDR [ SqlName = Index_TestCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTWHONETTESTCODE On RowID [ PrimaryKey, SqlName = PK_BT_WHONETTESTCODE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property WhoCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property IsWhoNet As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTWhoNetTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
<Value name="4">
<Value>WhoCode</Value>
</Value>
<Value name="5">
<Value>IsWhoNet</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWhoNetTestCodeD</DataLocation>
<DefaultData>BTWhoNetTestCodeDefaultData</DefaultData>
<IdLocation>^dbo.BTWhoNetTestCodeD</IdLocation>
<IndexLocation>^dbo.BTWhoNetTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTWhoNetTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
