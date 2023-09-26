/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：通用字典类型表V2.0 
/// Table：CT.WDT.CDSS.CommonDictType
Class CT.WDT.CDSS.CommonDictType Extends (%Persistent, User.Abstract)
{

/// 类型代码
Property TypeCode As %String [ Required ];

/// 类型描述（目前有月经婚育字典、妊娠/产后状态字典、生命体征字典、麻醉方式字典、存在状态字典）
Property TypeDesc As %String [ Required ];

/// 使用标志（0已审核，1编辑中）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property TypeAlias As %String;

Index CodeIndex On TypeCode [ Unique ];

Index DescIndex On TypeDesc;

Index UpdateDateIndex On UpdateDate As Exact;

Storage Default
{
<Data name="CommonDictTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeCode</Value>
</Value>
<Value name="3">
<Value>TypeDesc</Value>
</Value>
<Value name="4">
<Value>UseFlag</Value>
</Value>
<Value name="5">
<Value>UpdateUser</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>Remarks</Value>
</Value>
<Value name="8">
<Value>TypeAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.CommonDictTypeD</DataLocation>
<DefaultData>CommonDictTypeDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.CommonDictTypeD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.CommonDictTypeI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.CommonDictTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
