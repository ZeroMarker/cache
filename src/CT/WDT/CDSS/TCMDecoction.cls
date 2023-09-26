/// Creator:胡宜良
/// CreatDate:2021-08-19
/// Description：中药煎法字典
/// Table：CT.WDT.CDSS.TCMDecoction
Class CT.WDT.CDSS.TCMDecoction Extends (%Persistent, User.Abstract)
{

/// 煎法编码
Property DecoctionCode As %String [ Required ];

/// 煎法名称
Property DecoctionName As %String;

/// 适用中药
Property DecoctionApplication As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态(编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property DecoctionAlias As %String;

Index CodeIndex On DecoctionCode [ Unique ];

Index NameIndex On DecoctionName As Exact;

Index OperatTimeIndex On OperatTime;

Storage Default
{
<Data name="TCMDecoctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DecoctionCode</Value>
</Value>
<Value name="3">
<Value>DecoctionName</Value>
</Value>
<Value name="4">
<Value>DecoctionApplication</Value>
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
<Value name="9">
<Value>DecoctionAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TCMDecoctionD</DataLocation>
<DefaultData>TCMDecoctionDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMDecoctionD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMDecoctionI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMDecoctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
