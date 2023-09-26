Class DHCExternalService.RegInterface.Entity.SelfAppt.OPAppArriveRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OPAppArrive";

/// 交易结果：0：成功1：失败
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 挂号序号
Property SeqCode As %String(TRUNCATE = 1);

/// 挂号费
Property RegFee As %String(TRUNCATE = 1);

/// 就诊时间段
Property AdmitRange As %String(TRUNCATE = 1);

/// 就诊地点
Property AdmitAddress As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

Property DeptCode As %String(TRUNCATE = 1);

Property DeptName As %String(TRUNCATE = 1);

Property DoctorCode As %String(TRUNCATE = 1);

Property DoctorName As %String(TRUNCATE = 1);

/// 号别代码
Property DoctorLevelCode As %String(TRUNCATE = 1);

/// 号别名称
Property DoctorLevelDesc As %String(TRUNCATE = 1);

/// 发票号
Property ReceiptNo As %String(TRUNCATE = 1);

/// 出诊时间 上午、下午、全天
Property TimeRange As %String(TRUNCATE = 1);

/// 挂号流水号
Property RegistrationID As %String(TRUNCATE = 1);

}
