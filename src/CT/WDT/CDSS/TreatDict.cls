/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：治疗方案字典表V2.0 
/// Table：CT.WDT.CDSS.TreatDict
Class CT.WDT.CDSS.TreatDict Extends (%Persistent, User.Abstract)
{

/// 治疗方案代码
Property TreatCode As %String [ Required ];

/// 治疗方案名称
Property TreatDesc As %String(MAXLEN = 100) [ Required ];

/// 使用标志（0已审核，1编辑中）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property TreatAlias As %String;

Index CodeIndex On TreatCode [ Unique ];

Index DescIndex On TreatDesc;

Storage Default
{
<Data name="TreatDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TreatCode</Value>
</Value>
<Value name="3">
<Value>TreatDesc</Value>
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
<Value>TreatAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TreatDictD</DataLocation>
<DefaultData>TreatDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TreatDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TreatDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TreatDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
