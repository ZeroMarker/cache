/// Desc:		图库目录
/// Creator:	Candyxu
/// CreateDate:	2017-07-13
Class EMRmeta.Image.Category Extends (%Persistent, User.Abstract, %XML.Adaptor)
{

Index IdxParentID On ParentID;

/// 编码
Property Code As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(MAXLEN = 20, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 父节点RowID
Property ParentID As %Integer;

/// 顺序
Property Sequence As %Integer;

Index IdxParentIDSequence On (ParentID, Sequence);

Index IdxName On Name;

Index IdxCode On Code;

Storage Default
{
<Data name="CategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.Image.CategoryD</DataLocation>
<DefaultData>CategoryDefaultData</DefaultData>
<IdLocation>^DHCEMRM.Image.CategoryD</IdLocation>
<IndexLocation>^DHCEMRM.Image.CategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.Image.CategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
