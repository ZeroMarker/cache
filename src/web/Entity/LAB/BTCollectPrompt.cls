/// 名称:标准版检验-采集提示
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2019-11-27
Class web.Entity.LAB.BTCollectPrompt Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTCollectPrompt";

// RowId

Property RowID As %String;

// 代码

Property Code As %String;

// 描述

Property CName As %String;

// 关联医院

Property HospitalDR As %String;

// 序号

Property Sequence As %String;

// 激活

Property Active As %String;

}
