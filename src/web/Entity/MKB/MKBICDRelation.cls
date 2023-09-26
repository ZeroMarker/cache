/// 描述: ICD映射、诊断关系User.MKBICDRelation实体类
/// 编写者：基础数据平台组-李欣
/// 编写日期: 20180410
Class web.Entity.MKB.MKBICDRelation Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBICDRelation";

Property MKBICDRRowId As %String;

/// 诊断表达式
Property MKBICDRDiag As %String;

/// 诊断描述
Property MKBICDRDiagDesc As %String;

/// ICD北京版
Property MKBICDRBJDr As %String;

/// ICD国际码1
Property MKBICDRInterCode1 As %String;

/// ICD国际码2
Property MKBICDRInterCode2 As %String;

/// 北京版备注
Property MKBICDRBJNote As %String;

/// 北京版对照状态
Property MKBICDRBJState As %String;

/// HIS icd10 rowid
Property MKBICDRHisDr As %String;

/// His icd 代码（MRC_ICDDx）
Property MKBICDRHisCode As %String;

/// His icd10 代码（MRC_ICDDx）
Property MKBICDRHis10Code As %String;

/// His icd10 描述（MRC_ICDDx）
Property MKBICDRHisDesc As %String;

/// His版备注
Property MKBICDRHisNote As %String;

/// His版对照状态
Property MKBICDRHisState As %String;

}
