/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description：疾病关联诊断因子组合表V2.0
/// Table：User.DHCDSSDiseJFactorComb
Class web.CDSSEntity.CMKB.DiseJFactorComb Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DiseJFactorComb";

/// 疾病关联诊断因子表组合id
Property RowId As %String;

/// 疾病表DR
Property DiseaseDR As %String;

/// 疾病关联诊断因子的id串User.DHCDSSDiseJFactor
Property DiseJFactorDRs As %String;

/// 组合等级（一级~五级（高），1，2，3,4,5）
Property CombGrade As %String;

/// 备注
Property Remarks As %String;

/// 前台传的操作人
Property OperationUser As %String;

}
