/// 输血质控 检测试剂结果对照
Class dbo.BBQCMaterialItemReagRes Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBQC_MaterialItemReagRes ]
{

/// Foreign Key FKBBQCMaterialItemReagResMaterialItemReagDR created via DDL
ForeignKey FKBBQCMaterialItemReagResMaterialItemReagDR(MaterialItemReagDR) References dbo.BBQCMaterialItemReag(PKBBQCMATERIALITEMREAG) [ SqlName = FK_BBQCMaterialItemReagResMaterialItemReagDR ];

/// DDL Primary Key Specification
Index PKBBQCMATERIALITEMREAGRES On RowID [ PrimaryKey, SqlName = PK_BBQC_MATERIALITEMREAGRES, Type = index, Unique ];

Index IndexMaster On (MaterialItemReagDR, Result) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// MaterialItemReagDR  
Property MaterialItemReagDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

/// ResValue  
Property ResValue As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

/// ResStatus  
Property ResStatus As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBQCMaterialItemReagResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialItemReagDR</Value>
</Value>
<Value name="3">
<Value>Result</Value>
</Value>
<Value name="4">
<Value>ResValue</Value>
</Value>
<Value name="5">
<Value>ResStatus</Value>
</Value>
</Data>
<DataLocation>^dbo.BBQCMaterialItemReagResD</DataLocation>
<DefaultData>BBQCMaterialItemReagResDefaultData</DefaultData>
<IdLocation>^dbo.BBQCMaterialItemReagResD</IdLocation>
<IndexLocation>^dbo.BBQCMaterialItemReagResI</IndexLocation>
<StreamLocation>^dbo.BBQCMaterialItemReagResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
