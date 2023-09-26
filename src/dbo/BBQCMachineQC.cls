/// 输血质控 质控编号
Class dbo.BBQCMachineQC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBQC_MachineQC ]
{

/// Foreign Key FKBBQCMachineQCMaterialItemDR created via DDL
ForeignKey FKBBQCMachineQCMaterialItemDR(MaterialItemDR) References dbo.BBQCMaterialItem(PKBBQCMATERIALITEM) [ SqlName = FK_BBQCMachineQCMaterialItemDR ];

/// Foreign Key FKBBQCMachineQCMachineParameterDR created via DDL
ForeignKey FKBBQCMachineQCMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BBQCMachineQCMachineParameterDR ];

/// DDL Primary Key Specification
Index PKBBQCMACHINEQC On RowID [ PrimaryKey, SqlName = PK_BBQC_MACHINEQC, Type = index, Unique ];

Index IndexMaster On (MaterialItemDR, MachineParameterDR) [ SqlName = Index_Master, Type = index, Unique ];

Index indexSquence On (MachineParameterDR, SampleID) [ SqlName = index_Squence, Type = index ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// MaterialItemDR  
Property MaterialItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// MachineParameterDR  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// SampleID  
Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBQCMachineQCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialItemDR</Value>
</Value>
<Value name="3">
<Value>MachineParameterDR</Value>
</Value>
<Value name="4">
<Value>SampleID</Value>
</Value>
</Data>
<DataLocation>^dbo.BBQCMachineQCD</DataLocation>
<DefaultData>BBQCMachineQCDefaultData</DefaultData>
<IdLocation>^dbo.BBQCMachineQCD</IdLocation>
<IndexLocation>^dbo.BBQCMachineQCI</IndexLocation>
<StreamLocation>^dbo.BBQCMachineQCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
