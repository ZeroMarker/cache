Class DHCExternalService.RegInterface.Entity.SelfAppt.List.Order Extends (%RegisteredObject, %XML.Adaptor)
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

}
