Class DHCExternalService.RegInterface.Entity.ReturnInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// ResultCode	交易结果：0：成功非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// ResultCode	交易结果：0：成功非0：错误
Property Result As %String(TRUNCATE = 1);

/// ErrorMsg	对错误/异常的详细描述信息
Property ErrorMsg As %String(TRUNCATE = 1);

/// TransactionId	交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// ResultContent	对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

}
