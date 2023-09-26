/// 名称: 特殊人群与检验指标关联字典
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-10
Class web.Entity.KB.DHCSpecialPopuLab Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCSpecialPopuLab";

Property SPELRowId As %String;

Property SPELPODr As %String;

Property SPELChildsub As %String;

Property SPELPhyDr As %String;

Property SPELActiveFlag As %String;

Property SPELSysFlag As %String;

}
