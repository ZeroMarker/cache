/// 名称: ICD诊断代码 国际版
/// 描述: 实体类
/// 编写者：基础数据平台组 sunfengchao
/// 编写日期: 2016-12-19
Class web.Entity.CT.DKBICDInt Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DKBICDInt";

/// DelFormId 用于合并时删除项id
Property DelFormId As %String;

/// RowId
Property DKBIntRowId As %String;

/// 代码
Property DKBIntCode As %String;

/// 描述
Property DKBIntDesc As %String;

/// ICD10 Code
Property DKBIntICD9CMCode As %String;

/// 开始日期
Property DKBIntDateActiveFrom As %String;

/// 结束日期
Property DKBIntDateActiveTo As %String;

/// 从年龄
Property DKBIntAgeFrom As %String;

/// 到年龄
Property DKBIntAgeTo As %String;

/// 限制性别
Property DKBIntSexDR As %String;

/// 有效 Y/N
Property DKBIntValid As %String;

/// ICD9 Code
Property DKBIntICD9Map As %String;

/// 副编码
Property DKBInt2ndCodeInPair As %String;

/// 注释
Property DKBIntLongDescription As %String;

/// 肿瘤形态学编码标志 Y/N
Property DKBIntMetastaticSite As %String;

/// 损伤中毒外部原因标志 Y/N
Property DKBIntInjuryPoisoningCode As %String;

/// 中医诊断标志 Y/N
Property DKBIntBillFlag3 As %String;

/// 中医证型标志 Y/N
Property DKBIntBillFlag1 As %String;

/// 对照标志 Y/N
Property DKBIntContrastFlag As %String;

}
