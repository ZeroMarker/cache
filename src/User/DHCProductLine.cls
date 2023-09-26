/// 名称: User.DHCProductLine
/// 描述: 产品线查询
/// 编写者：谷雪萍
/// 编写日期: 2015-10-15
Class User.DHCProductLine Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ProductLine ]
{

/// 产品线编码,要求唯一
Property Code As %String(MAXLEN = 100) [ Required ];

/// 产品线名称,中文描述
Property Caption As %String(MAXLEN = 200) [ Required ];

/// 父菜单指针
Property ParentDr As User.DHCProductLine;

/// 简写名称
Property Shorthand As %String;

/// 实施分类（区域医疗/传统HIs/专业系统/健康乐）
Property Type As %String;

/// 产品线报价
Property Offer As %String;

/// 产品额定人月
Property ProManMonth As %Float;

/// 实施额定人月
Property ImpManMonth As %Float;

/// 人月数
Property ManMonth As %Float;

/// 对内报价
Property InQuotation As %String;

/// 对外报价
Property OutQuotation As %String;

/// 产品线描述
Property ProDesc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1);

/// 是否独立运行
Property StandaloneFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// 是否销售
Property SalesFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// 是否有效
Property ActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// 显示顺序,可以使用1,2,3或者A、B、C等字符定义，使用Ascii码来标识大小
Property Sequence As %String;

Index CodeIndex On Code [ Unique ];

Index ParIndex On ParentDr;

/// 父菜单+顺序生成的索引
Index ParSeqIdx On (ParentDr, Sequence);

Storage Default
{
<Data name="DHCProductLineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Caption</Value>
</Value>
<Value name="4">
<Value>ParentDr</Value>
</Value>
<Value name="5">
<Value>Shorthand</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>Offer</Value>
</Value>
<Value name="8">
<Value>ProManMonth</Value>
</Value>
<Value name="9">
<Value>ImpManMonth</Value>
</Value>
<Value name="10">
<Value>ManMonth</Value>
</Value>
<Value name="11">
<Value>InQuotation</Value>
</Value>
<Value name="12">
<Value>OutQuotation</Value>
</Value>
<Value name="13">
<Value>ProDesc</Value>
</Value>
<Value name="14">
<Value>StandaloneFlag</Value>
</Value>
<Value name="15">
<Value>SalesFlag</Value>
</Value>
<Value name="16">
<Value>ActiveFlag</Value>
</Value>
<Value name="17">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^User.DHCProductLineD</DataLocation>
<DefaultData>DHCProductLineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCProductLineD</IdLocation>
<IndexLocation>^User.DHCProductLineI</IndexLocation>
<StreamLocation>^User.DHCProductLineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
