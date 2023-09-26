///     
Class dbo.BTRGMachineTestReagent Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_MachineTestReagent, StorageStrategy = Default ]
{

/// Foreign Key FKBTRGMachineTestReagentMachine created via DDL
ForeignKey FKBTRGMachineTestReagentMachine(MachineDR) References dbo.BTRGMachine(PKBTRGMACHINE) [ SqlName = FK_BTRG_MachineTestReagent_Machine ];

/// Foreign Key FKBTRGMachineTestReagentReagent created via DDL
ForeignKey FKBTRGMachineTestReagentReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_BTRG_MachineTestReagent_Reagent ];

/// Foreign Key FKBTRGMachineTestReagentTestCode created via DDL
ForeignKey FKBTRGMachineTestReagentTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTRG_MachineTestReagent_TestCode ];

Index IndexMachine On MachineDR [ SqlName = Index_Machine, Type = index ];

Index IndexMaster On (MachineDR, TestCodeDR, ReagentDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexReagent On ReagentDR [ SqlName = Index_Reagent, Type = index ];

Index IndexTestCode On TestCodeDR [ SqlName = Index_TestCode, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGMachineTestReagent On RowID [ PrimaryKey, SqlName = PK_BTRG_MachineTestReagent, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property MachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 每测试用量  
Property Volume As %Library.Float [ SqlColumnNumber = 6 ];

/// 用量单位  
Property VolUnit As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 转换系数  
Property PackUnit As %Library.Float [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTRGMachineTestReagentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>MachineDR</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>ReagentDR</Value>
</Value>
<Value name="6">
<Value>Volume</Value>
</Value>
<Value name="7">
<Value>VolUnit</Value>
</Value>
<Value name="8">
<Value>PackUnit</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGMachineTestReagentD</DataLocation>
<DefaultData>BTRGMachineTestReagentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGMachineTestReagentD</IdLocation>
<IndexLocation>^dbo.BTRGMachineTestReagentI</IndexLocation>
<StreamLocation>^dbo.BTRGMachineTestReagentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
