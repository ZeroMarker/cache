/// 名称: 病历业务域
/// 描述: 病历业务域
/// 编写者：叶剑
/// 编写日期: 2020-5-13
Class EMRmeta.EMRStructure Extends %Persistent
{

Index IdxParentIDCode On (ParentID, Code) [ Unique ];

Index IdxCode On Code;

/// 结构类型枚举值，目录：Category,文档：Document
Property StructType As %String(TRUNCATE = 1);

/// 结构描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构编码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 关联上级节点Code
Property ParentCode As %String(TRUNCATE = 1);

/// 关联上级节点
Property ParentID As %String(TRUNCATE = 1);

/// 术语集内部标识符
Property GlossaryInternalID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="EMRStructureDefaultData">
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
<Value>GlossaryInternalID</Value>
</Value>
<Value name="8">
<Value>ParentCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRStructureD</DataLocation>
<DefaultData>EMRStructureDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRStructureD</IdLocation>
<IndexLocation>^DHCEMRM.EMRStructureI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRStructureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
