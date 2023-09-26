///     
Class dbo.BTTATTestCodeGroupLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATTestCodeGroupLink, StorageStrategy = Default ]
{

/// Foreign Key FKTATTestCodeGroupLinkGroup created via DDL
ForeignKey FKTATTestCodeGroupLinkGroup(TestCodeGroupDR) References dbo.BTTATTestCodeGroup(PKBTTATTESTCODEGROUP) [ SqlName = FK_TATTestCodeGroupLinkGroup ];

/// Foreign Key FKTATTestCodeGroupLinkTc created via DDL
ForeignKey FKTATTestCodeGroupLinkTc(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TATTestCodeGroupLinkTc ];

Index IndexCode On (TestCodeGroupDR, Sequence) [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTATTESTCODEGROUPLINK On RowID [ PrimaryKey, SqlName = PK_BT_TATTESTCODEGROUPLINK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property OperatorCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Property FindResult As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

Property Logical As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

Property ResultType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTTATTestCodeGroupLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeGroupDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>OperatorCode</Value>
</Value>
<Value name="7">
<Value>FindResult</Value>
</Value>
<Value name="8">
<Value>Logical</Value>
</Value>
<Value name="9">
<Value>ResultType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTATTestCodeGroupLinkD</DataLocation>
<DefaultData>BTTATTestCodeGroupLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTATTestCodeGroupLinkD</IdLocation>
<IndexLocation>^dbo.BTTATTestCodeGroupLinkI</IndexLocation>
<StreamLocation>^dbo.BTTATTestCodeGroupLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
