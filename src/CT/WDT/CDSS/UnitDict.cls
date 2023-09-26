/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：单位字典表V2.0
/// Table：CT_WDT_CDSS.UnitDict
Class CT.WDT.CDSS.UnitDict Extends (%Persistent, User.Abstract)
{

/// 单位代码
Property UnitCode As %String [ Required ];

/// 单位名称
Property UnitDesc As %String [ Required ];

/// 使用标志（0已审核，1编辑中）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property Alias As %String;

Index CodeIndex On UnitCode [ Unique ];

Index DescIndex On UnitDesc;

Index UpdateDateIndex On UpdateDate As Exact;

Storage Default
{
<Data name="UnitDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UnitCode</Value>
</Value>
<Value name="3">
<Value>UnitDesc</Value>
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
<Value>Alias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.UnitDictD</DataLocation>
<DefaultData>UnitDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.UnitDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.UnitDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.UnitDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
