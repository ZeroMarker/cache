/// 名称: 生理周期字典表
/// 描述: 实体类
/// 编写者：基础数据平台组-杨本庆
/// 编写日期:  2017-12-1
Class web.Entity.CT.DHCPhysiologicalCycle Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCPhysiologicalCycle";

Property PHYCRowId As %String;

Property PHYCCode As %String;

Property PHYCDesc As %String;

Property PHYCActiveFlag As %String;

}
