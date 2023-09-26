/// 导入配置表
/// Creaor: 谷雪萍
Class web.Entity.BDP.BDPIMConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.BDPIMConfig";

Property ID As %String;

/// 中文名称
Property IMCTableDesc As %String;

/// 实体类名
Property IMCTableName As %String;

/// rowID名（entity）
Property IMCIDName As %String;

/// 保存的类
Property IMCSaveClass As %String;

/// 保存方法名
Property IMCSaveMethod As %String;

/// Entity类名
Property IMCSaveEntity As %String;

/// 导入时 修改时用于校验 获取rowid的索引
Property IMCGetRowId As %String;

/// 关联Gof配置
Property IMCLinkGofDr As %String;

/// 关联Excel配置
Property IMCLinkExcelDr As %String;

/// 父菜单指针
Property IMCParentDr As %String;

/// 导入说明 2016-11-21
Property IMCText As %String;

/// 导出-获取Global  2021-02-19
Property EXCXGlobal As %String;

/// 导出-是否是子表
Property EXCIsChildTable As %String;

/// 导出-获取父表Global
Property EXCParRefGlobal As %String;

}
