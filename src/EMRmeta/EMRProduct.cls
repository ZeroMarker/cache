/// 名称:EMRmeta.EMRProduct
/// 描述:项目上了公司哪些产品
/// 编写者：Donglulu
/// 编写日期: 2016-08-02
Class EMRmeta.EMRProduct Extends %Persistent
{

/// 产品代码
Property ProductCode As %String(TRUNCATE = 1);

/// 产品名称
Property ProductName As %String(TRUNCATE = 1);

Index IdxProductCode On ProductCode;

Storage Default
{
<Data name="EMRProductDefaultData">
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
<DataLocation>^DHCEMRM.EMRProductD</DataLocation>
<DefaultData>EMRProductDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRProductD</IdLocation>
<IndexLocation>^DHCEMRM.EMRProductI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
