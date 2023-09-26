/// 检查项目结果信息
Class DHCMA.CPW.SD.Data.RisItemInfo Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 检查记录
Property RisInfoDr As DHCMA.CPW.SD.Data.RisInfo;

/// 检查项目代码
Property RItemCode As %String;

/// 检查项目结果-输出
Property RItemVal As %String;

/// 检查项目结果参考值
Property RItemRange As %String;

/// 检查项目结果异常标志-输出
Property RItemValAb As %String;

}
