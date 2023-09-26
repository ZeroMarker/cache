/// 用户权限表
Class web.DHCCKBUserAuthority Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	根据姓名查询用户权限表内数据，传给前台
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			姓名
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBUserAuthority).GetUserListByName("50","1","")
ClassMethod GetUserListByName(rows = 30, page = 1, UserName As %String = "") As %String
{
	n (rows, page,UserName)

	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s queryCode=UserName
	s queryCode = $zcvt(queryCode,"U")
	s h=0,count=0
	
	s RowID=""  
	f  s RowID=$o(^CKB.PDSS.UserAuthorityD(RowID))  q:RowID=""  d
	.s UserID=$lg(^CKB.PDSS.UserAuthorityD(RowID),2)
	.s UserName=$p(^SSU("SSUSR",UserID),"^",2)
	.s RoleID=$lg(^CKB.PDSS.UserAuthorityD(RowID),3)
	.s RoleName=$lg($g(^CT.CKB.PDSS.CommonDictionD(RoleID)),3)
	.s JobID=$lg(^CKB.PDSS.UserAuthorityD(RowID),4)
	.s JobName=$lg($g(^CT.CKB.PDSS.CommonDictionD(JobID)),3)
	.s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(UserName)
	.q:(queryCode'="")&&($zcvt(UserName,"U")'[queryCode)&&(pinDesc'[queryCode)
	.s h=h+1
	.s tempstr=RowID_"^"_UserName_"^"_RoleName_"^"_JobName_"^"_UserID_"^"_RoleID_"^"_JobID
	.s ^TMP("DHCCKB","web.DHCCKBUserAuthority","GetUserListByName",pid,h)=tempstr
	
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	///转换数据为Json格式
	s title="RowID^UserName^RoleName^JobName^UserID^RoleID^JobID" // 列title 
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s count=0,index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBUserAuthority","GetUserListByName",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCCKB","web.DHCCKBUserAuthority","GetUserListByName",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description:	获取人员表combox
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			
/// return:			人员姓名集合
/// other:			w ##class(web.DHCCKBUserAuthority).GetUserComboxData("")
ClassMethod GetUserComboxData(q As %String = "") As %String
{
	n (q)
	s queryCode = q
	s queryCode = $zcvt(queryCode,"U")
	s ^TMP("web.DHCCKBUserAuthority","GetUserComboxData") = $lb(q)
	
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s h=0,count=0
	s RowID=""  
	f  s RowID=$o(^SSU("SSUSR",RowID))  q:RowID=""  d
	.s UserCode=$p(^SSU("SSUSR",RowID),"^",1)
	.s UserDesc=$p(^SSU("SSUSR",RowID),"^",2)
	.s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(UserDesc)
	.q:(queryCode'="")&&($zcvt(UserCode,"U")'[queryCode)&&(UserDesc'[queryCode)&&(pinDesc'[queryCode)
	.s h=h+1
	.s tempstr=RowID_"^"_UserDesc
	.s ^TMP("DHCCKB","web.DHCCKBUserAuthority","GetUserComboxData",pid,h)=tempstr     // 数据存储
	q:h=0 ""
	///转换数据为Json格式
	s title="value^text" // 列title 
	w "[" 		//  输出json前缀串
	s count=0,index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBUserAuthority","GetUserComboxData",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCCKB","web.DHCCKBUserAuthority","GetUserComboxData",pid,index))
	.s count = count+1
	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	w "]"
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description:	获取职务表combox
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			
/// return:			职务集合
/// other:			w ##class(web.DHCCKBUserAuthority).GetRoleComboxData("")
ClassMethod GetRoleComboxData(q As %String = "") As %String
{
	n (q)
	s queryCode = q
	s queryCode = $zcvt(queryCode,"U")
	s ^TMP("web.DHCCKBUserAuthority","GetRoleComboxData") = $lb(q)
	
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s h=0,count=0
	
	s Parref=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("PositionData"),""))
	s RowID=""  
	f  s RowID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,RowID))  q:RowID=""  d
	.s RoleCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),2)
	.s RoleDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),3)
	.s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(RoleDesc)
	.q:(queryCode'="")&&($zcvt(RoleCode,"U")'[queryCode)&&(RoleDesc'[queryCode)&&(pinDesc'[queryCode)
	.s h=h+1
	.s tempstr=RowID_"^"_RoleDesc
	.s ^TMP("DHCCKB","web.DHCCKBUserAuthority","GetRoleComboxData",pid,h)=tempstr     // 数据存储
	
	
	q:h=0 ""
	///转换数据为Json格式
	s title="value^text" // 列title 
	w "[" 		//  输出json前缀串
	s count=0,index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBUserAuthority","GetRoleComboxData",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCCKB","web.DHCCKBUserAuthority","GetRoleComboxData",pid,index))
	.s count = count+1
	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	w "]"
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description:	获取岗位表combox
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			
/// return:			岗位集合
/// other:			w ##class(web.DHCCKBUserAuthority).GetJobComboxData("")
ClassMethod GetJobComboxData(q As %String = "") As %String
{
	n (q)
	s queryCode = q
	s queryCode = $zcvt(queryCode,"U")
	s ^TMP("web.DHCCKBUserAuthority","GetJobComboxData") = $lb(q)
	
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s h=0,count=0
	
	s Parref=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("JobData"),""))
	s RowID=""  
	f  s RowID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,RowID))  q:RowID=""  d
	.s JobCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),2)
	.s JobDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),3)
	.s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(JobDesc)
	.q:(queryCode'="")&&($zcvt(JobCode,"U")'[queryCode)&&(JobDesc'[queryCode)&&(pinDesc'[queryCode)
	.s h=h+1
	.s tempstr=RowID_"^"_JobDesc
	.s ^TMP("DHCCKB","web.DHCCKBUserAuthority","GetJobComboxData",pid,h)=tempstr     // 数据存储
	
	
	q:h=0 ""
	///转换数据为Json格式
	s title="value^text" // 列title 
	w "[" 		//  输出json前缀串
	s count=0,index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBUserAuthority","GetJobComboxData",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCCKB","web.DHCCKBUserAuthority","GetJobComboxData",pid,index))
	.s count = count+1
	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	w "]"
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
/// w ##class(web.DHCCKBUserAuthority).killTmpGlobal("199785")
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCCKB","web.DHCCKBUserAuthority","GetUserListByName",pid)
	k ^TMP("web.DHCCKBUserAuthority","GetUserComboxData",pid)
	k ^TMP("web.DHCCKBUserAuthority","GetRoleComboxData",pid)
	k ^TMP("web.DHCCKBUserAuthority","GetJobComboxData",pid)
	q ""
}

/// Description:	保存或修改(用)
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			id^姓名^职务^岗位
/// return:			
/// other:			w ##class(web.DHCCKBUserAuthority).SaveUpdate("^闵凤英^管理员^审批岗^10228^235466^235460")
ClassMethod SaveUpdate(params As %String = "") As %String
{
	n (params)
	s ^TMP("web.DHCCKBUserAuthority","SaveUpdate")=params
	s len = $l(params,"&&")
	s ret = 0
	f i = 1:1:len q:(ret<0)  d
	.s tmpstr = $p(params,"&&",i)
	.s RowID = $p(tmpstr,"^",1)
	.s UserName = $p(tmpstr,"^",2)
	.s RoleName = $p(tmpstr,"^",3)
	.s JobName = $p(tmpstr,"^",4)
	.s UserID = $p(tmpstr,"^",5)
	.s RoleID = $p(tmpstr,"^",6)
	.s JobID = $p(tmpstr,"^",7)
	
	.s flag =..CheckUserRepeat(RowID,UserID,RoleID,JobID)
	.s ret = flag
	.q:flag'=0
	.b ; //1
	.i RowID="" d
	..s ret = ..SaveUser(tmpstr)		// ret是id
	.e  d
	..s ret = ..UpdateUser(tmpstr)	// ret是SQLCODE
	q ret
}

/// Description:	保存或修改(用)
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			id^姓名^职务^岗位
/// return:			
/// other:			w ##class(web.DHCCKBUserAuthority).SaveUser("^Demo Group^组员^审批岗^1^235464^235460")
ClassMethod SaveUser(tmpstr) As %String
{
	n (tmpstr)
	s ^TMP("web.DHCCKBUserAuthority","SaveUser")=tmpstr
	s RowID = $p(tmpstr,"^",1)
	s UserName = $p(tmpstr,"^",2)
	s RoleName = $p(tmpstr,"^",3)
	s JobName = $p(tmpstr,"^",4)
	s UserID = $p(tmpstr,"^",5)
	s RoleID = $p(tmpstr,"^",6)
	s JobID = $p(tmpstr,"^",7)

	&SQL(
	INSERT INTO CKB_PDSS.UserAuthority
	(CUA_User_Dr,CUA_Role_Dr,CUA_Job_Dr)
	VALUES
	(:UserID,:RoleID,:JobID)
	)
	q SQLCODE
}

/// Description:	保存或修改(用)
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			id^姓名^职务^岗位
/// return:			
/// other:			w ##class(web.DHCCKBUserAuthority).UpdateUser("^OtherNameProp^别名^23^26947","")
ClassMethod UpdateUser(tmpstr) As %String
{
	n (tmpstr)
	s RowID = $p(tmpstr,"^",1)
	s UserName = $p(tmpstr,"^",2)
	s RoleName = $p(tmpstr,"^",3)
	s JobName = $p(tmpstr,"^",4)
	s UserID = $p(tmpstr,"^",5)
	s RoleID = $p(tmpstr,"^",6)
	s JobID = $p(tmpstr,"^",7)
	&SQL(
	UPDATE CKB_PDSS.UserAuthority
	SET CUA_User_Dr=:UserID,
		CUA_Role_Dr=:RoleID,
		CUA_Job_Dr=:JobID
	WHERE CUA_RowID=:RowID
	)
	q SQLCODE
}

/// Description:	判断是否存在重复数据
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			代码，描述，字典id
/// return:			存在则返回id，不存在则返回0
/// other:			w ##class(web.DHCCKBUserAuthority).CheckUserRepeat("","1","129662","235459")
ClassMethod CheckUserRepeat(RowID, UserID, RoleID, JobID) As %String
{
	n (RowID,UserID,RoleID,JobID)
	s ^TMP("web.DHCCKBUserAuthority","CheckDictionRepeat")=$lb(RowID,UserID,RoleID,JobID)
	s ret=0	
	
	i $d(^CKB.PDSS.UserAuthorityI("IndexUserRoleJob",UserID,RoleID,JobID))  d
	.s ret=-100
	
	
	q ret
}

/// Description:	删除人员表
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			UserID
/// return:			0成功 非0 失败
/// other:			w ##class(web.DHCCKBUserAuthority).DeleteDic(122)
ClassMethod DeleteUser(RowID) As %String
{
	n (RowID)
	&SQL(
	DELETE FROM CKB_PDSS.UserAuthority
	WHERE CUA_RowID=:RowID
	)

	q SQLCODE
}

}
