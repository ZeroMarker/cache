/// 名称: 特殊人群与病症关联字典
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-10
Class web.Entity.KB.DHCSpecialPopuDis Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCSpecialPopuDis";

Property SPEDRowId As %String;

Property SPEDPODr As %String;

Property SPEDChildsub As %String;

Property SPEDDISDr As %String;

Property SPEDActiveFlag As %String;

Property SPEDSysFlag As %String;

}
