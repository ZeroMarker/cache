/// Creator:鲁俊文
/// CreatDate:2022-10-26
/// Description：版本字典表
Class web.Entity.CT.BDVersionDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.BDVersionDict";

/// RowId
Property ID As %String;

/// 类型
Property Type As %String;

/// 版本代码
Property VersionCode As %String;

/// 版本名称
Property VersionName As %String;

/// 开始日期
Property DateFrom As %String;

/// 结束日期
Property DateTo As %String;

/// 同步到病案系统(Y/N)
Property IsSyncToMr As %String;

/// 中医数据标识(Y/N)
Property IsChineseMedicineFlag As %String;

/// 医保数据标识(Y/N)
Property IsInsuFlag As %String;

}
