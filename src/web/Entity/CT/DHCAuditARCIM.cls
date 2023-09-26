/// Function: 医嘱项 审批使用的实体类 
/// CreateDate: 2023-04-23
/// Creator：sunfengchao 
Class web.Entity.CT.DHCAuditARCIM Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCAuditARCIM";

/// RowId号
Property ARCIMRowId As %String;

/// 代码
Property ARCIMCode As %String;

/// 描述
Property ARCIMDesc As %String;

/// 别名
Property Alias As %String;

/// 药物
Property ARCIMPHCDFDR As %String;

/// 账单子组
Property ARCIMBillSubDR As %String;

/// 起始日期  
Property ARCIMEffDate As %Date;

///  结束日期
Property ARCIMEffDateTo As %Date;

/// 医嘱子分类
Property ARCIMItemCatDR As %String;

/// 计帐单位
Property ARCIMBillingUOMDR As %String;

/// 独立医嘱
Property ARCIMOrderOnItsOwn As %String;

/// 无库存医嘱
Property ARCIMAllowOrderWOStockCheck As %String;

/// 审批表ID
Property AuditID As %String;

/// 任务ID
Property TaskId As %String;

/// 审批意见
Property AuditComment As %String;

}
