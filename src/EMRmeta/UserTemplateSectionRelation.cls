/// 名称:用户模板章节关系表
/// 描述:用户模板章节关系表
/// 编写者：yejian
/// 编写日期: 2020-3-10
Class EMRmeta.UserTemplateSectionRelation Extends %Persistent
{

/// 模板ID
Property TemplateID As %String;

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 名称EMRmeta.UserTemplate的Name
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节编码
Property SectionCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节名称
Property SectionName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 章节继承状态 REFERENCE 继承，REPLACE 替换
Property Status As %String(TRUNCATE = 1);

Index IdxTemplateID On TemplateID;

Index IdxCode On Code;

Index IdxTemplateCode On (TemplateID, Code);

Index IdxTemplateSecCode On (TemplateID, SectionCode);

Index IdxCodeSection On (Code, SectionCode);

Index IdxStatusSection On (Code, Status, SectionCode);

Index IdxTemplateCodeSection On (TemplateID, Code, SectionCode);

Storage Default
{
<Data name="UserTemplateSectionRelationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>SectionCode</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>SectionName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplateRelationD</DataLocation>
<DefaultData>UserTemplateSectionRelationDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplateRelationD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplateRelationI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplateRelationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
