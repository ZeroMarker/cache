/// 名称: 菜单定义
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2013-5-2
Class web.Entity.BDP.BDPMenuDefine Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPMenuDefine";

/// RowId号
Property ID As %String;

/// 代码
Property Code As %String;

/// 菜单名称,中文描述
Property Caption As %String;

/// 菜单指向的功能定义
Property LinkFuntionDR As %String;

/// 对应的URL解析地址,默认的是
Property LinkUrl As web.BDP.sys.String;

/// 本菜单默认的图标，默认是+,打开是-
Property Image As web.BDP.sys.String;

/// 点击本菜单时，可以执行的Cache服务器端的类方法
Property Method As web.BDP.sys.String;

/// 显示顺序,可以使用1,2,3或者A、B、C等字符定义，使用Ascii码来标识大小
Property Sequence As %String;

/// 菜单快捷键
Property ShortcutKey As %String;

/// 在弹出窗口或者增加Tab的方式显示当前菜单功能
Property ShowInNewWindow As %String;

/// 父菜单指针
Property ParentMenuDr As %String;

/// 值表达式，暂时留着
Property ValueExpression As web.BDP.sys.String;

/// |chenying
Property ActiveFlag As %String;

Property UpdateDate As %String;

Property UpdateTime As %String;

Property UpdateUser As %String;

/// |chenying
/// 激活基础数据维护菜单
Property actMenuBDP As %String;

/// 激活功能元素授权菜单
Property actMenuAutItem As %String;

/// 激活基础数据授权菜单
Property actMenuAutData As %String;

/// 组件名称
Property CompName As %String;

/// 产品线指针 2015.10.27 guxueping
Property ProductLineDr As %String;

/// 首拼 2017.10.10 guxueping
Property FirstPYCODE As %String;

/// 全拼 2017.10.10 guxueping
Property WholePYCODE As %String;

/// 是否属于医用知识库 guxueping
Property IsMKBMenu As %String;

}
