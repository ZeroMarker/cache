///     
Class dbo.BTTestSetGroupLinks Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetGroupLinks, StorageStrategy = Default ]
{

Index IndexMaster On (TestSetGroupDR, TestSetDR) [ SqlName = IndexMaster, Type = index, Unique ];

Index IndexTestSet On (TestSetDR, TestSetGroupDR) [ SqlName = Index_TestSet, Type = index ];

/// DDL Primary Key Specification
Index PKBTTestSetGroupLinks On RowID [ PrimaryKey, SqlName = PK_BT_TestSetGroupLinks, Type = index, Unique ];

/// Foreign Key FKTestSetGroupLinks created via DDL
ForeignKey FKTestSetGroupLinks(TestSetGroupDR) References dbo.BTTestSetGroup(PKBTTestSetGroup) [ SqlName = FK_TestSetGroupLinks ];

/// Foreign Key FKTestSetGroupLinksTS created via DDL
ForeignKey FKTestSetGroupLinksTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSetGroupLinksTS ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTTestSetGroupLinksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetGroupDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetGroupLinksD</DataLocation>
<DefaultData>BTTestSetGroupLinksDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestSetGroupLinksD</IdLocation>
<IndexLocation>^dbo.BTTestSetGroupLinksI</IndexLocation>
<StreamLocation>^dbo.BTTestSetGroupLinksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
