///     
Class dbo.BTMIMachineMicRemark Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineMicRemark ]
{

/// Foreign Key FKBTMIMachineMicRemarkMachineParameterDR created via DDL
ForeignKey FKBTMIMachineMicRemarkMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTMIMachineMicRemarkMachineParameterDR ];

/// DDL Primary Key Specification
Index PKBTMIMACHINEMICREMARK On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEMICREMARK, Type = index, Unique ];

Index IndexMaster On (MachineParameterDR, Channel) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 4 ];

Property Channel As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMIMachineMicRemarkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>Remark</Value>
</Value>
<Value name="4">
<Value>Channel</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineMicRemarkD</DataLocation>
<DefaultData>BTMIMachineMicRemarkDefaultData</DefaultData>
<IdLocation>^dbo.BTMIMachineMicRemarkD</IdLocation>
<IndexLocation>^dbo.BTMIMachineMicRemarkI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineMicRemarkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
