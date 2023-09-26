/// 名称:EMRservice.entity.ESuperUser
/// 描述:用户信息entity
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRservice.entity.ESuperUser Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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
