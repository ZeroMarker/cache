Class EMRmeta.TemplateStructure Extends %Persistent
{

Index IdxParentIDCode On (ParentID, Code) [ Unique ];

Index IdxCode On Code;

/// 结构类型枚举值，目录：Category,文档：Document,章节：Section
Property StructType As %String(TRUNCATE = 1);

/// 结构描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构编码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 关联上级节点
Property ParentID As %String(TRUNCATE = 1);

/// 关联上级节点Code
Property ParentCode As %String(TRUNCATE = 1);

/// 是否是文档固定章节(True/False),仅在StructType='Section'数据上有效
Property IsFixedSection As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

Property GlossaryInternalID As %String;

/// 病历类型页码设置（页眉、页脚）
Property MetaTemplate As %GlobalCharacterStream(LOCATION = "^DHCEMRM.TemplateStructureS");

Storage Default
{
<Data name="TemplateStructureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StructType</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>ParentID</Value>
</Value>
<Value name="7">
<Value>IsFixedSection</Value>
</Value>
<Value name="8">
<Value>ResChildCount</Value>
</Value>
<Value name="9">
<Value>MetaTemplate</Value>
</Value>
<Value name="10">
<Value>ParentCode</Value>
</Value>
<Value name="11">
<Value>GlossaryInternalID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateStructureD</DataLocation>
<DefaultData>TemplateStructureDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.TemplateStructureD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateStructureI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateStructureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
