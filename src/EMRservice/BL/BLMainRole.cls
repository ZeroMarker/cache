/// 名称：EMRservice.BL.BLMainRole
/// 描述：电子病历维护程序角色表BL
/// 编写者：yejian
/// 编写日期: 2014-2-13
Class EMRservice.BL.BLMainRole Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   查询
/// Table：        
/// Input：          
/// Output：       EMRservice.dataset.EMainRoleAllDataSet
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod SelectAll() As EMRservice.dataset.EMainRoleAllDataSet
{
	Set ds=##class(EMRservice.dataset.EMainRoleAllDataSet).%New()
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
	&sql(insert into EMRmeta.MainRole (RoleName, RoleDesc) values(:roleName, :roleDesc))
    q SQLCODE
}

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,RoleName:%String,RoleDesc:%String")
{
	SELECT ID,RoleName,RoleDesc
	FROM EMRmeta.MainRole
	ORDER BY ID
}

}
