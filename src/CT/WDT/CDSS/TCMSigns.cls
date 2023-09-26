/// Creator:谷雪萍
/// CreatDate:2022-01-25
/// Description：中医体征字典
/// Table：CT_WDT_CDSS.TCMSigns
Class CT.WDT.CDSS.TCMSigns Extends (%Persistent, User.Abstract)
{

/// 体征编码
Property SignCode As %String [ Required ];

/// 体征名称
Property SignName As %String;

/// 别名
Property SignAlias As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态(编辑中、已审核、已弃用)
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On SignCode [ Unique ];

Index NameIndex On SignName;

Storage Default
{
<Data name="TCMSignsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SignCode</Value>
</Value>
<Value name="3">
<Value>SignName</Value>
</Value>
<Value name="4">
<Value>SignAlias</Value>
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
<DataLocation>^CT.WDT.CDSS.TCMSignsD</DataLocation>
<DefaultData>TCMSignsDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMSignsD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMSignsI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMSignsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
