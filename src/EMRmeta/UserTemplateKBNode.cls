/// 名称:用户模板知识库节点表
/// 描述:用户模板知识库节点表
/// 编写者：yejian
/// 编写日期: 2017-11-7
Class EMRmeta.UserTemplateKBNode Extends %Persistent
{

Index IdxKBNodeID On KBNodeID;

Index IdxCode On Code;

Index IdxKbBaseIDSeq On (Code, KbBaseID, Sequence);

Index IdxCodeSection On (Code, SectionCode);

Index IdxCodeSectionComposite On (Code, SectionCode, CompositeCode);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节编码
Property SectionCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板复合编码
Property CompositeCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// KbBaseID
Property KbBaseID As %String [ Required ];

/// 知识库节点表ID
Property KBNodeID As %String [ Required ];

/// 顺序
Property Sequence As %Integer;

/// 有效标志
Property ActiveFlag As %String;

Storage Default
{
<Data name="UserTemplateKBNodeDefaultData">
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
<Value>KBNodeID</Value>
</Value>
<Value name="5">
<Value>KBTreeID</Value>
</Value>
<Value name="6">
<Value>ActiveFlag</Value>
</Value>
<Value name="7">
<Value>KBNodeIDS</Value>
</Value>
<Value name="8">
<Value>KbBaseID</Value>
</Value>
<Value name="9">
<Value>CompositeCode</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplateKBNodeD</DataLocation>
<DefaultData>UserTemplateKBNodeDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplateKBNodeD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplateKBNodeI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplateKBNodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
