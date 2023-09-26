Class DHCExternalService.RegInterface.Entity.SelfAppt.BookServiceRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "Response";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 挂号序号
Property OrderCode As %String(TRUNCATE = 1);

/// 预约单号
Property SeqCode As %String(TRUNCATE = 1);

/// 就诊时间段
Property RegFee As %String(TRUNCATE = 1);

/// 挂号费
Property AdmitRange As %String(TRUNCATE = 1);

/// 就诊地点
Property AdmitAddress As %String(TRUNCATE = 1);

/// 预约单内容
Property OrderContent As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

}
