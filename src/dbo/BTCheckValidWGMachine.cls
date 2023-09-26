///     
Class dbo.BTCheckValidWGMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidWGMachine, StorageStrategy = Default ]
{

/// Foreign Key FKCheckValidWGMachine created via DDL
ForeignKey FKCheckValidWGMachine(CheckValidRulesDR) References dbo.BTCheckValidRules(PKBTCHECKVALIDRULES) [ SqlName = FK_CheckValidWGMachine ];

/// Foreign Key FKCheckValidWGMachineWG created via DDL
ForeignKey FKCheckValidWGMachineWG(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_CheckValidWGMachineWG ];

Index IndexMaster On (CheckValidRulesDR, WorkGroupMachineDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWorkGroupMachine On WorkGroupMachineDR [ SqlName = Index_WorkGroupMachine, Type = index ];

/// DDL Primary Key Specification
Index PKBTCHECKVALIDWGMACHINE On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDWGMACHINE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property CheckValidRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTCheckValidWGMachineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckValidRulesDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidWGMachineD</DataLocation>
<DefaultData>BTCheckValidWGMachineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCheckValidWGMachineD</IdLocation>
<IndexLocation>^dbo.BTCheckValidWGMachineI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidWGMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
