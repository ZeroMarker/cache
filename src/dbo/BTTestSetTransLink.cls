Class dbo.BTTestSetTransLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetTransLink, StorageStrategy = Default ]
{

Index IndexTestSet On (TestSetDR, WorkGroupDR) [ SqlName = IndexTestSet, Type = index, Unique ];

Index IndexMaster On (TestSetDR, WorkGroupDR, TransTestSetDR) [ SqlName = Index_Master, Type = index ];

ForeignKey FKBTTestSetTransLinkBTTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTTestSetTransLinkBTTestSet ];

ForeignKey FKBTTestSetTransLinkWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTTestSetTransLinkWorkGroup ];

ForeignKey FKBTTestSetTransLinkTranTestSet(TransTestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTTestSetTransLinkTranTestSet ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TransTestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTTestSetTransLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupDR</Value>
</Value>
<Value name="4">
<Value>TransTestSetDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetTransLinkD</DataLocation>
<DefaultData>BTTestSetTransLinkDefaultData</DefaultData>
<IdLocation>^dbo.BTTestSetTransLinkD</IdLocation>
<IndexLocation>^dbo.BTTestSetTransLinkI</IndexLocation>
<StreamLocation>^dbo.BTTestSetTransLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
