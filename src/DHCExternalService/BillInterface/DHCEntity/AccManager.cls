/// 患者账户信息的类
Class DHCExternalService.BillInterface.DHCEntity.AccManager Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 账户类型 集体 /个人账户
Property AccountType As %String(TRUNCATE = 1);

/// 卡号码
Property CardNo As %String(TRUNCATE = 1);

/// 开户时使用证件的证件号码
Property CredNo As %String(TRUNCATE = 1);

/// 患者登记号码
Property PAPMINo As %String(TRUNCATE = 1);

/// 开户时使用的 证件类型
Property CredType As %String(TRUNCATE = 1);

/// 透支金额
Property Depprice As %String(TRUNCATE = 1);

/// PaPatMas
Property PAPMIRowID As %String(TRUNCATE = 1);

/// 开户日期
Property OCDate As %Date;

/// 账户密码
Property PassWord As %String(TRUNCATE = 1);

/// 开户时间
Property OCTime As %Time;

/// 操作用户
Property UserDR As %String(TRUNCATE = 1);

/// 第一次开户时使用的 收取的预交金金额
Property amt As %String(TRUNCATE = 1);

}
