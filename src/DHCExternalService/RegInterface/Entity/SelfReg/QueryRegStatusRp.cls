Class DHCExternalService.RegInterface.Entity.SelfReg.QueryRegStatusRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功 非0：错误
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

/// His交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 第三方移动订单号
Property PayOrderId As %String(TRUNCATE = 1);

/// 预约状态
Property Status As %String(TRUNCATE = 1);

}
