/// 名称:	EMR.DB.IStructSection
/// 描述:	章节打散表
/// 编写者：yejian
/// 编写日期: 2022-9-6
/// 产品组：电子病历产品组
Class EMR.DB.IStructSection Extends %Persistent
{

Index IdxForUpdate On (DocumentID, SectionCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, DocumentID) [ Unique ];

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

/// 业务编码
Property EMRCode As %String(TRUNCATE = 1);

/// 章节编码
Property SectionCode As %String(TRUNCATE = 1);

/// 章节名称
Property SectionName As %String(TRUNCATE = 1);

/// 文本(包含上下标等信息)
Property Text As %GlobalCharacterStream(LOCATION = "^EMR.DB.IStructSectionS");

Storage Default
{
<Data name="IStructSectionDefaultData">
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
<Value>SectionCode</Value>
</Value>
<Value name="9">
<Value>SectionName</Value>
</Value>
<Value name="10">
<Value>Text</Value>
</Value>
<Value name="11">
<Value>StyleText</Value>
</Value>
<Value name="12">
<Value>EMRCode</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.IStructSectionD</DataLocation>
<DefaultData>IStructSectionDefaultData</DefaultData>
<IdLocation>^EMR.DB.IStructSectionD</IdLocation>
<IndexLocation>^EMR.DB.IStructSectionI</IndexLocation>
<StreamLocation>^EMR.DB.IStructSectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
