/// Function: 新装ICD诊断代码-卫计委版 实体类
/// CreateDate: 2016-12-16
/// Creator:  sunfengchao
Class web.Entity.CT.DKBICDHpc Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DKBICDHpc";

/// DelFormId 用于合并时删除项id
Property DelFormId As %String;

/// RowId
Property DKBHpcRowId As %String;

/// 代码
Property DKBHpcCode As %String;

/// 描述
Property DKBHpcDesc As %String;

/// ICD10 Code
Property DKBHpcICD9CMCode As %String;

/// 开始日期
Property DKBHpcDateActiveFrom As %String;

/// 结束日期
Property DKBHpcDateActiveTo As %String;

/// 从年龄
Property DKBHpcAgeFrom As %String;

/// 到年龄
Property DKBHpcAgeTo As %String;

/// 限制性别
Property DKBHpcSexDR As %String;

/// 有效 Y/N
Property DKBHpcValid As %String;

/// ICD9 Code
Property DKBHpcICD9Map As %String;

/// 副编码
Property DKBHpc2ndCodeInPair As %String;

/// 注释
Property DKBHpcLongDescription As %String;

/// 肿瘤形态学编码标志 Y/N
Property DKBHpcMetastaticSite As %String;

/// 损伤中毒外部原因标志 Y/N
Property DKBHpcInjuryPoisoningCode As %String;

/// 中医诊断标志 Y/N
Property DKBHpcBillFlag3 As %String;

/// 中医证型标志 Y/N
Property DKBHpcBillFlag1 As %String;

/// 对照标志 Y  N GU
Property DKBHpcContrastFlag As %String;

}
