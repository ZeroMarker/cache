Class dbo.BTHandTestSetGroupLinks Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_HandTestSetGroupLinks, StorageStrategy = Default ]
{

Index IndexMaster On (HandTestSetGroupDR, TestSetDR) [ SqlName = IndexMaster, Type = index, Unique ];

Index IndexTestSet On (TestSetDR, HandTestSetGroupDR) [ SqlName = Index_TestSet, Type = index ];

/// DDL Primary Key Specification
Index PKBTHandTestSetGroupLinks On RowID [ PrimaryKey, SqlName = PK_BT_HandTestSetGroupLinks, Type = index, Unique ];

/// Foreign Key FKHandTestSetGroupLinks created via DDL
ForeignKey FKHandTestSetGroupLinks(HandTestSetGroupDR) References dbo.BTHandTestSetGroup(PKBTHandTestSetGroup) [ SqlName = FK_HandTestSetGroupLinks ];

/// Foreign Key FKHTestSetGroupLinksTS created via DDL
ForeignKey FKHandTestSetGroupLinksTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_HandTestSetGroupLinksTS ];

/// RowID
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 组合套
Property HandTestSetGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 医嘱
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTHandTestSetGroupLinksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HandTestSetGroupDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTHandTestSetGroupLinksD</DataLocation>
<DefaultData>BTHandTestSetGroupLinksDefaultData</DefaultData>
<IdLocation>^dbo.BTHandTestSetGroupLinksD</IdLocation>
<IndexLocation>^dbo.BTHandTestSetGroupLinksI</IndexLocation>
<StreamLocation>^dbo.BTHandTestSetGroupLinksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
