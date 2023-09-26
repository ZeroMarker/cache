/// 排样规则关联子工作小组及组合套 表
Class dbo.BTSmartEpisWGMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SmartEpisWGMachine ]
{

/// Foreign Key FKBTSmartEpisWGMachineBTTestSet created via DDL
ForeignKey FKBTSmartEpisWGMachineBTTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTSmartEpisWGMachineBTTestSet ];

/// Foreign Key FKBTSmartEpisWGMachineBTSmartEpis created via DDL
ForeignKey FKBTSmartEpisWGMachineBTSmartEpis(SmartEpisDR) References dbo.BTSmartEpis(PKBTSmartEpis) [ SqlName = FK_BTSmartEpisWGMachineBTSmartEpis ];

/// Foreign Key FKBTSmartEpisWGMachineWorkGroupMachineDR created via DDL
ForeignKey FKBTSmartEpisWGMachineWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_BTSmartEpisWGMachineWorkGroupMachineDR ];

Index IndexMaster On (SmartEpisDR, TestSetDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSmartEpisWGMachine On RowID [ PrimaryKey, SqlName = PK_BT_SmartEpisWGMachine, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 流水号规则
Property SmartEpisDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 医嘱
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 子工作小组
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTSmartEpisWGMachineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SmartEpisDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>WorkGroupMachineDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSmartEpisWGMachineD</DataLocation>
<DefaultData>BTSmartEpisWGMachineDefaultData</DefaultData>
<IdLocation>^dbo.BTSmartEpisWGMachineD</IdLocation>
<IndexLocation>^dbo.BTSmartEpisWGMachineI</IndexLocation>
<StreamLocation>^dbo.BTSmartEpisWGMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
