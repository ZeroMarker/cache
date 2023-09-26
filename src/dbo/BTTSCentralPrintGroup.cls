///     
Class dbo.BTTSCentralPrintGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TSCentralPrintGroup ]
{

/// DDL Primary Key Specification
Index PKBTTSCENTRALPRINTGROUP On RowID [ PrimaryKey, SqlName = PK_BT_TSCENTRALPRINTGROUP, Type = index, Unique ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTTSCentralPrintGroupDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTSCentralPrintGroupD</DataLocation>
<DefaultData>BTTSCentralPrintGroupDefaultData</DefaultData>
<IdLocation>^dbo.BTTSCentralPrintGroupD</IdLocation>
<IndexLocation>^dbo.BTTSCentralPrintGroupI</IndexLocation>
<StreamLocation>^dbo.BTTSCentralPrintGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
