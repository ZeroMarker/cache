/// 输血质控 质控物
Class dbo.BBQCMaterial Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBQC_Material ]
{

/// Foreign Key FKBBQCMaterialWorkGroupDR created via DDL
ForeignKey FKBBQCMaterialWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BBQCMaterialWorkGroupDR ];

/// Foreign Key FKBBQCMaterialMachineParameterDR created via DDL
ForeignKey FKBBQCMaterialMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BBQCMaterialMachineParameterDR ];

/// DDL Primary Key Specification
Index PKBBQCMATERIAL On RowID [ PrimaryKey, SqlName = PK_BBQC_MATERIAL, Type = index, Unique ];

Index IndexCode On (WorkGroupDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (WorkGroupDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 仪器名  
Property MachineName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 7 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BBQCMaterialDefaultData">
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
<Value>WorkGroupDR</Value>
</Value>
<Value name="5">
<Value>MachineParameterDR</Value>
</Value>
<Value name="6">
<Value>MachineName</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBQCMaterialD</DataLocation>
<DefaultData>BBQCMaterialDefaultData</DefaultData>
<IdLocation>^dbo.BBQCMaterialD</IdLocation>
<IndexLocation>^dbo.BBQCMaterialI</IndexLocation>
<StreamLocation>^dbo.BBQCMaterialS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
