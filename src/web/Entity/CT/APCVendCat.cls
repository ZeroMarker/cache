/// 名称:库存-供应商分类实体类
/// 编写者:基础平台组-陈莹
/// 编写日期: 2012-8-30
Class web.Entity.CT.APCVendCat Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.APCVendCat";

//单位RowId

Property APCVCRowId As %String;

//供应商分类代码

Property APCVCCode As %String;

//供应商分类描述

Property APCVCDesc As %String;

//供应商分类单位

Property APCVCCoCodeDR As %String;

}
