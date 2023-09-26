/// 名称:床位费时制
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-10-14
Class web.Entity.CT.BedFeeTime Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.BedFeeTime";

/// RowId
Property BedFeeTimeRowId As %String;

/// 代码
Property BedFeeTimeCode As %String;

/// 名称
Property BedFeeTimeName As %String;

/// 开始日期
Property BedFeeDateFrom As %String;

/// 结束日期
Property BedFeeDateTo As %String;

}
