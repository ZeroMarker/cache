Class dbo.BTWorkGroupMachineRuleTS Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WorkGroupMachineRuleTS ]
{

Index IndexMaster On (WorkGroupMachineRuleDR, TestSetDR) [ SqlName = IndexMaster, Type = index ];

Index IndexTestSet On (TestSetDR, WorkGroupMachineRuleDR) [ SqlName = IndexTestSet, Type = index ];

/// DDL Primary Key Specification
Index PKBTWorkGroupMachineRuleTS On RowID [ PrimaryKey, SqlName = PK_BT_WorkGroupMachineRule, Type = index, Unique ];

/// Foreign Key FKWorkGroupMachineRuleTS created via DDL
ForeignKey FKWorkGroupMachineRuleTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_WorkGroupMachineRuleTS ];

/// Foreign Key FKWGMTSWorkGroupMachine created via DDL
ForeignKey FKWGMTSWorkGroupMachine(WorkGroupMachineRuleDR) References dbo.BTWorkGroupMachineRule(PKBTWorkGroupMachineRule) [ SqlName = FK_WGMTSWorkGroupMachine ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupMachineRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTWorkGroupMachineRuleTSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineRuleDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWorkGroupMachineRuleTSD</DataLocation>
<DefaultData>BTWorkGroupMachineRuleTSDefaultData</DefaultData>
<IdLocation>^dbo.BTWorkGroupMachineRuleTSD</IdLocation>
<IndexLocation>^dbo.BTWorkGroupMachineRuleTSI</IndexLocation>
<StreamLocation>^dbo.BTWorkGroupMachineRuleTSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
