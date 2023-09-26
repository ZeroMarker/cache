///     
Class dbo.BTMIMachineMovelog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineMovelog, StorageStrategy = Default ]
{

/// Foreign Key FKMachineMove created via DDL
ForeignKey FKMachineMove(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineMove ];

/// Foreign Key FKMachineMoveRoom created via DDL
ForeignKey FKMachineMoveRoom(RoomDR) References dbo.BTRoom(PKBTROOM) [ SqlName = FK_MachineMoveRoom ];

/// Foreign Key FKMachineMoveWorkGroup created via DDL
ForeignKey FKMachineMoveWorkGroup(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_MachineMoveWorkGroup ];

Index IndexMaster On (MachineParameterDR, StartDate, StartTime) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTMIMACHINEMOVELOG On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEMOVELOG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property RoomDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTMIMachineMovelogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>RoomDR</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>StartTime</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineMovelogD</DataLocation>
<DefaultData>BTMIMachineMovelogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMIMachineMovelogD</IdLocation>
<IndexLocation>^dbo.BTMIMachineMovelogI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineMovelogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
