/// 知识库诊断表
Class EPRmeta.KBNodeDiagnos Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
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
<Value>KBDiagnosID</Value>
</Value>
<Value name="3">
<Value>KBNodeID</Value>
</Value>
<Value name="4">
<Value>KBTreeID</Value>
</Value>
<Value name="5">
<Value>ActiveFlag</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.KBNodeDiagnosD</DataLocation>
<DefaultData>KBNodeDiagnosDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.KBNodeDiagnosD</IdLocation>
<IndexLocation>^DHCEPRM.KBNodeDiagnosI</IndexLocation>
<StreamLocation>^DHCEPRM.KBNodeDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
