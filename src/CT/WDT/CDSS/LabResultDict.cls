/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：检验结果字典表V2.0
/// Table：CT.WDT.CDSS.LabResultDict
Class CT.WDT.CDSS.LabResultDict Extends (%Persistent, User.Abstract)
{

/// 检验结果代码
Property LRCode As %String [ Required ];

/// 检验结果名称
Property LRDesc As %String [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property LabResultAlias As %String;

Index CodeIndex On LRCode [ Unique ];

Index DescIndex On LRDesc;

Storage Default
{
<Data name="LabResultDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LRCode</Value>
</Value>
<Value name="3">
<Value>LRDesc</Value>
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
<Value>LabResultAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.LabResultDictD</DataLocation>
<DefaultData>LabResultDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.LabResultDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.LabResultDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.LabResultDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
