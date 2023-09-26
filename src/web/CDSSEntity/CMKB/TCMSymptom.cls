/// Description：中医证候字典表 
/// Table：CT.WDT.CDSS.TCMSymptom
Class web.CDSSEntity.CMKB.TCMSymptom Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ SqlRowIdName = "", SqlTableName = "" ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMSymptom";

/// SymptomRowId
Property SymptomRowId As %String;

/// ICD编码
Property SymptomCode As %String;

/// 证候名称
Property SymptomName As %String;

/// 别名
Property SymptomAlias As %String;

/// 版本
Property SymptomVersion As %String;

/// 操作人
Property Operator As %String;

/// 创建时间
Property OperatTime As %String;

/// 状态 (编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String;

}
