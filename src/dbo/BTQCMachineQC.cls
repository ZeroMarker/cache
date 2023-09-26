/// 仪器质控
Class dbo.BTQCMachineQC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MachineQC, StorageStrategy = Default ]
{

/// Foreign Key FKMachineQC created via DDL
ForeignKey FKMachineQC(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineQC ];

/// Foreign Key FKMachineQCMaterial created via DDL
ForeignKey FKMachineQCMaterial(MaterialDR) References dbo.BTQCMaterial(PKBTQCMATERIAL) [ SqlName = FK_MachineQCMaterial ];

Index IndexMaster On (MachineParameterDR, MaterialDR, LevelNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSampleID On (MachineParameterDR, SampleID, MaterialDR, LevelNo) [ SqlName = Index_SampleID, Type = index, Unique ];

Index IndexSampleIDParallel On (MachineParameterDR, SampleIDParallel, MaterialDR, LevelNo) [ SqlName = Index_SampleIDParallel, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCMACHINEQC On RowID [ PrimaryKey, SqlName = PK_BTQC_MACHINEQC, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 质控物  
Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 浓度  
Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 标识  
Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

/// TestCodeDRS  
Property TestCodeDRS As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 7 ];

/// 平行质控标识  
Property SampleIDParallel As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTQCMachineQCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>MaterialDR</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>SampleID</Value>
</Value>
<Value name="6">
<Value>TestCodeDRS</Value>
</Value>
<Value name="7">
<Value>SampleIDParallel</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMachineQCD</DataLocation>
<DefaultData>BTQCMachineQCDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTQCMachineQCD</IdLocation>
<IndexLocation>^dbo.BTQCMachineQCI</IndexLocation>
<StreamLocation>^dbo.BTQCMachineQCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
