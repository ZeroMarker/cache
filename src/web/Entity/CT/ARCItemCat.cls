/// 名称: 医嘱子分类维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-9-6
Class web.Entity.CT.ARCItemCat Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCItemCat";

/// RowIds
Property ARCICRowId As %String;

/// 代码
Property ARCICCode As %String;

/// 描述
Property ARCICDesc As %String;

/// 医嘱类型
Property ARCICOrderType As %String;

/// 医嘱分类 OEC_OrderCategory
Property ARCICOrdCatDR As %String;

/// 限制类
Property ARCICRestrictedOrder As %String;

/// 医嘱执行类型 OEC_ExecCateg
Property ARCICExecCategDR As %String;

/// 计算数量 Y/N
Property ARCICCalcQtyFlag As %String;

}
