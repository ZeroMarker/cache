/// 名称:标准版检验-合报告分组
/// 描述:合报告分组实体类
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2020-4-16
Class web.Entity.LAB.BTTestSetOGTTGroup Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTTestSetGroup";

Property RowID As %String;

// 代码

Property Code As %String;

// 名字

Property CName As %String;

// 主组合套

Property MainTestSetDR As %String;

// 医院

Property HospitalDR As %String;

// 序号

Property Sequence As %String;

// 激活

Property Active As %String;

}
