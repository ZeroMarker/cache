/// 名称 : DHCMed.DCEns.LIS.LabReport
/// 说明 : 检验报告/送检记录
Class DHCMed.DCEns.LIS.LabReport Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "TSReport";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 检验报告（对应医嘱表LabTestSetRow字段）
Property TestSetRow As %String(MAXLEN = 32767, XMLNAME = "TestSetRow");

/// 报告序号（每次检出菌与药敏试验结果都会生成一个报告序号）
Property OrderNo As %String(MAXLEN = 32767, XMLNAME = "OrderNo");

/// 医院代码
Property HospCode As %String(MAXLEN = 32767, XMLNAME = "HospCode");

/// 检验号（对应医嘱表LabEpisodeNo字段）
Property EpisodeNo As %String(MAXLEN = 32767, XMLNAME = "EpisodeNo");

/// 项目组套/检验医嘱
Property TestSetCode As %String(MAXLEN = 32767, XMLNAME = "TestSetCode");

/// 项目组套/检验医嘱
Property TestSetDesc As %String(MAXLEN = 32767, XMLNAME = "TestSetDesc");

/// 标本
Property SpecimenCode As %String(MAXLEN = 32767, XMLNAME = "SpecimenCode");

/// 标本
Property SpecimenDesc As %String(MAXLEN = 32767, XMLNAME = "SpecimenDesc");

/// 申请科室
Property LocationCode As %String(MAXLEN = 32767, XMLNAME = "LocationCode");

/// 申请科室
Property LocationDesc As %String(MAXLEN = 32767, XMLNAME = "LocationDesc");

/// 采集日期时间
Property CollectDateTime As %String(MAXLEN = 32767, XMLNAME = "CollectDateTime");

/// 采集者
Property CollectUser As %String(MAXLEN = 32767, XMLNAME = "CollectUser");

/// 接收日期时间
Property ReceiveDateTime As %String(MAXLEN = 32767, XMLNAME = "ReceiveDateTime");

/// 接收者
Property ReceiveUser As %String(MAXLEN = 32767, XMLNAME = "ReceiveUser");

/// 审核日期时间
Property AuthDateTime As %String(MAXLEN = 32767, XMLNAME = "AuthDateTime");

/// 审核者
Property AuthUser As %String(MAXLEN = 32767, XMLNAME = "AuthUser");

/// 是否有效（1有效、0无效）
Property IsActive As %String(MAXLEN = 32767, XMLNAME = "IsActive");

/// 检验项目结果
Property TSResultInfo As list Of DHCMed.DCEns.LIS.LabResult(XMLNAME = "TSResultInfo");

}
