Class DHCExternalService.RegInterface.Entity.SelfAppt.BookServiceRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "Response";

Parameter XMLIGNORENULL = 1;

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

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 门诊排班项代码
Property ScheduleItemCode As %String(TRUNCATE = 1);

/// 锁定的队列号
Property LockQueueNo As %String(TRUNCATE = 1);

/// 卡类型
Property CardType As %String(TRUNCATE = 1);

/// 卡号
Property CardNo As %String(TRUNCATE = 1);

/// 证件类型
Property CredTypeCode As %String(TRUNCATE = 1);

/// 患者唯一号
Property PatientID As %String(TRUNCATE = 1);

/// 证件号
Property IDCardNo As %String(TRUNCATE = 1);

/// 联系电话
Property TelePhoneNo As %String(TRUNCATE = 1);

/// 手机
Property MobileNo As %String(TRUNCATE = 1);

/// 姓名
Property PatientName As %String(TRUNCATE = 1);

/// 性别代码
Property Gender As %String(TRUNCATE = 1);

/// 住址
Property Address As %String(TRUNCATE = 1);

/// HIS系统的预约ID
Property HISApptID As %String(TRUNCATE = 1);

/// 挂号序号
Property SeqCode As %String(TRUNCATE = 1);

/// 就诊时间段
Property AdmitRange As %String(TRUNCATE = 1);

/// 支付标记（Y：已支付）
Property PayFlag As %String(TRUNCATE = 1);

/// 支付方式代码
Property PayModeCode As %String(TRUNCATE = 1);

/// 银行代码
Property PayBankCode As %String(TRUNCATE = 1);

/// 银行卡卡号
Property PayCardNo As %String(TRUNCATE = 1);

/// 个人支付费用
Property PayFee As %String(TRUNCATE = 1);

/// 医保支付费用
Property PayInsuFee As %String(TRUNCATE = 1);

/// 医保分解返回串
Property PayInsuFeeStr As %String(TRUNCATE = 1);

/// 支付交易号
Property PayTradeNo As %String(TRUNCATE = 1);

/// 支付交易信息串（应该包括银行代码、支付卡号、银行交易日期、银行交易流水号）
Property PayTradeStr As %String(TRUNCATE = 1);

}
