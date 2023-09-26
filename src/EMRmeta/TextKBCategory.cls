/// Desc:       文本知识库目录
/// Creator:    Candyxu
/// CreateDate: 2018-2-27
Class EMRmeta.TextKBCategory Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 目录名称
Property Name As %String;

/// 目录类型
Property Type As %String;

/// 父节点
Property ParentID As %Integer;

/// 目录顺序
Property Sequence As %Integer;

/// 是否有效
Property IsValid As %String;

Index IdxName On Name;

Index IdxParentIDSeq On (ParentID, Sequence);

Index IdxParentIDName On (ParentID, Name);

Index IdxType On Type;

Index IdxParentID On ParentID;

Storage Default
{
<Data name="TextKBCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TextKBCategoryD</DataLocation>
<DefaultData>TextKBCategoryDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TextKBCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.TextKBCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.TextKBCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
