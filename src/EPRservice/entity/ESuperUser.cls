Class EPRservice.entity.ESuperUser Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property IsAdmin As %String(TRUNCATE = 1);

/// 标识编号
Property SupCode As %String(TRUNCATE = 1);

/// 密码
Property SupPassWord As %String(TRUNCATE = 1);

/// 用户编号
Property SupUserID As %Library.String(TRUNCATE = 1);

Property SupUserName As %Library.String(TRUNCATE = 1);

/// 角色表：EPRMeta.MainRole
Property RoleID As %String(TRUNCATE = 1);

}
