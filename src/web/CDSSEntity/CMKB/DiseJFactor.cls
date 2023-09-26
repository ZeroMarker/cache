/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description：疾病关联诊断因子表V2.0
/// Table：User.DHCDSSDiseJFactor
Class web.CDSSEntity.CMKB.DiseJFactor Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DiseJFactor";

/// 疾病关联诊断因子表id
Property RowId As %String;

/// 疾病表DR
Property DiseaseDR As %String;

/// 诊断因子
Property FactorDR As %String;

/// 诊断因子类型
Property FactorType As %String;

/// 诊断因子等级（一级~五级（高），1，2，3,4,5）
Property FactorGrade As %String;

/// 是否否定条件（0否，1是）
Property IsNegatCondi As %String;

/// 是否充要条件（0否，1是）
Property IsNecessAndSuffiCondi As %String;

/// 是否必要条件（0否，1是）
Property IsNecessCondi As %String;

/// 是否住院召回（0否，1是）(暂时不用)
Property IsHospRecall As %String;

/// 是否门诊召回（0否，1是）(暂时不用)
Property IsOutpatientRecall As %String;

/// 是否展示（0否，1是）
Property IsShow As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 前台传的诊断因子
Property DiagFactorName As %String;

/// 前台传的操作人
Property OperationUser As %String;

}
