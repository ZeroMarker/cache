/// Desc:		图库目录，相当于KBCategory
/// Creator:	Kumon Xie
/// CreateDate:	2011-09-16
Class EPRmeta.ImageCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxParentID On ParentID;

/// 名称
Property Name As %String(MAXLEN = 20, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 父节点RowID
Property ParentID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ImageCategoryDefaultData">
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
</Data>
<DataLocation>^DHCEPRM.ImageCategoryD</DataLocation>
<DefaultData>ImageCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.ImageCategoryD</IdLocation>
<IndexLocation>^DHCEPRM.ImageCategoryI</IndexLocation>
<StreamLocation>^DHCEPRM.ImageCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
