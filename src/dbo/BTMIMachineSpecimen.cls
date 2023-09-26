///     
Class dbo.BTMIMachineSpecimen Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineSpecimen, StorageStrategy = Default ]
{

Index IndexMaster On (MachineParameterDR, SpecimenDR, Channel) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexChannel On (MachineParameterDR, Channel) [ SqlName = Index_Channel, Type = index ];

/// DDL Primary Key Specification
Index PKBTMIMACHINESPECIMEN On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINESPECIMEN, Type = index, Unique ];

/// Foreign Key FKMachineSpecimenMi created via DDL
ForeignKey FKMachineSpecimenMi(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineSpecimenMi ];

/// Foreign Key FKMachineSpecimenSp created via DDL
ForeignKey FKMachineSpecimenSp(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_MachineSpecimenSp ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Channel As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMIMachineSpecimenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>SpecimenDR</Value>
</Value>
<Value name="4">
<Value>Channel</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineSpecimenD</DataLocation>
<DefaultData>BTMIMachineSpecimenDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMIMachineSpecimenD</IdLocation>
<IndexLocation>^dbo.BTMIMachineSpecimenI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
