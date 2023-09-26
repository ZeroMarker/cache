/// 名称: DHCMed.CR.PO.Interface
/// 描述: 外部接口
/// 编写者：wuqk
/// 编写日期: 2012-12-05
Class DHCMed.CR.PO.Interface Extends %Persistent
{

/// 接口类别代码
Property CategoryCode As %String [ Required ];

/// 接口代码
Property InterfaceCode As %String [ Required ];

Index InterfaceCodeIndex On InterfaceCode [ Unique ];

/// 接口名称
Property InterfaceName As %String;

/// 参数列表 split by ","
Property Arguments As %String;

/// 接口类方法
Property InterfaceClassMethod As %String [ Required ];

/// 返回对象类型
Property ReturnType As %String [ Required ];

Query QueryInterfaceByCateCode(CategoryCode As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,CategoryCode,InterfaceClassMethod,InterfaceCode,InterfaceName,ReturnType,Arguments FROM Interface
 WHERE (CategoryCode = :CategoryCode)
}

Storage Default
{
<Data name="InterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryCode</Value>
</Value>
<Value name="3">
<Value>InterfaceCode</Value>
</Value>
<Value name="4">
<Value>InterfaceName</Value>
</Value>
<Value name="5">
<Value>InterfaceClassMethod</Value>
</Value>
<Value name="6">
<Value>ReturnType</Value>
</Value>
<Value name="7">
<Value>Arguments</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CR.PO.InterfaceD</DataLocation>
<DefaultData>InterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CR.PO.InterfaceD</IdLocation>
<IndexLocation>^DHCMed.CR.PO.InterfaceI</IndexLocation>
<StreamLocation>^DHCMed.CR.PO.InterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
