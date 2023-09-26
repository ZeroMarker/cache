/// 名称:检验标本维护 - 采集容器实体类
/// 编写者:基础平台组 - 谢海睿
/// 编写日期:2019-11-13
Class web.Entity.LAB.BTContainer Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTContainer";

Property RowID As %String;

// 代码

Property Code As %String;

// 名称

Property CName As %String;

// 医院

Property HospitalDR As %String;

// 容量

Property Volumn As %String;

// 颜色

Property Color As %String;

// 说明

Property Remark As %String;

// 序号

Property Sequence As %String;

// 激活

Property Active As %String;

// 容器图片

Property Photo As %String;

// 容器类型

Property ConType As %String;

}
