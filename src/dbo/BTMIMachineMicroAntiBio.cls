/// 仪器关联抗生素
Class dbo.BTMIMachineMicroAntiBio Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineMicroAntiBio, StorageStrategy = Default ]
{

Index IndexMaster On (MachineParameterDR, AntibioticsDR, MachineAntiBiotic) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexChannel On (MachineParameterDR, MachineAntiBiotic) [ SqlName = Index_Channel, Type = index ];

/// DDL Primary Key Specification
Index PKBTMIMACHINEMICROANTIBIO On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEMICROANTIBIO, Type = index, Unique ];

/// Foreign Key FKMachineAntibiocsAnt created via DDL
ForeignKey FKMachineAntibiocsAnt(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_MachineAntibiocsAnt ];

/// Foreign Key FKMachineAntibiocsMi created via DDL
ForeignKey FKMachineAntibiocsMi(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineAntibiocsMi ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 抗生素代码  
Property MachineAntiBiotic As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMIMachineMicroAntiBioDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>MachineAntiBiotic</Value>
</Value>
<Value name="4">
<Value>AntibioticsDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineMicroAntiBioD</DataLocation>
<DefaultData>BTMIMachineMicroAntiBioDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMIMachineMicroAntiBioD</IdLocation>
<IndexLocation>^dbo.BTMIMachineMicroAntiBioI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineMicroAntiBioS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
