/// Desc:       个人模板章节继承关系表
/// Creator:    yan
/// CreateDate: 2020-5-7
Class EMRmeta.ExampleInsSecRelation Extends %Persistent
{

/// 模板ID
Property TemplateID As %String;

/// EMRmeta.ExampleInstance表ID
Property ExampleID As %String(MAXLEN = 200, TRUNCATE = 1);

/// EMRmeta.ExampleInstance表Name
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节编码
Property SectionCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节名称
Property SectionName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 章节继承状态 REFERENCE 继承，REPLACE 替换
Property Status As %String(TRUNCATE = 1);

Index IdxTemplateID On TemplateID;

Index IdxExampleID On ExampleID;

Index IdxTemplateExampleID On (TemplateID, ExampleID);

Index IdxTemplateSecCode On (TemplateID, SectionCode);

Index IdxExampleIDSection On (ExampleID, SectionCode);

Index IdxStatusSection On (ExampleID, Status, SectionCode);

Index IdxTemplateExampleIDSection On (TemplateID, ExampleID, SectionCode) [ Unique ];

Storage Default
{
<Data name="ExampleInsSecRelationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>ExampleID</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>SectionCode</Value>
</Value>
<Value name="6">
<Value>SectionName</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ExampleInsSecRelationD</DataLocation>
<DefaultData>ExampleInsSecRelationDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ExampleInsSecRelationD</IdLocation>
<IndexLocation>^DHCEMRM.ExampleInsSecRelationI</IndexLocation>
<StreamLocation>^DHCEMRM.ExampleInsSecRelationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
