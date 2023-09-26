/// 仪器关联细菌
Class dbo.BTMIMachineMicroBugs Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineMicroBugs, StorageStrategy = Default ]
{

Index IndexMaster On (MachineParameterDR, OrganismDR, MachineBug) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexChannel On (MachineParameterDR, MachineBug) [ SqlName = Index_Channel, Type = index ];

/// DDL Primary Key Specification
Index PKBTMIMACHINEMICROBUGS On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEMICROBUGS, Type = index, Unique ];

/// Foreign Key FKMachineOrganismMi created via DDL
ForeignKey FKMachineOrganismMi(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineOrganismMi ];

/// Foreign Key FKMachineOrganismOrg created via DDL
ForeignKey FKMachineOrganismOrg(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_MachineOrganismOrg ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 细菌代码  
Property MachineBug As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

/// 细菌  
Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMIMachineMicroBugsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>MachineBug</Value>
</Value>
<Value name="4">
<Value>OrganismDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineMicroBugsD</DataLocation>
<DefaultData>BTMIMachineMicroBugsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMIMachineMicroBugsD</IdLocation>
<IndexLocation>^dbo.BTMIMachineMicroBugsI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineMicroBugsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
