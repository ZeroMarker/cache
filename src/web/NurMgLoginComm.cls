/// Creator:guozj
/// Date:2017-08-29
/// Descriptions:系统登录公共类
Class web.NurMgLoginComm Extends %RegisteredObject
{

/// Creator: 
/// CreatDate: 2017-08-29
/// Description: 判断用户密码是否正确
/// Table：SS_User,CT_CareProv,CT_CarPrvTp
/// Input：userCode: 用户登陆名 passWord: 用户密码
/// Return：成功返回 0^用户ID 失败返回 密码错误
ClassMethod ConfirmPassWord(userCode As %String, passWord As %String) As %String
{
	;s ^TMP("username%password")=userCode_"$"_passWord
	//s %session.EndSession=1
	;s %session.AppTimeout=60*1
	;s sc=%session.Login("_system","SYS",1)
	s retStr=0
	i userCode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "医护人员类型定义有误!"

	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(passWord)
	i pin="" s retStr="密码错误"
	e  d
	.i pin'=$p($G(^SSU("SSUSR",userId)),"^",3) s retStr="密码错误"
	zn oldnamespace
	i retStr=0 s retStr=0_"^"_userId
	q retStr
}

ClassMethod GetNursePassword(usercode As %String, password As %String) As %String
{
	;s %session.AppTimeout=60*1
	;s sc=%session.Login("_system","SYS",1)
	s retstr=0
	s hisno="",userpassword="",nurserw=""
	i usercode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	b ;01
	s flag=-1
	i userId="" d
	.//HIS工号为空 执行护管查询工号
	.s flag=0 //HIS工号为空
	.s nurseid=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(usercode," ",""),"U"),""))
	.i nurseid="" s userId="" //护管工号不存在
	.e  d
	..s userId=nurseid //护管工号存在
	..s nurseobj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
	..s userpassword=nurseobj.PerPassword
	e  d
	.//HIS工号不为空
	.s flag=1 //HIS工号不为空
	.//判断护管工号是否同步，同步后进行登录，否则提示需要同步
	.i usercode="demo" s userpassword=$p($G(^SSU("SSUSR",userId)),"^",3)
	.e  d
	..s nurserw=$O(^DHCNMG.HR.MgPersonsI("hisno"," "_$zcvt($tr(usercode," ",""),"U"),""))
	..b ;110
	..i nurserw'=""  d
	...s nurobj=##class(DHCNMG.HR.MgPersons).%OpenId(nurserw)
	...s userpassword=$p($G(^SSU("SSUSR",userId)),"^",3)
	...
	;q:userId="" "用户有误！"
	q:((flag=0)&&(userId="")) "护管工号不存在！"
	q:((flag=1)&&(nurserw="")&&(usercode'="demo")) "请联系护理部同步HIS工号"
	;q:((userId'="")&&(nurserw="")&&(usercode'="demo")) "请联系护理部同步HIS工号"
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(password)
	i pin="" s retstr="密码错误"
	e  d
	.i pin'=userpassword s retstr="密码错误"
	zn oldnamespace
	i flag=1 s userId=nurserw
	i retstr=0 s retstr=0_"^"_userId_"^"_flag
	
	q retstr
}

ClassMethod GetUserPassword(usercode As %String, password As %String) As %String
{
	;s %session.AppTimeout=60*1
	;s sc=%session.Login("_system","SYS",1)
	s retstr=0
	s hisno="",userpassword="",nurserw="",state=0
	
	s Row=$O(^DHCNMG.DB.MgMergeHisInfoI("HIS"," "_$zcvt($tr(usercode," ",""),"U"),""))
	i Row=""
	{
		s state=0 //HIS号没有同步或者不存在
		
	}
	else
	{
		s state=1 //HIS号已经同步
	}
	s HRow=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(usercode," ",""),"U"),""))
	i HRow="" s state=2 //护管工号不存在
	e  s state=3 //护管工号存在
	i state=0 q:"请联系护理部同步HIS号或使用护管工号登录"
	
	i usercode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	s flag=-1
	i userId="" d
	.//HIS工号为空 执行护管查询工号
	.s flag=0 //HIS工号为空
	.s nurseid=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(usercode," ",""),"U"),""))
	.i nurseid="" s userId="" //护管工号不存在
	.e  d
	..s userId=nurseid //护管工号存在
	..s nurseobj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
	..s userpassword=nurseobj.PerPassword
	e  d
	.//HIS工号不为空
	.s flag=1 //HIS工号不为空
	.//判断护管工号是否同步，同步后进行登录，否则提示需要同步
	.i usercode="demo" s userpassword=$p($G(^SSU("SSUSR",userId)),"^",3)
	.e  d
	..s nurserw=$O(^DHCNMG.HR.MgPersonsI("hisno"," "_$zcvt($tr(usercode," ",""),"U"),""))
	..i nurserw'="" d
	...s nurobj=##class(DHCNMG.HR.MgPersons).%OpenId(nurserw)
	...s userpassword=$p($G(^SSU("SSUSR",userId)),"^",3)
	;q:userId="" "用户有误！"
	q:((flag=0)&&(userId="")) "护管工号不存在！"
	q:((flag=1)&&(nurserw="")&&(usercode'="demo")) "请联系护理部同步HIS工号"
	;q:((userId'="")&&(nurserw="")&&(usercode'="demo")) "请联系护理部同步HIS工号"
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(password)
	i pin="" s retstr="密码错误"
	e  d
	.i pin'=userpassword s retstr="密码错误"
	zn oldnamespace
	i retstr=0 s retstr=0_"^"_userId_"^"_flag
	
	q retstr
}

/// Creator:gzj
/// Date:2018-07-03
/// Decription:核对实习生的用户名和密码
/// 
ClassMethod GetInternPassword(usercode As %String, password As %String) As %String
{
	;s %session.AppTimeout=60*1
	;s sc=%session.Login("_system","SYS",1)
	s retStr=0
	s hisno="",userpassword="",nurserw=""
	s nurseid=$O(^DHCNMG.HR.MgPersonsI("Info"," P"," "_$zcvt($tr(usercode," ",""),"U"),""))
	q:nurseid="" "用户有误！"
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
	q:'$IsObject(obj) "用户有误！"
	s userpassword=obj.PerPassword
	s pin=$$ENCR^SSUTIL2(password)
	i pin="" s retStr="密码错误"
	e  d
	.i pin'=userpassword s retStr="密码错误"
	i retStr=0 s retStr=0_"^"_nurseid
	q retStr
}

ClassMethod NurseTest(usercode As %String, password As %String) As %String
{
}

/// Creator:guozj
/// Description:查询护士所含角色
/// Date:2017-10-10
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgLoginComm","FindNurRoleStore")
Query FindNurRoleStore(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurRoleStoreExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("loginstr")=parr
	i parr="demo"
	{
		s ret="secdesc|超级管理员"_"^seccode|admin"_"^seccodeid|0"
		do OutputRoleStore
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	else 
	{
		s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(parr," ",""),"U"),rowid)) q:rowid=""  d
		.s rolerw="" f  s rolerw=$O(^DHCNMG.HR.MgNurRoleI("ssid",rowid,rolerw)) q:rolerw=""  d
		..s obj=##class(DHCNMG.HR.MgNurRole).%OpenId(rolerw)
		..q:((obj.RoleStDate'="")&&(obj.RoleStDate>+$H))
		..q:((obj.RoleEndDate'="")&&(obj.RoleEndDate<=+$H))
		..b ;01
		..s secdesc="",seccode=""
		..i obj.RoleID'="" d
		...s roleobj=##class(DHCNMG.Set.MgRoles).%OpenId(obj.RoleID)
		...s secdesc=roleobj.RoleDesc
		...s seccode=roleobj.RoleCode
		..s ret="secdesc|"_secdesc_"^seccode|"_seccode_"^seccodeid|"_obj.RoleID
		..do OutputRoleStore
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
OutputRoleStore
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurRoleStoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurRoleStoreExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurRoleStoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurRoleStoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: 
/// CreatDate: 2017-10-10
/// Description: 根据登录用户获取人员ID 和默认科室
/// Table
/// Input：username: 用户登陆名
/// Return：成功返回 人员ID^所在科室id
ClassMethod GetLoginInfo(username As %String, flag As %String, type As %String) As %String
{
	//flag=1 HIS工号不为空 flag=0 HIS工号为空
	s ^TMP("username")=username_"%"_flag_"%"_type
	s ret=""
	q:username="demo" "loginID|0"_"^loginDep|"_"^loginDesc|管理员"
	i type="N"
	{
		i flag=0 d 
		.s rowid=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(username," ",""),"U"),""))
		e  i flag=1 d
		.s rowid=$O(^DHCNMG.HR.MgPersonsI("hisno"," "_$zcvt($tr(username," ",""),"U"),""))
		i rowid'="" d
		.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
		.s ward=obj.PerDepDR
		.s ret="loginID|"_rowid_"^loginDep|"_ward_"^loginDesc|"_obj.PerName
	
	}
	elseif type="P"
	{
		s rowid=$O(^DHCNMG.HR.MgPersonsI("Info"," P"," "_$zcvt($tr(username," ",""),"U"),""))
		i rowid'="" d
		.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
		.s ward=obj.PerDepDR
		.s ret="loginID|"_rowid_"^loginDep|"_ward
	}
	q ret
}

ClassMethod GetLoginRoleCode(role As %String) As %String
{
	s ^TMP("roleget")=role
	q:role="" ""
	s ret=""
	q:role="0" "admin"
	s obj=##class(DHCNMG.Set.MgRoles).%OpenId(role)
	q:'$IsObject(obj) ""
	s ret=obj.RoleCode
	q ret
}

/// Creator: 
/// CreatDate: 2018-01-04
/// Description: 获取用户ID下所包含的角色信息
/// Table:
/// Input:id:护理管理人员表id
/// Return:
ClassMethod GetLoginNurseInRole(id As %String) As %String
{
	s ^TMP("getlosinnurseinrole")=id
	s ret=""
	q:id=0 "admin|1|0"
	s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurRoleI("ssid",id,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.HR.MgNurRole).%OpenId(rowid)
	.;q:(obj.RoleEndDate'="")
	.q:((+$h<obj.RoleStDate)||((+$h>obj.RoleEndDate)&&(obj.RoleEndDate'="")))
	.s roleid=obj.RoleID
	.s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(roleid)
	.q:'$IsObject(roleObj)
	.s rolecode=roleObj.RoleCode
	.s rolelevel=roleObj.RoleLevel
	.i ret="" s ret=rolecode_"|"_rolelevel_"|"_roleid
	.e  s ret=ret_"^"_rolecode_"|"_rolelevel_"|"_roleid
	q ret
}

/// 
/// Description:登出
ClassMethod LogOut() As %String
{
	s %session.EndSession=1
	q 0
}

ClassMethod NewNurseLogin(card As %String) As %String
{
	s ^TMP("newnurselogin")=card
	q:card="" ""
	s ret=""
	s rowid=$O(^DHCNMG.HR.MgNurNewNursesI("card"," "_$zcvt($tr(card," ",""),"U"),""))
	i rowid'="" d
	.s obj=##class(DHCNMG.HR.MgNurNewNurses).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s NewNurseName=obj.NewNurseName
	.s NewNurseID=obj.NewNurseID
	.i obj.NewBirthday'="" s NewBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.NewBirthday)
	.e  s NewBirthday=""
	.s NewCardId=obj.NewCardId
	.s NewSexDR=obj.NewSexDR
	.s NewDepDR=obj.NewDepDR
	.i obj.NewDepDate'="" s NewDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.NewDepDate)
	.e  s NewDepDate=""
	.i obj.NewComeDate'="" s NewComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.NewComeDate)
	.e  s NewComeDate=""
	.i obj.NewWorkDate'="" s NewWorkDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.NewWorkDate)
	.e  s NewWorkDate=""
	.s NewMarriage=obj.NewMarriage
	.s NewNativePlace=obj.NewNativePlace
	.s NewPolitical=obj.NewPolitical
	.s NewAddress=obj.NewAddress
	.s NewContact=obj.NewContact
	.s NewPhone=obj.NewPhone
	.s NewLocDR=obj.NewLocDR
	.s NewSyncCode=obj.NewSyncState
	.s ret="NewSyncCode|"_NewSyncCode_"^NewNurseName|"_NewNurseName_"^NewNurseID|"_NewNurseID_"^NewBirthday|"_NewBirthday_"^NewCardId|"_NewCardId_"^NewSexDR|"_NewSexDR_"^NewDepDR|"_NewDepDR_"^NewDepDate|"_NewDepDate_"^NewComeDate|"_NewComeDate_"^NewWorkDate|"_NewWorkDate_"^NewMarriage|"_NewMarriage_"^NewNativePlace|"_NewNativePlace_"^NewAddress|"_NewAddress_"^NewContact|"_NewContact_"^NewPhone|"_NewPhone_"^RowID|"_rowid_"^NewPolitical|"_NewPolitical_"^NewLocDR|"_NewLocDR
	q ret
}

}
