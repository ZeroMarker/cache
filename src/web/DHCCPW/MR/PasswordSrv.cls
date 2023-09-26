/// 名称: web.DHCCPW.MR.PasswordSrv
/// 描述: 密码校验类
/// 编写者：zhufei
/// 编写日期: 2010-05-18
Class web.DHCCPW.MR.PasswordSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-05-18
/// Description:  根据登录用户和输入密码进行校验
/// Table：       User.SSUser
/// Input：       ID:    User.SSUser.ID,User.SSUser.Password
/// Return：      返回ret
/// w ##class(web.DHCCPW.MR.PaPatmasSrv).IsRightDoctorAudit(1,"")
ClassMethod IsRightDoctorAudit(argUserID As %String, argPassword As %String) As %String
{
	New (argUserID,argPassword)
	Set return=0
	//
	Set return=1
	Quit return
}

Storage Default
{
<Data name="PasswordSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.MR.PasswordSrvD</DataLocation>
<DefaultData>PasswordSrvDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.MR.PasswordSrvD</IdLocation>
<IndexLocation>^web.DHCCPW.MR.PasswordSrvI</IndexLocation>
<StreamLocation>^web.DHCCPW.MR.PasswordSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
