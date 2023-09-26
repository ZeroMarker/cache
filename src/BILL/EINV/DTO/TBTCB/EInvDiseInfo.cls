/// 同步天成诊断明细信息
Class BILL.EINV.DTO.TBTCB.EInvDiseInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

/// SETTLEMNTNO	结算号	Varchar	30	是	Organ+ SettlementNo关键字唯一，建主索引
Property SETTLEMNTNO As %String(XMLPROJECTION = "ELEMENT");

/// ORGAN	机构代码	Varchar	4	是	财政分配
Property ORGAN As %String(XMLPROJECTION = "ELEMENT");

/// DIAGNOSISCODE	诊断编码	Varchar	50	是	没有诊断信息统一传 “无”, 针对基层医疗机构或者疾病诊断不 明确（挂号、急救等）的情况下：
/// 保持现在疾病诊断列表必传的要 求，遇到不明确的情况下，统一疾病诊断编码传“0”，疾病诊断名称传“未知”。
Property DIAGNOSISCODE As %String(XMLPROJECTION = "ELEMENT");

/// DIAGNOSISNAME	诊断名称	Varchar	128	是	
Property DIAGNOSISNAME As %String(XMLPROJECTION = "ELEMENT");

/// REMARK	备注	Varchar	200	
Property REMARK As %String(XMLPROJECTION = "ELEMENT");

}
