/// 名称:检验标本维护 - 组合套分组关联实体类
/// 编写者:基础平台组 - 谢海睿
/// 编写日期:2019-11-15
Class web.Entity.LAB.BTTestSetGroupLinks Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTTestSetGroupLinks";

Property RowID As %String;

// 合管组合套分组 

Property TestSetGroupDR As %String;

// 项目组合套

Property TestSetDR As %String;

}
