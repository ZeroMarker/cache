Class DHCExternalService.RegInterface.Entity.SelfAppt.QueryOPAppArriveListRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
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

/// 卡号
Property CardNo As %String(TRUNCATE = 1);

/// 卡类型
Property CardType As %String(TRUNCATE = 1);

/// 证件类型
Property CredTypeCode As %String(TRUNCATE = 1);

/// 证件号码
Property IDCardNo As %String(TRUNCATE = 1);

/// 病人主索引号
Property PatientNo As %String(TRUNCATE = 1);

/// 开始日期(YYYY-MM-DD)
Property OrderApptStartDate As %String(TRUNCATE = 1);

/// 结束日期(YYYY-MM-DD)
Property OrderApptEndDate As %String(TRUNCATE = 1);

/// 查询日期标记。AppDate:预约申请日期；AdmDate:预约就诊日期；“”:查询没有过期的预约记录，不需要开始日期和结束日期条件。
Property QueryDateFlag As %String(TRUNCATE = 1);

/// 查询用户类型：ORG：非HIS的机构(只查询本机构预约的记录)
/// OWN：个人
/// HIS：可以查询预约了本HIS系统排班的预约记录
Property QueryUserType As %String(TRUNCATE = 1);

/// 预约单状态(normal 正常;cancel 退号)
Property OrderStatus As %String(TRUNCATE = 1);

/// 预约单号
Property OrderCode As %String(TRUNCATE = 1);

}
