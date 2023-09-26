/// Creator:谷雪萍
/// CreatDate:2022-01-25
/// Description：中医治法字典
/// Table：CT_WDT_CDSS.TCMTreatment
Class CT.WDT.CDSS.TCMTreatment Extends (%Persistent, User.Abstract)
{

/// 治法编码
Property TreatmentCode As %String [ Required ];

/// 治法名称
Property TreatmentName As %String;

/// 别名
Property TreatmentAlias As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态(编辑中、已审核、已弃用)
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On TreatmentCode [ Unique ];

Index NameIndex On TreatmentName;

Storage Default
{
<Data name="TCMTreatmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TreatmentCode</Value>
</Value>
<Value name="3">
<Value>TreatmentName</Value>
</Value>
<Value name="4">
<Value>TreatmentAlias</Value>
</Value>
<Value name="5">
<Value>Operator</Value>
</Value>
<Value name="6">
<Value>OperatTime</Value>
</Value>
<Value name="7">
<Value>State</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TCMTreatmentD</DataLocation>
<DefaultData>TCMTreatmentDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMTreatmentD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMTreatmentI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMTreatmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
