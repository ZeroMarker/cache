///     
Class dbo.BTEpidemicCheckWGMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_EpidemicCheckWGMachine, StorageStrategy = Default ]
{

/// Foreign Key FKEpidemicCheckWGMachine created via DDL
ForeignKey FKEpidemicCheckWGMachine(EpidemicCheckRulesDR) References dbo.BTEpidemicCheckRules(PKBTEPIDEMICCHECKRULES) [ SqlName = FK_EpidemicCheckWGMachine ];

/// Foreign Key FKEpidemicCheckWGMachineWG created via DDL
ForeignKey FKEpidemicCheckWGMachineWG(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_EpidemicCheckWGMachineWG ];

Index IndexMaster On (EpidemicCheckRulesDR, WorkGroupMachineDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWorkGroupMachine On WorkGroupMachineDR [ SqlName = Index_WorkGroupMachine, Type = index ];

/// DDL Primary Key Specification
Index PKBTEPIDEMICCHECKWGMACHINE On RowID [ PrimaryKey, SqlName = PK_BT_EPIDEMICCHECKWGMACHINE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property EpidemicCheckRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTEpidemicCheckWGMachineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpidemicCheckRulesDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTEpidemicCheckWGMachineD</DataLocation>
<DefaultData>BTEpidemicCheckWGMachineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTEpidemicCheckWGMachineD</IdLocation>
<IndexLocation>^dbo.BTEpidemicCheckWGMachineI</IndexLocation>
<StreamLocation>^dbo.BTEpidemicCheckWGMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
