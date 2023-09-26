/// 输血质控 质控项目
Class dbo.BBQCMaterialItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBQC_MaterialItem ]
{

/// Foreign Key FKBBQCMaterialItemMaterialDR created via DDL
ForeignKey FKBBQCMaterialItemMaterialDR(MaterialDR) References dbo.BBQCMaterial(PKBBQCMATERIAL) [ SqlName = FK_BBQCMaterialItemMaterialDR ];

/// Foreign Key FKBBQCMaterialItemTestItemDR created via DDL
ForeignKey FKBBQCMaterialItemTestItemDR(TestItemDR) References dbo.BBQCTestItem(PKBBQCTESTITEM) [ SqlName = FK_BBQCMaterialItemTestItemDR ];

/// Foreign Key FKBBQCMaterialItemTestMethodDR created via DDL
ForeignKey FKBBQCMaterialItemTestMethodDR(TestMethodDR) References dbo.BBQCTestMethod(PKBBQCTESTMETHOD) [ SqlName = FK_BBQCMaterialItemTestMethodDR ];

/// Foreign Key FKBBQCMaterialItemMachineParameterDR created via DDL
ForeignKey FKBBQCMaterialItemMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BBQCMaterialItemMachineParameterDR ];

/// DDL Primary Key Specification
Index PKBBQCMATERIALITEM On RowID [ PrimaryKey, SqlName = PK_BBQC_MATERIALITEM, Type = index, Unique ];

Index IndexMaster On (MaterialDR, TestItemDR, LevelNo, TestMethodDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (MaterialDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 质控物  
Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 检测项目  
Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 浓度水平  
Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 检测方法  
Property TestMethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 仪器名称  
Property MachineName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BBQCMaterialItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>TestMethodDR</Value>
</Value>
<Value name="6">
<Value>MachineParameterDR</Value>
</Value>
<Value name="7">
<Value>MachineName</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBQCMaterialItemD</DataLocation>
<DefaultData>BBQCMaterialItemDefaultData</DefaultData>
<IdLocation>^dbo.BBQCMaterialItemD</IdLocation>
<IndexLocation>^dbo.BBQCMaterialItemI</IndexLocation>
<StreamLocation>^dbo.BBQCMaterialItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
