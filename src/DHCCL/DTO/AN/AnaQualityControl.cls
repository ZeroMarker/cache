/// 麻醉质控统计
Class DHCCL.DTO.AN.AnaQualityControl Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 序号
Property SeqNo As %String;

/// 质控指标标题
Property OperQualityTitle As %String;

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
