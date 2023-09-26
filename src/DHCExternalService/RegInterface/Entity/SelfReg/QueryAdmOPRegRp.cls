Class DHCExternalService.RegInterface.Entity.SelfReg.QueryAdmOPRegRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 记录数量
Property RecordCount As %String(TRUNCATE = 1);

/// 就诊记录列表
Property Orders As list Of DHCExternalService.RegInterface.Entity.SelfReg.List.Order;

}
