/// 质控物
Class dbo.BTQCMaterial Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_Material, StorageStrategy = Default ]
{

/// Foreign Key FKMaterialMachine created via DDL
ForeignKey FKMaterialMachine(MachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MaterialMachine ];

/// Foreign Key FKMaterialWorkGroup created via DDL
ForeignKey FKMaterialWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_MaterialWorkGroup ];

Index IndexCode On (WorkGroupDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (WorkGroupDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexMachineDR On (MachineDR, Sequence) [ SqlName = Index_MachineDR, Type = index ];

/// DDL Primary Key Specification
Index PKBTQCMATERIAL On RowID [ PrimaryKey, SqlName = PK_BTQC_MATERIAL, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 仪器  
Property MachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 浓度数  
Property Levels As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 波长  
Property WaveLength As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

/// 是否自动入库  {1:true,0:false}
Property AutoSave As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 10 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 是否覆盖数据  {1:true,0:false}
Property IsOverWriteData As %Library.Boolean [ SqlColumnNumber = 13 ];

/// 不允许日间质控  {1:true,0:false}
Property NotAllowDay As %Library.Boolean [ SqlColumnNumber = 14 ];

/// 日间质控没做不显示  {1:true,0:false}
Property NotShowNullDay As %Library.Boolean [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTQCMaterialDefaultData">
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
<Value>MachineDR</Value>
</Value>
<Value name="6">
<Value>Levels</Value>
</Value>
<Value name="7">
<Value>WaveLength</Value>
</Value>
<Value name="8">
<Value>AutoSave</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
<Value name="12">
<Value>IsOverWriteData</Value>
</Value>
<Value name="13">
<Value>NotAllowDay</Value>
</Value>
<Value name="14">
<Value>NotShowNullDay</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMaterialD</DataLocation>
<DefaultData>BTQCMaterialDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTQCMaterialD</IdLocation>
<IndexLocation>^dbo.BTQCMaterialI</IndexLocation>
<StreamLocation>^dbo.BTQCMaterialS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
