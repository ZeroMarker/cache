/// 名称:标准版检验-检验项目
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-03-10
Class web.Entity.LAB.BTTestCode Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTTestCode";

// RowId

Property RowID As %String;

// 代码

Property Code As %String;

// 描述

Property CName As %String;

// 关联医院

Property HospitalDR As %String;

// 标准码

Property SCode As %String;

// 显示序号

Property Sequence As %String;

// 激活

Property Active As %String;

}
