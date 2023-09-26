/// 导入配置表
/// Creaor: 谷雪萍
Class web.Entity.BDP.BDPEXConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.BDPEXConfig";

Property ID As %String;

/// 中文名称
Property EXCTableDesc As %String;

/// 实体类名
Property EXCTableName As %String;

/// rowID名（entity）
Property EXCIDName As %String;

/// 例如， $o(^IHBI.KBaseDefineD(xrowid))
Property EXCXGlobal As %String;

/// 关联Gof
Property EXCLinkGofDr As %String;

/// 关联Excel
Property EXCLinkExcelDr As %String;

/// 是否是子表
Property EXCIsChildTable As %String;

/// 获取父表Global
Property EXCParRefGlobal As %String;

}
