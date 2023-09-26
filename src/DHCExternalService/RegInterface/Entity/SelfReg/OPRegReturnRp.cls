Class DHCExternalService.RegInterface.Entity.SelfReg.OPRegReturnRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功  ---非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// His返回的交易流水号
Property HisTradeNo As %String(TRUNCATE = 1);

/// 退费金额
Property ReturnFee As %String(TRUNCATE = 1);

}
