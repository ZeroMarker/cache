/// 名称:	EMR.DOC.DTO.RBACRole
/// 描述:	通用文档管理模块 Document(Doc) 角色对象
/// 编写者：yejian
/// 编写日期: 2020-11-9
Class EMR.DOC.DTO.RBACRole Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 角色id
Property RoleId As %String(TRUNCATE = 1);

/// 角色编码
Property RoleCode As %String(TRUNCATE = 1);

/// 角色名称
Property RoleName As %String(TRUNCATE = 1);

/// 角色描述
Property RoleDesc As %String(TRUNCATE = 1);

}
