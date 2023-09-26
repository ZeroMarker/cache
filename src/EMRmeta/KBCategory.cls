/// 名称:EMRmeta.KBCategory
/// 描述:知识库目录表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.KBCategory Extends %Persistent
{

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

Storage Default
{
<Data name="KBCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>ResChildCount</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.KBCategoryD</DataLocation>
<DefaultData>KBCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.KBCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.KBCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.KBCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
