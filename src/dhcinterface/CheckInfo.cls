Class dhcinterface.CheckInfo Extends (%Persistent, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 预约次数
Property BookedCount As %String(TRUNCATE = 1);

/// 预约费总额
Property BookedFee As %String(TRUNCATE = 1);

/// 预约交易号串
Property BookedStr As %String(TRUNCATE = 1);

/// 取消预约次数
Property CancelCount As %String(TRUNCATE = 1);

/// 取消预约交易号串
Property CancelStr As %String(TRUNCATE = 1);

/// 对帐流水号
Property CheckId As %String(TRUNCATE = 1);

/// 交易日期
Property Date As %Date;

/// 诊查费总额
Property ExamineFee As %String(TRUNCATE = 1);

/// 取号次数
Property FixedCount As %String(TRUNCATE = 1);

/// 取号交易号串
Property FixedStr As %String(TRUNCATE = 1);

/// 违约次数
Property OverdueCount As %String(TRUNCATE = 1);

/// 违约交易号串
Property OverdueStr As %String(TRUNCATE = 1);

/// 挂号费总额
Property RegistrationFee As %String(TRUNCATE = 1);

}
