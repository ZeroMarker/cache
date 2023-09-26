/// 名称:CT.EMR.IP.SysOption
/// 描述:系统参数设置表（住院 IP）
/// 编写者：yejian
/// 编写日期: 2020-7-8
Class CT.EMR.IP.SysOption Extends %Persistent
{

Index idxTypeName On (Type, Name) [ Unique ];

Index idxName On Name;

/// 参数名称
Property Name As %String(TRUNCATE = 1);

/// 产品组标识
Property Product As CT.EMR.DOC.Products;

/// 参数类型(通用文档:DOC，住院：IP，门急诊：OP)
Property Type As %String(TRUNCATE = 1);

/// 参数描述
Property Description As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 参数值
Property OptionValue As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 参数显示状态（Y：显示，N：隐藏）
Property IsVisible As %String(TRUNCATE = 1);

Storage Default
{
<Data name="SysOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>OptionValue</Value>
</Value>
<Value name="6">
<Value>IsVisible</Value>
</Value>
<Value name="7">
<Value>Product</Value>
</Value>
</Data>
<DataLocation>^CT.EMR.IP.SysOptionD</DataLocation>
<DefaultData>SysOptionDefaultData</DefaultData>
<IdLocation>^CT.EMR.IP.SysOptionD</IdLocation>
<IndexLocation>^CT.EMR.IP.SysOptionI</IndexLocation>
<StreamLocation>^CT.EMR.IP.SysOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
