Class web.DHCPE.CashierInterface.Entity.result Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

/// 结果状态0  错误  1成功
Property status As %String(TRUNCATE = 1);

/// 失败信息
Property error As %String(TRUNCATE = 1);

Property success As success;

}
