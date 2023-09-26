/// 名称: 病症与诊断关联表
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-5
Class web.Entity.KB.DHCPHDiseaseItmList Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDiseaseItmList";

Property PHDISLIRowId As %String;

Property PHDISLIDisDr As %String;

Property PHDISLIChildsub As %String;

Property PHDISLIICDDr As %String;

Property PHDISLIType As %String;

Property PHDISLISysFlag As %String;

}
