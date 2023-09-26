/// Description：用户其他登录科室导入Entity类
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年4月14日
Class web.BDPExt.SSUserOtherLogonLocEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract, web.Entity.CT.SSUserOtherLogonLoc) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.BDPExt.SSUserOtherLogonLocEntity";

/// RowId
Property OTHLLRowId As %String;

/// 人事ID
Property SSUSRInitials As %String;

/// 姓名
Property SSUSRName As %String;

/// 科室代码
Property CTLOCCode As %String;

/// 科室描述
Property CTLOCDesc As %String;

/// 安全组名
Property SSGRPDesc As %String;

/// 是否同步到指定科室(Y/N)
Property SyncRBFlag As %String;

/// 开始日期
Property OTHLLStartDate As %String;

/// 结束日期
Property OTHLLEndDate As %String;

}
