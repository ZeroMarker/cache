Class dhcinterface.ReturnMsg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// ljq-就诊地点
Property AdmitAddress As %String(TRUNCATE = 1);

/// ljq-就诊时段
Property AdmitRange As %String(TRUNCATE = 1);

/// 预约的Rowid
Property ApptId As %String(TRUNCATE = 1);

/// 排班剩余数
Property AvailableRegCount As %String(TRUNCATE = 1);

/// ljq-银行代码
Property BankCode As %String(TRUNCATE = 1);

/// 公告信息
Property BulletinInfos As list Of BulletinInfo;

/// New对帐明细信息
Property CheckDetails As list Of CheckInfoDetail;

/// 返回信息
Property ErrorMsg As %String(TRUNCATE = 1);

/// 病人信息
Property PatientInfo As PatientInfo;

/// ljq-退号费
Property RefundFee As %String(TRUNCATE = 1);

/// ljq-挂号费
Property RegFee As %String(TRUNCATE = 1);

/// Test
Property Result As %String(TRUNCATE = 1);

/// 返回值
Property ResultCode As %String(TRUNCATE = 1);

/// 挂号排队号
Property SeqCode As %String(TRUNCATE = 1);

/// ljq-交易流水号
Property TradeNo As %String(TRUNCATE = 1);

/// 同步排班剩余数的Request
Property SynAvailableRegCountRt As %String(MAXLEN = 32767, TRUNCATE = 1);

}
