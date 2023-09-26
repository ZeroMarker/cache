///     
Class dbo.BTMIMachineQC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineQC, StorageStrategy = Default ]
{

/// Foreign Key FKMachineQCMach created via DDL
ForeignKey FKMachineQCMach(MacineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineQCMach ];

/// Foreign Key FKMachineQCMat created via DDL
ForeignKey FKMachineQCMat(MaterialDR) References dbo.BTQCMaterial(PKBTQCMATERIAL) [ SqlName = FK_MachineQCMat ];

Index IndexMachineQC On (MacineParameterDR, MaterialDR, QCLevel) [ SqlName = Index_MachineQC, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTMIMACHINEQC On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEQC, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MacineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property QCLevel As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTMIMachineQCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MacineParameterDR</Value>
</Value>
<Value name="3">
<Value>MaterialDR</Value>
</Value>
<Value name="4">
<Value>QCLevel</Value>
</Value>
<Value name="5">
<Value>SampleID</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineQCD</DataLocation>
<DefaultData>BTMIMachineQCDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMIMachineQCD</IdLocation>
<IndexLocation>^dbo.BTMIMachineQCI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineQCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
