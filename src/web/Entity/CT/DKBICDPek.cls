/// Function: 新装ICD诊断代码-北京版 entity
/// CreateDate: 2016-12-19
/// Creator:  sunfengchao
Class web.Entity.CT.DKBICDPek Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DKBICDPek";

/// DelFormId 用于合并时删除项id
Property DelFormId As %String;

/// RowId
Property DKBPekRowId As %String;

/// 代码
Property DKBPekCode As %String;

/// 描述
Property DKBPekDesc As %String;

/// ICD10 Code
Property DKBPekICD9CMCode As %String;

/// 开始日期
Property DKBPekDateActiveFrom As %String;

/// 结束日期
Property DKBPekDateActiveTo As %String;

/// 从年龄
Property DKBPekAgeFrom As %String;

/// 到年龄
Property DKBPekAgeTo As %String;

/// 限制性别
Property DKBPekSexDR As %String;

/// 有效 Y/N
Property DKBPekValid As %String;

/// ICD9 Code
Property DKBPekICD9Map As %String;

/// 副编码
Property DKBPek2ndCodeInPair As %String;

/// 注释
Property DKBPekLongDescription As %String;

/// 肿瘤形态学编码标志 Y/N
Property DKBPekMetastaticSite As %String;

/// 损伤中毒外部原因标志 Y/N
Property DKBPekInjuryPoisoningCode As %String;

/// 中医诊断标志 Y/N
Property DKBPekBillFlag3 As %String;

/// 中医证型标志 Y/N
Property DKBPekBillFlag1 As %String;

/// 对照标志 Y/N
Property DKBPekContrastFlag As %String;

}
