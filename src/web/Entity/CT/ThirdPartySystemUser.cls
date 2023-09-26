/// 三方系统用户配置	Entity
/// 基础数据平台-likefan
/// 2023-03-24
Class web.Entity.CT.ThirdPartySystemUser Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ThirdPartySystemUser";

Property TPSURowId As %String;

/// 三方系统
Property TPSUTPSParref As %String;

/// 指向HIS用户
Property TPSUUserDr As %String;

/// 三方系统用户代码 
Property TPSUUserCode As %String;

/// 三方系统用户姓名
Property TPSUUserName As %String;

}
