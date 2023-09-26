/// 名称:	CT.MA.QC.QualityTemplate
/// 描述:	质控基础数据表
/// 编写者：hky
/// 编写日期: 2021-06-30
Class CT.MA.QC.QualityTemplate Extends (%Persistent, User.Abstract)
{

/// 目的是使ID列具有和Code列相同的数据
Index RowIDBasedIDKeyIndex On Code [ IdKey, PrimaryKey, Unique ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 病历结构
Property TemplateStruct As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 描述
Property Title As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 术语集编码
Property GlossaryInternalID As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="QualityTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>TemplateStruct</Value>
</Value>
<Value name="4">
<Value>Title</Value>
</Value>
<Value name="5">
<Value>GlossaryInternalID</Value>
</Value>
<Value name="6">
<Value>ID</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualityTemplateD</DataLocation>
<DefaultData>QualityTemplateDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualityTemplateD</IdLocation>
<IndexLocation>^CT.MA.QC.QualityTemplateI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualityTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
