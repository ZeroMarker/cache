/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：通用名字典表V2.0
/// Table：CT.WDT.CDSS.CommonDict
Class CT.WDT.CDSS.CommonDict Extends (%Persistent, User.Abstract)
{

/// 通用名字典类型
Property TypeDR As CT.WDT.CDSS.CommonDictType [ Required ];

/// 通用名代码
Property DictCode As %String [ Required ];

/// 通用名名称
Property DictDesc As %String [ Required ];

/// 使用标志（0已审核，1编辑中）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 默认单位
Property DefaultUnitDR As CT.WDT.CDSS.UnitDict;

/// 英文名称
Property EnName As %String;

/// 别名
Property DictAlias As %String;

Index CodeIndex On DictCode [ Unique ];

Index DescIndex On DictDesc;

Index TypeIndex On TypeDR;

Index UpdateDateIndex On UpdateDate As Exact;

Index TypeDescIndex On (TypeDR As Exact, DictDesc As Exact);

Index TypeCodeIndex On (TypeDR As Exact, DictCode As Exact);

Storage Default
{
<Data name="CommonDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeDR</Value>
</Value>
<Value name="3">
<Value>DictCode</Value>
</Value>
<Value name="4">
<Value>DictDesc</Value>
</Value>
<Value name="5">
<Value>UseFlag</Value>
</Value>
<Value name="6">
<Value>UpdateUser</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
<Value name="9">
<Value>DefaultUnitDR</Value>
</Value>
<Value name="10">
<Value>EnName</Value>
</Value>
<Value name="11">
<Value>DictAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.CommonDictD</DataLocation>
<DefaultData>CommonDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.CommonDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.CommonDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.CommonDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
