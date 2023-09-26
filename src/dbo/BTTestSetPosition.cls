///     
Class dbo.BTTestSetPosition Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetPosition ]
{

Index IndexMaster On (TestSetDR, Sequence, Position) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKBTTestSetPositionTestSetDR created via DDL
ForeignKey FKBTTestSetPositionTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTTestSetPositionTestSetDR ];

/// DDL Primary Key Specification
Index PKBTTESTSETPOSITION On RowID [ PrimaryKey, SqlName = PK_BT_TESTSETPOSITION, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property Position As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 4 ];

Property Num As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTTestSetPositionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>Position</Value>
</Value>
<Value name="4">
<Value>Num</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetPositionD</DataLocation>
<DefaultData>BTTestSetPositionDefaultData</DefaultData>
<IdLocation>^dbo.BTTestSetPositionD</IdLocation>
<IndexLocation>^dbo.BTTestSetPositionI</IndexLocation>
<StreamLocation>^dbo.BTTestSetPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
