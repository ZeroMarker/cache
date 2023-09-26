///     
Class dbo.BTTestSetOGTTGroupLinks Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetOGTTGroupLinks, StorageStrategy = Default ]
{

Index IndexMaster On SubTestSetDR [ SqlName = Index_Master, Type = index, Unique ];

Index IndexMainTestSet On (MainTestSetDR, SubTestSetDR) [ SqlName = Index_MainTestSet, Type = index ];

Index IndexSubTestSet On (SubTestSetDR, MainTestSetDR) [ SqlName = Index_SubTestSet, Type = index ];

Index IndexSubTestSetOGTTGroup On (SubTestSetDR, TestSetOGTTGroupDR) [ SqlName = Index_SubTestSetOGTTGroup, Type = index, Unique ];

Index IndexTestSetOGTTGroupDR On (TestSetOGTTGroupDR, MainTestSetDR, SubTestSetDR) [ SqlName = Index_TestSetOGTTGroupDR, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTestSetOGTTGroupLinks On RowID [ PrimaryKey, SqlName = PK_BT_TestSetOGTTGroupLinks, Type = index, Unique ];

/// Foreign Key FKBTTestSetOGTTGroupLinksBTTestSet created via DDL
ForeignKey FKBTTestSetOGTTGroupLinksBTTestSet(MainTestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BT_TestSetOGTTGroupLinks_BT_TestSet ];

/// Foreign Key FKBTTestSetOGTTGroupLinksBTTestSet1 created via DDL
ForeignKey FKBTTestSetOGTTGroupLinksBTTestSet1(SubTestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BT_TestSetOGTTGroupLinks_BT_TestSet1 ];

/// Foreign Key FKBTTestSetOGTTGroupLinksBTTestSetOGTTGroup created via DDL
ForeignKey FKBTTestSetOGTTGroupLinksBTTestSetOGTTGroup(TestSetOGTTGroupDR) References dbo.BTTestSetOGTTGroup(PKBTTestSetOGTTGroup) [ SqlName = FK_BT_TestSetOGTTGroupLinks_BT_TestSetOGTTGroup ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetOGTTGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property MainTestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SubTestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTTestSetOGTTGroupLinksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetOGTTGroupDR</Value>
</Value>
<Value name="3">
<Value>MainTestSetDR</Value>
</Value>
<Value name="4">
<Value>SubTestSetDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetOGTTGroupLinksD</DataLocation>
<DefaultData>BTTestSetOGTTGroupLinksDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestSetOGTTGroupLinksD</IdLocation>
<IndexLocation>^dbo.BTTestSetOGTTGroupLinksI</IndexLocation>
<StreamLocation>^dbo.BTTestSetOGTTGroupLinksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
