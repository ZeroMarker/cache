Class DHCExternalService.OPAlloc.Entity.GetOPAllocReportRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 客户端类型
Property ClientType As %String(TRUNCATE = 1);

/// 终端编码
Property TerminalID As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 卡类型
Property CardType As %String(TRUNCATE = 1);

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 设备标识
Property MachineID As %String(TRUNCATE = 1);

/// 诊区标识
Property ZoneID As %String(TRUNCATE = 1);

/// 就诊号(HIS就诊Rowid)
Property AdmNo As %String(TRUNCATE = 1);

}
