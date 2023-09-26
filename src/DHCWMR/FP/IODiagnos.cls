/// 首页诊断取值接口
Class DHCWMR.FP.IODiagnos Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 记录ID
Property IODRecordID As %String(TRUNCATE = 1);

/// 诊断ICD
Property IODICD10 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断名称
Property IODICDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断类型
Property IODType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院病情
Property IODAdmitCond As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院情况
Property IODDischCond As %String(MAXLEN = 100, TRUNCATE = 1);

/// 确诊/未确诊
Property IODIsDefinite As %String(MAXLEN = 100, TRUNCATE = 1);

}
