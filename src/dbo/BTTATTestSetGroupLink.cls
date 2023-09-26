///     
Class dbo.BTTATTestSetGroupLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATTestSetGroupLink, StorageStrategy = Default ]
{

/// Foreign Key FKTATTestCodeGroupLinkTestSet created via DDL
ForeignKey FKTATTestCodeGroupLinkTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TATTestCodeGroupLinkTestSet ];

/// Foreign Key FKTATTestSetGroupLinkTestSet created via DDL
ForeignKey FKTATTestSetGroupLinkTestSet(TestSetGroupDR) References dbo.BTTATTestSetGroup(PKBTTATTESTSETGROUP) [ SqlName = FK_TATTestSetGroupLinkTestSet ];

Index IndexCode On (TestSetGroupDR, Sequence) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexTestSet On (TestSetDR, TestSetGroupDR) [ SqlName = Index_TestSet, Type = index ];

/// DDL Primary Key Specification
Index PKBTTATTESTSETGROUPLINK On RowID [ PrimaryKey, SqlName = PK_BT_TATTESTSETGROUPLINK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTTATTestSetGroupLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetGroupDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTATTestSetGroupLinkD</DataLocation>
<DefaultData>BTTATTestSetGroupLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTATTestSetGroupLinkD</IdLocation>
<IndexLocation>^dbo.BTTATTestSetGroupLinkI</IndexLocation>
<StreamLocation>^dbo.BTTATTestSetGroupLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
