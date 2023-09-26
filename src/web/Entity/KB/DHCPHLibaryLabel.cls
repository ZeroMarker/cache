/// 名称: 知识库标识字典
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-10-31
Class web.Entity.KB.DHCPHLibaryLabel Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHLibaryLabel";

Property PHLIRowId As %String;

Property PHLICode As %String;

Property PHLIDesc As %String;

Property PHLIActiveFlag As %String;

}
