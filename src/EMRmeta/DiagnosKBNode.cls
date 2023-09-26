/// 名称:EMRmeta.DiagnosKBNode
/// 描述:病种知识库节点表
/// 编写者：yejian
/// 编写日期: 2016-7-19
Class EMRmeta.DiagnosKBNode Extends %Persistent
{

Index IdxKBNodeID On KBNodeID;

Index IdxKBTreeID On KBTreeID;

Index IdxDiagnosCode On DiagnosCode;

Index IdxNodeIDAndDiagnosCode On (KBNodeID, DiagnosCode) [ Unique ];

/// 知识库节点表ID
Property KBNodeID As %Integer [ Required ];

/// 目录ID
Property KBTreeID As %Integer [ Required ];

/// 病种代码EMRmeta.Diagnos的DiagnosCode
Property DiagnosCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 有效标志
Property ActiveFlag As %Integer;

Storage Default
{
<Data name="DiagnosKBNodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KBNodeID</Value>
</Value>
<Value name="3">
<Value>KBTreeID</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>ActiveFlag</Value>
</Value>
<Value name="6">
<Value>DiagnosCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DiagnosKBNodeD</DataLocation>
<DefaultData>DiagnosKBNodeDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DiagnosKBNodeD</IdLocation>
<IndexLocation>^DHCEMRM.DiagnosKBNodeI</IndexLocation>
<StreamLocation>^DHCEMRM.DiagnosKBNodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
