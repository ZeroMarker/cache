/// 名称:EMRmeta.Repository.iBookCategory
/// 描述:联机文献目录表
/// 编写者：guozongtao
/// 编写日期: 2014-8-19
Class EMRmeta.Repository.iBookCategory Extends %Persistent
{

Index IdxParentID On ParentID;

/// 目录描述信息
Property Description As %String;

/// 目录名称
Property CategoryName As %String;

/// 上级目录ID
Property ParentID As %String;

/// 包含联机文献数量
Property ResChildCount As %String;

/// 目录顺序
Property CategorySeq As %String;

Storage Default
{
<Data name="iBookCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>CategoryName</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>ResChildCount</Value>
</Value>
<Value name="6">
<Value>CategorySeq</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.iBookCategoryD</DataLocation>
<DefaultData>iBookCategoryDefaultData</DefaultData>
<IdLocation>^DHCEMRM.iBookCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.iBookCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.iBookCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
