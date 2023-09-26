/// Desc:查询用户
/// Creator:Candy
Class DHCEPRFS.Entity.EQueryUser Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String;

/// 代码
Property UserCode As %String;

/// 名称
Property UserName As %String;

/// 密码
Property PassWord As %String;

/// 是否可用
Property IsAvailable As %String;

/// 有效开始时间
Property StartDate As %String;

/// 有效结束时间
Property EndDate As %String;

/// 是否过期
Property Expire As %String;

/// 类型，temp-临时，his-HIS用户
Property Type As %String;

/// SSUser的ID
Property SSUserID As %String;

}
