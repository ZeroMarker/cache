/// 名称:EMRmeta.Products
/// 描述:产品模块基础字典表
/// 编写者：Donglulu
/// 编写日期: 2019-06-21
Class EMRmeta.Products Extends (%Persistent, User.Abstract)
{

/// 产品代码
Property ProductCode As %String(TRUNCATE = 1);

/// 产品名称
Property ProductName As %String(TRUNCATE = 1);

Index IdxProductCode On ProductCode [ Unique ];

Storage Default
{
<Data name="ProductsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductCode</Value>
</Value>
<Value name="3">
<Value>ProductName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ProductsD</DataLocation>
<DefaultData>ProductsDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ProductsD</IdLocation>
<IndexLocation>^DHCEMRM.ProductsI</IndexLocation>
<StreamLocation>^DHCEMRM.ProductsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
