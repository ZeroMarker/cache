/// Description：同义词检索字典表
/// Creator:杨继鸿
/// Table： CT.WDT.CDSS.SynSearchDict
Class web.CDSSEntity.CMKB.SynSearchDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ SqlRowIdName = "", SqlTableName = "" ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.SynSearchDict";

/// RowId
Property RowId As %String;

/// 简称中文
Property SynSAbbre As %String;

/// 简称拼音码
Property SynSAbbrePYCode As %String;

/// 全名
Property SynSFullName As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperateTime As %String;

/// 状态(编辑中、已审核、已弃用)
Property State As %String;

/// 备注
Property Remarks As %String;

}
