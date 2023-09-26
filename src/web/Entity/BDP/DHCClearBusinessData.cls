/// 清业务数据维护信息
/// 2015-09-15 谷雪萍
/// 最后修改日期：2015-10-30 
Class web.Entity.BDP.DHCClearBusinessData Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.DHCClearBusinessData";

Property ClearRowID As %String;

/// 产品组
Property ClearProductGroup As %String;

/// Global名称
Property ClearGlobal As %String;

/// Global对应的表名
Property ClearGlobalTable As %String;

/// 中文描述
Property ClearDesc As %String;

/// 有效标记
Property ClearStatus As %String;

/// 命名空间 2015-10-30 guxueping
Property ClearNamespace As %String;

}
