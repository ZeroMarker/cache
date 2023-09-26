/// 名称: 医嘱项与收费项关联
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2013-9-3
Class web.Entity.CT.DHCOrderLinkTar Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCOrderLinkTar";

/// RowId号 
Property OLTRowId As %String;

/// 医嘱项id
Property OLTARCIMDR As %String;

/// 收费项id
Property OLTTariffDR As %String;

/// 数量
Property OLTQty As %String;

/// 开始时间
Property OLTStartDate As %String;

/// 截止时间
Property OLTEndDate As %String;

/// 是否打折标志（Y/N）  ADD @ 20170222
Property OLTBascPriceFlag As %String;

/// 多部位计价一次（Y/N）  ADD @ 20170304
Property OLTBillOnceFlag As %String;

}
