/// Description：中医症状字典表
/// Creator:赵文伟
/// Table：CT.WDT.CDSS.TCMSymDict
Class web.CDSSEntity.CMKB.TCMSymDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ SqlRowIdName = "", SqlTableName = "" ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMSymDict";

/// SymDictRowId
Property SymDictRowId As %String;

/// 症状编码
Property SymDictCode As %String;

/// 症状名称
Property SymDictName As %String;

/// 别名
Property SymDictAlias As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %String;

/// 状态(编辑中、已审核、已弃用)
Property State As %String;

/// 备注
Property Remarks As %String;

}
