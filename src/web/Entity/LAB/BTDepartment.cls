/// 名称:标准版检验-科室
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2019-11-15
Class web.Entity.LAB.BTDepartment Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTDepartment";

// rowid

Property RowID As %String;

// 代码

Property Code As %String;

// 名称

Property CName As %String;

// 医院

Property HospitalDR As %String;

// 序号

Property Sequence As %String;

// 激活

Property Active As %String;

}
