/// 基础数据平台-临床知识库-分类/类型字典表
Class User.DHCPHLibCat Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_PHLibCat ]
{

Property PHICCode As %String;

Property PHICDesc As %String;

/// 父分类
Property PHICLastLevel As User.DHCPHLibCat;

/// 等级 可以使用1,2,3等字符定义，使用Ascii码来标识大小
Property PHICLevel As %String;

Property PHICLibDr As User.DHCPHLibaryLabel;

Property PHICActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

Property PHICSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// 是否需要皮试
Property PHICSkinTestFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

Index CodeIndex On PHICCode [ Unique ];

Index DescIndex On PHICDesc [ Unique ];

Index ParCatIdx On PHICLastLevel;

/// 父菜单+顺序生成的索引
Index ParSeqIdx On (PHICLastLevel, PHICLevel);

Storage Default
{
<Data name="DHCPHLibCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PHICCode</Value>
</Value>
<Value name="3">
<Value>PHICDesc</Value>
</Value>
<Value name="4">
<Value>PHICLastLevel</Value>
</Value>
<Value name="5">
<Value>PHICLevel</Value>
</Value>
<Value name="6">
<Value>PHICLibDr</Value>
</Value>
<Value name="7">
<Value>PHICActiveFlag</Value>
</Value>
<Value name="8">
<Value>PHICSysFlag</Value>
</Value>
<Value name="9">
<Value>PHICSkinTestFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCPHLibCatD</DataLocation>
<DefaultData>DHCPHLibCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPHLibCatD</IdLocation>
<IndexLocation>^User.DHCPHLibCatI</IndexLocation>
<StreamLocation>^User.DHCPHLibCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
