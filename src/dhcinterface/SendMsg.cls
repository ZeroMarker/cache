Class dhcinterface.SendMsg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// ljq-对账结束日期
Property AccEndDate As %String(TRUNCATE = 1);

/// ljq-对账结束日期
Property AccEndHour As %String(TRUNCATE = 1);

/// ljq-对账结束日期
Property AccEndMinute As %String(TRUNCATE = 1);

/// ljq-对账开始日期
Property AccStartDate As %String(TRUNCATE = 1);

/// ljq-对账开始小时
Property AccStartHour As %String(TRUNCATE = 1);

/// ljq-对账开始分钟
Property AccStartMinute As %String(TRUNCATE = 1);

/// ljq-对账类型
Property AccType As %String(TRUNCATE = 1);

/// 预约挂号流水号
Property ApptId As %String(TRUNCATE = 1);

/// 消息类型?取消预约/违约通知?
Property ApptType As %String(TRUNCATE = 1);

/// 排班剩余数量
Property AvailableRegCount As %String(TRUNCATE = 1);

/// ljq-银行代码
Property BankCode As %String(TRUNCATE = 1);

/// 公告信息
Property BulletinInfos As list Of BulletinInfo;

/// 联系电话
Property CardType As %String(TRUNCATE = 1);

/// New对帐流水号
Property CheckId As %String(TRUNCATE = 1);

/// New对帐信息
Property CheckInfo As CheckInfo;

/// New 114坐席客户机地址
Property ClientAddress As %String(TRUNCATE = 1);

/// ljq-结束日期
Property EndDate As %String(TRUNCATE = 1);

/// ljq-结束小时
Property EndHour As %String(TRUNCATE = 1);

/// ljq-结束分钟
Property EndMinite As %String(TRUNCATE = 1);

/// New差异明细信息
Property ErrorCheckDetails As list Of ErrorCheckInfoDetail;

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// ljq-交易方式
Property Method As %String(TRUNCATE = 1);

/// 卡号
Property PatientCard As %String(TRUNCATE = 1);

/// PA_PatMas.PAPER_RowId
Property PatientID As %String(TRUNCATE = 1);

/// ljq-支付金额
Property PaymentFee As %String(TRUNCATE = 1);

/// ljq-支付方式
Property PaymentMode As %String(TRUNCATE = 1);

/// New 排班记录传输结束日期
Property RBAEndDate As %String(TRUNCATE = 1);

/// 排班记录集
Property RBAS As list Of RBASRec;

/// 排班记录RowId
Property RBASId As %String(TRUNCATE = 1);

/// 停替诊原因
Property RBASREASON As %String(TRUNCATE = 1);

/// 排班记录
Property RBASRec As RBASRec;

/// New 排班记录传输起始日期
Property RBAStartDate As %String(TRUNCATE = 1);

/// ljq-退费金额
Property RefundFee As %String(TRUNCATE = 1);

/// ljq-交易流水号
/// Property TranNo As %String;
/// ljq-退号方式 WEB?机构网上退号 PERWEB?个人网上退号
Property RefundType As %String(TRUNCATE = 1);

/// ljq-开始日期
Property StartDate As %String(TRUNCATE = 1);

/// ljq-开始小时
Property StartHour As %String(TRUNCATE = 1);

/// ljq-开始分钟
Property StartMinite As %String(TRUNCATE = 1);

/// ljq-交易流水表DR
Property TradeNo As %String(TRUNCATE = 1);

/// ljq-流水类型
Property TransType As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 冲正交易流水号串
Property TransactionIds As %String(TRUNCATE = 1);

/// New 114操作员编码
Property UserID As %String(TRUNCATE = 1);

/// 医疗机构代码
Property HospitalCode As %String(TRUNCATE = 1);

}
