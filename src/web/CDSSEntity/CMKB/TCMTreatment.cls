/// Description：中医治法字典表
/// Creator:赵文伟
/// Table： CT.WDT.CDSS.TCMTreatments
Class web.CDSSEntity.CMKB.TCMTreatment Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ SqlRowIdName = "", SqlTableName = "" ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMTreatment";

/// TreatmentRowId
Property TreatmentRowId As %String;

/// 体征编码
Property TreatmentCode As %String;

/// 体征名称
Property TreatmentName As %String;

/// 别名
Property TreatmentAlias As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %String;

/// 状态(编辑中、已审核、已弃用)
Property State As %String;

/// 备注
Property Remarks As %String;

}
