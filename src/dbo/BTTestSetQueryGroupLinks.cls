Class dbo.BTTestSetQueryGroupLinks Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetQueryGroupLinks ]
{

Index IndexMaster On (TestSetQueryGroupDR, TestSetDR) [ SqlName = IndexMaster, Type = index, Unique ];

Index IndexTestSet On (TestSetDR, TestSetQueryGroupDR) [ SqlName = Index_TestSet, Type = index ];

/// DDL Primary Key Specification
Index PKBTTestSetGroupLinks On RowID [ PrimaryKey, SqlName = PK_BT_TestSetGroupLinks, Type = index, Unique ];

/// Foreign Key FKTestSetGroupLinks created via DDL
ForeignKey FKTestSetQueryGroupLinks(TestSetQueryGroupDR) References dbo.BTTestSetQueryGroup(PKBTTestSetQueryGroup) [ SqlName = FK_TestSetGroupLinks ];

/// Foreign Key FKTestSetGroupLinksTS created via DDL
ForeignKey FKTestSetGroupLinksTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSetGroupLinksTS ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetQueryGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTTestSetQueryGroupLinksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetQueryGroupDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetQueryGroupLinksD</DataLocation>
<DefaultData>BTTestSetQueryGroupLinksDefaultData</DefaultData>
<IdLocation>^dbo.BTTestSetQueryGroupLinksD</IdLocation>
<IndexLocation>^dbo.BTTestSetQueryGroupLinksI</IndexLocation>
<StreamLocation>^dbo.BTTestSetQueryGroupLinksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
