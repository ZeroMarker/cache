/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：护理结果字典表V2.0
/// Table：CT.WDT.CDSS.NurseResultDict
Class CT.WDT.CDSS.NurseResultDict Extends (%Persistent, User.Abstract)
{

/// 护理结果代码
Property NRCode As %String [ Required ];

/// 护理结果名称
Property NRDesc As %String [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property NurseResultAlias As %String;

Index CodeIndex On NRCode [ Unique ];

Index DescIndex On NRDesc;

Storage Default
{
<Data name="NurseResultDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NRCode</Value>
</Value>
<Value name="3">
<Value>NRDesc</Value>
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
<Value>NurseResultAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.NurseResultDictD</DataLocation>
<DefaultData>NurseResultDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.NurseResultDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.NurseResultDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.NurseResultDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
