/// 名称: EMRmeta.MedicalConceptLocation
/// 描述: 医学概念与章节关联(科室)
/// 编写者：yejian
/// 编写日期: 2017-2-22
Class EMRmeta.MedicalConceptLocation Extends %Persistent
{

Index IdxCode On Code [ Unique ];

Index IdxConceptCode On ConceptCode;

Index IdxTemplateSection On (TemplateCode, SectionCode);

/// 数据值域标示符 引用到模板使用的Code [Code n:1 ConceptCode]
Property Code As %String;

/// 医学概念码表Code
Property ConceptCode As %String;

/// 显示名称
Property DisplayName As %String;

/// 概念详细描述说明
Property Description As %String;

/// 章节维护模板编码
Property TemplateCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板名称
Property TemplateName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板章节编码
Property SectionCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板章节名称
Property SectionName As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="MedicalConceptLocationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>ConceptCode</Value>
</Value>
<Value name="4">
<Value>DisplayName</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>TemplateCode</Value>
</Value>
<Value name="7">
<Value>TemplateName</Value>
</Value>
<Value name="8">
<Value>SectionCode</Value>
</Value>
<Value name="9">
<Value>SectionName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.MedConceptLocationD</DataLocation>
<DefaultData>MedicalConceptLocationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.MedConceptLocationD</IdLocation>
<IndexLocation>^DHCEMRM.MedConceptLocationI</IndexLocation>
<StreamLocation>^DHCEMRM.MedConceptLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
