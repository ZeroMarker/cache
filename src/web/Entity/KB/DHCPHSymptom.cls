/// 名称: 知识库症状字典表
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2016-7-18
Class web.Entity.KB.DHCPHSymptom Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHSymptom";

Property SYMRowId As %String;

Property SYMCode As %String;

Property SYMDesc As %String;

Property SYMActiveFlag As %String;

}
