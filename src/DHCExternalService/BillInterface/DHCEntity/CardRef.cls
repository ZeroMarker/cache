/// 用来传输卡注册信息的数据
Class DHCExternalService.BillInterface.DHCEntity.CardRef Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 卡的状态
Property ActiveFlag As %String(TRUNCATE = 1);

Property CFDate As %Date;

/// 帐户的RowID
Property CFAccNoDR As %String(TRUNCATE = 1);

/// 卡号/
Property CardNo As %String(TRUNCATE = 1);

Property CFTime As %Time;

/// 对应于此卡的发票RowID
Property CardINVPRTDR As %String(TRUNCATE = 1);

/// 卡类型 RowID  CF_CardType_DR
Property CardTypeDefine As %String(TRUNCATE = 1);

/// CardRef 这个表的RowID
Property CardRowID As %String(TRUNCATE = 1);

/// 计算机 IP
Property ComputerIP As %String(TRUNCATE = 1);

/// PatPatms
Property PAPMIRowID As %String(TRUNCATE = 1);

/// 证件号码 对于与 DHC_CardRef 表的CF_IDCardNo字段
Property CredNo As %String(TRUNCATE = 1);

/// 卡的校验码
Property SecurityNo As %String(TRUNCATE = 1);

/// 费用模式
Property FareType As %String(TRUNCATE = 1);

/// 操作用户
Property UserDR As %String(TRUNCATE = 1);

/// 登记号码
Property PAPMINo As %String(TRUNCATE = 1);

}
