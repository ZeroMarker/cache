/// Creator:丁亚男
/// CreatDate:2020-06-04
/// Description：频率字典 
/// Table：CT.WDT.CDSS.FrequencyDict
Class CT.WDT.CDSS.FrequencyDict Extends (%Persistent, User.Abstract)
{

/// 频率编码
Property FrequencyCode As %String [ Required ];

/// 频率名称
Property FrequencyName As %String;

/// 频率描述
Property FrequencyDesc As %String(MAXLEN = "");

/// 使用标志（0编辑中，1已删除，2已审核）
Property UseFlag As %String;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String [ InitialExpression = "dhcc" ];

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 频率别名
Property FrequencyAlias As %String;

Index CodeIndex On FrequencyCode [ Unique ];

Index NameIndex On FrequencyName;

Storage Default
{
<Data name="FrequencyDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FrequencyCode</Value>
</Value>
<Value name="3">
<Value>FrequencyName</Value>
</Value>
<Value name="4">
<Value>FrequencyDesc</Value>
</Value>
<Value name="5">
<Value>UseFlag</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateUserID</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
<Value name="9">
<Value>FrequencyAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.FrequencyDictD</DataLocation>
<DefaultData>FrequencyDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.FrequencyDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.FrequencyDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.FrequencyDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
