/// Creator:基础数据平台组 谷雪萍
/// CreateDate:2016-04-25
/// Desc:基础数据平台   收费项目分类
Class web.Entity.CT.BDPItemCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPItemCategory";

Property ID As %String;

/// 代码,要求唯一
Property Code As %String;

/// 名称,中文描述
Property Caption As %String;

/// 级联树的类型
Property Type As %String;

/// 父菜单指针
Property ParentCatDr As %String;

/// 激活状态标志
Property ActiveFlag As %String;

/// 显示顺序,1,2,3
Property Sequence As %String;

}
