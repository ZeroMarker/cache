/// 仪器关联工作小组
Class dbo.BTMIMachineParamLinkWGM Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineParamLinkWGM ]
{

Index IndexMaster On (MachineParameterDR, WorkGroupMachineDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (MachineParameterDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKMachineModuleMach created via DDL
ForeignKey FKMachineLinkWMGMach(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineLinkWMGMach ];

/// Foreign Key FKMachineWorkGroup created via DDL
ForeignKey FKMachineLinkWMGDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_MachineLinkWMGDR ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序列  
Property Sequence As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMIMachineParamLinkWGMDefaultData">
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
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineParamLinkWGMD</DataLocation>
<DefaultData>BTMIMachineParamLinkWGMDefaultData</DefaultData>
<IdLocation>^dbo.BTMIMachineParamLinkWGMD</IdLocation>
<IndexLocation>^dbo.BTMIMachineParamLinkWGMI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineParamLinkWGMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
