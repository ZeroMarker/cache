/// 有调用发消息的接口方法，每个项目都不一样，一定要对比更新
Class dhc.dao.SSUser Extends BSP.SYS.DAO.Base
{

/// debug:d ##class(%ResultSet).RunQuery("web.SSUserOtherLogonLoc","LookUpSelectedUserByUHD","demo","","")
Query LookUpLoc(User As %Library.String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "OtherId:%String:ID,Loc:%String:科室,LocId:%String:科室Id,Group:%String:安全组,GroupId:%String:安全组Id,HOSPDesc:%String:医院,HOSPId:%String:医院Id,LocAlias:%String:别名")
{
}

ClassMethod LookUpLocExecute(ByRef QHandle As %Library.Binary, User As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// debug:d ##class(%ResultSet).RunQuery("web.SSUserOtherLogonLoc","LookUpSelectedUserByUHD","demo","","")
Query LookUpPost(User As %Library.String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "OtherId:%String:ID,PostDesc:%String:岗位,PostId:%String:岗位Id,HOSPDesc:%String:医院,HOSPId:%String:医院Id,PostAlias:%String:岗位别名")
{
}

ClassMethod LookUpPostExecute(ByRef QHandle As %Library.Binary, User As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// 2018-05-28
ClassMethod UpdateDefaultDeptById(OtherLocId)
{
}

ClassMethod CheckPsw(NewPasswrod)
{
}

/// 2018-05-28
ClassMethod UpdateDefaultPostById(OtherLocId)
{
}

ClassMethod UpdatePsw3(usercode = "", oldPsw = "", newPsw = "")
{
}

ClassMethod UpdatePsw(oldPsw = "", newPsw = "", userCode = "", RSID = "")
{
}

ClassMethod UpdatePin(oldPsw, newPsw)
{
}

/// dto改为dhc.dto.SSUser
ClassMethod Save(dto As dhc.dto.SSUser)
{
}

ClassMethod Encode(key = "")
{
}

/// 通过USERNAME写DEPARTMENT,SSUSERGROUPDESC,Hospital
ClassMethod PaddingUser()
{
}

ClassMethod UserCodeSure(userCode = "")
{
}

/// 系统可以配置，其他字段登录，将其他字段匹配出用户ID返回
/// userCode 其他的字段登录
/// return 用户的 rowID
/// w ##class(dhc.dao.SSUser).FindUserByExtendCode("15559715055")
ClassMethod FindUserByExtendCode(username = "")
{
}

/// 手机登录，发送短信验证码
/// w ##class(dhc.dao.SSUser).SendSMByPhone("18296999206")
ClassMethod SendSMByPhone(UserPhone = "")
{
}

/// 发送短信
ClassMethod SendSMByUserCode(userCode = "", UserPhone = "")
{
}

/// d ##class(dhc.dao.SSUser).CountSendSM("15559715055")
ClassMethod CountSendSM(UserPhone = "")
{
}

/// w ##class(dhc.dao.SSUser).CheckCountSendSM("15559715055")
ClassMethod CheckCountSendSM(UserPhone = "")
{
}

/// 忘记密码与激活用户都会使用到
ClassMethod ValidSMToken(userCode = "", SMToken, OprType = "")
{
}

/// newPsw为加密的密码
/// userCode为用户工号
ClassMethod UpdatePswSess(newPsw = "", userCode = "")
{
}

ClassMethod IsBirthday(userid)
{
}

ClassMethod recheck(usercode, password, RSID, bizId = "")
{
}

/// 登录后，再其他登录科室记录登录此科室的次数，用于切换科室显示的排序。
/// d ##class(dhc.dao.SSUser).UpdateLogonCount(1,246,289)
ClassMethod UpdateLogonCount(userId = "", locId = "", grpId = "")
{
}

/// 切换科室页面，清空所有科室的排序统计。
/// d ##class(dhc.dao.SSUser).ClearLogonCount(1)
ClassMethod ClearLogonCount(userId = "")
{
}

/// 登录页面，验证码，激活用户方法
/// d ##class(dhc.dao.SSUser).ActiveUser()
ClassMethod ActiveUser(userCode = "")
{
}

/// 登录页面，验证码，激活用户方法前，查询用户是未激活的转态？
/// w ##class(dhc.dao.SSUser).IsUnActiveUser("demo")
/// userCode ： 登录页面的用户名
ClassMethod IsUnActiveUser(userCode = "")
{
}

}
