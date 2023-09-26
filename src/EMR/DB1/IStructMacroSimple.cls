/// 名称:	EMR.DB1.IStructMacroSimple
/// 描述:	宏对象打散表
/// 编写者：yejian
/// 编写日期: 2022-11-3
/// 产品组：电子病历产品组
Class EMR.DB1.IStructMacroSimple Extends %Persistent
{

Index IdxForUpdate On (DocumentID, SectionCode, MacroCode, MacroItemCode);

Index IdxForGetSection On (DocumentID, MacroCode, SectionCode);

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, MacroCode, DocumentID, MacroItemCode);

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

/// 类型(menarche，menstruationPeriod ，merstrualCycle，lastMenstrual，lastMenstrualText)
Property MacroItemCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称（初潮年龄,行径天数,月经周期，末次月经/绝经，末次月经/绝经文本）
Property Name As %String(TRUNCATE = 1);

/// 值
Property Value As %String(TRUNCATE = 1);

Storage Default
{
<Data name="IStructMacroSimpleDefaultData">
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
<Value>MacroItemCode</Value>
</Value>
<Value name="14">
<Value>Name</Value>
</Value>
<Value name="15">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.IStructMacroSimpleD</DataLocation>
<DefaultData>IStructMacroSimpleDefaultData</DefaultData>
<IdLocation>^EMR.DB1.IStructMacroSimpleD</IdLocation>
<IndexLocation>^EMR.DB1.IStructMacroSimpleI</IndexLocation>
<StreamLocation>^EMR.DB1.IStructMacroSimpleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
