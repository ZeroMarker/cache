///     
Class dbo.BTWorkGroupTSGroupTS Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WorkGroupTSGroupTS ]
{

/// Foreign Key FKBTWorkGroupTSGroupTSBTWorkGroupTSGroupDR created via DDL
ForeignKey FKBTWorkGroupTSGroupTSBTWorkGroupTSGroupDR(BTWorkGroupTSGroupDR) References dbo.BTWorkGroupTSGroup(PKBTWORKGROUPTSGROUP) [ SqlName = FK_BTWorkGroupTSGroupTSBTWorkGroupTSGroupDR ];

/// Foreign Key FKBTWorkGroupTSGroupTSTestSetDR created via DDL
ForeignKey FKBTWorkGroupTSGroupTSTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTWorkGroupTSGroupTSTestSetDR ];

Index IndexMaster On (BTWorkGroupTSGroupDR, TestSetDR) [ SqlName = IndexMaster, Type = index ];

Index IndexTestSet On (TestSetDR, BTWorkGroupTSGroupDR) [ SqlName = IndexTestSet, Type = index ];

/// DDL Primary Key Specification
Index PKBTWORKGROUPTSGROUPTS On RowID [ PrimaryKey, SqlName = PK_BT_WORKGROUPTSGROUPTS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BTWorkGroupTSGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTWorkGroupTSGroupTSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTWorkGroupTSGroupDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWorkGroupTSGroupTSD</DataLocation>
<DefaultData>BTWorkGroupTSGroupTSDefaultData</DefaultData>
<IdLocation>^dbo.BTWorkGroupTSGroupTSD</IdLocation>
<IndexLocation>^dbo.BTWorkGroupTSGroupTSI</IndexLocation>
<StreamLocation>^dbo.BTWorkGroupTSGroupTSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
