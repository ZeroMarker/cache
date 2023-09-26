/// 名称:	EMR.DB.IStructSimple
/// 描述:	简单元素打散表
/// 编写者：yejian
/// 编写日期: 2022-11-3
/// 产品组：电子病历产品组
Class EMR.DB.IStructSimple Extends %Persistent
{

Index IdxForUpdate On (DocumentID, SectionCode, SimpleItemCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, SimpleItemCode, DocumentID) [ Unique ];

Index IdxForSource On (DocumentID, SectionCode, KBNodeID, SimpleSourceCode);

Index IdxForGetSection On (DocumentID, SectionCode);

Index IdxForKBNode On (EpisodeID, TemplateID, KBNodeID, SectionCode, SimpleItemCode, DocumentID);

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 实例ID
Property DocumentID As EMR.DB.DocumentData;

/// 住院号
Property PatientID As User.PAPatMas;

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0);

/// 模板ID
Property TemplateID As CF.EMR.DOC.Template;

/// 版本
Property TemplateVersion As %Integer;

/// 片段ID
Property KBNodeID As %String(TRUNCATE = 1);

/// 业务编码
Property EMRCode As %String(TRUNCATE = 1);

/// 章节编码
Property SectionCode As %String(TRUNCATE = 1);

/// 简单元素编码
Property SimpleItemCode As %String(TRUNCATE = 1);

/// 简单元素原始编码(片段维护编码)
Property SimpleSourceCode As %String(TRUNCATE = 1);

/// 简单元素名称
Property SimpleItemName As %String(TRUNCATE = 1);

/// 元素选项编码
Property ValueCode As %String(MAXLEN = 500, TRUNCATE = 1);

/// 元素选项值
Property DataValue As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 关联值
Property DataRef As %String(MAXLEN = 100, TRUNCATE = 1);

/// 分隔符
Property Separator As %String(MAXLEN = 100, TRUNCATE = 1);

/// 类型
Property Type As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="IStructSimpleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>DocumentID</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
<Value name="5">
<Value>DOCCode</Value>
</Value>
<Value name="6">
<Value>TemplateID</Value>
</Value>
<Value name="7">
<Value>TemplateVersion</Value>
</Value>
<Value name="8">
<Value>KBNodeID</Value>
</Value>
<Value name="9">
<Value>EMRCode</Value>
</Value>
<Value name="10">
<Value>SectionCode</Value>
</Value>
<Value name="11">
<Value>SimpleItemCode</Value>
</Value>
<Value name="12">
<Value>SimpleItemName</Value>
</Value>
<Value name="13">
<Value>ValueCode</Value>
</Value>
<Value name="14">
<Value>DataValue</Value>
</Value>
<Value name="15">
<Value>DataRef</Value>
</Value>
<Value name="16">
<Value>Separator</Value>
</Value>
<Value name="17">
<Value>Type</Value>
</Value>
<Value name="18">
<Value>SimpleSourceCode</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.IStructSimpleD</DataLocation>
<DefaultData>IStructSimpleDefaultData</DefaultData>
<IdLocation>^EMR.DB.IStructSimpleD</IdLocation>
<IndexLocation>^EMR.DB.IStructSimpleI</IndexLocation>
<StreamLocation>^EMR.DB.IStructSimpleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
