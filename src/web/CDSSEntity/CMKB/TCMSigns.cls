/// Description：中医体征字典表
/// Creator:赵文伟
/// Table： CT.WDT.CDSS.TCMSigns
Class web.CDSSEntity.CMKB.TCMSigns Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ SqlRowIdName = "", SqlTableName = "" ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMSigns";

/// SignRowId
Property SignRowId As %String;

/// 体征编码
Property SignCode As %String;

/// 体征名称
Property SignName As %String;

/// 别名
Property SignAlias As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %String;

/// 状态(编辑中、已审核、已弃用)
Property State As %String;

/// 备注
Property Remarks As %String;

}
