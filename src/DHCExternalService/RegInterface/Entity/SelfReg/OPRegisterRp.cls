Class DHCExternalService.RegInterface.Entity.SelfReg.OPRegisterRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功 非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 挂号序号
Property SeqCode As %String(TRUNCATE = 1);

/// 挂号费
Property RegFee As %String(TRUNCATE = 1);

/// 就诊时间段
Property AdmitRange As %String(TRUNCATE = 1);

/// 就诊地点
Property AdmitAddress As %String(TRUNCATE = 1);

/// His交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 第三方移动订单号
Property PayOrderId As %String(TRUNCATE = 1);

/// 就诊流水号
Property AdmNo As %String(TRUNCATE = 1);

Property DeptCode As %String(TRUNCATE = 1);

Property DeptName As %String(TRUNCATE = 1);

Property DoctorCode As %String(TRUNCATE = 1);

Property DoctorName As %String(TRUNCATE = 1);

/// 号别代码
Property DoctorLevelCode As %String(TRUNCATE = 1);

/// 号别名称
Property DoctorLevelDesc As %String(TRUNCATE = 1);

/// 发票号
Property ReceiptNo As %String(TRUNCATE = 1);

/// 出诊时间 上午、下午、全天
Property TimeRange As %String(TRUNCATE = 1);

/// 挂号流水号
Property RegistrationID As %String(TRUNCATE = 1);

/// His缴费流水号
Property HisTradeOrderId As %String(TRUNCATE = 1);

/// 诊查费
Property CheckFee As %String(TRUNCATE = 1);

/// 总费用
Property TotalFee As %String(TRUNCATE = 1);

/// 总费用人民币大写
Property TotalRMBDX As %String(TRUNCATE = 1);

/// HIS挂号信息 Json格式
Property PrintDataJson As %String(TRUNCATE = 1);

}
