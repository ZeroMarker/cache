/// 名称:EMRmeta.KBTree
/// 描述:知识库目录树表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.KBTree Extends (%Persistent, User.Abstract)
{

Index IdxKnowledgeBaseID On KnowledgeBaseID;

Index IdxParentID On ParentID;

Index IdxBaseIDParentID On (KnowledgeBaseID, ParentID);

Index IdxBaseParentUserID On (KnowledgeBaseID, ParentID, PersonalKBUserID);

Index IdxBaseIDParentIDSeq On (KnowledgeBaseID, ParentID, Sequence);

Property Description As %String(TRUNCATE = 1);

Property KnowledgeBaseID As %String(TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

Property Sequence As %Integer;

Property PersonalKBUserID As %String(TRUNCATE = 1);

/// 是否启用个人知识库目录 （Y：启用-默认，N：停用）
Property IsActive As %String(TRUNCATE = 1) [ InitialExpression = "Y" ];

/// 是否分享个人知识库目录 （Y：分享，N：不分享-默认）
Property IsShare As %String(TRUNCATE = 1) [ InitialExpression = "N" ];

Storage Default
{
<Data name="KBTreeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>KnowledgeBaseID</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
<Value name="6">
<Value>ResChildCount</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>PersonalKBUserID</Value>
</Value>
<Value name="9">
<Value>IsActive</Value>
</Value>
<Value name="10">
<Value>IsShare</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.KBTreeD</DataLocation>
<DefaultData>KBTreeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.KBTreeD</IdLocation>
<IndexLocation>^DHCEMRM.KBTreeI</IndexLocation>
<StreamLocation>^DHCEMRM.KBTreeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
