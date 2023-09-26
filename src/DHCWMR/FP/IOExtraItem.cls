/// 首页附加项取值接口
Class DHCWMR.FP.IOExtraItem Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 记录ID
Property IOERecordID As %String(TRUNCATE = 1);

/// 代码
Property IOECode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property IOEDesc As %String(MAXLEN = 100, TRUNCATE = 1);

}
