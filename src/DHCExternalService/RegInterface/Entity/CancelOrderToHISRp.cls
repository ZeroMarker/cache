Class DHCExternalService.RegInterface.Entity.CancelOrderToHISRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// ResultCode	交易结果：0：成功 非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg	对错误/异常的详细描述信息
Property ErrorMsg As %String(TRUNCATE = 1);

/// TransactionId	his交易流水号
Property TransactionId As %String(TRUNCATE = 1);

}
