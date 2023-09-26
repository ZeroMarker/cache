Class dbo.BTTestSetPrintGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetPrintGroup ]
{

/// DDL Primary Key Specification
Index PKBTTESTSETPRINTGROUP On RowID [ PrimaryKey, SqlName = PK_BT_TestSetPrintGroup, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property GroupStr As %Library.String(COLLATION = "Exact", MAXLEN = 3000) [ SqlColumnNumber = 3 ];

Property LinkType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTTestSetPrintGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupStr</Value>
</Value>
<Value name="3">
<Value>LinkType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetPrintGroupD</DataLocation>
<DefaultData>BTTestSetPrintGroupDefaultData</DefaultData>
<IdLocation>^dbo.BTTestSetPrintGroupD</IdLocation>
<IndexLocation>^dbo.BTTestSetPrintGroupI</IndexLocation>
<StreamLocation>^dbo.BTTestSetPrintGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
