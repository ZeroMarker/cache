Class dbo.BTSampleRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SampleRule ]
{

Index IndexMaster On (TestSetDR, WorkGroupDR, WorkGroupMachineDR) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKTestSetWorkGroupWg created via DDL
ForeignKey FKTestSetWorkGroupWg(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_TestSetWorkGroupWg ];

/// Foreign Key FKTestSetLayoutTS created via DDL
ForeignKey FKTestSetLayoutTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSetLayoutTS ];

/// Foreign Key FKTestSetLayoutWorkGroup created via DDL
ForeignKey FKTestSetLayoutWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_TestSetLayoutWorkGroup ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property RuleGroup As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTSampleRuleDefaultData">
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
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="5">
<Value>RuleGroup</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSampleRuleD</DataLocation>
<DefaultData>BTSampleRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTSampleRuleD</IdLocation>
<IndexLocation>^dbo.BTSampleRuleI</IndexLocation>
<StreamLocation>^dbo.BTSampleRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
