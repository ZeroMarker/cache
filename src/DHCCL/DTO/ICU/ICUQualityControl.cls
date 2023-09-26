/// 重症质控指标信息
Class DHCCL.DTO.ICU.ICUQualityControl Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 质控序号
Property SeqNo As %String;

/// 质控指标标题
Property Title As %String;

/// 质控指标分子
Property Count As %String;

/// 质控指标分子代码
Property CountCode As %String;

/// 质控指标分母
Property Total As %String;

/// 质控指标分母代码
Property TotalCode As %String;

/// 质控指标比率
Property Rate As %String;

}
