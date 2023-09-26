Class dbo.CFBTFridgeWGMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = CFBT_FridgeWGMachine ]
{

/// Foreign Key FKCFBTFridgeWGMachineBTFridge created via DDL
ForeignKey FKCFBTFridgeWGMachineBTFridge(FridgeDR) References dbo.BTFridge(PKBTFRIDGE) [ SqlName = FK_CFBTFridgeWGMachineBTFridge ];

/// Foreign Key FKCFBTFridgeWGMachineWorkGroupMachineDR created via DDL
ForeignKey FKCFBTFridgeWGMachineWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_CFBTFridgeWGMachineWorkGroupMachineDR ];

/// Foreign Key FKCFBTFridgeWGMachineUserInDR created via DDL
ForeignKey FKCFBTFridgeWGMachineUserInDR(UserInDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CFBTFridgeWGMachineUserInDR ];

/// Foreign Key FKCFBTFridgeWGMachineUserOutDR created via DDL
ForeignKey FKCFBTFridgeWGMachineUserOutDR(UserInDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CFBTFridgeWGMachineUserOutDR ];

Index IndexMaster On (FridgeDR, WorkGroupMachineDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWorkGroupMachine On (WorkGroupMachineDR, FridgeDR) [ SqlName = Index_WorkGroupMachine, Type = index ];

/// DDL Primary Key Specification
Index PKCFBTFridgeWGMachine On RowID [ PrimaryKey, SqlName = PK_CFBT_FridgeWGMachine, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 流水号规则
Property FridgeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 子工作小组
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 入库人
Property UserInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 出库人
Property UserOutDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="CFBTFridgeWGMachineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FridgeDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>UserInDR</Value>
</Value>
<Value name="5">
<Value>UserOutDR</Value>
</Value>
</Data>
<DataLocation>^dbo.CFBTFridgeWGMachineD</DataLocation>
<DefaultData>CFBTFridgeWGMachineDefaultData</DefaultData>
<IdLocation>^dbo.CFBTFridgeWGMachineD</IdLocation>
<IndexLocation>^dbo.CFBTFridgeWGMachineI</IndexLocation>
<StreamLocation>^dbo.CFBTFridgeWGMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
