/// Description:范例病历
/// Creator:    Candy
/// CreateDate: 2018-3-30
Class EMRmeta.ExampleInstanceSection Extends (%Persistent, %XML.Adaptor)
{

Index ExampleID On ExampleID;

Index ExampleIDSectionCode On (ExampleID, SectionCode) [ Unique ];

Property ExampleID As %Integer;

/// 模板章节编码
Property SectionCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节名称
Property SectionName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 元数据
Property MetaData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ExamInsSectionS");

/// 脚本信息
Property ScriptData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ExamInsSectionS");

/// 展现数据
Property PresentationData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ExamInsSectionS");

/// 媒体数据
Property MediasData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ExamInsSectionS");

/// 默认值
Property InitialData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ExamInsSectionS");

/// 有效标志
Property Status As %String;

/// 文本信息
Property Text As %GlobalCharacterStream(LOCATION = "^DHCEMRM.ExamInsSectionS");

/// 实例数据
Property ScatterData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ExamInsSectionS");

Storage Default
{
<Data name="ExampleInstanceSectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExampleID</Value>
</Value>
<Value name="3">
<Value>SectionCode</Value>
</Value>
<Value name="4">
<Value>SectionName</Value>
</Value>
<Value name="5">
<Value>MetaData</Value>
</Value>
<Value name="6">
<Value>ScriptData</Value>
</Value>
<Value name="7">
<Value>PresentationData</Value>
</Value>
<Value name="8">
<Value>MediasData</Value>
</Value>
<Value name="9">
<Value>InitialData</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>Text</Value>
</Value>
<Value name="12">
<Value>ScatterData</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ExamInsSectionD</DataLocation>
<DefaultData>ExampleInstanceSectionDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ExamInsSectionD</IdLocation>
<IndexLocation>^DHCEMRM.ExamInsSectionI</IndexLocation>
<StreamLocation>^DHCEMRM.ExamInsSectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
