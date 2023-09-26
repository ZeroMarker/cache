/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诊疗规则流程类型表V2.0
/// Table：CT.WDT.CDSS.ChartType
Class CT.WDT.CDSS.ChartType Extends (%Persistent, User.Abstract)
{

/// 诊疗规则流程类型代码
Property ChartTypeCode As %String [ Required ];

/// 诊疗规则流程类型描述
Property ChartTypeDesc As %String [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On ChartTypeCode [ Unique ];

Index DescIndex On ChartTypeDesc;

Storage Default
{
<Data name="ChartTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChartTypeCode</Value>
</Value>
<Value name="3">
<Value>ChartTypeDesc</Value>
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
</Data>
<DataLocation>^CT.WDT.CDSS.ChartTypeD</DataLocation>
<DefaultData>ChartTypeDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ChartTypeD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ChartTypeI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ChartTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
