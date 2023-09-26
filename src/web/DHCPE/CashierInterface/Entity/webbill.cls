Class web.DHCPE.CashierInterface.Entity.webbill Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Property name As %String(TRUNCATE = 1);

/// 单位开票点编码
Property ivcnode As %String(TRUNCATE = 1);

/// 单位开票点用户编码
Property nodeuser As %String(TRUNCATE = 1);

/// 用户密码
Property userpwd As %String(TRUNCATE = 1);

/// 单位校验KEY
Property key As %String(TRUNCATE = 1);

/// 接口版本
Property version As %String(TRUNCATE = 1);

/// 系统类型
Property systype As %String(TRUNCATE = 1);

/// param对象
Property params As param;

}
