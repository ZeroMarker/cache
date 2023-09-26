Class web.DHCPE.CashierInterface.Entity.success Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

/// 票据号
Property billno As %String(TRUNCATE = 1);

/// 票据类型
Property billtype As %String(TRUNCATE = 1);

/// 票别号
Property billreg As %String(TRUNCATE = 1);

/// 金额
Property amt As %String(TRUNCATE = 1);

/// 数字指纹
Property key As %String(TRUNCATE = 1);

}
