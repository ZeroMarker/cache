Class EPRinstance.EPRActionAppointSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxConsultationID On ConsultationID [ Unique ];

/// 类型(枚举值:CONS,比如院内会诊、远程会诊等)
Property ConsultationType As %String(TRUNCATE = 1);

/// 会诊记录ID
Property ConsultationID As %String(TRUNCATE = 1);

/// 申请授权记录ID
Property AppointID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="EPRActionAppointSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppointID</Value>
</Value>
<Value name="3">
<Value>ConsultationID</Value>
</Value>
<Value name="4">
<Value>ConsultationType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.EPRActionAppointSubD</DataLocation>
<DefaultData>EPRActionAppointSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.EPRActionAppointSubD</IdLocation>
<IndexLocation>^DHCEPRI.EPRActionAppointSubI</IndexLocation>
<StreamLocation>^DHCEPRI.EPRActionAppointSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
