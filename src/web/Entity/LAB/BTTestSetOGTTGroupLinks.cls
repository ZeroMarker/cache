/// 名称:标准版检验-合报告分组关联
/// 描述:合报告分组关联实体类
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2020-4-16
Class web.Entity.LAB.BTTestSetOGTTGroupLinks Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTTestSetOGTTGroupLinks";

Property RowID As %String;

// 组合套组

Property TestSetOGTTGroupDR As %String;

// 主组合套

Property MainTestSetDR As %String;

// 子组合套

Property SubTestSetDR As %String;

// 序号

Property Sequence As %String;

}
