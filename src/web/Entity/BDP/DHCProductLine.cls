/// 描述: 产品线查询
/// 编写者：谷雪萍
/// 编写日期: 2015-10-15
Class web.Entity.BDP.DHCProductLine Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.DHCProductLine";

/// RowId号
Property ID As %String;

/// 产品线编码,要求唯一
Property Code As %String;

/// 产品线名称,中文描述
Property Caption As %String;

/// 父菜单指针
Property ParentDr As %String;

/// 简写名称
Property Shorthand As %String;

/// 实施分类（区域医疗/传统HIs/健康乐）
Property Type As %String;

/// 产品线报价
Property Offer As %String;

/// 产品额定人月
Property ProManMonth As %String;

/// 实施额定人月
Property ImpManMonth As %String;

/// 人月数
Property ManMonth As %String;

/// 对内报价
Property InQuotation As %String;

/// 对外报价
Property OutQuotation As %String;

/// 产品线描述
Property ProDesc As %String;

/// 是否独立运行
Property StandaloneFlag As %String;

/// 是否销售
Property SalesFlag As %String;

/// 是否有效
Property ActiveFlag As %String;

/// 显示顺序,可以使用1,2,3或者A、B、C等字符定义，使用Ascii码来标识大小
Property Sequence As %String;

}
