/// Creator:丁亚男
/// CreatDate:2021-09-23
/// Description：疾病关联识别词表V2.0
/// Table：User.DHCDSSDiseJWord
Class web.CDSSEntity.CMKB.DiseJIWord Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DiseJIWord";

/// 疾病关联识别词表id
Property RowId As %String;

/// 疾病表DR
Property DiseaseDR As %String;

/// 识别词
Property WordDR As %String;

/// 识别词类型
Property WordType As %String;

/// 识别词等级（一级~五级（高），1，2，3,4,5）
Property WordGrade As %String;

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

/// 前台传的识别词
Property WordName As %String;

/// 前台传的操作人
Property OperationUser As %String;

}
