Class DHCExternalService.RegInterface.Entity.CancelOrderToHISRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// HospitalId	医院ID
Property HospitalId As %String(TRUNCATE = 1);

/// HIS	HIS厂商
Property HIS As %String(TRUNCATE = 1);

/// TransactionId	交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// ExtUserID	操作员编码
Property ExtUserID As %String(TRUNCATE = 1);

/// ApptId	预约挂号记录标识
Property ApptId As %String(TRUNCATE = 1);

/// RefundType	当日退费、隔日退费的标记
Property RefundType As %String(TRUNCATE = 1);

/// ExtOrgCode	外部机构编码
Property ExtOrgCode As %String(TRUNCATE = 1);

/// ClientType	客户端类型
Property ClientType As %String(TRUNCATE = 1);

}
