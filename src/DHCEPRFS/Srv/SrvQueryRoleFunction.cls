/// Desc: 角色权限
/// Creator:Candy
Class DHCEPRFS.Srv.SrvQueryRoleFunction Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvQueryRoleFunction";

/// Desc:增加角色数据
/// Creator：Candy
/// input：ID，RoleName，角色名称，RoleDesc 角色描述
/// Output：-1 失败 1成功
ClassMethod AddRole(ID As %String, RoleName As %String, RoleDesc As %String, ParentName As %String = "") As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQueryRoleFunction).AddRole(ID,RoleName,RoleDesc,ParentName)
}

/// Desc:保存角色数据
/// Creator：Candy
/// input：ID，RoleName，角色名称，RoleDesc 角色描述
/// Output：-1 失败 1成功
ClassMethod SaveRole(ID As %String, RoleName As %String, RoleDesc As %String, ParentName As %String = "") As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQueryRoleFunction).SaveRole(ID,RoleName,RoleDesc,ParentName)
}

/// Desc:通过父角色返回RoleID
/// Creator：liushuang
/// input：ParentName，父角色名称
/// Output：RoleID
ClassMethod GetRoleID(AParentID As %String) As %String [ WebMethod ]
{
	s obj = ##Class(DHCEPRFS.BL.BLQueryRoleFunction).GetRoleID(AParentID)
	q obj
}

/// Desc:增加角色权限
///  Creator：Candy
/// input：RoleID，角色ID，FuncIDs 权限ID
/// Output：-1 失败 1成功
ClassMethod AddRoleFunc(RoleID As %String, FuncIDs As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQueryRoleFunction).AddRoleFunc(RoleID,FuncIDs)
}

/// Desc:保存角色权限顺序
/// Creator：liushuang  2017.2.22
/// input：RoleID，角色ID，FuncIDSEQ 权限顺序
/// Output：-1 失败 1成功
ClassMethod AddRoleFuncSEQ(RoleID As %String, FuncIDSEQ As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQueryRoleFunction).AddRoleFuncSEQ(RoleID,FuncIDSEQ)
}

/// Desc:获得所有角色数据
/// Creator：Candy
ClassMethod GetAllRole() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryRoleFunction:GetAllRole")
	d obj.SetArgs()
	q obj
}

/// Desc:获得所有父角色ID
/// Creator：LiuShuang
ClassMethod GetAllParentID() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryRoleFunction:GetAllParentID")
	d obj.SetArgs()
	q obj
}

/// Desc:获得功能字典
ClassMethod GetAllFunction() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryRoleFunction:GetAllDicFunction")
	d obj.SetArgs()
	q obj
}

/// Desc:获得角色权限
ClassMethod GetAllRoleFunc() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryRoleFunction:GetAllRoleFunc")
	d obj.SetArgs()
	q obj
}

/// Desc:通过用户ID（AUserID）得到此用户的权限
/// Creator：liushuang  2017.2.22
/// input：AUserID
/// Output：此用户权限组成的字符串
ClassMethod GetUserFuncByUserID(AUserID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLQueryRoleFunction).GetUserFuncByUserID(AUserID)
	q ret
}

/// Desc:获得选择角色的权限
ClassMethod GetAllRoleItems(ARoleID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryRoleFunction:GetAllRoleItems")
	d obj.SetArgs(ARoleID)
	q obj
}

}
