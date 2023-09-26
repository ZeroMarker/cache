/// 名称:用户模板章节表
/// 描述:用户模板章节表
/// 编写者：yejian
/// 编写日期: 2017-11-27
Class EMRmeta.UserTemplateSection Extends %Persistent
{

Index IdxCode On Code;

Index IdxKbBaseID On (Code, KbBaseID);

Index IdxCodeSection On (Code, SectionCode);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节编码
Property SectionCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// KbBaseID
Property KbBaseID As %String;

/// 有效标志
Property ActiveFlag As %String;

/// 元数据
Property MetaData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.UserTemplateSectionS");

/// 脚本信息
Property ScriptData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.UserTemplateSectionS");

/// 展现数据
Property PresentationData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.UserTemplateSectionS");

/// 媒体数据
Property MediasData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.UserTemplateSectionS");

/// 默认值
Property InitialData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.UserTemplateSectionS");

Storage Default
{
<Data name="UserTemplateSectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>SectionCode</Value>
</Value>
<Value name="4">
<Value>KbBaseID</Value>
</Value>
<Value name="5">
<Value>ActiveFlag</Value>
</Value>
<Value name="6">
<Value>MetaData</Value>
</Value>
<Value name="7">
<Value>ScriptData</Value>
</Value>
<Value name="8">
<Value>PresentationData</Value>
</Value>
<Value name="9">
<Value>MediasData</Value>
</Value>
<Value name="10">
<Value>InitialData</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplateSectionD</DataLocation>
<DefaultData>UserTemplateSectionDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplateSectionD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplateSectionI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplateSectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
