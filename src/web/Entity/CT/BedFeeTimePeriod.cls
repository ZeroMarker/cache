/// 名称:时制关联时段
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-10-17
Class web.Entity.CT.BedFeeTimePeriod Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

// 子表ID

Property RowId As %String;

// 父表ID

Property ParRef As %String;

// 开始日期

Property DateFrom As %String;

// 结束日期

Property DateTo As %String;

Parameter PersistentClassName = "web.Entity.CT.BedFeeTimePeriod";

}
