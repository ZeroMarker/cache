Class EPRmeta.KBNode Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Index IdxKBTreeID On KBTreeID;

Index IdxKBKnowledgeBaseID On KnowledgeBaseID;

Property Description As %String(TRUNCATE = 1);

Property KBTreeID As %String(TRUNCATE = 1);

Property KnowledgeBaseID As %String(TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property S1InstanceData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.KBNodeS");

Property S1MetaData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.KBNodeS");

Property S2InstanceData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.KBNodeS");

Property S2MetaData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.KBNodeS");

Property S3InstanceData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.KBNodeS");

Property S3MetaData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.KBNodeS");

Property Sequence As %Integer;

/// 是否通用知识库(Y:通用；N:不通用,对于个人知识库来说全部为N)
Property IsCommon As %String(TRUNCATE = 1);

/// 是否启用知识接点 （Y：启用-默认，N：停用）
Property IsInUse As %String(TRUNCATE = 1) [ InitialExpression = "Y" ];

Storage Default
{
<Data name="KBNodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>KBTreeID</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>S1InstanceData</Value>
</Value>
<Value name="6">
<Value>S1MetaData</Value>
</Value>
<Value name="7">
<Value>S2InstanceData</Value>
</Value>
<Value name="8">
<Value>S2MetaData</Value>
</Value>
<Value name="9">
<Value>S3InstanceData</Value>
</Value>
<Value name="10">
<Value>S3MetaData</Value>
</Value>
<Value name="11">
<Value>KnowledgeBaseID</Value>
</Value>
<Value name="12">
<Value>Sequence</Value>
</Value>
<Value name="13">
<Value>IsCommon</Value>
</Value>
<Value name="14">
<Value>IsInUse</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.KBNodeD</DataLocation>
<DefaultData>KBNodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.KBNodeD</IdLocation>
<IndexLocation>^DHCEPRM.KBNodeI</IndexLocation>
<StreamLocation>^DHCEPRM.KBNodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
