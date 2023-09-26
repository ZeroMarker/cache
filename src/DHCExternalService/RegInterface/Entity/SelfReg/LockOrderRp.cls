Class DHCExternalService.RegInterface.Entity.SelfReg.LockOrderRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 交易代码
Property TransactionId As %String(TRUNCATE = 1);

/// 结果标志（0–成功、-1–失败、-50此卡号已解除绑定）
Property ResultCode As %String(TRUNCATE = 1);

/// 错误描述
Property ResultContent As %String(TRUNCATE = 1);

/// 锁定的挂号序号
Property LockQueueNo As %String(TRUNCATE = 1);

/// 门诊排班记录标识
Property ScheduleItemCode As %String(TRUNCATE = 1);

/// 门诊号别
Property AdmDoc As %String(TRUNCATE = 1);

/// 门诊日期
Property AdmDate As %String(TRUNCATE = 1);

/// 门诊时间
Property AdmTime As %String(TRUNCATE = 1);

/// 挂号费用）
Property RegFee As %String(TRUNCATE = 1);

/// 医保挂号信息扩展串
Property InsuRegParaInfo As %String(TRUNCATE = 1);

/// 无法医保挂号说明
Property NoInsuRegParaReason As %String(TRUNCATE = 1);

/// 可进行医保分解标识
Property InsuAdmReasonSource As %String(TRUNCATE = 1);

}
