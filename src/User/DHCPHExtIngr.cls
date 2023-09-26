/// 基础数据平台-临床知识库-药品成分字典表
Class User.DHCPHExtIngr Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_PHExtIngr ]
{

Property PHEINGCode As %String;

Property PHEINGDesc As %String;

/// 父分类
Property PHEINGLastLevel As User.DHCPHExtIngr;

/// 等级 可以使用1,2,3等字符定义，使用Ascii码来标识大小
Property PHEINGLevel As %String;

Property PHEINGActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

Property PHEINGSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// (DISPLAYLIST = ",大于,小于,等于,不大于,不小于,不等于", VALUELIST = ",>,<,=,!>,!<,<>")
Property PHEINGRelation As %String;

Property PHEINGPivaTotalQty As %Float;

Index CodeIndex On PHEINGCode [ Unique ];

Index DescIndex On PHEINGDesc [ Unique ];

Index ParCatIdx On PHEINGLastLevel;

/// 父菜单+顺序生成的索引
Index ParSeqIdx On (PHEINGLastLevel, PHEINGLevel);

Storage Default
{
<Data name="DHCPHExtIngrDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PHEINGCode</Value>
</Value>
<Value name="3">
<Value>PHEINGDesc</Value>
</Value>
<Value name="4">
<Value>PHEINGLastLevel</Value>
</Value>
<Value name="5">
<Value>PHEINGLevel</Value>
</Value>
<Value name="6">
<Value>PHEINGActiveFlag</Value>
</Value>
<Value name="7">
<Value>PHEINGSysFlag</Value>
</Value>
<Value name="8">
<Value>PHEINGRelation</Value>
</Value>
<Value name="9">
<Value>PHEINGPivaTotalQty</Value>
</Value>
</Data>
<DataLocation>^User.DHCPHExtIngrD</DataLocation>
<DefaultData>DHCPHExtIngrDefaultData</DefaultData>
<IdLocation>^User.DHCPHExtIngrD</IdLocation>
<IndexLocation>^User.DHCPHExtIngrI</IndexLocation>
<StreamLocation>^User.DHCPHExtIngrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
