Class dbo.BTTestCodePrintLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodePrintLink ]
{

/// Foreign Key FKTestCodePrintLink created via DDL
ForeignKey FKTestCodePrintLink(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodePrintLink ];

/// Foreign Key FKTestCodePrintLinkLink created via DDL
ForeignKey FKTestCodePrintLinkLink(LinkTestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodePrintLinkLink ];

Index IndexMaster On (TestCodeDR, LinkTestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexLink On (LinkTestCodeDR, TestCodeDR) [ SqlName = Index_Link, Type = index ];

/// DDL Primary Key Specification
Index PKBTTESTCODEPRINTLINK On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODEPRINTLINK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LinkTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SplitStr As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTTestCodePrintLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>LinkTestCodeDR</Value>
</Value>
<Value name="4">
<Value>SplitStr</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodePrintLinkD</DataLocation>
<DefaultData>BTTestCodePrintLinkDefaultData</DefaultData>
<IdLocation>^dbo.BTTestCodePrintLinkD</IdLocation>
<IndexLocation>^dbo.BTTestCodePrintLinkI</IndexLocation>
<StreamLocation>^dbo.BTTestCodePrintLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
