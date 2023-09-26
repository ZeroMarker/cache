/// creator:
/// date:
/// desc:示例程序：由his触发，调用第三方系统接口的总入口
Class DHCDoc.Interface.Outside.Template.Syn.HISTrigger Extends %RegisteredObject
{

/// 查询第三方系统科室列表（XML List）
ClassMethod QueryDepartment() As %String
{
	q ##Class(DHCDoc.Interface.Outside.Template.SynMethods).QueryDepartment()
}

/// 查询第三方系统科室列表（Json List）
ClassMethod QueryDepartmentJson() As %String
{
	q ##Class(DHCDoc.Interface.Outside.Template.SynMethods).QueryDepartmentJson()
}

}
