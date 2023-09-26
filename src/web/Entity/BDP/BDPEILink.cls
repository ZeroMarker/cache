Class web.Entity.BDP.BDPEILink Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPEILink";

/// RowId
Property ID As %String;

/// 文件名称
Property EILFileName As %String;

/// 模板类型
Property EILType As %String;

/// 文件类型
Property EILFileType As %String;

/// 导入导出类型
Property EILEIType As %String;

/// 开始sheet（数字）
Property EILStartSheet As %String;

/// 结束sheet
Property EILEndSheet As %String;

/// 起读行数
Property EILStartRow As %String;

}
