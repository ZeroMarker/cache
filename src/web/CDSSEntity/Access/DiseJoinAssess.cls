/// Description：疾病关联评估量表
/// Table：CT.WDT.CDSS.DiseJoinAssess
Class web.CDSSEntity.Access.DiseJoinAssess Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Access.DiseJoinAssess";

/// RowId
Property RowId As %String;

/// 疾病表DR
Property DiseaseDR As %String;

/// 评估量表
Property RatingScaleDR As %String;

/// 备注
Property Remarks As %String;

}
