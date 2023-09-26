/// 名称：EPRservice.BOMainRoleFunction
/// 描述：电子病历维护程序角色权限表WebService接口
/// 编写者：LingChen
/// 编写日期: 2010-10-22
Class EPRservice.BOMainRoleFunction Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "MainRoleFunctionService";

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   查询角色权限
/// Table：        
/// Input：          
/// Output：        
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Test:          d ##Class(EPRservice.BOMainRoleFunction).SelectFuncNameByRoleID("")
ClassMethod SelectFuncNameByRoleID(roleID As %String) As EPRservice.dataset.MainRoleFuncDataSet [ WebMethod ]
{
    q ##Class(EPRservice.BLMainRoleFuntion).SelectFuncNameByRoleID(roleID)
}

ClassMethod UpdataRoleFuntion(functions As %String, roleID As %String) [ WebMethod ]
{
	q ##Class(EPRservice.BLMainRoleFuntion).UpdataRoleFuntion(functions, roleID)
}

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   查询角色知识树分配
ClassMethod SelectKBTreeByRoleID(roleID As %String) As EPRservice.dataset.MainRoleKBDataSet [ WebMethod ]
{
    q ##Class(EPRservice.BLMainRoleFuntion).SelectKBTreeByRoleID(roleID)
}

ClassMethod UpdataRoleKBTree(KBTreeIDs As %String, roleID As %String) [ WebMethod ]
{
	q ##Class(EPRservice.BLMainRoleFuntion).UpdataRoleKBTree(KBTreeIDs, roleID)
}

}
