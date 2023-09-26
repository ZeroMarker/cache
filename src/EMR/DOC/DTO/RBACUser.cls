/// 名称:	EMR.DOC.DTO.RBACRole
/// 描述:	通用文档管理模块 Document(Doc) 角色用户对象
/// 编写者：yejian
/// 编写日期: 2020-11-9
Class EMR.DOC.DTO.RBACUser Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 是否默认Admin用户（1:是，0:不是)
Property IsAdmin As %String(TRUNCATE = 1);

/// 用户ID
Property UserCode As %String(TRUNCATE = 1);

/// 用户名称
Property UserName As %String(TRUNCATE = 1);

/// 用户角色：CF.EMR.DOC.RBACRole(admin(默认具有所有权限)和其他类型互斥)
Property RoleID As %String;

}
