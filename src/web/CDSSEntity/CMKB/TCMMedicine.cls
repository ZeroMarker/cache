/// Description：中药字典表
/// Table：CT.WDT.CDSS.TCMMedicine
Class web.CDSSEntity.CMKB.TCMMedicine Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMMedicine";

/// MedicineRowId
Property MedicineRowId As %String;

/// 中药编码
Property MedicineCode As %String;

/// 中药名称
Property MedicineName As %String;

/// 别名
Property MedicineAlias As %String;

/// 性味
Property MedicineTaste As %String;

/// 归经
Property MedicineChannelTropism As %String;

/// 功效
Property MedicineEfficacy As %String;

/// 主治
Property MedicineAttending As %String;

/// 用法用量
Property MedicineUsage As %String;

/// 禁忌
Property MedicineTaboo As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %String;

/// 状态(编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String;

}
