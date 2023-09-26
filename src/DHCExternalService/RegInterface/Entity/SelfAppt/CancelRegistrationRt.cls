Class DHCExternalService.RegInterface.Entity.SelfAppt.CancelRegistrationRt Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易代码
Property TradeCode As %String;

/// 预约机构
Property ExtOrgCode As %String;

/// 客户端类型
Property ClientType As %String;

/// 医院唯一编号
Property HospitalId As %String;

/// 操作员代码
Property ExtUserID As %String;

/// 交易流水号
Property TransactionId As %String;

/// 预约单号
Property OrderCode As %String;

}
