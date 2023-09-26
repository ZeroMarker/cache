Class DHCExternalService.RegInterface.Entity.SelfAppt.List.ApptOrder Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Order";

/// 预约单号
Property OrderCode As %String(TRUNCATE = 1);

/// 申请日期(YYYY-MM-DD)
Property OrderApptDate As %String(TRUNCATE = 1);

/// 预约单状态(normal 正常;cancel 退号)
Property OrderStatus As %String(TRUNCATE = 1);

/// 预约单申请人（患者姓名）
Property OrderApptUser As %String(TRUNCATE = 1);

/// 病人主索引号（病人ID）
Property PatientNo As %String(TRUNCATE = 1);

/// 预约就诊日期(YYYY-MM-DD)
Property AdmitDate As %String(TRUNCATE = 1);

/// 就诊科室
Property Department As %String(TRUNCATE = 1);

/// 医生
Property Doctor As %String(TRUNCATE = 1);

/// 医生职称
Property DoctorTitle As %String(TRUNCATE = 1);

/// 总费用
Property RegFee As %String(TRUNCATE = 1);

/// 就诊序号
Property SeqCode As %String(TRUNCATE = 1);

/// 候诊地点
Property AdmitAddress As %String(TRUNCATE = 1);

/// 就诊时段
Property SessionName As %String(TRUNCATE = 1);

/// 预约单内容
Property OrderContent As %String(TRUNCATE = 1);

/// 候诊时间
Property AdmitRange As %String(TRUNCATE = 1);

/// 联系电话
Property TelePhoneNo As %String(TRUNCATE = 1);

/// 手机
Property MobileNo As %String(TRUNCATE = 1);

/// 允许退号标志Y：允许退号
Property AllowRefundFlag As %String(TRUNCATE = 1);

/// 支付状态P:已支付TB：未支付R：已退费
Property PayFlag As %String(TRUNCATE = 1);

/// 医院
Property HospitalName As %String(TRUNCATE = 1);

/// 专业
Property ServiceName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ApptOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderCode</Value>
</Value>
<Value name="3">
<Value>OrderApptDate</Value>
</Value>
<Value name="4">
<Value>OrderStatus</Value>
</Value>
<Value name="5">
<Value>OrderApptUser</Value>
</Value>
<Value name="6">
<Value>PatientNo</Value>
</Value>
<Value name="7">
<Value>AdmitDate</Value>
</Value>
<Value name="8">
<Value>Department</Value>
</Value>
<Value name="9">
<Value>Doctor</Value>
</Value>
<Value name="10">
<Value>DoctorTitle</Value>
</Value>
<Value name="11">
<Value>RegFee</Value>
</Value>
<Value name="12">
<Value>SeqCode</Value>
</Value>
<Value name="13">
<Value>AdmitAddress</Value>
</Value>
<Value name="14">
<Value>SessionName</Value>
</Value>
<Value name="15">
<Value>OrderContent</Value>
</Value>
<Value name="16">
<Value>AdmitRange</Value>
</Value>
<Value name="17">
<Value>TelePhoneNo</Value>
</Value>
<Value name="18">
<Value>MobileNo</Value>
</Value>
<Value name="19">
<Value>AllowRefundFlag</Value>
</Value>
<Value name="20">
<Value>PayFlag</Value>
</Value>
<Value name="21">
<Value>HospitalName</Value>
</Value>
<Value name="22">
<Value>ServiceName</Value>
</Value>
</Data>
<DataLocation>^DHCExternalService.RegInterface.Ent9DC8.ApptOrderD</DataLocation>
<DefaultData>ApptOrderDefaultData</DefaultData>
<IdLocation>^DHCExternalService.RegInterface.Ent9DC8.ApptOrderD</IdLocation>
<IndexLocation>^DHCExternalService.RegInterface.Ent9DC8.ApptOrderI</IndexLocation>
<StreamLocation>^DHCExternalService.RegInterface.Ent9DC8.ApptOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
