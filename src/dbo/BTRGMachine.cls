///     
Class dbo.BTRGMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_Machine, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexReagentGroupDR On ReagentGroupDR [ SqlName = Index_ReagentGroupDR, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGMACHINE On RowID [ PrimaryKey, SqlName = PK_BTRG_MACHINE, Type = index, Unique ];

/// Foreign Key FKRGMachineDevice created via DDL
ForeignKey FKRGMachineDevice(DeviceDR) References dbo.BTDevice(PKBTDEVICE) [ SqlName = FK_RG_Machine_Device ];

/// Foreign Key FKRGMachineGroup created via DDL
ForeignKey FKRGMachineGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_Machine_Group ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

Property DeviceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTRGMachineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>DeviceDR</Value>
</Value>
<Value name="5">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGMachineD</DataLocation>
<DefaultData>BTRGMachineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGMachineD</IdLocation>
<IndexLocation>^dbo.BTRGMachineI</IndexLocation>
<StreamLocation>^dbo.BTRGMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
