/// 名称: 电子病历维护程序角色权限表
/// 描述: 角色权限表
/// 编写者：LingChen
/// 编写日期: 2010-10-22
Class EPRservice.dao.DMainRoleFunction Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Query SelectFuncNameByRoleID(roleID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "FuncName:%String")
{
	SELECT FuncName
	FROM EPRMeta.MainRoleFunction
	WHERE RoleID = :roleID
	ORDER BY ID
}

Query SelectKBTreeByRoleID(roleID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "KBTreeID:%String")
{
	SELECT KBTreeID
	FROM EPRmeta.MainRoleKBTree
	WHERE RoleID = :roleID
	ORDER BY ID
}

}
