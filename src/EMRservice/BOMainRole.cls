/// 名称：EPRservice.BOMainRole
/// 描述：电子病历维护程序角色表WebService接口
/// 编写者：yejian
/// 编写日期: 2014-2-13
Class EMRservice.BOMainRole Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "MainRoleService";

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   查询
/// Table：        
/// Input：          
/// Output：        
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Test:          d ##Class(EPRservice.BOMainRole).SelectAll()
ClassMethod SelectAll() As EMRservice.dataset.EMainRoleAllDataSet [ WebMethod ]
{
    q ##Class(EMRservice.BL.BLMainRole).SelectAll()
}

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   增加一个角色
/// Table：        
/// Input：          
/// Output：        
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Test:          d ##Class(EPRservice.BOMainRole).AddRole("","")
ClassMethod AddRole(roleName As %String, roleDesc As %String) [ WebMethod ]
{
    q ##Class(EMRservice.BL.BLMainRole).AddRole(roleName, roleDesc)
}

}
