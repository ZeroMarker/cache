/// creator:lulin
/// createdate:2019-12-15
/// description:系统自动获取患者数据明细表
Class DHCNS.Config.NsAutoPatSub Extends %Persistent
{

Relationship Parref As DHCNS.Config.NsAutoPat [ Cardinality = parent, Inverse = ChildSub ];

/// 就诊号
Property KeyWord As %String [ SqlColumnNumber = 2, SqlFieldName = KeyWord ];

/// 主管医生
Property Doctor As %String [ SqlColumnNumber = 3, SqlFieldName = Doctor ];

/// 主管护士
Property Nurse As %String [ SqlColumnNumber = 4, SqlFieldName = Nurse ];

/// 备注信息,姓名
Property SubDesc As %String [ SqlColumnNumber = 5, SqlFieldName = SubDesc ];

/// 是否是婴儿Y/N
Property IsBaby As %String [ SqlColumnNumber = 6, SqlFieldName = IsBaby ];

/// 就诊日期
Property AdmDate As %Date [ SqlColumnNumber = 7, SqlFieldName = AdmDate ];

/// 就诊时间
Property AdmTime As %Time [ SqlColumnNumber = 8, SqlFieldName = AdmTime ];

/// 出生日期[yyyy-mm-dd]
Property PerBirthDate As %String [ SqlColumnNumber = 9, SqlFieldName = PerBirthDate ];

/// 诊断描述
Property PerDiagnos As %String(MAXLEN = 10000) [ SqlColumnNumber = 10, SqlFieldName = PerDiagnos ];

/// 出院描述
Property PerLeaveDiagnos As %String(MAXLEN = 10000) [ SqlColumnNumber = 11, SqlFieldName = PerLeaveDiagnos ];

Index key On (Parref, KeyWord);

Index IsBaby On (Parref, IsBaby);

Storage Default
{
<Data name="NsAutoPatSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KeyWord</Value>
</Value>
<Value name="3">
<Value>Doctor</Value>
</Value>
<Value name="4">
<Value>Nurse</Value>
</Value>
<Value name="5">
<Value>SubDesc</Value>
</Value>
<Value name="6">
<Value>IsBaby</Value>
</Value>
<Value name="7">
<Value>AdmDate</Value>
</Value>
<Value name="8">
<Value>AdmTime</Value>
</Value>
<Value name="9">
<Value>PerBirthDate</Value>
</Value>
<Value name="10">
<Value>PerDiagnos</Value>
</Value>
<Value name="11">
<Value>PerLeaveDiagnos</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsAutoPatSubD</DataLocation>
<DefaultData>NsAutoPatSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNS.Config.NsAutoPatSubI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsAutoPatSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
