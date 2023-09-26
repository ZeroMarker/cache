/// 排样规则医嘱分堆医嘱明细 表
Class dbo.BTSmartEpisTSGroupLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SmartEpisTSGroupLink ]
{

/// Foreign Key FKBTSmartEpisTSGroupLinkBTTestSet created via DDL
ForeignKey FKBTSmartEpisTSGroupLinkBTTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTSmartEpisTSGroupLinkBTTestSet ];

/// Foreign Key FKBTSmartEpisTSGroupLinkWorkGroupDR created via DDL
ForeignKey FKBTSmartEpisTSGroupLinkWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTSmartEpisTSLinkGroupWorkGroupDR ];

/// Foreign Key FKBTSmartEpisTSGroupLinkSmartEpisTSGroupDR created via DDL
ForeignKey FKBTSmartEpisTSGroupLinkSmartEpisTSGroupDR(SmartEpisTSGroupDR) References dbo.BTSmartEpisTSGroup(PKBTSmartEpisTSGroup) [ SqlName = FK_BTSmartEpisTSLinkGroupSmartEpisTSGroupDR ];

Index IndexMaster On (WorkGroupDR, TestSetDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTestSet On (TestSetDR, WorkGroupDR) [ SqlName = Index_TestSet, Type = index ];

/// DDL Primary Key Specification
Index PKBTSmartEpisTSGroupLink On RowID [ PrimaryKey, SqlName = PK_BT_SmartEpisTSGroupLink, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 医嘱
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 医嘱分堆
Property SmartEpisTSGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTSmartEpisTSGroupLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>SmartEpisTSGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSmartEpisTSGroupLinkD</DataLocation>
<DefaultData>BTSmartEpisTSGroupLinkDefaultData</DefaultData>
<IdLocation>^dbo.BTSmartEpisTSGroupLinkD</IdLocation>
<IndexLocation>^dbo.BTSmartEpisTSGroupLinkI</IndexLocation>
<StreamLocation>^dbo.BTSmartEpisTSGroupLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
