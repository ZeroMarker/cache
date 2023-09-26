Class dbo.BTMIMachineParameterModule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineParameterModule ]
{

Index IndexMaster On (MachineParameterDR, ModuleNo) [ SqlName = Index_Master, Type = index ];

Index IndexChannel On (MachineParameterDR, ModuleNo, ResultChannel) [ SqlName = Index_Channel, Type = index ];

Index IndexModuleNo On (ModuleNo, MachineParameterDR) [ SqlName = Index_ModuleNo, Type = index ];

/// Foreign Key FKMachineModuleMach created via DDL
ForeignKey FKMachineModuleMach(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineModuleMach ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ModuleNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property QCFlag As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property ResultChannel As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTMIMachineParameterModuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>ModuleNo</Value>
</Value>
<Value name="4">
<Value>QCFlag</Value>
</Value>
<Value name="5">
<Value>ResultChannel</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineParameterModuleD</DataLocation>
<DefaultData>BTMIMachineParameterModuleDefaultData</DefaultData>
<IdLocation>^dbo.BTMIMachineParameterModuleD</IdLocation>
<IndexLocation>^dbo.BTMIMachineParameterModuleI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineParameterModuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
