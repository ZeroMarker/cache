/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诱因/病因字典表V2.0
/// Table：CT.WDT.CDSS.PathogenyDict
Class CT.WDT.CDSS.PathogenyDict Extends (%Persistent, User.Abstract)
{

/// 病因代码
Property PathogenyCode As %String [ Required ];

/// 病因名称
Property PathogenyDesc As %String [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property PathogenyAlias As %String;

Index CodeIndex On PathogenyCode [ Unique ];

Index DescIndex On PathogenyDesc;

Storage Default
{
<Data name="PathogenyDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PathogenyCode</Value>
</Value>
<Value name="3">
<Value>PathogenyDesc</Value>
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
<Value>PathogenyAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.PathogenyDictD</DataLocation>
<DefaultData>PathogenyDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.PathogenyDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.PathogenyDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.PathogenyDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
