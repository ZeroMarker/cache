/// 菜单关联功能元素
/// 描述:实体类
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2021-11-24
Class web.Entity.CT.FunctionalElement Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.FunctionalElement";

/// rowid
Property ID As %String;

/// ParRef
Property ParRef As %String;

/// 功能元素代码
Property ItemCode As %String;

/// 功能元素名称
Property ItemName As %String;

/// 按钮类型
Property ItemType As %String;

}
