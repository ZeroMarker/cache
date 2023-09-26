/// 名称:EMRmeta.KBNode
/// 描述:知识库节点诊断表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.KBNodeDiagnos Extends %Persistent
{

Index IdxKBNodeID On KBNodeID;

Index IdxKBTreeID On KBTreeID;

Index IdxKBDiagnosID On KBDiagnosID;

Index IdxNodeDiagnosID On (KBNodeID, KBDiagnosID) [ Unique ];

/// 知识库节点表ID
Property KBNodeID As %Integer [ Required ];

/// 目录ID
Property KBTreeID As %Integer [ Required ];

/// 知识库诊断表ID
Property KBDiagnosID As %Integer [ Required ];

/// 有效标志
Property ActiveFlag As %Integer;

Storage Default
{
<Data name="KBNodeDiagnosDefaultData">
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
<Value>KBDiagnosID</Value>
</Value>
<Value name="5">
<Value>ActiveFlag</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.KBNodeDiagnosD</DataLocation>
<DefaultData>KBNodeDiagnosDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.KBNodeDiagnosD</IdLocation>
<IndexLocation>^DHCEMRM.KBNodeDiagnosI</IndexLocation>
<StreamLocation>^DHCEMRM.KBNodeDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
