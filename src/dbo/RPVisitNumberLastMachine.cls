Class dbo.RPVisitNumberLastMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberLastMachine ]
{

Index IndexSacanDate On (WorkGroupMachineDR, SacanDate, VisitNumber) [ SqlName = Index_SacanDate, Type = index ];

Index IndexVisitNumber On VisitNumber [ SqlName = Index_VisitNumber, Type = index, Unique ];

/// Foreign Key FKWorkGroupMachine created via DDL
ForeignKey FKWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_WorkGroupMachine ];

/// Foreign Key FKOldWorkGroupMachine created via DDL
ForeignKey FKOldWorkGroupMachine(OldWorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_OldWorkGroupMachine ];

/// Foreign Key FKMachineParameter created via DDL
ForeignKey FKMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineParameter ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property SacanDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SacanTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property OldWorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RPVisitNumberLastMachineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumber</Value>
</Value>
<Value name="3">
<Value>SacanDate</Value>
</Value>
<Value name="4">
<Value>SacanTime</Value>
</Value>
<Value name="5">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="6">
<Value>MachineParameterDR</Value>
</Value>
<Value name="7">
<Value>OldWorkGroupMachineDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberLastMachineD</DataLocation>
<DefaultData>RPVisitNumberLastMachineDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberLastMachineD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberLastMachineI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberLastMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
