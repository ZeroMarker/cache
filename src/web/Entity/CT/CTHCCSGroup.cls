/// 名称:群组
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-12-24
Class web.Entity.CT.CTHCCSGroup Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHCCSGroup";

// GROUPRowId

Property GROUPRowId As %String;

// 群组代码

Property GROUPCode As %String;

// 群组名称

Property GROUPDesc As %String;

// 开始日期

Property GROUPDateFrom As %String;

// 结束日期

Property GROUPDateTo As %String;

}
