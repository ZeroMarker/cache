/// 名称:	EMR.DB1.IStructMacro
/// 描述:	宏对象打散表（月经生育史、深度公式）
/// 编写者：yejian
/// 编写日期: 2022-11-3
/// 产品组：电子病历产品组
Class EMR.DB1.IStructMacro Extends %Persistent
{

Index IdxForUpdate On (DocumentID, SectionCode, MacroCode) [ Unique ];

Index IdxForGetSection On (DocumentID, MacroCode, SectionCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, MacroCode, DocumentID) [ Unique ];

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 实例ID
Property DocumentID As EMR.DB1.DocumentData;

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

/// 章节编码
Property SectionCode As %String(TRUNCATE = 1);

/// 业务编码
Property EMRCode As %String(TRUNCATE = 1);

/// 宏编码
Property MacroCode As %String(TRUNCATE = 1);

/// 宏原始编码(片段维护编码)
Property MacroSourceCode As %String(TRUNCATE = 1);

/// 宏名称
Property MacroName As %String(TRUNCATE = 1);

/// 宏数据
Property Text As %GlobalCharacterStream(LOCATION = "^EMR.DB1.IStructMacroS");

/// 宏类型（menstrual 月经生育、eyeDeepGrade 前房深度、fetalHeart 胎心）
Property MacroType As %String(TRUNCATE = 1);

/// 大小（前房深度，胎心的图片大小）
Property MacroSize As %String(TRUNCATE = 1);

Storage Default
{
<Data name="IStructMacroDefaultData">
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
<Value>SectionCode</Value>
</Value>
<Value name="10">
<Value>EMRCode</Value>
</Value>
<Value name="11">
<Value>MacroCode</Value>
</Value>
<Value name="12">
<Value>MacroSourceCode</Value>
</Value>
<Value name="13">
<Value>MacroName</Value>
</Value>
<Value name="14">
<Value>Text</Value>
</Value>
<Value name="15">
<Value>MacroType</Value>
</Value>
<Value name="16">
<Value>MacroSize</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.IStructMacroD</DataLocation>
<DefaultData>IStructMacroDefaultData</DefaultData>
<IdLocation>^EMR.DB1.IStructMacroD</IdLocation>
<IndexLocation>^EMR.DB1.IStructMacroI</IndexLocation>
<StreamLocation>^EMR.DB1.IStructMacroS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
