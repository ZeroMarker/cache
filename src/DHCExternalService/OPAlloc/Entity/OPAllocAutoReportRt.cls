Class DHCExternalService.OPAlloc.Entity.OPAllocAutoReportRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 预约机构
Property ExtOrgCode As %String(TRUNCATE = 1);

/// 客户端类型
Property ClientType As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 服务名称
Property ServiceName As %String(TRUNCATE = 1);

/// 类型标识1-卡号,2-ID
Property IDType As %String(TRUNCATE = 1);

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 设备标识
Property MachineID As %String(TRUNCATE = 1);

/// 诊区标识
Property ZoneID As %String(TRUNCATE = 1);

/// 就诊队列ID(HIS队列表Rowid)
Property AdmQueID As %String(TRUNCATE = 1);

/// 卡类型
Property CardType As %String(TRUNCATE = 1);

/// 卡号
Property PatientCard As %String(TRUNCATE = 1);

}
