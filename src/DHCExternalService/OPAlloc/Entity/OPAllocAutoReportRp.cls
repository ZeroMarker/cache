Class DHCExternalService.OPAlloc.Entity.OPAllocAutoReportRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 	交易结果：0000：成功 非0000：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 	对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 	提示信息
Property Tip As %String(TRUNCATE = 1);

/// 	病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 	姓名
Property PatientName As %String(TRUNCATE = 1);

/// 	性别
Property PatientSex As %String(TRUNCATE = 1);

/// 	报到顺序号
Property ArrivalNo As %String(TRUNCATE = 1);

/// 	等候人数信息
Property FrontNum As %String(TRUNCATE = 1);

/// 	建议就诊时间
Property AdmitRange As %String(TRUNCATE = 1);

}
