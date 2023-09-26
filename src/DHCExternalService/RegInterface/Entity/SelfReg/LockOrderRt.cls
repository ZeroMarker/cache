Class DHCExternalService.RegInterface.Entity.SelfReg.LockOrderRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 渠道代码（交易发起方）
Property ClientType As %String(TRUNCATE = 1);

/// 医院代码
Property HospitalId As %String(TRUNCATE = 1);

/// 交易日期YYYY-MM-DD
Property TradeDate As %String(TRUNCATE = 1);

/// 交易时间hh:mm:ss
Property TradeTime As %String(TRUNCATE = 1);

/// 收费员代码（自助机在HIS登记的代码）
Property ExtUserID As %String(TRUNCATE = 1);

/// 病人ID/HISID
Property PatientID As %String(TRUNCATE = 1);

/// 门诊排班记录标识
Property ScheduleItemCode As %String(TRUNCATE = 1);

/// 锁定的挂号序号
Property LockQueueNo As %String(TRUNCATE = 1);

/// 卡号
Property CardNo As %String(TRUNCATE = 1);

/// 卡类型代码
Property CardType As %String(TRUNCATE = 1);

/// 证件类型代码
Property CredTypeCode As %String(TRUNCATE = 1);

/// 证件号
Property IDCardNo As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 原交易流水号
Property OldTransactionId As %String(TRUNCATE = 1);

/// 手机号
Property Mobile As %String(TRUNCATE = 1);

/// 第三方移动订单号
Property PayOrderId As %String(TRUNCATE = 1);

/// 分时段开始时间
Property BeginTime As %String(TRUNCATE = 1);

/// 分时段结束时间
Property EndTime As %String(TRUNCATE = 1);

/// 费别ID
Property BillTypeID As %String(TRUNCATE = 1);

/// 医保卡数据
Property InsuCardData As %String(TRUNCATE = 1);

/// 需要返回医保挂号信息
Property NeedInsuRegData As %String(TRUNCATE = 1);

/// 支付方式代码
Property PayModeCode As %String(TRUNCATE = 1);

/// 亚专业代码
Property ClinicGroupDr As %String(TRUNCATE = 1);

}
