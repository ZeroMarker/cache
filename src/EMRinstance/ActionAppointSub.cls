/// 名称: EMRinstance.ActionAppointSub
/// 描述: 会诊病历浏览授权,授权子表
/// 编写者: niucaicai
/// 编写日期:2015-12-07
Class EMRinstance.ActionAppointSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxConsultationID On ConsultationID;

/// 类型(枚举值:CONS,比如院内会诊、远程会诊等)
Property ConsultationType As %String(TRUNCATE = 1);

/// 会诊记录ID
Property ConsultationID As %String(TRUNCATE = 1);

/// 申请授权记录ID
Property AppointID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ActionAppointSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConsultationType</Value>
</Value>
<Value name="3">
<Value>ConsultationID</Value>
</Value>
<Value name="4">
<Value>AppointID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.ActionAppointSubD</DataLocation>
<DefaultData>ActionAppointSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.ActionAppointSubD</IdLocation>
<IndexLocation>^DHCEMRI.ActionAppointSubI</IndexLocation>
<StreamLocation>^DHCEMRI.ActionAppointSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
