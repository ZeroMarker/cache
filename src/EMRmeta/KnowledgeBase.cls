/// 名称:EMRmeta.KnowledgeBase
/// 描述:知识库主表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.KnowledgeBase Extends (%Persistent, User.Abstract)
{

Property Description As %String(TRUNCATE = 1);

Property KBCategoryID As %String(TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 使用状态DOC 文档型，GRID 网格型。
Property NodeType As %String(TRUNCATE = 1) [ InitialExpression = "DOC" ];

Storage Default
{
<Data name="KnowledgeBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>KBCategoryID</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>S1Name</Value>
</Value>
<Value name="6">
<Value>S2Name</Value>
</Value>
<Value name="7">
<Value>S3Name</Value>
</Value>
<Value name="8">
<Value>SegmentNumber</Value>
</Value>
<Value name="9">
<Value>NodeType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.KnowledgeBaseD</DataLocation>
<DefaultData>KnowledgeBaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.KnowledgeBaseD</IdLocation>
<IndexLocation>^DHCEMRM.KnowledgeBaseI</IndexLocation>
<StreamLocation>^DHCEMRM.KnowledgeBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
