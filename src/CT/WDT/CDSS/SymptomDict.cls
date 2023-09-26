/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：症状字典表V2.0
/// Table：CT.WDT.CDSS.SymptomDict
Class CT.WDT.CDSS.SymptomDict Extends (%Persistent, User.Abstract)
{

/// 症状代码
Property SymptomCode As %String [ Required ];

/// 症状名称
Property SymptomDesc As %String [ Required ];

/// 使用标志（0已审核，1编辑中）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property SymptomAlias As %String;

Index CodeIndex On SymptomCode [ Unique ];

Index DescIndex On SymptomDesc;

Index UpdateDateIndex On UpdateDate As Exact;

Storage Default
{
<Data name="SymptomDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SymptomCode</Value>
</Value>
<Value name="3">
<Value>SymptomDesc</Value>
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
<Value>SymptomAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.SymptomDictD</DataLocation>
<DefaultData>SymptomDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.SymptomDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.SymptomDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.SymptomDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
