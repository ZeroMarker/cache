/// Creator:lulin
/// Descriptions:系统登录相关公共方法类
/// Date:2020-05-25
Class web.INMLoginComm Extends %RegisteredObject
{

/// creator: lulin
/// createDate: 2018-12-10
/// description: 某人某天是否具有某角色【角色代码】
/// table: 
/// input:用户id、日期、角色代码(多个逗号隔开)
/// output:
/// other:w ##class(web.INMLoginComm).IsNurInRoleForCode(1,"nurhead",+$H)
ClassMethod IsNurInRoleForCode(id, parr, date As %String = "") As %String
{
	q:(id="")!(parr="") 0
	q:id=0 1
	s flag=0
	i date="" d
	.s nowDate=+$H
	e  i date["-"  d
	.s nowDate=$zdh(date,3)
	e  d
	.s nowDate=date
	f i=1:1:$L(parr,",") q:flag=1  d
	.s roleCode=$zcvt($p(parr,",",i),"U")
	.q:roleCode=""
	.s:roleCode=0 flag=1
	.q:flag=1
	.s roleId="" f  s roleId=$O(^CT.DHCINM.Set.MgRolesI("code"," Y"," "_roleCode,roleId)) q:((roleId="")||(flag=1))  d
	..s flag=..IsNurInRole(id,roleId,nowDate)
	q flag
}

/// creator: lulin
/// createDate: 2018-12-10
/// description: 某人某天是否具有某角色【角色id】
/// table: 
/// input:用户id、日期、角色代码(多个逗号隔开)
/// output:
/// other:
ClassMethod IsNurInRoleForId(id, parr, date As %String = "") As %String
{
	q:(id="")!(parr="") 0
	q:id=0 1
	s flag=0
	i date="" d
	.s nowDate=+$H
	e  i date["-"  d
	.s nowDate=$zdh(date,3)
	e  d
	.s nowDate=date
	f i=1:1:$L(parr,",") d
	.s roleId=$zcvt($g(parr,","),"U")
	.s:roleId=0 flag=1
	.q:flag=1
	.s flag=..IsNurInRole(id,roleId,nowDate)
	q flag
}

/// creator: lulin
/// createDate: 2018-12-10
/// description: 某人某天是否具有某角色
/// table: 
/// input:用户id、日期、角色代码(多个逗号隔开)
/// output:
/// other:
ClassMethod IsNurInRole(id, roleId, nowDate) As %String
{
	s flag=0
	s userRoleId="" f  s userRoleId=$O(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,id,userRoleId)) q:((userRoleId="")||(flag=1))  d
	.s userRoleObj=$g(^CF.DHCINM.DB.MgUserRoleD(id,userRoleId))
	.q:userRoleObj=""
	.;s roleId=$LG(userRoleObj,2)
	.;q:roleId=""
	.;q:($g(tmp(roleId))'="")
	.s startDate=$LG(userRoleObj,3)
	.q:(startDate'="")&&(startDate>nowDate)
	.s endDate=$LG(userRoleObj,4)
	.q:((endDate'="")&&(endDate<=nowDate))
	.s flag=1
	q flag
}

/// Creator:lulin
/// Createdate:2019-11-26
/// Description:根据登陆人获取其权限
/// Input:id:登陆人id
/// Output:
/// Other:w ##class(web.INMLoginComm).GetRolesByLoginId(1)
ClassMethod GetRolesByLoginId(id) As %String
{
	q:id="" ""
	q:id=0 0
	s nowDate=+$H
	s ret="",tmp=""
	s nurRoleId="" f  s nurRoleId=$O(^CF.DHCINM.DB.MgUserRoleD(id,nurRoleId)) q:nurRoleId=""  d
	.s tObj=$g(^CF.DHCINM.DB.MgUserRoleD(id,nurRoleId))
	.q:tObj=""
	.s roleId=$LG(tObj,2)
	.q:roleId=""
	.q:($g(tmp(roleId))'="")
	.s startDate=$LG(tObj,3)
	.q:(startDate'="")&&(startDate>nowDate)
	.s endDate=$LG(tObj,4)
	.q:((endDate'="")&&(endDate<=nowDate))
	.i ret="" s ret=roleId
	.e  s ret=ret_"^"_roleId
	.s tmp(roleId)=roleId
	q ret
}

/// Creator:lulin
/// Createdate:2019-11-26
/// Description:根据登陆人获取辖区
/// Input:登录用户,临时数组
/// Output:是否拥有所有权限,辖区病区
/// Other:
ClassMethod SetLoginWard(nurseid, tmpWard) As %String
{
	q:nurseid="" 0
	k tmpWard
	s roleflag=0
	s roles=..GetRolesByLoginId(nurseid)
	s type=0  //此处可以做成配置，配置某个角色是否具有全部权限
	s twoForAllWard=2
	;可配置综合参数几级以上角色是否拥有所有病区权限
	f i=1:1:$l(roles,"^") q:roleflag=1  d
	.s trole=$p(roles,"^",i)
	.q:trole=""
	.i trole'=0 d
	..s roleObj=##class(CT.DHCINM.Set.MgRoles).%OpenId(trole)
	..i $IsObject(roleObj) d
	...s code=$zcvt(roleObj.RoleCode,"U")
	...i code="ADMIN" s roleflag=1 ;超级管理员
	...i (roleObj.RoleLevel<=twoForAllWard) s roleflag=1
	.e  s roleflag=1
	.q:roleflag=1
	.s rolerw="" f  s rolerw=$O(^CF.DHCINM.Set.MgDataLimitI("Role"," "_trole," "_nurseid,rolerw)) q:rolerw=""  d
	..s roledeprw="" f  s roledeprw=$O(^CF.DHCINM.Set.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
	...s SubWard=$LG(^CF.DHCINM.Set.MgDataLimitSubD(rolerw,roledeprw),2)
	...q:SubWard=""
	...s tmpWard(SubWard)=SubWard
	s perId=$LG($G(^CF.DHCINM.DB.MgUserD(nurseid)),5)
	i perId'="" d
	.s curward=$LG($g(^CF.DHCINM.HR.PersonsD(perId)),10)
	.s:(curward'="")&&('$d(tmpWard(curward))) tmpWard(curward)=curward
	q roleflag
}

/// Creator:lulin
/// Description:判断HIS工号和密码是否正确
/// Date:2020-04-09
/// Table:
/// Input:
/// Output：-1:不存在HIS工号，0:密码错误，1：密码正确
/// Others:
ClassMethod ConfirmHISPassword(userCode As %String = "", password As %String = "") As %String
{
	s ret=0
#;	s hisId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
#;	q:hisId="" "-1" //不能存在his工号
#;	s userpassword=$p($G(^SSU("SSUSR",hisId)),"^",3)
#;	s oldnamespace=$ZNSPACE
#;	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
#;	zn datanamespace
#;	s pin=$$ENCR^SSUTIL2(password)
#;	s:pin=userpassword ret=1
#;	zn oldnamespace

	/// 0^UserNotFindErr         -用户不存在
	/// -userid^UnActiveErr      -未激活
	/// -userid^DateFromScopeErr -未到用户开启日
	/// -userid^DateToScopeErr   -用户有效期已过
	/// -userid^PasswordErr      -密码错误
	s result=##Class(web.SSUser).IsValidUser(userCode,password)
	q:+result>0 1
	s ssuerId=$p(result,"^")
	q:ssuerId=0 "-1"
	s resson=$p(result,"^",2)
	s ret=$case(resson,"UnActiveErr":-2,"DateFromScopeErr":-3,"DateToScopeErr":-4,"PasswordErr":0,:-999)
	q ret
}

/// Creator:lulin
/// Description:判断用户名密码是否正确
/// Date:2020-04-09
/// Table:
/// Input:
/// Output：状态^护管工号
/// Others:需要和第三方HIS确定超级用户工号
ClassMethod GetNursePassword(usercode As %String, password As %String) As %String
{
	q:(usercode="")||(password="") "请输入工号和密码"
	s retstr=0
	s isHIS=..ConfirmHISPassword(usercode,password)
	;登录使用his工号获取对应person得id
	s hisId=##class(web.INMHISComm).GetUserIdByCode(usercode)
	s nurseid=""
	i hisId'="" d
	.s nurseid=$O(^CF.DHCINM.DB.MgUserI("SSUser"," "_$zcvt($tr(hisId," ",""),"U"),"")) 
	;需要和第三方HIS确定超级用户工号
	s:usercode="demo" nurseid="0"
	;使用his工号登录
	i isHIS'=-1  d
	.i nurseid="" s retstr="未在护管中维护HIS工号,请联系护理部维护"
	.e  i isHIS'=1 s retstr=$case(isHIS,-2:"未激活",-3:"未到用户开启日",-4:"用户有效期已过",0:"密码错误",:"其他错误") ;retstr="密码错误"
	.e  s retstr="1"
	;his中有工号并已经验证，返回结果
	q:isHIS'=-1 retstr_"^"_nurseid
	;如果HIS中无工号使用护管工号登录
	s nurseid=$O(^CF.DHCINM.DB.MgUserI("UserID"," "_$zcvt($tr(usercode," ",""),"U"),""))
	q:nurseid="" "系统无此用户"
	s nurseobj=##class(CF.DHCINM.DB.MgUser).%OpenId(nurseid)
	q:'$IsObject(nurseobj) "系统无此用户"
	q:((nurseobj.EndDate'="")&&(nurseobj.EndDate<+$H)) "用户已停用不可登录"
	s userpassword=nurseobj.Password
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(password)
	i pin=userpassword s retstr=1
	e  s retstr="密码错误"
	zn oldnamespace
	q retstr_"^"_nurseid
}

/// Description:登出
ClassMethod LogOut() As %String
{
	s %session.EndSession=1
	q 0
}

/// Creator:lulin
/// Createdate:2020-09-03
/// Description:根据登录用户Code获取用户Id
/// Input:用户code,类型：H:his,M:护管
/// Output:
/// Other:
ClassMethod GetIDByUserCode(UserCode As %String, type As %String) As %String
{
	q:(UserCode="") ""
	q:$zcvt(UserCode,"U")="DEMO" 0
	s UserCode=$zcvt(UserCode,"U")
	s ret=$O(^CF.DHCINM.DB.MgUserI("UserID"," "_UserCode,""))
	i type="H" d
	.s ssuserID=##class(web.INMHISComm).GetUserIdByCode(UserCode)
	.s ret=$O(^CF.DHCINM.DB.MgUserI("SSUser"," "_ssuserID,""))
	q ret
}

/// Creator:lulin
/// Createdate:2020-04-09
/// Description:用户登录后获取基本信息
/// Input:parr
/// Output:
/// Other:需要和第三方HIS确定超级用户工号,terminal调试注释掉251session。
ClassMethod GetPersonByLoginId(id As %String) As %String
{
	q:(id="") ""
	s loginName="",loginID="",loginPerID="",loginCode="",loginRoleCodes="" ;姓名、id、工号、角色
	s loginWardDesc="",loginHireDuty="",topRoleDesc="",topRoleLevel=999,lang="zh",langDesc="中文"
	s IsAdvanced=$LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),25)
	i id=0 {
		s loginCode="demo",loginID="0",loginPerID="0",loginName="超级管理员",loginRoleCodes="0"
	}else{
		s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(id)
		i $IsObject(userObj) d
		.s loginName=userObj.UserName
		.s loginID=userObj.%Id()
		.s loginCode=userObj.UserID
		.s loginPerDR=userObj.PerDR
		.i loginPerDR'="" d
		..s loginPerID=loginPerDR
		..s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(loginPerDR)
		..i $IsObject(perObj) d
		...s loginWardId=perObj.PerDepDR
		...i loginWardId'="" d
		....s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(loginWardId)
		....i $IsObject(wardObj) d
		.....s loginWardDesc=wardObj.WardDesc
		..s hireDate="" f  s hireDate=$O(^CF.DHCINM.HR.HireDutyI("HireDate",loginPerDR,hireDate)) q:hireDate=""  d
		...q:(hireDate>+$H)
		...s hireId="" f  s hireId=$O(^CF.DHCINM.HR.HireDutyI("HireDate",loginPerDR,hireDate,hireId)) q:hireId=""  d
		....s hireObj=##class(CF.DHCINM.HR.HireDuty).%OpenId(hireId)
		....q:'$IsObject(hireObj)
		....s hireDutyId=hireObj.HireDuty
		....q:hireDutyId=""
		....s codeObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(hireDutyId)
		....q:'$IsObject(codeObj)
		....S loginHireDuty=codeObj.SubDesc
		.s loginRoleCodes=..GetRolesByLoginId(id)
		.s loginRoleCodes=$tr(loginRoleCodes,"^",",")
		.f i=1:1:$L(loginRoleCodes,",") d
		..s troleId=$P(loginRoleCodes,",",i)
		..q:troleId=""
		..s roleObj=$g(^CT.DHCINM.Set.MgRolesD(troleId))
		..q:roleObj=""
		..s roleLevel=$lg(roleObj,6)
		..s roleDesc=$lg(roleObj,3)
		..s:((roleLevel'="")&&(topRoleLevel>roleLevel)) topRoleDesc=roleDesc,topRoleLevel=roleLevel
		.i userObj.UserDR'="" d
		..s langDr=$p($g(^SSU("SSUSR",userObj.UserDR)),"^",13)
		..q:langDr=""
		..s langCode=$p($g(^SS("LAN",langDr)),"^",1)
		..i (langCode'="CH")&&(langCode'="")  d
		...s INMLangCode=##class(web.INMSetComm).GetParamSubByCode("LangSet",langCode,"SubCode")
		...s:INMLangCode'="" lang=INMLangCode,langDesc=##class(web.INMSetComm).GetParamSubByCode("LangSet",langCode,"SubDesc")
	}
	s ret="loginName|"_loginName_"^loginID|"_loginID_"^loginCode|"_loginCode_"^loginRoleCodes|"_loginRoleCodes
	s ret=ret_"^loginWardDesc|"_loginWardDesc_"^loginHireDuty|"_loginHireDuty_"^loginPerID|"_loginPerID_"^IsAdvanced|"_IsAdvanced
	s ret=ret_"^topRoleDesc|"_topRoleDesc_"^Lang|"_lang_"^LangDesc|"_langDesc
	q ret
}

/// Creator:lulin
/// Createdate:2020-04-09
/// Description:根据登录人角色获取菜单、路由
/// Input:parr
/// Output:
/// Other:
ClassMethod GetMenuItemsForRoles(loginId As %String = "") As %String
{
	s roles=..GetRolesByLoginId(loginId)
	s len=$l(roles,"^")
	s ret="",isAll=0
	s tmp=""
	f i=1:1:len
	{
		s role=$p(roles,"^",i)
		i role="" continue
		s:role=0 isAll=1
		q:role=0
		s moduleId="" f  s moduleId=$O(^CT.DHCINM.Set.MgLimitSetI("sort"," "_role,moduleId)) q:moduleId=""  d
		.s limitId="" f  s limitId=$O(^CT.DHCINM.Set.MgLimitSetI("sort"," "_role,moduleId,limitId)) q:limitId=""  d
		..s menuId="" f  s menuId=$O(^CT.DHCINM.Set.MgLimitSetSubI("Menu",limitId,menuId)) q:menuId=""  d
		...s tmp($tr(moduleId," ",""),$tr(menuId," ",""))=$tr(moduleId," ","")_"^"_$tr(menuId," ","")
	}
	w "["
	s mouldnum=0
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^CT.DHCINM.Set.MgModuleI("Sort",sort,id)) q:id=""  d
	..q:((isAll=0)&&($d(tmp(id))=0))
	..s obj=##class(CT.DHCINM.Set.MgModule).%OpenId(id)
	..q:'$IsObject(obj)
	..q:($O(^CT.DHCINM.Set.MgMenuI("ModuleSort",id,""))="") ;无所辖菜单
	..q:((obj.ModuleStDate'="")&&(obj.ModuleStDate>+$h))
	..q:((obj.ModuleEndDate'="")&&(obj.ModuleEndDate<+$h))
	..q:(($LG($g(^CT.DHCINM.Set.MgArgParamSetD(1)),25)="N")&&(obj.IsAdvanced="Y"))
	..s title=obj.ModuleDesc,Code=obj.ModuleCode
	..i mouldnum=0 w "{""label"":"""_title_""",""code"":"""_Code_""",""active"":false,""id"":"""_id_""""
	..e  w ",{""label"":"""_title_""",""code"":"""_Code_""",""active"":false,""id"":"""_id_""""
	..s childnum=0,activeMenuId=""
	..s:$IsObject(obj.ModuleMenuDR) activeMenuId=obj.ModuleMenuDR.%Id()
	..w ",""children"":["
	..s menusort="" f  s menusort=$O(^CT.DHCINM.Set.MgMenuI("ModuleSort",id,menusort)) q:menusort=""  d
	...s menuid="" f  s menuid=$O(^CT.DHCINM.Set.MgMenuI("ModuleSort",id,menusort,menuid)) q:menuid=""  d
	....s menuobj=##class(CT.DHCINM.Set.MgMenu).%OpenId(menuid)
	....q:'$IsObject(menuobj)
	....q:((menuobj.MenuStDate'="")&&(menuobj.MenuStDate>+$h))
	....q:((menuobj.MenuEndDate'="")&&(menuobj.MenuEndDate<+$h))
	....q:menuobj.MenuParentDR'="" ;获取第一层菜单
	....q:(($LG($g(^CT.DHCINM.Set.MgArgParamSetD(1)),25)="N")&&(menuobj.IsAdvanced="Y"))
	....s parid=id_"-"_menuid
	....q:((isAll=0)&&($d(tmp(id,parid))=0))
	....s menutitle=menuobj.MenuDesc,menucode=menuobj.MenuCode,menuroute=menuobj.MenuRouter
	....s menuicon=menuobj.MenuIcon,menuparams=menuobj.MenuParams,menuPath=menuobj.MenuPath
	....s active="false"
	....s:(activeMenuId=menuid) active="true"
	....i childnum=0 d
	.....w "{""label"":"""_menutitle_""",""code"":"""_menucode_""",""route"":"""_menuroute_""",""active"":"_active
	.....w ",""id"":"""_parid_""",""icon"":"""_menuicon_""",""params"":"""_menuparams_""",""menuPath"":"""_menuPath_""""
	.....w ",""children"":["
	.....i $O(^CT.DHCINM.Set.MgMenuI("ParentSort",menuid,""))'="" d ..WriteMenuChildren(id,menuid,activeMenuId,isAll,.tmp)
	.....w "]}"
	....e  d  
	.....w ",{""label"":"""_menutitle_""",""code"":"""_menucode_""",""route"":"""_menuroute_""",""active"":"_active
	.....w ",""id"":"""_parid_""",""icon"":"""_menuicon_""",""params"":"""_menuparams_""",""menuPath"":"""_menuPath_""""
	.....w:($e(menucode,1,3)="HOS")||(menucode="MySchedule") ",""UserShow"":""0"""
	.....w ",""children"":["
	.....i $O(^CT.DHCINM.Set.MgMenuI("ParentSort",menuid,""))'="" d ..WriteMenuChildren(id,menuid,activeMenuId,isAll,.tmp)
	.....w "]}"
	....s childnum=childnum+1
	..w "]"
	..s mouldnum=mouldnum+1
	..w "}"
	w "]"
	q ""
}

/// Creator:lulin
/// Createdate:2020-04-09
/// Description:输出菜单子节点
/// Input:parr
/// Output:
/// Other:
ClassMethod WriteMenuChildren(moduleId, menuId, activeMenuId, isAll, tmp) As %String
{
	s childnum=0
	q:menuId="" ""
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgMenuI("ParentSort",menuId,sort)) q:sort=""  d
	.s childMenuId="" f  s childMenuId=$O(^CT.DHCINM.Set.MgMenuI("ParentSort",menuId,sort,childMenuId)) q:childMenuId=""  d
	..s menuobj=##class(CT.DHCINM.Set.MgMenu).%OpenId(childMenuId)
	..q:'$IsObject(menuobj)
	..q:((menuobj.MenuStDate'="")&&(menuobj.MenuStDate>+$h))
	..q:((menuobj.MenuEndDate'="")&&(menuobj.MenuEndDate<+$h))
	..q:(($LG($g(^CT.DHCINM.Set.MgArgParamSetD(1)),25)="N")&&(menuobj.IsAdvanced="Y"))
	..s parid=moduleId_"-"_childMenuId
	..q:((isAll=0)&&($d(tmp(moduleId,parid))=0))
	..s menutitle=menuobj.MenuDesc,menucode=menuobj.MenuCode,menuroute=menuobj.MenuRouter
	..s menuicon=menuobj.MenuIcon,menuparams=menuobj.MenuParams,menuPath=menuobj.MenuPath
	..s active="false"
	..s:(activeMenuId=childMenuId) active="true"
	..i childnum=0 d
	...w "{""label"":"""_menutitle_""",""code"":"""_menucode_""",""route"":"""_menuroute_""",""active"":"_active
	...w ",""id"":"""_parid_""",""icon"":"""_menuicon_""",""params"":"""_menuparams_""",""menuPath"":"""_menuPath_""""
	...w ",""children"":["
	...i $O(^CT.DHCINM.Set.MgMenuI("ParentSort",childMenuId,""))'="" d ..WriteMenuChildren(moduleId,childMenuId,activeMenuId,isAll,.tmp)
	...w "]}"
	..e  d  
	...w ",{""label"":"""_menutitle_""",""code"":"""_menucode_""",""route"":"""_menuroute_""",""active"":"_active
	...w ",""id"":"""_parid_""",""icon"":"""_menuicon_""",""params"":"""_menuparams_""",""menuPath"":"""_menuPath_""""
	...w ",""children"":["
	...i $O(^CT.DHCINM.Set.MgMenuI("ParentSort",childMenuId,""))'="" d ..WriteMenuChildren(moduleId,childMenuId,activeMenuId,isAll,.tmp)
	...w "]}"
	..s childnum=childnum+1
}

/// Creator:lulin
/// Createdate:2019-11-26
/// Description:根据登陆人获取某菜单其按钮权限
/// Input:
/// Output:
/// Other:
ClassMethod GetAllElements(loginId As %String, router As %String) As %String
{
	s ret=""
	s tmp=""
	q:(loginId="")||(router="") "{}"
	s roles=..GetRolesByLoginId(loginId)
	s rw=$O(^CT.DHCINM.Set.MgMenuI("route"," "_$zcvt($tr(router," ",""),"U"),""))
	q:rw="" "{}"
	s obj=##class(CT.DHCINM.Set.MgMenu).%OpenId(rw)
	q:'$IsObject(obj) "{}"
	q:'$IsObject(obj.MenuModuleDR) "{}"
	s moudid=obj.MenuModuleDR.%Id()
	s menuid=moudid_"-"_rw
	s isAll=0
	f j=1:1:$l(roles,"^") q:isAll=1  d
	.s roleid=$p(roles,"^",j)
	.q:roleid=""
	.s:roleid=0 isAll=1
	.q:isAll=1
	.s limitId=$O(^CT.DHCINM.Set.MgLimitSetI("sort"," "_roleid," "_moudid,""))
	.q:limitId=""
	.s limitSubId=$O(^CT.DHCINM.Set.MgLimitSetSubI("Menu",limitId," "_menuid,""))
	.q:limitSubId=""
	.s elements=$LG($G(^CT.DHCINM.Set.MgLimitSetSubD(limitId,limitSubId)),3)
	.q:elements=""
	.s len=$LL(elements)
	.f i=1:1:len d
	..s itm=$LG(elements,i)
	..q:itm=""
	..s elementid=$p(itm,"-",3)
	..q:elementid=""
	..s tmp(elementid)=elementid
	s ret="{",isFirst=1
	s elementid="" f  s elementid=$O(^CT.DHCINM.Set.MgMenuElementD(rw,elementid)) q:elementid=""  d
	.s ElementCode=$LG($G(^CT.DHCINM.Set.MgMenuElementD(rw,elementid)),2)
	.q:ElementCode=""
	.s ifShow="false"
	.s:(isAll=1)||($d(tmp(elementid))) ifShow="true"
	.i isFirst=1  s ret=ret_""""_ElementCode_""":"_ifShow
	.e  s ret=ret_","""_ElementCode_""":"_ifShow
	.s isFirst=0
	s ret=ret_"}"
	w ret
	q ""
}

/// Description:获取最高角色
ClassMethod GetTopRoleByLoginId(id)
{
	q:(id="") ""
	s loginName=""
	q:id=0 "0^DEMO"
	s min=100
	s roles=..GetRolesByLoginId(id)
	i roles'["^" s min=roles
	e  d
	.f i=1:1:$l(roles,"^")  d
	..s role=$p(roles,"^",i)
	..i role<min s min=role
	s rolecode=$lg(^CT.DHCINM.Set.MgRolesD(min),2)
	q min_"^"_rolecode
}

}
