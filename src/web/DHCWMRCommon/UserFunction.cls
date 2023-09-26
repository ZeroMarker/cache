Import SQLUser

Class web.DHCWMRCommon.UserFunction Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

/// 检验用户是否具有某种权限（Medtrak的权限设置）
/// UserGroupId--用户安全组ID  ModuleName--模块名称  MenuName--菜单名称
/// 返回0代表有权限
ClassMethod UserFunction(UserGroupId, ModuleName, MenuName) As %String
{
	n (UserGroupId,ModuleName,MenuName)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$UserFunction^SMLUserFunc(UserGroupId,ModuleName,MenuName)
	zn CurrentNS
	q ret
}

Storage Default
{
<Data name="UserFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWMRCommon.UserFunctionD</DataLocation>
<DefaultData>UserFunctionDefaultData</DefaultData>
<IdLocation>^web.DHCWMRCommon.UserFunctionD</IdLocation>
<IndexLocation>^web.DHCWMRCommon.UserFunctionI</IndexLocation>
<StreamLocation>^web.DHCWMRCommon.UserFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
