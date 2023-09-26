/// 输血质控 检测试剂
Class dbo.BBQCMaterialItemReag Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBQC_MaterialItemReag ]
{

/// Foreign Key FKBBQCMaterialItemReagMaterialItemDR created via DDL
ForeignKey FKBBQCMaterialItemReagMaterialItemDR(MaterialItemDR) References dbo.BBQCMaterialItem(PKBBQCMATERIALITEM) [ SqlName = FK_BBQCMaterialItemReagMaterialItemDR ];

/// Foreign Key FKBBQCMaterialItemReagTestReagentDR created via DDL
ForeignKey FKBBQCMaterialItemReagTestReagentDR(TestReagentDR) References dbo.BBQCTestReagent(PKBBQCTESTREAGENT) [ SqlName = FK_BBQCMaterialItemReagTestReagentDR ];

/// DDL Primary Key Specification
Index PKBBQCMATERIALITEMREAG On RowID [ PrimaryKey, SqlName = PK_BBQC_MATERIALITEMREAG, Type = index, Unique ];

Index IndexMaster On (MaterialItemDR, TestReagentDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (MaterialItemDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// MaterialItemDR  
Property MaterialItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// TestReagentDR  
Property TestReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 5 ];

/// RefResult  
Property RefResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 目标  
Property Target As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBQCMaterialItemReagDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialItemDR</Value>
</Value>
<Value name="3">
<Value>TestReagentDR</Value>
</Value>
<Value name="4">
<Value>Remark</Value>
</Value>
<Value name="5">
<Value>RefResult</Value>
</Value>
<Value name="6">
<Value>Target</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BBQCMaterialItemReagD</DataLocation>
<DefaultData>BBQCMaterialItemReagDefaultData</DefaultData>
<IdLocation>^dbo.BBQCMaterialItemReagD</IdLocation>
<IndexLocation>^dbo.BBQCMaterialItemReagI</IndexLocation>
<StreamLocation>^dbo.BBQCMaterialItemReagS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
