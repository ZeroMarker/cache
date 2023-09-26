/// 名称:EMRmeta.TemplateVersion
/// 描述:文档模板版本信息表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.TemplateVersion Extends %Persistent
{

Index IndexTemplateVersion On (TemplateID, VersionNumber);

Property Author As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property LastSaveDate As %Date;

Property LastSaveTime As %Time;

Property MetaData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.TemplateVersionS");

Property PresentationData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.TemplateVersionS");

Property GridData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.TemplateVersionS");

/// 病历模板规则脚本定义信息
Property ScriptData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.TemplateVersionS");

Property MediasData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.TemplateVersionS");

Property InitialData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.TemplateVersionS");

Property PublicationDate As %Date;

Property PublicationTime As %Time;

Property Status As %Integer;

Property TemplateID As %String(TRUNCATE = 1);

Property VersionNumber As %Integer;

/// 病历摘要信息
Property TemplateSummary As %String(MAXLEN = 20000, TRUNCATE = 1);

Storage Default
{
<Data name="TemplateVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Author</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>InitialData</Value>
</Value>
<Value name="6">
<Value>LastSaveDate</Value>
</Value>
<Value name="7">
<Value>LastSaveTime</Value>
</Value>
<Value name="8">
<Value>MetaData</Value>
</Value>
<Value name="9">
<Value>PresentationData</Value>
</Value>
<Value name="10">
<Value>GridData</Value>
</Value>
<Value name="11">
<Value>ScriptData</Value>
</Value>
<Value name="12">
<Value>PublicationDate</Value>
</Value>
<Value name="13">
<Value>PublicationTime</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>TemplateID</Value>
</Value>
<Value name="16">
<Value>VersionNumber</Value>
</Value>
<Value name="17">
<Value>EditorType</Value>
</Value>
<Value name="18">
<Value>TemplateSummary</Value>
</Value>
<Value name="19">
<Value>MediasData</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateVersionD</DataLocation>
<DefaultData>TemplateVersionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.TemplateVersionD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateVersionI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
