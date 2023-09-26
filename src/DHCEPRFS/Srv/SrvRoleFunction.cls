Class DHCEPRFS.Srv.SrvRoleFunction Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvRoleFunction";

/// Desc:获得功能权限列表
/// Creator:Candyxu
/// Createdate:2013-7-21
/// Input:
/// Output:MainDicFuntion DataSet
ClassMethod GetAllDic() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMainRoleFunction:GetAllDic")
	d obj.SetArgs()
	q obj
}

/// Description:角色列表
/// Creator：Candyxu
/// Createdate: 2013-7-21
/// Table：        
/// Input：          
/// Output: MainRole DataSet
ClassMethod GetAllRole() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMainRoleFunction:GetAllRole")
	d obj.SetArgs()
	q obj
}

/// Desc: 角色权限列表
/// Creator:Candyxu
/// CreateDate: 2013-07-22
/// Input:ARoleID 角色ID
/// Output: RowID 表iD,RoleID 角色ID,FuncName 功能名称
ClassMethod GetFunctionByRole(RoleID As %String) [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMainRoleFunction:GetRoleFunction")
	d obj.SetArgs(RoleID)
	q obj
}

/// Desc: 增加角色
/// Creator：Candyxu
/// CreatDate: 2013-07-22：        
/// Input：roleName: 角色名称 , roleDesc :角色扫描     
/// Output：1：保存成功， -1:保存不成功 
ClassMethod AddRole(roleName As %String, roleDesc As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLMainRoleFunction).AddRole(roleName,roleDesc)
}

}
