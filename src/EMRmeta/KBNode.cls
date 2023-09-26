/// 名称:EMRmeta.KBNode
/// 描述:知识库目录表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.KBNode Extends (%Persistent, User.Abstract)
{

Index IdxKBTreeID On KBTreeID;

Index IdxKBKnowledgeBaseID On KnowledgeBaseID;

Index idxUserID On UserID;

Index IdxKBTreeIDSeq On (KBTreeID, Sequence);

/// 知识库描述信息
Property Description As %String(TRUNCATE = 1);

/// 唯一标示
Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

/// 父目录(tree)
Property KBTreeID As %String(TRUNCATE = 1);

/// 目录（KnowledgeBaseID)
Property KnowledgeBaseID As %String(TRUNCATE = 1);

/// 节点名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 元数据
Property MetaData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.KBNodeS");

/// 脚本信息
Property ScriptData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.KBNodeS");

/// 展现数据
Property PresentationData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.KBNodeS");

/// 媒体数据
Property MediasData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.KBNodeS");

/// 默认值
Property InitialData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.KBNodeS");

/// 顺序
Property Sequence As %Integer;

/// 是否通用知识库(Y:通用；N:不通用,对于个人知识库来说全部为N)
Property IsCommon As %String(TRUNCATE = 1);

/// 是否启用知识接点 （Y：启用-默认，N：停用）
Property IsInUse As %String(TRUNCATE = 1) [ InitialExpression = "Y" ];

/// 创建者UserID
Property UserID As %String(TRUNCATE = 1);

/// 使用状态 ALL 通用，DOC 文档型，GRID 网格型。
Property NodeType As %String(TRUNCATE = 1);

/// 纯文本内容
Property TextData As %String(MAXLEN = 30000, TRUNCATE = 1);

/// 是否分享个人知识库节点 （Y：分享，N：不分享-默认）
Property IsShare As %String(TRUNCATE = 1) [ InitialExpression = "N" ];

Index IdxIsShareIsInUse On (IsShare, IsInUse);

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
<Value>KnowledgeBaseID</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>MetaData</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>IsCommon</Value>
</Value>
<Value name="9">
<Value>IsInUse</Value>
</Value>
<Value name="10">
<Value>PresentationData</Value>
</Value>
<Value name="11">
<Value>ScriptData</Value>
</Value>
<Value name="12">
<Value>GUID</Value>
</Value>
<Value name="13">
<Value>Author</Value>
</Value>
<Value name="14">
<Value>UserID</Value>
</Value>
<Value name="15">
<Value>NodeType</Value>
</Value>
<Value name="16">
<Value>TextData</Value>
</Value>
<Value name="17">
<Value>InitialData</Value>
</Value>
<Value name="18">
<Value>MediasData</Value>
</Value>
<Value name="19">
<Value>IsShare</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.KBNodeD</DataLocation>
<DefaultData>KBNodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.KBNodeD</IdLocation>
<IndexLocation>^DHCEMRM.KBNodeI</IndexLocation>
<StreamLocation>^DHCEMRM.KBNodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
