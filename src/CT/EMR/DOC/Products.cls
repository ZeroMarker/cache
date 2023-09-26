/// 名称:CT.EMR.DOC.Products
/// 描述:项目
/// 编写者：yejian
/// 编写日期: 2020-9-24
/// 产品组
Class CT.EMR.DOC.Products Extends %Persistent
{

Index IdxCode On ProductCode [ Unique ];

/// 产品编码（住院:IP,门急诊:OP,通用：DOC(共用)）
Property ProductCode As %String(TRUNCATE = 1);

/// 产品名称
Property ProductName As %String(TRUNCATE = 1);

// Property ParentID As %String(TRUNCATE = 1);

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
<DataLocation>^CT.EMR.DOC.ProductsD</DataLocation>
<DefaultData>ProductsDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.ProductsD</IdLocation>
<IndexLocation>^CT.EMR.DOC.ProductsI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.ProductsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
