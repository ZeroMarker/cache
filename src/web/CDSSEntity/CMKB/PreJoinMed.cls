/// Description：中医方剂字典关联中药字典表
/// Table：User.DHCDSSTCMPreJoinMed
/// Creator:赵文伟
Class web.CDSSEntity.CMKB.PreJoinMed Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMPreJoinMed";

/// RowId
Property RowId As %String;

/// 方剂 指向中医方剂字典
Property PrescriptionDR As %String;

/// 中药 指向中药字典
Property MedicineDR As %String;

// 中药名称

// Property MedicineName As %String;

/// 推荐剂量DR
Property RecommendDose As %String;

// 推荐剂量

// Property MedicineUsage As %String;

/// 剂量单位DR
Property DoseUnit As %String;

// 剂量单位

// Property UnitDesc As %String;

/// 煎法DR
Property Decoction As %String;

// 煎法

// Property DecoctionName As %String;

}
