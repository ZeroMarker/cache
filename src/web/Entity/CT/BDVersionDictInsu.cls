/// Creator:鲁俊文
/// CreatDate:2022-10-26
/// Description：版本字典表与医保版本对照实体类
Class web.Entity.CT.BDVersionDictInsu Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDVersionDictInsu";

/// RowId
Property ID As %String;

/// 版本字典表字段dr
Property VersionDictDr As %String;

/// 医保版本dr
Property VersionInsuDr As %String;

/// 开始日期
Property DateFrom As %String;

/// 结束日期
Property DateTo As %String;

/// 同步到病案系统(Y/N)
Property IsSyncToMr As %String;

}
