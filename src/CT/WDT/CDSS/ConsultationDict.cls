/// Creator:谷雪萍
/// CreatDate:2020-01-26
/// Description：会诊医嘱字典表V2.0 
/// Table：CT.WDT.CDSS.ConsultationDict
Class CT.WDT.CDSS.ConsultationDict Extends (%Persistent, User.Abstract)
{

/// 会诊代码
Property ConsultCode As %String [ Required ];

/// 会诊名称
Property ConsultDesc As %String [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property ConsultAlias As %String;

Index CodeIndex On ConsultCode [ Unique ];

Index DescIndex On ConsultDesc;

Storage Default
{
<Data name="ConsultationDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConsultCode</Value>
</Value>
<Value name="3">
<Value>ConsultDesc</Value>
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
<Value>ConsultAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ConsultationDictD</DataLocation>
<DefaultData>ConsultationDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ConsultationDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ConsultationDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ConsultationDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
