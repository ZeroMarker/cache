Class EPRservice.BLMainRole Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   查询
/// Table：        
/// Input：          
/// Output：       EPRservice.dataset.MainRoleAllDataSet
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod SelectAll() As EPRservice.dataset.MainRoleAllDataSet
{
	Set ds=##class(EPRservice.dataset.MainRoleAllDataSet).%New()
	Quit ds
}

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   增加一个角色
/// Table：        
/// Input：          
/// Output：        
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Test:          d ##Class(EPRservice.BLMainRole).AddRole("","")
ClassMethod AddRole(roleName As %String, roleDesc As %String)
{
	&sql(insert into EPRMeta.MainRole (RoleName, RoleDesc) values(:roleName, :roleDesc))
    q SQLCODE
}

}
