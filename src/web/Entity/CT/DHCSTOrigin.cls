/// 名称:产地保存实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2017-08-16
Class web.Entity.CT.DHCSTOrigin Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCSTOrigin";

Property OrigRowId As %String;

//代码

Property OrigCode As %String;

//描述

Property OrigName As %String;

//类型

Property OrigType As %String;

//医院

Property OrigHospDr As %String;

//别名

Property OrigAlias As %String;

}
