/// 版本号与数据关联表Entity类
/// User.BDPTableVersionLinkData
/// 基础数据平台-李可凡
/// 2019年12月19日
Class web.Entity.BDP.BDPTableVersionLinkData Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPTableVersionLinkData";

/// RowID
Property RowID As %String;

/// 表名称（MRC_ICDDx)
Property TableName As %String;

/// 版本号
Property Version As %String;

/// 关联数据rowid
Property DataId As %String;

}
