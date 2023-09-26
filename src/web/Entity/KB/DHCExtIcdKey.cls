/// 名称: 诊断关键字表字典
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-5
Class web.Entity.KB.DHCExtIcdKey Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCExtIcdKey";

Property ICDKRowId As %String;

Property ICDKICDDr As %String;

Property ICDKText As %String;

Property ICDKSysFlag As %String;

}
