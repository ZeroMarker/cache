/// 名称: 特殊人群与既往史关联字典
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-10
Class web.Entity.KB.DHCSpecialPopuHistory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCSpecialPopuHistory";

Property SPEHRowId As %String;

Property SPEHPODr As %String;

Property SPEHChildsub As %String;

Property SPEHDHDr As %String;

Property SPEHActiveFlag As %String;

Property SPEHSysFlag As %String;

}
