/// 名称:检验标本维护 - 合管组合套分组实体类
/// 编写者:基础平台组 - 谢海睿
/// 编写日期:2019-11-15
Class web.Entity.LAB.BTTestSetGroup Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTTestSetGroup";

Property RowID As %String;

// 代码

Property Code As %String;

// 名字

Property CName As %String;

// 医院

Property HospitalDR As %String;

// 序号

Property SeqNum As %String;

// 激活

Property Active As %String;

}
