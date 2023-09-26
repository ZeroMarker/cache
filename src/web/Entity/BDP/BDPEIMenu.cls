/// 描述: 导入导出菜单表
/// 编写者：谷雪萍
/// 编写日期: 2016-11-03
Class web.Entity.BDP.BDPEIMenu Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPEIMenu";

/// RowId号
Property ID As %String;

/// 菜单代码,要求唯一
Property Code As %String;

/// 菜单名称,中文描述
Property Caption As %String;

/// 父菜单指针
Property ParentMenuDr As %String;

/// 显示顺序,可以使用1,2,3或者A、B、C等字符定义，使用Ascii码来标识大小
Property Sequence As %String;

/// 本菜单默认的图标，默认是+,打开是-
Property Image As %String;

/// 表名
Property TableName As %String;

/// 类名
Property ClassName As %String;

/// Kglobal 2016-11-21
Property Kglobal As %String;

/// 显示在导入菜单 2016-11-22
Property ImportFlag As %String;

/// 显示在导出菜单 2016-11-22
Property ExportFlag As %String;

/// 是否加锁 2016-11-25
Property LockFlag As %String;

/// 指向表结构登记，可以获取此菜单的公私有属性 2020-06-01chenying
Property LinkTableDr As %String(MAXLEN = "");

}
