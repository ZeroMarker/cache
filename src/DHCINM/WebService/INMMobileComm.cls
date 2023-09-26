Class DHCINM.WebService.INMMobileComm Extends %RegisteredObject
{

/// Creator: jyc
/// CreatDate: 2019-10-09
/// Description: 验证工号、密码，返回登录信息
/// w ##class(DHCINM.WebService.INMMobileComm).Logon("demo","1")
ClassMethod Logon(userCode As %String, password As %String) As %String
{
	s Q=""
    q:(userCode="")!(password="") ##class(DHCINM.WebService.INMServerUtilComm).returnJson(0,"账户或密码为空","") 
	s confiremRet=..ConfirmPassWord(userCode,password)  //验证账号密码
	s confiremRetCode=$P(confiremRet,"^",1)
	s loginId=$P(confiremRet,"^",2)
 	q:confiremRetCode'=1 ##class(DHCINM.WebService.INMServerUtilComm).returnJson(0,confiremRetCode,"") 
	s name=""
	i userCode'="demo" d
	.s objUser=##class(CF.DHCINM.DB.MgUser).%OpenId(loginId)
	.s name=objUser.UserName  //姓名
	e  d
	.s name="超级管理员",loginId="0"
	s ret="userCode|"_userCode_"^loginId|"_loginId_"^name|"_name_"^TomcatUr|"_$lg($g(^CT.DHCINM.Set.MgSysParamSubD(11,1)),3)
	s result=##class(DHCINM.WebService.INMServerUtilComm).StrToJson(ret,"^","|")
	q ##class(DHCINM.WebService.INMServerUtilComm).returnJson(1,"",result)
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

/// Description: 判断用户密码是否正确
/// Table：SS_User,CT_CareProv,CT_CarPrvTp
/// Input：userCode: 用户登陆名 passWord: 用户密码
/// Return：成功返回 0^用户ID 失败返回 密码错误
ClassMethod ConfirmPassWord(usercode As %String, password As %String) As %String
{
	q:(usercode="")||(password="") "请输入工号和密码"
	s retstr=0
	s isHIS=..ConfirmHISPassword(usercode,password)
	;登录使用his工号获取对应person得id
	s hisId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
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

/// Description:获取查房单数量(按状态)
/// Date:2020-09-21
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 检查月份
/// Output:待检查数量、已保存数量、已检查数量、全部数量
/// Other:w ##class(DHCINM.WebService.INMMobileComm).GetCheckSurvey("158","2020-09")
ClassMethod GetCheckSurvey(loginId As %String, checkMonth As %String) As %String
{
	///随机检查:未检查的算到当前月份中;已检查的,算到结果的检查日期(DHCINM.CHK.MgCheckResult.CheckDate)的月份.
	///非随机检查:按照任务日期计算.
	q:(loginId="")||(checkMonth'["-") "{""statusTotal"":""0"",""noCheckNum"":""0"",""isSaveNum"":""0"",""checkNum"":""0""}"
	s firstDate=$zdh(checkMonth_"-01",3)
	s lastDate=$SYSTEM.SQL.LASTDAY(firstDate)
	s now=$e($zd(+$h,3),1,7)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	s toCheck=0,unFinishCheck=0,checked=0,total=0
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom)) q:isRandom=""  d
	.s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType)) q:taskType=""  d
	..s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType,taskId)) q:taskId=""  d
	...s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	...q:(taskObj.TaskIsRandom'="Y")&&((firstDate>taskObj.TaskEndDate)||(lastDate<taskObj.TaskStDate))
	...q:'$IsObject(taskObj)
	...q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")
	...s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	....s taskItemId=$p(taskStr,"「",2)
	....s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	.....q:(isAll'=1)&&('$d(tmpWard(taskWardId)))&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.....s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	.....i resultId'="" d
	......s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	......q:'$IsObject(resultObj)
	......q:(taskObj.TaskIsRandom="Y")&&((resultObj.CheckDate>lastDate)||(resultObj.CheckDate<firstDate))
	......i resultObj.CheckStatus="S" s checked=checked+1
	......e  s unFinishCheck=unFinishCheck+1
	......s total=total+1
	.....e  d
	......q:(taskObj.TaskIsRandom="Y")&&(checkMonth'=now)
	......s toCheck=toCheck+1
	......s total=total+1
	
	s ret="statusTotal|"_total_"^noCheckNum|"_toCheck_"^isSaveNum|"_unFinishCheck_"^checkNum|"_checked
	q ##class(DHCINM.WebService.INMServerUtilComm).StrToJson(ret,"^","|")
}

/// Description:获取查房单数量(按级别)
/// CreateDate:2020-09-22
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 检查月份 状态(A:全部,N:未检查,Y:已检查,S:已保存)
/// Output:护理部级别数量、科室级别数量、病区级别数量、全部数量
/// Other:w ##class(DHCINM.WebService.INMMobileComm).GetCheckLevelNum("158","2020-09","A")
ClassMethod GetCheckLevelNum(loginId As %String, checkMonth As %String, checkStatus As %String) As %String
{
	///随机检查:未检查的算到当前月份中;已检查的,算到结果的检查日期(DHCINM.CHK.MgCheckResult.CheckDate)的月份.
	///非随机检查:按照任务日期计算.
	q:(loginId="")||(checkMonth'["-") "{""levelTotal"":""0"",""hlbNum"":""0"",""locNum"":""0"",""wardNum"":""0""}"
	s firstDate=$zdh(checkMonth_"-01",3)
	s lastDate=$SYSTEM.SQL.LASTDAY(firstDate)
	s now=$e($zd(+$h,3),1,7)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	s HCount=0,LCount=0,WCount=0,total=0
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom)) q:isRandom=""  d
	.s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType)) q:taskType=""  d
	..s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType,taskId)) q:taskId=""  d
	...s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	...q:'$IsObject(taskObj)
	...q:(taskObj.TaskIsRandom'="Y")&&((firstDate>taskObj.TaskEndDate)||(lastDate<taskObj.TaskStDate))
	...q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")
	...s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	....s taskItemId=$p(taskStr,"「",2)
	....s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	.....q:(isAll'=1)&&('$d(tmpWard(taskWardId)))&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.....s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	.....i resultId'="" d
	......q:checkStatus="N"
	......s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	......q:'$IsObject(resultObj)
	......q:(taskObj.TaskIsRandom="Y")&&((resultObj.CheckDate>lastDate)||(resultObj.CheckDate<firstDate))
	......q:((checkStatus="Y")&&(resultObj.CheckStatus'="S"))||((checkStatus="S")&&(resultObj.CheckStatus="S"))
	......i taskObj.TaskLevel="W" s WCount=WCount+1
	......e  i taskObj.TaskLevel="L" s LCount=LCount+1
	......e  s HCount=HCount+1
	......s total=total+1
	.....e  d
	......q:(checkStatus="Y")||(checkStatus="S")
	......q:(taskObj.TaskIsRandom="Y")&&(checkMonth'=now)
	......i taskObj.TaskLevel="W" s WCount=WCount+1
	......e  i taskObj.TaskLevel="L" s LCount=LCount+1
	......e  s HCount=HCount+1
	......s total=total+1
	
	s ret="levelTotal|"_total_"^hlbNum|"_HCount_"^locNum|"_LCount_"^wardNum|"_WCount
	q ##class(DHCINM.WebService.INMServerUtilComm).StrToJson(ret,"^","|")
}

/// Description:获取查房单数量(按质控类型)
/// CreateDate:2020-09-22
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 检查月份 状态(A:全部,N:未检查,Y:已检查,S:已保存) 级别(A:全部,H:护理部,L:科级,W:病区)
/// Output:查房单数量(按质控类型)
/// Other:w ##class(DHCINM.WebService.INMMobileComm).GetCheckType("158","2020-09","A","A")
ClassMethod GetCheckType(loginId As %String, checkMonth As %String, checkStatus As %String, level As %String) As %String
{
	///随机检查:未检查的算到当前月份中;已检查的,算到结果的检查日期(DHCINM.CHK.MgCheckResult.CheckDate)的月份.
	///非随机检查:按照任务日期计算.
	q:(loginId="")||(checkMonth'["-") "[]"
	s firstDate=$zdh(checkMonth_"-01",3)
	s lastDate=$SYSTEM.SQL.LASTDAY(firstDate)
	s now=$e($zd(+$h,3),1,7)
	
	k tmpType
	s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," QUALTYPE",""))
	q:parId="" "[]"
	s subId="" f  s subId=$o(^CT.DHCINM.Set.MgSysParamSubD(parId,subId)) q:subId=""  d
	.s subGlo=^CT.DHCINM.Set.MgSysParamSubD(parId,subId)
	.s code=$lg(subGlo,2)
	.s desc=$lg(subGlo,3)
	.s tmpType(parId_"||"_subId,"Code")=code
	.s tmpType(parId_"||"_subId,"Desc")=desc
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	k tmpCount
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom)) q:isRandom=""  d
	.s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType)) q:taskType=""  d
	..s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType,taskId)) q:taskId=""  d
	...s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	...q:'$IsObject(taskObj)
	...q:(taskObj.TaskIsRandom'="Y")&&((firstDate>taskObj.TaskEndDate)||(lastDate<taskObj.TaskStDate))
	...q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")
	...s tLevel=taskObj.TaskLevel
	...i (taskObj.TaskType.%Id()="5||2")||(taskObj.TaskType.%Id()="5||4")||(taskObj.TaskType.%Id()="5||5") s tLevel="H"
	...q:(level'="A")&&(level'=tLevel)
	...s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	....s taskItemId=$p(taskStr,"「",2)
	....s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	.....q:(isAll'=1)&&('$d(tmpWard(taskWardId)))&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.....s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	.....i resultId'="" d
	......q:checkStatus="N"
	......s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	......q:'$IsObject(resultObj)
	......q:(taskObj.TaskIsRandom="Y")&&((resultObj.CheckDate>lastDate)||(resultObj.CheckDate<firstDate))
	......q:((checkStatus="Y")&&(resultObj.CheckStatus'="S"))||((checkStatus="S")&&(resultObj.CheckStatus="S"))
	......s tmpCount(taskType)=$g(tmpCount(taskType))+1
	.....e  d
	......q:(checkStatus="Y")||(checkStatus="S")
	......q:(taskObj.TaskIsRandom="Y")&&(checkMonth'=now)
	......s tmpCount(taskType)=$g(tmpCount(taskType))+1
	
	s ret="["
	s typeId="" f  s typeId=$o(tmpType(typeId)) q:typeId=""  d
	.q:+$g(tmpCount(typeId))=0
	.s tmpRet="{""code"":"""_$tr(typeId,"|","_")_""",""desc"":"""_tmpType(typeId,"Desc")_""",""num"":"""_+$g(tmpCount(typeId))_"""}"
	.i ret="[" s ret=ret_tmpRet
	.e  s ret=ret_","_tmpRet
	s ret=ret_"]"
	q ret
}

/// Description:获取检查单(按质控项目或病区)
/// CreateDate:2020-09-22
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 检查月份 状态(A:全部,N:未检查,Y:已检查,S:已保存) 级别(A:全部,H:护理部,L:科级,W:病区) 质控类型Id 模式(T:任务模式,W:病区模式)
/// Output:检查单(按质控项目或病区)
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindCheckForm("158","2020-09","A","A","5__1","T")
ClassMethod FindCheckForm(loginId As %String, checkMonth As %String, checkStatus As %String, level As %String, type As %String, flag As %String) As %String
{
	q:(loginId="")||(checkMonth'["-")||(checkStatus="")||(level="")||(type="")||(flag="") "{""data"":[],""total"":""0""}"
	s type=$tr(type,"_","|")
	s firstDate=$zdh(checkMonth_"-01",3)
	s lastDate=$SYSTEM.SQL.LASTDAY(firstDate)
	s now=$e($zd(+$h,3),1,7)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	k tmp
	s total=0
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom)) q:isRandom=""  d
	.s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType)) q:taskType=""  d
	..q:(type'=taskType)
	..s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType,taskId)) q:taskId=""  d
	...s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	...q:'$IsObject(taskObj)
	...q:(taskObj.TaskIsRandom'="Y")&&((firstDate>taskObj.TaskEndDate)||(lastDate<taskObj.TaskStDate))
	...q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")
	...s tLevel=taskObj.TaskLevel
	...i (taskObj.TaskType.%Id()="5||2")||(taskObj.TaskType.%Id()="5||4")||(taskObj.TaskType.%Id()="5||5") s tLevel="H"
	...q:(level'="A")&&(level'=tLevel)
	...s tLevelDesc=$case(tLevel,"W":"病","L":"科","H":"院",:"")
	...i flag="T" d
	....s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	.....s taskItemDesc=$p(taskStr,"「")
	.....s taskItemId=$p(taskStr,"「",2)
	.....s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	......q:(isAll'=1)&&('$d(tmpWard(taskWardId)))&&(taskObj.TaskCheckPerson.Find(loginId)="")
	......s taskWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(taskWardId)),4)
	......s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	......s tFlag=0
	......s status="",statusDesc=""
	......i resultId'="" d
	.......q:checkStatus="N"
	.......s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	.......q:'$IsObject(resultObj)
	.......q:(taskObj.TaskIsRandom="Y")&&((resultObj.CheckDate>lastDate)||(resultObj.CheckDate<firstDate))
	.......s status=resultObj.CheckStatus
	.......q:((checkStatus="Y")&&(status'="S"))||((checkStatus="S")&&(status'="N"))
	.......s status=$case(status,"S":"Y","N":"S",:"")
	.......s statusDesc=$case(status,"Y":"提交","S":"保存",:"")
	.......s tFlag=1
	......e  d
	.......q:(checkStatus="Y")||(checkStatus="S")
	.......q:(taskObj.TaskIsRandom="Y")&&(checkMonth'=now)
	.......s status="N",statusDesc="未检查"
	.......s tFlag=1
	......q:tFlag'=1
	......s taskRet="{""id"":"""_taskWardId_""",""desc"":"""_taskWardDesc_""",""status"":"""_status_""",""statusDesc"":"""_statusDesc_""""
	......s taskRet=taskRet_",""level"":"""_tLevel_""",""levelDesc"":"""_tLevelDesc_""",""releaseId"":"""_taskId_""",""type"":"""_$tr(taskObj.TaskType.%Id(),"|","_")_"""}"
	......s:'$d(tmp(taskItemId,"Desc")) tmp(taskItemId,"Desc")=taskItemDesc
	......s tmp(taskItemId,"Ret")=$g(tmp(taskItemId,"Ret"))_$case(+$g(tmp(taskItemId,"Count")),0:"",:",")_taskRet
	......s tmp(taskItemId,"Count")=$g(tmp(taskItemId,"Count"))+1
	......s total=total+1
	...e  d
	....s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	.....q:(isAll'=1)&&('$d(tmpWard(taskWardId)))&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.....s taskWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(taskWardId)),4)
	.....s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	......s taskItemDesc=$p(taskStr,"「")
	......s taskItemId=$p(taskStr,"「",2)
	......s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	......s tFlag=0
	......s status="",statusDesc=""
	......i resultId'="" d
	.......q:checkStatus="N"
	.......s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	.......q:'$IsObject(resultObj)
	.......q:(taskObj.TaskIsRandom="Y")&&((resultObj.CheckDate>lastDate)||(resultObj.CheckDate<firstDate))
	.......s status=resultObj.CheckStatus
	.......q:((checkStatus="Y")&&(status'="S"))||((checkStatus="S")&&(status'="N"))
	.......s status=$case(status,"S":"Y","N":"S",:"")
	.......s statusDesc=$case(status,"Y":"提交","S":"保存",:"")
	.......s tFlag=1
	......e  d
	.......q:(checkStatus="Y")||(checkStatus="S")
	.......q:(taskObj.TaskIsRandom="Y")&&(checkMonth'=now)
	.......s status="N",statusDesc="未检查"
	.......s tFlag=1
	......q:tFlag'=1
	......s wardRet="{""id"":"""_taskItemId_""",""desc"":"""_taskItemDesc_""",""status"":"""_status_""",""statusDesc"":"""_statusDesc_""""
	......s wardRet=wardRet_",""level"":"""_tLevel_""",""levelDesc"":"""_tLevelDesc_""",""releaseId"":"""_taskId_""",""type"":"""_$tr(taskObj.TaskType.%Id(),"|","_")_"""}"
	......s:'$d(tmp(taskWardId,"Desc")) tmp(taskWardId,"Desc")=taskWardDesc
	......s tmp(taskWardId,"Ret")=$g(tmp(taskWardId,"Ret"))_$case(+$g(tmp(taskWardId,"Count")),0:"",:",")_wardRet
	......s tmp(taskWardId,"Count")=$g(tmp(taskWardId,"Count"))+1
	......s total=total+1
	
	i total=0 s ret="{""data"":[],""total"":""0""}"
	e  d
	.s tCount=0
	.s ret="{""data"":["
	.s id="" f  s id=$o(tmp(id)) q:id=""  d
	..s ret=ret_$case(tCount,0:"",:",")_"{""id"":"""_$tr(id,"|","_")_""",""desc"":"""_tmp(id,"Desc")_""",""wardItems"":["_tmp(id,"Ret")_"]}"
	..s tCount=tCount+1
	.s ret=ret_"],""total"":"""_total_"""}"
	
	q ret
}

/// Description:获取检查单(按日期)
/// CreateDate:2020-09-23
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 检查月份 质控类型Id
/// Output:检查单(按日期)
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindCheckDateList("158","2020-09","5__1^5__2")
ClassMethod FindCheckDateList(loginId As %String, checkMonth As %String, type As %String) As %String
{
	q:(loginId="")||(checkMonth'["-") "{""data"":[],""total"":""0""}"
	s type=$tr(type,"_","|")
	s typeList=$lfs(type,"^")
	s firstDate=$zdh(checkMonth_"-01",3)
	s firstWeekDay=$zd(firstDate,10)
	s diff=firstWeekDay+6#7
	s firstDate=firstDate-diff
	s lastDate=firstDate+41
	s now=$e($zd(+$h,3),1,7)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	s tmpColor("NIGHTCHECK")="#e54d42"
	s tmpColor("WEEKCHECK")="#39b54a"
	s tmpColor("HOLIDAYCHECK")="#0081ff"
	s tmpColor("QUALCHECK")="#e03997"
	s tmpColor("SPECIALCHECK")="#8799a3"
	s tmpColor("DEPTCHECK")="#ffff00"
	s tmpColor("MASTERCHECK")="#24998d"
	s tmpColor("QUARTERCHECK")="#333399"
	
	k tmp
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom)) q:isRandom=""  d
	.i isRandom=" Y" d
	..s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType)) q:taskType=""  d
	...q:(type'="")&&($lf(typeList,taskType)=0)
	...s taskTypeCode="",taskTypeDesc="",taskTypeColor=""
	...s taskTypeObj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(taskType)
	...s:$IsObject(taskTypeObj) taskTypeCode=$zcvt(taskTypeObj.SubCode,"U"),taskTypeDesc=taskTypeObj.SubDesc,taskTypeColor=taskTypeObj.SubColor
	...s:taskTypeColor="" taskTypeColor=$g(tmpColor(taskTypeCode))
	...s taskStDate="" f  s taskStDate=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate)) q:taskStDate=""  d
	....s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate,taskId)) q:taskId=""  d
	.....s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	.....q:'$IsObject(taskObj)
	.....q:taskObj.TaskStatus'="Y"
	.....q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.....s taskLevelDesc=$case(taskObj.TaskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	.....s taskCheckerName="",taskCheckerIndex=0
	.....s checkerKey="" f  s checkerId=taskObj.TaskCheckPerson.GetNext(.checkerKey) q:checkerKey=""  d
	......s perName=""
	......s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(checkerId)
	......s:$IsObject(perObj) perName=perObj.PerName
	......s taskCheckerName=taskCheckerName_$case(taskCheckerIndex,0:"",:",")_perName
	......s taskCheckerIndex=taskCheckerIndex+1
	.....s taskWardDesc="",taskWardIndex=0,wardChecerFlag=0,realTaskWardID=""
	.....s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	......s wardDesc="",realTaskWardID=taskWardId
	......s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(taskWardId)
	......s:$IsObject(wardObj) wardDesc=wardObj.WardDesc
	......s taskWardDesc=taskWardDesc_$case(taskWardIndex,0:"",:",")_wardDesc
	......s taskWardIndex=taskWardIndex+1
	......s:(isAll=1)||($d(tmpWard(taskWardId))) wardChecerFlag=1
	.....q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()=0)&&(wardChecerFlag'=1)
	.....s taskItemStr=taskObj.TaskItem.GetAt(1)
	.....s taskItemDesc=$p(taskItemStr,"「")
	.....s taskItemId=$p(taskItemStr,"「",2)
	.....s taskCheckDate=""
	.....s flag=0
	.....s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,realTaskWardID,""))
	.....i resultId'="" d
	......s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	......q:'$IsObject(resultObj)
	......q:(resultObj.CheckDate>lastDate)||(resultObj.CheckDate<firstDate)
	......s taskCheckDate=$zd(resultObj.CheckDate,3)
	......s flag=1
	.....e  d
	......q:checkMonth'=now
	......s taskCheckDate=now_"-01"
	......s flag=1
	.....q:flag'=1
	.....s taskRet="{""typeDesc"":"""_taskTypeDesc_""",""levelDesc"":"""_taskLevelDesc_""",""checkPerName"":"""_taskCheckerName_""",""checkTime"":"""""
	.....s taskRet=taskRet_",""checkWard"":"""_taskWardDesc_""",""checkItem"":"""_taskItemDesc_"""}"
	.....s taskCheckDate=$zdh(taskCheckDate,3)
	.....s:'$d(tmp(taskCheckDate,taskType,"Desc")) tmp(taskCheckDate,taskType,"Desc")=taskTypeDesc
	.....s:'$d(tmp(taskCheckDate,taskType,"Color")) tmp(taskCheckDate,taskType,"Color")=taskTypeColor
	.....s tmp(taskCheckDate,taskType)=$g(tmp(taskCheckDate,taskType))_$case(+$g(tmp(taskCheckDate,taskType,"Count")),0:"",:",")_taskRet
	.....s tmp(taskCheckDate,taskType,"Count")=$g(tmp(taskCheckDate,taskType,"Count"))+1
	.e  d
	..s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType)) q:taskType=""  d
	...q:(type'="")&&($lf(typeList,taskType)=0)
	...s taskTypeCode="",taskTypeDesc="",taskTypeColor=""
	...s taskTypeObj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(taskType)
	...s:$IsObject(taskTypeObj) taskTypeCode=$zcvt(taskTypeObj.SubCode,"U"),taskTypeDesc=taskTypeObj.SubDesc,taskTypeColor=taskTypeObj.SubColor
	...s:taskTypeColor="" taskTypeColor=$g(tmpColor(taskTypeCode))
	...s taskStDate=firstDate-1 f  s taskStDate=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate)) q:(taskStDate="")||(taskStDate>lastDate)  d
	....s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate,taskId)) q:taskId=""  d
	.....s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	.....q:'$IsObject(taskObj)
	.....q:taskObj.TaskStatus'="Y"
	.....q:(firstDate>taskObj.TaskEndDate)||(lastDate<taskObj.TaskStDate)
	.....q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.....s taskLevelDesc=$case(taskObj.TaskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	.....s taskCheckerName="",taskCheckerIndex=0
	.....s checkerKey="" f  s checkerId=taskObj.TaskCheckPerson.GetNext(.checkerKey) q:checkerKey=""  d
	......s perName=""
	......s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(checkerId)
	......s:$IsObject(perObj) perName=perObj.PerName
	......s taskCheckerName=taskCheckerName_$case(taskCheckerIndex,0:"",:",")_perName
	......s taskCheckerIndex=taskCheckerIndex+1
	.....s taskWardDesc="",taskWardIndex=0,wardChecerFlag=0
	.....s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	......s wardDesc=""
	......s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(taskWardId)
	......s:$IsObject(wardObj) wardDesc=wardObj.WardDesc
	......s taskWardDesc=taskWardDesc_$case(taskWardIndex,0:"",:",")_wardDesc
	......s taskWardIndex=taskWardIndex+1
	......s:(isAll=1)||($d(tmpWard(taskWardId))) wardChecerFlag=1
	.....q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()=0)&&(wardChecerFlag'=1)
	.....s taskItemDesc="",taskItemIndex=0
	.....s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	......s itemDesc=$p(taskStr,"「")
	......s taskItemDesc=taskItemDesc_$case(taskItemIndex,0:"",:",")_itemDesc
	......s taskItemIndex=taskItemIndex+1
	.....s taskCheckDate=$zd(taskStDate,3)_$select($lf($lb("NIGHTCHECK","WEEKCHECK","HOLIDAYCHECK"),taskTypeCode)=0:"至"_$zd(taskObj.TaskEndDate,3),1:"")
	.....s taskRet="{""typeDesc"":"""_taskTypeDesc_""",""levelDesc"":"""_taskLevelDesc_""",""checkPerName"":"""_taskCheckerName_""",""checkTime"":"""_taskCheckDate_""""
	.....s taskRet=taskRet_",""checkWard"":"""_taskWardDesc_""",""checkItem"":"""_taskItemDesc_"""}"
	.....s:'$d(tmp(taskStDate,taskType,"Desc")) tmp(taskStDate,taskType,"Desc")=taskTypeDesc
	.....s:'$d(tmp(taskStDate,taskType,"Color")) tmp(taskStDate,taskType,"Color")=taskTypeColor
	.....s tmp(taskStDate,taskType)=$g(tmp(taskStDate,taskType))_$case(+$g(tmp(taskStDate,taskType,"Count")),0:"",:",")_taskRet
	.....s tmp(taskStDate,taskType,"Count")=$g(tmp(taskStDate,taskType,"Count"))+1
	
	s ret="{""data"":["
	f outDate=firstDate:1:lastDate d
	.s dayRet="{""date"":"""_$zd(outDate,3)_""",""types"":["
	.s tCount=0
	.s typeId="" f  s typeId=$o(tmp(outDate,typeId)) q:typeId=""  d
	..s dayRet=dayRet_$case(tCount,0:"",:",")_"{""color"":"""_tmp(outDate,typeId,"Color")_""",""typeDesc"":"""_tmp(outDate,typeId,"Desc")_""",""id"":"""_typeId_""",""items"":["_tmp(outDate,typeId)_"]}"
	..s tCount=tCount+1
	.s dayRet=dayRet_"]}"
	.s ret=ret_$case(outDate,firstDate:"",:",")_dayRet
	s ret=ret_"],""total"":"""_(lastDate-firstDate+1)_"""}"
	
	q ret
}

/// Description:获取全部质控类型
/// Date:2020-09-23
/// Creator:wangpf
/// Table:CT.DHCINM.Set.MgSysParam CT.DHCINM.Set.MgSysParamSub
/// Input:
/// Output:全部质控类型
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindCheckTypeList()
ClassMethod FindCheckTypeList(loginId As %String, checkMonth As %String) As %String
{
	s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," QUALTYPE",""))
	q:parId="" "{""data"":[],""total"":""0""}"
	
	s tmpColor("NIGHTCHECK")="#e54d42"
	s tmpColor("WEEKCHECK")="#39b54a"
	s tmpColor("HOLIDAYCHECK")="#0081ff"
	s tmpColor("QUALCHECK")="#e03997"
	s tmpColor("SPECIALCHECK")="#8799a3"
	s tmpColor("DEPTCHECK")="#ffff00"
	s tmpColor("MASTERCHECK")="#24998d"
	s tmpColor("QUARTERCHECK")="#333399"
	
	s ret="{""data"":[",total=0,now=+$h
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",parId,sort)) q:sort=""  d
	.s subId="" f  s subId=$o(^CT.DHCINM.Set.MgSysParamSubI("Sort",parId,sort,subId)) q:subId=""  d
	..s subGlo=^CT.DHCINM.Set.MgSysParamSubD(parId,subId)
	..s stDate=$lg(subGlo,8)
	..s endDate=$lg(subGlo,9)
	..q:(stDate>now)||((endDate'="")&&(endDate<now))
	..s code=$zcvt($lg(subGlo,2),"U")
	..s desc=$lg(subGlo,3)
	..s color=$lg(subGlo,6)
	..s:color="" color=$g(tmpColor(code))
	..s typeRet="{""id"":"""_parId_"__"_subId_""",""desc"":"""_desc_""",""color"":"""_color_"""}"
	..s ret=ret_$case(total,0:"",:",")_typeRet
	..s total=total+1
	s ret=ret_"],""total"":"""_total_"""}"
	
	q ret
}

/// Description:获取指定日期之间的质控检查项目
/// Date:2020-09-23
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 质控类型Id 开始日期 结束日期
/// Output:指定日期之间的质控检查项目
/// Other:w ##class(DHCINM.WebService.INMMobileComm).GetCheckProject(0,"5__2","2020-08-01","2022-08-31")
ClassMethod GetCheckProject(loginId As %String, checkTypeI As %String, startDate As %String, endDate As %String) As %String
{
	s ^TMP("GetCheckProject")=loginId_","_checkTypeI_","_startDate_","_endDate
	q:(loginId="")||(startDate'["-")||(endDate'["-") "{""data"":[],""total"":""0""}"
	
	s checkTypeI=$tr($tr(checkTypeI,$c(0),""),"_","|")
	s ^TMP("GetCheckProject2")=loginId_","_checkTypeI_","_startDate_","_endDate
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
	k tmpMonth
	f date=startDate:1:endDate d
	.s month=$e($zd(date,3),1,7)
	.s:'$d(tmpMonth(month)) tmpMonth(month)=1
	s now=$e($zd(+$h,3),1,7)
	i $d(tmpMonth(now)) s flag=1
	e  s flag=0
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	k tmp
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom)) q:isRandom=""  d
	.i isRandom=" Y" d
	..s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType)) q:taskType=""  d
	...q:(checkTypeI'="")&&(checkTypeI'=taskType)
	...s taskStDate="" f  s taskStDate=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate)) q:taskStDate=""  d
	....s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate,taskId)) q:taskId=""  d
	.....s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	.....q:'$IsObject(taskObj)
	.....q:taskObj.TaskStatus'="Y"
	.....q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.....s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	......s taskItemDesc=$p(taskStr,"「")
	......s taskItemId=$p(taskStr,"「",2)
	......s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	.......q:(isAll'=1)&&('$d(tmpWard(taskWardId)))&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.......s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	.......i resultId'="" d
	........s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	........q:'$IsObject(resultObj)
	........q:(resultObj.CheckDate>endDate)||(resultObj.CheckDate<startDate)
	........s:'$d(tmp(taskItemId)) tmp(taskItemId)=taskItemDesc
	.......e  d
	........q:flag'=1
	........s:'$d(tmp(taskItemId)) tmp(taskItemId)=taskItemDesc
	.e  d
	..s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType)) q:taskType=""  d
	...q:(checkTypeI'="")&&(checkTypeI'=taskType)
	...s taskStDate=startDate-1 f  s taskStDate=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate)) q:(taskStDate="")||(taskStDate>endDate)  d
	....s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate,taskId)) q:taskId=""  d
	.....s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	.....q:'$IsObject(taskObj)
	.....q:taskObj.TaskStatus'="Y"
	.....q:(startDate>taskObj.TaskEndDate)||(endDate<taskObj.TaskStDate)
	.....q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.....s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	......s taskItemDesc=$p(taskStr,"「")
	......s taskItemId=$p(taskStr,"「",2)
	......s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	.......q:(isAll'=1)&&('$d(tmpWard(taskWardId)))&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.......s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	.......i resultId'="" d
	........s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	........q:'$IsObject(resultObj)
	........q:(resultObj.CheckDate>endDate)||(resultObj.CheckDate<startDate)
	........s:'$d(tmp(taskItemId)) tmp(taskItemId)=taskItemDesc
	.......e  d
	........s:'$d(tmp(taskItemId)) tmp(taskItemId)=taskItemDesc
	
	s ret="{""data"":[",total=0
	s itemId="" f  s itemId=$o(tmp(itemId)) q:itemId=""  d
	.s itemRet="{""QualId"":"""_itemId_""",""QualDesc"":"""_tmp(itemId)_"""}"
	.s ret=ret_$case(total,0:"",:",")_itemRet
	.s total=total+1
	s ret=ret_"],""total"":"""_total_"""}"
	
	q ret
}

/// Description:获取指定日期之间的质控检查病区
/// Date:2020-09-23
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 质控类型Id 开始日期 结束日期
/// Output:质控检查病区
/// Other:w ##class(DHCINM.WebService.INMMobileComm).GetCheckWard(0,"5__1","2020-08-01","2020-08-31")
ClassMethod GetCheckWard(loginId As %String, checkTypeI As %String, startDate As %String, endDate As %String) As %String
{
	q:(loginId="")||(startDate'["-")||(endDate'["-") "{""data"":[],""total"":""0""}"
	
	s checkTypeI=$tr(checkTypeI,"_","|")
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
	k tmpMonth
	f date=startDate:1:endDate d
	.s month=$e($zd(date,3),1,7)
	.s:'$d(tmpMonth(month)) tmpMonth(month)=1
	s now=$e($zd(+$h,3),1,7)
	i $d(tmpMonth(now)) s flag=1
	e  s flag=0
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	k tmp
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom)) q:isRandom=""  d
	.i isRandom=" Y" d
	..s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType)) q:taskType=""  d
	...q:(checkTypeI'="")&&(checkTypeI'=taskType)
	...s taskStDate="" f  s taskStDate=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate)) q:taskStDate=""  d
	....s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate,taskId)) q:taskId=""  d
	.....s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	.....q:'$IsObject(taskObj)
	.....q:taskObj.TaskStatus'="Y"
	.....q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.....s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	......s taskItemId=$p(taskStr,"「",2)
	......s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	.......q:(isAll'=1)&&('$d(tmpWard(taskWardId)))&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.......s taskWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(taskWardId)),4)
	.......s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	.......i resultId'="" d
	........s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	........q:'$IsObject(resultObj)
	........q:(resultObj.CheckDate>endDate)||(resultObj.CheckDate<startDate)
	........s:'$d(tmp(taskWardId)) tmp(taskWardId)=taskWardDesc
	.......e  d
	........q:flag'=1
	........s:'$d(tmp(taskWardId)) tmp(taskWardId)=taskWardDesc
	.e  d
	..s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType)) q:taskType=""  d
	...q:(checkTypeI'="")&&(checkTypeI'=taskType)
	...s taskStDate=startDate-1 f  s taskStDate=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate)) q:(taskStDate="")||(taskStDate>endDate)  d
	....s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate,taskId)) q:taskId=""  d
	.....s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	.....q:'$IsObject(taskObj)
	.....q:taskObj.TaskStatus'="Y"
	.....q:(startDate>taskObj.TaskEndDate)||(endDate<taskObj.TaskStDate)
	.....q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.....s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	......s taskItemId=$p(taskStr,"「",2)
	......s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	.......q:(isAll'=1)&&('$d(tmpWard(taskWardId)))&&(taskObj.TaskCheckPerson.Find(loginId)="")
	.......s taskWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(taskWardId)),4)
	.......s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	.......i resultId'="" d
	........s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	........q:'$IsObject(resultObj)
	........q:(resultObj.CheckDate>endDate)||(resultObj.CheckDate<startDate)
	........s:'$d(tmp(taskWardId)) tmp(taskWardId)=taskWardDesc
	.......e  d
	........s:'$d(tmp(taskWardId)) tmp(taskWardId)=taskWardDesc
	
	s ret="{""data"":[",total=0
	s wardId="" f  s wardId=$o(tmp(wardId)) q:wardId=""  d
	.s itemRet="{""WardID"":"""_wardId_""",""WardDesc"":"""_tmp(wardId)_"""}"
	.s ret=ret_$case(total,0:"",:",")_itemRet
	.s total=total+1
	s ret=ret_"],""total"":"""_total_"""}"
	
	q ret
}

/// Description:获取指定日期之间的质控检查类型及数量
/// Date:2020-09-23
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 质控类型Id 开始日期 结束日期 类型(S:按管辖病区,L:按检查人)
/// Output:指定日期之间的质控检查类型及数量
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindCheckTypeListByDate(0,"2020-08-01","2020-08-31","S")
ClassMethod FindCheckTypeListByDate(loginId As %String, startDate As %String, endDate As %String, flag As %String) As %String
{
	///未检查:随机检查,算到当前月份中;其他检查,按检查任务的开始、结束日期计算.
	///已检查:算到结果的检查日期(DHCINM.CHK.MgCheckResult.CheckDate)的月份.
	///按检查人:未指定检查人时,该病区人员都视为检查人
	q:(loginId="")||(startDate'["-")||(endDate'["-")||(flag="") "{""data"":[],""total"":""0""}"
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
	k tmpMonth
	f date=startDate:1:endDate d
	.s month=$e($zd(date,3),1,7)
	.s:'$d(tmpMonth(month)) tmpMonth(month)=1
	s now=$e($zd(+$h,3),1,7)
	i $d(tmpMonth(now)) s tFlag=1
	e  s tFlag=0
	
	s tmpColor("NIGHTCHECK")="#e54d42"
	s tmpColor("WEEKCHECK")="#39b54a"
	s tmpColor("HOLIDAYCHECK")="#0081ff"
	s tmpColor("QUALCHECK")="#e03997"
	s tmpColor("SPECIALCHECK")="#8799a3"
	s tmpColor("DEPTCHECK")="#ffff00"
	s tmpColor("MASTERCHECK")="#24998d"
	s tmpColor("QUARTERCHECK")="#333399"
	
	k tmpType
	s now=+$h
	s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," QUALTYPE",""))
	q:parId="" "{""data"":[],""total"":""0""}"
	s subId="" f  s subId=$o(^CT.DHCINM.Set.MgSysParamSubD(parId,subId)) q:subId=""  d
	.s subGlo=^CT.DHCINM.Set.MgSysParamSubD(parId,subId)
	.s typeStDate=$lg(subGlo,8)
	.s typeEndDate=$lg(subGlo,9)
	.q:(typeStDate>now)||((typeEndDate'="")&&(typeEndDate<now))
	.s code=$zcvt($lg(subGlo,2),"U")
	.s desc=$lg(subGlo,3)
	.s color=$lg(subGlo,6)
	.s:color="" color=$g(tmpColor(code))
	.s tmpType(parId_"||"_subId,"Desc")=desc
	.s tmpType(parId_"||"_subId,"Color")=color
	
	k tmpWard
	s isAll= ##class(DHCINM.WebService.INMServerUtilComm).SetRoleWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom)) q:isRandom=""  d
	.s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType)) q:taskType=""  d
	..s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType,taskId)) q:taskId=""  d
	...s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	...q:'$IsObject(taskObj)
	...q:(taskObj.TaskIsRandom'="Y")&&((startDate>taskObj.TaskEndDate)||(endDate<taskObj.TaskStDate))
	...q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")&&(flag="L")
	...s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	....s taskItemId=$p(taskStr,"「",2)
	....s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	.....q:(loginId'=0)&&(((taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)=""))||((taskObj.TaskCheckPerson.Count()=0)&&('$d(tmpWard(taskWardId)))))&&((flag="L")||(flag=""))
	.....q:('$d(tmpWard(taskWardId)))&&(flag="S")
	.....s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	.....i resultId'="" d
	......s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	......q:'$IsObject(resultObj)
	......q:(taskObj.TaskIsRandom="Y")&&(resultObj.CheckDate>endDate)||(resultObj.CheckDate<startDate)
	......i resultObj.CheckStatus="S" s tmp(taskType,"Checked")=$g(tmp(taskType,"Checked"))+1
	......e  s tmp(taskType,"UnFinishCheck")=$g(tmp(taskType,"UnFinishCheck"))+1
	......i taskObj.TaskLevel="W" s tmp(taskType,"W")=$g(tmp(taskType,"W"))+1
	......e  i taskObj.TaskLevel="L" s tmp(taskType,"L")=$g(tmp(taskType,"L"))+1
	......e  s tmp(taskType,"H")=$g(tmp(taskType,"H"))+1
	......s tmp(taskType,"Total")=$g(tmp(taskType,"Total"))+1
	.....e  d
	......q:(taskObj.TaskIsRandom="Y")&&(tFlag'=1)
	......s tmp(taskType,"ToCheck")=$g(tmp(taskType,"ToCheck"))+1
	......i taskObj.TaskLevel="W" s tmp(taskType,"W")=$g(tmp(taskType,"W"))+1
	......e  i taskObj.TaskLevel="L" s tmp(taskType,"L")=$g(tmp(taskType,"L"))+1
	......e  s tmp(taskType,"H")=$g(tmp(taskType,"H"))+1
	......s tmp(taskType,"Total")=$g(tmp(taskType,"Total"))+1
	
	s ret="{""data"":[",total=0
	s typeId="" f  s typeId=$o(tmpType(typeId)) q:typeId=""  d
	.s itemRet="{""cid"":"""_$tr(typeId,"|","_")_""",""cdesc"":"""_tmpType(typeId,"Desc")_""",""cnum"":"""_+$g(tmp(typeId,"Total"))_""""
	.s itemRet=itemRet_",""color"":"""_tmpType(typeId,"Color")_""",""Hdesc"":""护理部"",""Hnum"":"""_+$g(tmp(typeId,"H"))_""""
	.s itemRet=itemRet_",""Ldesc"":""科室"",""Lnum"":"""_+$g(tmp(typeId,"L"))_""",""Wdesc"":""病区"",""Wnum"":"""_+$g(tmp(typeId,"W"))_""""
	.s itemRet=itemRet_",""Ndesc"":""未检查"",""Nnum"":"""_+$g(tmp(typeId,"ToCheck"))_""",""Sdesc"":""已保存"",""Snum"":"""_+$g(tmp(typeId,"UnFinishCheck"))_""""
	.s itemRet=itemRet_",""Ydesc"":""已检查"",""Ynum"":"""_+$g(tmp(typeId,"Checked"))_"""}"
	.s ret=ret_$case(total,0:"",:",")_itemRet
	.s total=total+1
	s ret=ret_"],""total"":"""_total_"""}"
	
	q ret
}

/// Description:获取指定日期之间的检查单
/// Date:2020-09-24
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 开始日期 结束日期 质控类型Id 状态(空:全部,N:未检查,Y:已检查,S:已保存) 级别(空:全部,H:护理部,L:科级,W:病区) 质控项目Id 病区Id 类型(S:按管辖病区,L:按检查人)
/// Output:指定日期之间的检查单
/// Other:d ##class(%ResultSet).RunQuery("DHCINM.WebService.INMMobileComm","FindCheckItemListByType",0,"2020-08-01","2020-09-30","5__2","","","","","")
Query FindCheckItemListByType(loginId As %String, startDate As %String, endDate As %String, type As %String, checkstatus As %String, checklevel As %String, checkitem As %String, checkward As %String, flag As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckItemListByTypeExecute(ByRef qHandle As %Binary, loginId As %String, startDate As %String, endDate As %String, type As %String, checkstatus As %String, checklevel As %String, checkitem As %String, checkward As %String, flag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (loginId="")||(startDate'["-")||(endDate'["-")||(type=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s type=$tr(type,"_","|")
	
	k tmpMonth
	f date=startDate:1:endDate d
	.s month=$e($zd(date,3),1,7)
	.s:'$d(tmpMonth(month)) tmpMonth(month)=1
	s now=$e($zd(+$h,3),1,7)
	i $d(tmpMonth(now)) s tFlag=1
	e  s tFlag=0
	
	k tmpWard
	s isAll=##class(DHCINM.WebService.INMServerUtilComm).SetRoleWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom)) q:isRandom=""  d
	.s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType)) q:taskType=""  d
	..q:type'=taskType
	..s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("Status",isRandom," Y",taskType,taskId)) q:taskId=""  d
	...s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	...q:'$IsObject(taskObj)
	...q:(taskObj.TaskIsRandom'="Y")&&((startDate>taskObj.TaskEndDate)||(endDate<taskObj.TaskStDate))
	...q:(loginId'=0)&&(taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)="")&&((flag="L")||(flag=""))
	...s TaskLevel=taskObj.TaskLevel
	...s taskLevelDesc=$case(taskObj.TaskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	...i (taskObj.TaskType.%Id()="5||2")||(taskObj.TaskType.%Id()="5||4")||(taskObj.TaskType.%Id()="5||5") s taskLevelDesc="护理部",TaskLevel="H"
	...q:(checklevel'="")&&(checklevel'=TaskLevel)
	...s taskCheckerId="",taskCheckerName="",taskCheckerIndex=0
	...s checkerKey="" f  s checkerId=taskObj.TaskCheckPerson.GetNext(.checkerKey) q:checkerKey=""  d
	....s perName=""
	....s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(checkerId)
	....s:$IsObject(perObj) perName=perObj.PerName
	....s taskCheckerId=taskCheckerId_$case(taskCheckerIndex,0:"",:",")_checkerId
	....s taskCheckerName=taskCheckerName_$case(taskCheckerIndex,0:"",:",")_perName
	....s taskCheckerIndex=taskCheckerIndex+1
	...s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:itemKey=""  d
	....s taskItemDesc=$p(taskStr,"「")
	....s taskItemId=$p(taskStr,"「",2)
	....q:(checkitem'="")&&(checkitem'=taskItemId)
	....s wardKey="" f  s taskWardId=taskObj.TaskCheckWard.GetNext(.wardKey) q:wardKey=""  d
	.....q:(checkward'="")&&(checkward'=taskWardId)
	.....q:(loginId'=0)&&(((taskObj.TaskCheckPerson.Count()>0)&&(taskObj.TaskCheckPerson.Find(loginId)=""))||((taskObj.TaskCheckPerson.Count()=0)&&('$d(tmpWard(taskWardId)))))&&((flag="L")||(flag=""))
	.....q:('$d(tmpWard(taskWardId)))&&(flag="S")
	.....s taskWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(taskWardId)),4)
	.....s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWardId,""))
	.....i resultId'="" d
	......q:checkstatus="N"
	......s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	......q:'$IsObject(resultObj)
	......q:(taskObj.TaskIsRandom="Y")&&((resultObj.CheckDate>endDate)||(resultObj.CheckDate<startDate))
	......q:((checkstatus="Y")&&(resultObj.CheckStatus'="S"))||((checkstatus="S")&&(resultObj.CheckStatus="S"))
	......s taskStatusDesc=$case(resultObj.CheckStatus,"S":"已检查","N":"已保存",:"")
	......s ret="Type|"_$tr(taskType,"|","_")_"^TaskId|"_taskId_"^Status|"_taskStatusDesc_"^Level|"_taskLevelDesc
	......s ret=ret_"^CheckItemDesc|"_taskItemDesc_"^CheckWardDesc|"_taskWardDesc_"^CheckScore|"_resultObj.CheckScore
	......s ret=ret_"^Checker|"_taskCheckerName_"^CheckDate|"_$zd(resultObj.CheckDate,3)_"^WardId|"_taskWardId_"^CheckItemId|"_taskItemId
	......s ret=ret_"^CheckId|"_taskCheckerId
	......d OutCheckList
	.....e  d
	......q:(checkstatus="Y")||(checkstatus="S")
	......q:(taskObj.TaskIsRandom="Y")&&(tFlag'=1)
	......s ret="Type|"_$tr(taskType,"|","_")_"^TaskId|"_taskId_"^Status|未检查^Level|"_taskLevelDesc
	......s ret=ret_"^CheckItemDesc|"_taskItemDesc_"^CheckWardDesc|"_taskWardDesc_"^CheckScore|^Checker|"_taskCheckerName
	......s ret=ret_"^CheckDate|^WardId|"_taskWardId_"^CheckItemId|"_taskItemId_"^CheckId|"_taskCheckerId
	......d OutCheckList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckItemListByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckItemListByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckItemListByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckItemListByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:获取检查单内容
/// Date:2020-09-25
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 质控任务Id 质控项目Id 质控类型Id 病区Id
/// Output:检查单内容
/// Other:w ##class(DHCINM.WebService.INMMobileComm).GetCheckScoreForm(0,4,1,"5__2",1)
ClassMethod GetCheckScoreForm(loginId As %String, releaseId As %String, qualId As %String, type As %String, wardId As %String) As %String
{
	q:(loginId="")||(releaseId="")||(qualId="")||(type="")||(wardId="") "{""status"":""1"",""msg"":""参数错误"",""data"":""""}"
	s type=$tr(type,"_","|")
	
	s typeCode=""
	s typeObj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(type)
	s typeCode=$zcvt(typeObj.SubCode,"U")
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(releaseId)
	q:'$IsObject(taskObj) "{""status"":""1"",""msg"":""任务不存在"",""data"":""""}"
	s taskStDate=taskObj.TaskStDate
	s:taskStDate'="" taskStDate=$zd(taskStDate,3)
	s taskEndDate=taskObj.TaskEndDate
	s:taskEndDate'="" taskEndDate=$zd(taskEndDate,3)
	s taskDate=""
	s:taskObj.TaskIsRandom'="Y" taskDate=taskStDate_$select($lf($lb("NIGHTCHECK","WEEKCHECK","HOLIDAYCHECK"),typeCode)=0:"至"_$zd(taskObj.TaskEndDate,3),1:"")
	s flag=0,taskItemDesc=""
	s itemKey="" f  s taskStr=taskObj.TaskItem.GetNext(.itemKey) q:(flag=1)||(itemKey="")  d
	.s taskItemDesc=$p(taskStr,"「")
	.s taskItemId=$p(taskStr,"「",2)
	.q:qualId'=taskItemId
	.s flag=1
	s taskCheckerId="",taskCheckerName="",taskCheckerIndex=0
	s checkerKey="" f  s checkerId=taskObj.TaskCheckPerson.GetNext(.checkerKey) q:checkerKey=""  d
	.s perName=""
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(checkerId)
	.s:$IsObject(perObj) perName=perObj.PerName
	.s taskCheckerId=taskCheckerId_$case(taskCheckerIndex,0:"",:",")_checkerId
	.s taskCheckerName=taskCheckerName_$case(taskCheckerIndex,0:"",:",")_perName
	.s taskCheckerIndex=taskCheckerIndex+1
	s checkFlag=0
	s:taskObj.TaskCheckPerson.Find(loginId)'="" checkFlag=1
	s:(taskObj.TaskCheckPerson.Count()=0)&&((isAll=1)||($d(tmpWard(wardId)))) checkFlag=1
	
	s taskWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(wardId)),4)
	
	s checkPat="",checkSerPat="",checkResPat="",checkNightNur=""
	s basicId=$o(^DHCINM.CHK.MgNurNightBasicI("Ward",releaseId,wardId,""))
	i basicId'="" d
	.s basicObj=##class(DHCINM.CHK.MgNurNightBasic).%OpenId(basicId)
	.s checkPat=basicObj.CheckPat
	.s checkSerPat=basicObj.CheckSerPat
	.s checkResPat=basicObj.CheckResPat
	.s checkNightNur=basicObj.CheckNightNur
	
	s now=+$h,resultCheckDate=+$h,taskHeadNur="",resultFocus=0,scoreType="",scoreTypeSub="",status="",statusDesc="",remark="",checkScore=""
	s qualInsertCount=0,qualInsert="[]",qualInsertPat="[]",qualInsertNur="[]",qualInsertInput="[]",resultUser="",resultUserName=""
	s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",releaseId,qualId,wardId,""))
	i resultId="" d
	.s status="N",statusDesc="未检查"
	.k @"tmp"
	.q:$d(^CT.DHCINM.DB.MgQualItemD(qualId))#2'=1
	.s qualGlo=^CT.DHCINM.DB.MgQualItemD(qualId)
	.s qualStDate=$lg(qualGlo,14)
	.s qualEndDate=$lg(qualGlo,15)
	.q:(qualStDate>now)||((qualEndDate'="")&&(qualEndDate<now))
	.k tmpQualItemInfo
	.s tmpQualItemInfo=##class(web.INMDBComm).GetQualItem(qualId)
	.d ##class(web.INMVueComm).SplitStr(tmpQualItemInfo,"^","|",.tmpQualItemInfo)
	.s qualScoreType=$g(tmpQualItemInfo("QualScoreType"))
	.s qualScoreTypeSub=$g(tmpQualItemInfo("QualScoreTypeSub"))
	.s qualStandardMode=$g(tmpQualItemInfo("QualStandardMode"))
	.s scoreType=qualScoreType,scoreTypeSub=qualScoreTypeSub
	.s qualInsertCount=$g(tmpQualItemInfo("QualInsertCount"))
	.s qualInsert=$g(tmpQualItemInfo("QualInsert"))
	.i qualInsert="" s qualInsert="[]",qualInsertPat="[]",qualInsertNur="[]",qualInsertInput="[]"
	.e  d
	..s qualInsertList=$lfs(qualInsert)
	..s qualInsert="["_qualInsert_"]"
	..s tmpString=""
	..f tmpI=1:1:qualInsertCount d
	...i tmpString="" s tmpString=""""""
	...e  s tmpString=tmpString_","""""
	..i $lf(qualInsertList,1)>0 s qualInsertPat="["_tmpString_"]"
	..e  s qualInsertPat="[]"
	..i $lf(qualInsertList,2)>0 s qualInsertNur="["_tmpString_"]"
	..e  s qualInsertNur="[]"
	..i $lf(qualInsertList,3)>0 s qualInsertInput="["_tmpString_"]"
	..e  s qualInsertInput="[]"
	.s CheckScoreFlag=$g(tmpQualItemInfo("QualScoreFlag"))
	.s CheckScoreDeAll=0
	.k tmpLeaf,@"tmpAll"
	.s subId="" f  s subId=$o(^CT.DHCINM.DB.MgQualItemSubI("parr",qualId,subId)) q:subId=""  d
	..q:'$d(^CT.DHCINM.DB.MgQualItemSubD(qualId,subId))
	..s qualSubGlo=^CT.DHCINM.DB.MgQualItemSubD(qualId,subId)
	..s qualSubStDate=$lg(qualSubGlo,7)
	..s qualSubEndDate=$lg(qualSubGlo,8)
	..q:(qualSubStDate>now)||((qualSubEndDate'="")&&(qualSubEndDate<now))
	..s qualSubSort=$lg(qualSubGlo,6)
	..q:qualSubSort=""
	..s @("tmpAll("_$tr(qualSubSort,".",",")_")")=qualId_"||"_subId
	..s:'$d(^CT.DHCINM.DB.MgQualItemSubI("par"," "_qualId_"||"_subId)) tmpLeaf(qualSubSort)=qualId_"||"_subId
	.s deepth=1
	.s subId="" f  s subId=$o(^CT.DHCINM.DB.MgQualItemSubI("parr",qualId,subId)) q:subId=""  d
	..q:'$d(^CT.DHCINM.DB.MgQualItemSubD(qualId,subId))
	..s qualSubGlo=^CT.DHCINM.DB.MgQualItemSubD(qualId,subId)
	..s qualSubStDate=$lg(qualSubGlo,7)
	..s qualSubEndDate=$lg(qualSubGlo,8)
	..q:(qualSubStDate>now)||((qualSubEndDate'="")&&(qualSubEndDate<now))
	..s qualSubSort=$lg(qualSubGlo,6)
	..q:qualSubSort=""
	..s:$l(qualSubSort,".")-1>deepth deepth=$l(qualSubSort,".")-1
	..s flag=1
	..s qualSubPar=$lg(qualSubGlo,5)
	..i qualSubPar'="" d
	...s qualSubParId1=$p(qualSubPar,"||")
	...s qualSubParId2=$p(qualSubPar,"||",2)
	...i '$d(^CT.DHCINM.DB.MgQualItemSubD(qualSubParId1,qualSubParId2)) s flag=0 q
	...s qualSubParGlo=^CT.DHCINM.DB.MgQualItemSubD(qualSubParId1,qualSubParId2)
	...s qualSubParStDate=$lg(qualSubParGlo,7)
	...s qualSubParEndDate=$lg(qualSubParGlo,8)
	...i (qualSubParStDate>now)||((qualSubParEndDate'="")&&(qualSubParEndDate<now)) s flag=0 q
	...s qualSubParSort=$lg(qualSubParGlo,6)
	...i qualSubParSort="" s flag=0 q
	..q:flag'=1
	..s hasChild=0
	..s:$d(^CT.DHCINM.DB.MgQualItemSubI("par"," "_qualId_"||"_subId)) hasChild=1
	..s score=$lg(qualSubGlo,4)
	..s:qualScoreType'=2 score=""
	..s:(qualScoreType'=2)&&(qualScoreTypeSub=1) score="√"
	..;s:((qualScoreTypeSub=2)&&(CheckScoreFlag="Y")) score=$lg(qualSubGlo,4)
	..s qualStandardList="[]"
	..i (qualScoreType'=2)&&(qualScoreTypeSub=1) s qualStandardList="[""是@√@el-icon-circle-check"",""否@×@el-icon-circle-close"",""不适用@-@el-icon-warning-outline""]"
	..e  i (qualScoreType'=2)&&(qualScoreTypeSub=2) s qualStandardList="[""符合@@el-icon-circle-check"",""部分符合@@el-icon-remove-outline"",""不符合@@el-icon-circle-close"",""不适用@-@el-icon-warning-outline""]"
	..e  i (qualScoreType=2)&&(qualScoreTypeSub=5)&&(qualStandardMode=1) s tmpQualStandardList=$lg(qualGlo,10),qualStandardList="["_$select(tmpQualStandardList'="":"""",1:"")_$replace(tmpQualStandardList,",",""",""")_$select(tmpQualStandardList'="":"""",1:"")_"]"
	..e  i (qualScoreType=2)&&(((qualScoreTypeSub=5)&&(qualStandardMode=2))||(qualScoreTypeSub=6)) s tmpQualStandardList=$lg(qualSubGlo,9),qualStandardList="["_$select(tmpQualStandardList'="":"""",1:"")_$replace(tmpQualStandardList,",",""",""")_$select(tmpQualStandardList'="":"""",1:"")_"]"
	..i hasChild=0 s rowSpan=1
	..e  d
	...s rowSpan=0,tmpLeafSort="" f  s tmpLeafSort=$o(tmpLeaf(tmpLeafSort)) q:tmpLeafSort=""  d
	....s:$e(tmpLeafSort,1,$l(qualSubSort))=qualSubSort rowSpan=rowSpan+1
	..s tmpRoot="",rootLen=$l(qualSubSort,".")
	..f rootIndex=3:1:rootLen d
	...i tmpRoot="" s tmpRoot=""""_$p(qualSubSort,".",1,rootIndex)_""""
	...e  s tmpRoot=tmpRoot_","""_$p(qualSubSort,".",1,rootIndex)_""""
	..s roots="["_tmpRoot_"]"
	..i (qualSubPar'="")&&($o(@("tmpAll("_$tr(qualSubParSort,".",",")_")")@(""))=$p(qualSubSort,".",$l(qualSubSort,"."))) s fatherShow=1
	..e  s fatherShow=0
	..s ret="{""SubItem"":"""_$lg(qualSubGlo,2)_""",""HasChild"":"""_hasChild_""",""QualSubId"":"""_qualId_"||"_subId_""",""SubSort"":"""_qualSubSort_""""
	..s ret=ret_",""SubScore"":"""_$lg(qualSubGlo,4)_""",""CheckMenu"":"_qualStandardList_",""RowSpan"":"""_rowSpan_""""
	..s ret=ret_",""FatherId"":"""_qualSubPar_""",""Roots"":"_roots_",""FatherShow"":"""_fatherShow_""""
	..s ret=ret_",""c"":"""_$case(qualScoreTypeSub,5:"",6:"",:score)_""",""r"":"""""
	..s ret=ret_",""standard"":"""_$lg(qualSubGlo,3)_""",""itemFlag"":"""_($l(qualSubSort,".")-1)_""",""CheckScoreDe"":"""""
	..s ret=ret_",""Review"":"""",""ReviewDesc"":"""",""ReviewPer"":"""",""ReviewPerName"":"""",""ReviewDate"":"""",""ReviewTime"":"""",""ReviewMenu"":[],""NeedReview"":""N"""
	..s ret=ret_"}"
	..s @("tmp("_$tr(qualSubSort,".",",")_")")=ret
	.s nurSignRet="",picture=""
	e  d
	.k @"tmp"
	.q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	.s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	.s resultUser=$lg(resultGlo,8)
	.i resultUser=0 s resultUserName="管理员"
	.e  i resultUser'="" d
	..s resultUserName=$lg($g(^CF.DHCINM.DB.MgUserD(resultUser)),2)
	.s checkScore=$lg(resultGlo,6)
	.s resultStatus=$lg(resultGlo,7)
	.s status=$case(resultStatus,"S":"Y","N":"S",:""),statusDesc=$case(status,"Y":"已检查","S":"已保存",:"")
	.s resultCheckDate=$lg(resultGlo,24)
	.s remark=$lg(resultGlo,9)
	.s resultFocus=$lg(resultGlo,10)
	.s taskHeadNur=$lg(resultGlo,12)
	.s resultScoreType=$lg(resultGlo,13)
	.s resultScoreTypeSub=$lg(resultGlo,14)
	.s resultStandardMode=$lg(resultGlo,15)
	.s CheckScoreFlag=$lg(resultGlo,29)
	.s scoreType=resultScoreType,scoreTypeSub=resultScoreTypeSub
	.s qualInsertCount=0
	.s qualInsert=$lg(resultGlo,17)
	.k tmpLeaf,@"tmpAll"
	.s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	..q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	..s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	..s resultSubSort=$lg(resultSubGlo,9)
	..q:resultSubSort=""
	..s @("tmpAll("_$tr(resultSubSort,".",",")_")")=resultId_"||"_resultSubId
	..s:'$d(^DHCINM.CHK.MgCheckResultSubI("Par",resultId_"||"_resultSubId)) tmpLeaf(resultSubSort)=resultId_"||"_resultSubId
	.s deepth=1
	.s CheckScoreDeAll=0
	.s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	..q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	..s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	..s resultSubSort=$lg(resultSubGlo,9)
	..q:resultSubSort=""
	..s:$l(resultSubSort,".")-1>deepth deepth=$l(resultSubSort,".")-1
	..s resultSubParId=$lg(resultSubGlo,8)
	..s flag=1
	..i resultSubParId'="" d
	...s resultSubParId1=$p(resultSubParId,"||")
	...s resultSubParId2=$p(resultSubParId,"||",2)
	...i '$d(^DHCINM.CHK.MgCheckResultSubD(resultSubParId1,resultSubParId2)) s flag=0 q
	...s resultSubParGlo=^DHCINM.CHK.MgCheckResultSubD(resultSubParId1,resultSubParId2)
	...s resultSubParSort=$lg(resultSubParGlo,9)
	...i resultSubParSort="" s flag=0 q
	..q:flag'=1
	..s hasChild=0
	..s:$d(^DHCINM.CHK.MgCheckResultSubI("Par",resultId_"||"_resultSubId)) hasChild=1
	..s resultStandardList="[]"
	..i (resultScoreType'=2)&&(resultScoreTypeSub=1) s resultStandardList="[""是@√@el-icon-circle-check"",""否@×@el-icon-circle-close"",""不适用@-@el-icon-warning-outline""]"
	..e  i (resultScoreType'=2)&&(resultScoreTypeSub=2) s resultStandardList="[""符合@@el-icon-circle-check"",""部分符合@@el-icon-remove-outline"",""不符合@@el-icon-circle-close"",""不适用@-@el-icon-warning-outline""]"
	..e  i (resultScoreType=2)&&(resultScoreTypeSub=5)&&(resultStandardMode=1) s tmpResultStandardList=$lg(resultGlo,16),resultStandardList="["_$select(tmpResultStandardList'="":"""",1:"")_$replace(tmpResultStandardList,",",""",""")_$select(tmpResultStandardList'="":"""",1:"")_"]"
	..e  i (resultScoreType=2)&&(((resultScoreTypeSub=5)&&(resultStandardMode=2))||(resultScoreTypeSub=6)) s tmpResultStandardList=$lg(resultSubGlo,10),resultStandardList="["_$select(tmpResultStandardList'="":"""",1:"")_$replace(tmpResultStandardList,",",""",""")_$select(tmpResultStandardList'="":"""",1:"")_"]"
	..i hasChild=0 s rowSpan=1,CheckScoreDe=$lg(resultSubGlo,15),CheckScoreDeAll=CheckScoreDeAll+CheckScoreDe
	..e  d
	...s CheckScoreDe=""
	...s rowSpan=0,tmpLeafSort="" f  s tmpLeafSort=$o(tmpLeaf(tmpLeafSort)) q:tmpLeafSort=""  d
	....s:$e(tmpLeafSort,1,$l(resultSubSort))=resultSubSort rowSpan=rowSpan+1
	..s tmpRoot="",rootLen=$l(resultSubSort,".")
	..f rootIndex=3:1:rootLen d
	...i tmpRoot="" s tmpRoot=""""_$p(resultSubSort,".",1,rootIndex)_""""
	...e  s tmpRoot=tmpRoot_","""_$p(resultSubSort,".",1,rootIndex)_""""
	..s roots="["_tmpRoot_"]"
	..i (resultSubParId'="")&&($o(@("tmpAll("_$tr(resultSubParSort,".",",")_")")@(""))=$p(resultSubSort,".",$l(resultSubSort,"."))) s fatherShow=1
	..e  s fatherShow=0
	..s reviewFlag="N"
	..s resultSubScore=$lg(resultSubGlo,3)
	..s subStandardScore=$lg(resultSubGlo,5)
	..s reviewFlag="N"
	..s subScoreList=$lfs(resultSubScore,",")
	..s subScoreList=$lfs(resultSubScore,",")
	..s scorePtr=0 f  s scoreStat=$listnext(subScoreList,scorePtr,subScoreI) q:(scoreStat'=1)||(reviewFlag="Y")  d
	...i (resultScoreType=1)&&(resultScoreTypeSub=1)&&(subScoreI="×") s reviewFlag="Y" q
	...e  i (resultScoreType=1)&&(resultScoreTypeSub=2)&&(($fn($p(subScoreI,"@",2),"",0)>0)||($fn($p(subScoreI,"@",3),"",0)>0)) s reviewFlag="Y" q
	...e  i (resultScoreType=2)&&((resultScoreTypeSub=3)||(resultScoreTypeSub=5))&&($fn(subScoreI,"",2)<subStandardScore) s reviewFlag="Y" q
	...e  i (resultScoreType=2)&&(resultScoreTypeSub=4)&&(subScoreI'="")&&($fn($SYSTEM.SQL.ABS(subScoreI),"",2)>0) s reviewFlag="Y" q
	...e  i (resultScoreType=2)&&(resultScoreTypeSub=6)&&(subScoreI'="") s reviewFlag="Y" q
	..s review=$lg(resultSubGlo,11)
	..s reviewDesc=$case(review,"Y":"复查通过","N":"复查未通过",:"")
	..s reviewPer=$lg(resultSubGlo,12)
	..s reviewPerName=""
	..i reviewPer=0 s reviewPerName="管理员"
	..e  i reviewPer'="" d
	...s userGlo=$g(^CF.DHCINM.DB.MgUserD(reviewPer))
	...s reviewPerName=$lg(userGlo,2)
	..s reviewDate=$lg(resultSubGlo,13)
	..s:reviewDate'="" reviewDate=$zd(reviewDate,3)
	..s reviewTime=$lg(resultSubGlo,14)
	..s:reviewTime'="" reviewTime=$zt(reviewTime,1)
	..s ret="{""SubItem"":"""_$lg(resultSubGlo,2)_""",""HasChild"":"""_hasChild_""",""QualSubId"":"""_$lg(resultSubGlo,7)_""",""SubSort"":"""_resultSubSort_""""
	..s ret=ret_",""SubScore"":"""_$lg(resultSubGlo,5)_""",""CheckMenu"":"_resultStandardList_",""RowSpan"":"""_rowSpan_""",""FatherId"":"""_resultSubParId_""""
	..s ret=ret_",""Roots"":"_roots_",""FatherShow"":"""_fatherShow_""""
	..s ret=ret_",""c"":"""_$lg(resultSubGlo,3)_""",""r"":"""_$lg(resultSubGlo,6)_""""
	..s ret=ret_",""standard"":"""_$lg(resultSubGlo,4)_""",""itemFlag"":"""_($l(resultSubSort,".")-1)_""",""CheckScoreDe"":"""_CheckScoreDe_""""
	..s ret=ret_",""Review"":"""_review_""",""ReviewDesc"":"""_reviewDesc_""""
	..s ret=ret_",""ReviewPer"":"""_reviewPer_""",""ReviewPerName"":"""_reviewPerName_""",""ReviewDate"":"""_reviewDate_""",""ReviewTime"":"""_reviewTime_""""
	..s ret=ret_",""ReviewMenu"":[{""value"":""Y"",""label"":""通过""},{""value"":""N"",""label"":""未通过""}],""NeedReview"":"""_reviewFlag_""""
	..s ret=ret_"}"
	..s @("tmp("_$tr(resultSubSort,".",",")_")")=ret
	..s:$l($lg(resultSubGlo,3),",")>qualInsertCount qualInsertCount=$l($lg(resultSubGlo,3),",")
	.i qualInsert="" s qualInsert="[]",qualInsertPat="[]",qualInsertNur="[]",qualInsertInput="[]"
	.e  d
	..s qualInsertList=$lfs(qualInsert)
	..s qualInsert="["_qualInsert_"]"
	..i $lf(qualInsertList,1)>0 d
	...s qualInsertPatList=$lg(resultGlo,26)
	...s tmpString=""
	...s ptr=0 f  s stat=$listnext(qualInsertPatList,ptr,tmpPat) q:stat'=1  d
	....i tmpString="" s tmpString=""""_tmpPat_""""
	....e  s tmpString=tmpString_","""_tmpPat_""""
	...s qualInsertPat="["_tmpString_"]"
	..e  s qualInsertPat="[]"
	..i $lf(qualInsertList,2)>0 d
	...s qualInsertNurList=$lg(resultGlo,27)
	...s tmpString=""
	...s ptr=0 f  s stat=$listnext(qualInsertNurList,ptr,tmpNur) q:stat'=1  d
	....i tmpString="" s tmpString=""""_tmpNur_""""
	....e  s tmpString=tmpString_","""_tmpNur_""""
	...s qualInsertNur="["_tmpString_"]"
	..e  s qualInsertNur="[]"
	..i $lf(qualInsertList,3)>0 d
	...s qualInsertInpList=$lg(resultGlo,28)
	...s tmpString=""
	...s ptr=0 f  s stat=$listnext(qualInsertInpList,ptr,tmpInput) q:stat'=1  d
	....i tmpString="" s tmpString=""""_tmpInput_""""
	....e  s tmpString=tmpString_","""_tmpInput_""""
	...s qualInsertInput="["_tmpString_"]"
	..e  s qualInsertInput="[]"
	.s nurSignRet=$lg(resultGlo,12)
	.s picture=$lg(resultGlo,32)
	.s:picture'="" picture=$lts(picture,",")
	
	s scoreTypeDesc=$case(scoreType,1:"按比例",2:"按分值",:"")
	s scoreTypeSubDesc=$case(scoreTypeSub,1:"是否模式",2:"符合模式",3:"得分模式",4:"扣分模式",5:"选项模式",6:"扣分原因模式",:"")
	s ret="{""TaskID"":"""_releaseId_""",""QualDesc"":"""_taskItemDesc_""",""TaskDate"":"""_taskDate_""",""TaskQualID"":"""_qualId_""""
	_",""TaskWard"":"""_wardId_""",""TaskChkDate"":"""_$zd(resultCheckDate,3)_""",""TaskUser"":"""_taskCheckerId_""""
	_",""TaskHeadNur"":"""_taskHeadNur_""",""IfFocus"":"""_resultFocus_""",""ScoreType"":"""_scoreType_""",""ScoreTypeSub"":"""_scoreTypeSub_""""
	_",""CheckId"":"""_resultId_""",""Status"":"""_status_""",""Remark"":"""_remark_""""
	_",""CheckScore"":"""_checkScore_""",""CheckType"":"""_$tr(type,"|","_")_""""
	_",""ScoreTypeDesc"":"""_scoreTypeDesc_""",""ScoreTypeSubDesc"":"""_scoreTypeSubDesc_""",""StatusDesc"":"""_statusDesc_""""
	_",""TaskWardDesc"":"""_taskWardDesc_""",""TaskUserDesc"":"""_taskCheckerName_""""
	_",""TaskPat"":"""_checkPat_""",""TastSerPat"":"""_checkSerPat_""""
	_",""TaskResPat"":"""_checkResPat_""",""TaskNightNur"":"""_checkNightNur_""",""CheckFlag"":"""_checkFlag_""""
	_",""InsertCount"":"""_qualInsertCount_""",""QualInsert"":"_qualInsert_",""QualInsertPat"":"_qualInsertPat
	_",""QualInsertNur"":"_qualInsertNur_",""QualInsertInput"":"_qualInsertInput
	_",""ResultUser"":"""_resultUser_""",""ResultUserName"":"""_resultUserName_""""
	_",""CheckScoreFlag"":"""_CheckScoreFlag_""",""CheckScoreDeAll"":"""_CheckScoreDeAll_""",""signName"":"""_nurSignRet_""",""Picture"":"""_picture_""""
	_",""Items"":["
	
	s index=0
	s query="tmp("""")" f  s query=$q(@query) q:query=""  d
	.s ret=ret_$case(index,0:"",:",")_(@query)
	.s index=index+1
	
	s ret=ret_"]}"
	s ret=$replace(ret,$c(10),"@br@")
	s ret=$replace(ret,$c(13),"@br@")
	s ret=$tr(ret,$c(0))
	q ##class(DHCINM.WebService.INMServerUtilComm).returnJson(0,"",ret)
}

/// Description:保存检查结果
/// Date:2020-09-28
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input:夜查房基本信息 质控任务Id 病区Id 质控项目Id 打分表信息 总分 userId
/// Output:status=0:成功 status=1:失败
/// Other:w ##class(DHCINM.WebService.INMMobileComm).SaveCheckScoreForm()
ClassMethod SaveCheckScoreForm(basic As %String, taskId As %String, wardId As %String, qualId As %String, parr As %String, score As %String, status As %String, remark As %String, insert As %String, loginId As %String, checkDate As %String, checkAccordScore As %String, checkAccordScoreSum As %String, signName As %String, Picture As %String) As %String [ WebMethod ]
{
	;s ^Tmp("SaveCheckScoreForm")=basic_"^"_taskId_"^"_wardId_"^"_qualId_"^"_parr_"^"_score_"^"_status_"^"_remark_"^"_insert_"^"_loginId_"^"_checkDate_"^"_checkAccordScore_"^"_checkAccordScoreSum
	s flag=0,msg=""
	s:(taskId="")||(wardId="")||(qualId="")||(parr="")||(score="")||(status="")||(insert="")||(loginId="")||(checkDate="") flag=1,msg="参数不能为空"
	s checkDate=$zdh(checkDate,3)
	
	i flag=0 d
	.s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	.i '$IsObject(taskObj) s flag=1,msg="任务不存在" q
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
	.i '$IsObject(wardObj) s flag=1,msg="病区不存在" q
	.s qualObj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(qualId)
	.i '$IsObject(qualObj) s flag=1,msg="质控项目不存在" q
	.q:loginId=0
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(loginId)
	.i '$IsObject(userObj) s flag=1,msg="登录人不存在" q
	
	i (taskObj.TaskType.%Id()="5||2")||(taskObj.TaskType.%Id()="5||4")||(taskObj.TaskType.%Id()="5||5") s isNightCheck=1
	e  s isNightCheck=0
	
	s $zt="error"
	ts
	s now=$h
	i (flag=0)&&(basic'="") d
	.k tmpBasic
	.s basciId=$o(^DHCINM.CHK.MgNurNightBasicI("Ward",taskId,wardId,""))
	.i basciId="" d
	..s obj=##class(DHCINM.CHK.MgNurNightBasic).%New()
	..s obj.CheckTask=taskObj
	..s obj.CheckTaskDate=taskObj.TaskStDate
	..s obj.CheckWard=wardObj
	.e  s obj=##class(DHCINM.CHK.MgNurNightBasic).%OpenId(basciId)
	.i '$IsObject(obj) s flag=1,msg="基本信息对象不存在" q
	.s obj.CheckDate=+now
	.s len=$l(basic,"^")
	.f i=1:1:len d
	..s data=$p(basic,"^",i)
	..s p=$p(data,"|")
	..s value=$p(data,"|",2)
	..s $ZOBJPROPERTY(obj,p)=value
	.s sc=obj.%Save()
	.i $$$ISERR(sc) s flag=1,msg="基本信息保存失败"
	s lastParrQualID=$p($p(parr,"ˇ",$l(parr,"ˇ")),"^",3)
	i flag=0 d
	.s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,qualId,wardId,""))
	.i resultId="" d
	..k tmpQualItemnfo
	..s tmpQualItemInfo=##class(web.INMDBComm).GetQualItem(qualId)
	..d ##class(DHCINM.WebService.INMServerUtilComm).SplitStr(tmpQualItemInfo,"^","|",.tmpQualItemInfo)
	..s qualScoreType=$g(tmpQualItemInfo("QualScoreType"))
	..s qualScoreTypeSub=$g(tmpQualItemInfo("QualScoreTypeSub"))
	..s qualStandardMode=$g(tmpQualItemInfo("QualStandardMode"))
	..s qualStandardList=$g(tmpQualItemInfo("QualStandardList"))
	..s qualInsert=$g(tmpQualItemInfo("QualInsert"))
	..s qualInsertCount=$g(tmpQualItemInfo("QualInsertCount"))
	..s resultObj=##class(DHCINM.CHK.MgCheckResult).%New()
	..s resultObj.CheckWard=wardObj
	..s resultObj.CheckTask=taskObj
	..s resultObj.CheckType=taskObj.TaskType
	..s resultObj.CheckItem=qualObj
	..s resultObj.CheckScoreType=qualScoreType
	..s resultObj.CheckScoreTypeSub=qualScoreTypeSub
	..s resultObj.CheckStandardMode=qualStandardMode
	..s resultObj.CheckStandardList=qualStandardList
	..s resultObj.CheckInsert=qualInsert
	..s resultObj.CheckInsertCount=qualInsertCount
	..s resultObj.CreateUser=loginId
	..s resultObj.CheckPass=qualObj.QualPass
	..s resultObj.CheckScoreFlag=qualObj.QualScoreFlag
	.e  s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	.i '$IsObject(resultObj) s flag=1,msg="结果对象不存在" q
	.s resultObj.CheckScore=score
	.s resultObj.CheckStatus=status
	.s resultObj.CheckRemark=remark
	.s resultObj.CheckUser=loginId
	.s resultObj.CheckDate=checkDate
	.i resultObj.CheckInsert'="" d
	..s inserList=$lfs(resultObj.CheckInsert)
	..s insertPat=$p(insert,"ˇ")
	..s insertNur=$p(insert,"ˇ",2)
	..s insertInput=$p(insert,"ˇ",3)
	..s checkInsertCount=$l(insertPat,"^")
	..s:$l(insertNur,"^")>checkInsertCount checkInsertCount=$l(insertNur,"^")
	..s:$l(insertInput,"^")>checkInsertCount checkInsertCount=$l(insertInput,"^")
	..i $lf(inserList,1)>0 d
	...d resultObj.InsertHeadPat.Clear()
	...f i=1:1:checkInsertCount d
	....s tmpValue=$p(insertPat,"^",i)
	....d resultObj.InsertHeadPat.Insert(tmpValue)
	..i $lf(inserList,2)>0 d
	...d resultObj.InsertHeadNur.Clear()
	...f i=1:1:checkInsertCount d
	....s tmpValue=$p(insertNur,"^",i)
	....d resultObj.InsertHeadNur.Insert(tmpValue)
	..i $lf(inserList,3)>0 d
	...d resultObj.InsertHeadInput.Clear()
	...f i=1:1:checkInsertCount d
	....s tmpValue=$p(insertInput,"^",i)
	....d resultObj.InsertHeadInput.Insert(tmpValue)
	.s resultObj.CheckNurse=signName
	.s:status="S" resultObj.SubmitDate=+now,resultObj.SubmitTime=$p(now,",",2)
	.s resultObj.CheckAccordScore=checkAccordScore
	.s resultObj.CheckAccordScoreSum=checkAccordScoreSum
	.d resultObj.Picture.Clear()
	.i Picture'="" d
	..s pictureList=$lfs(Picture,",")
	..s ptr=0 f  s pStatus=$listnext(pictureList,ptr,picAddress) q:pStatus'=1  d
	...d resultObj.Picture.Insert(picAddress)
	.s sc=resultObj.%Save()
	.i $$$ISERR(sc) s flag=1,msg="检查结果保存失败"
	
	i flag=0
	{
		s len=$l(parr,"ˇ")
		f i=1:1:len
		{
			s itm=$p(parr,"ˇ",i)
			i itm="" continue
			s value=$p(itm,"^")
			s remark=$p(itm,"^",2)
			s qualSubId=$p(itm,"^",3)
			s subAccordScore=$p(itm,"^",4)
			s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubI("Qual",resultObj.%Id(),qualSubId,""))
			i resultSubId="" d
			.s qualSubObj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(qualSubId)
			.i '$IsObject(qualSubObj) s flag=1 q
			.s resultSubObj=##class(DHCINM.CHK.MgCheckResultSub).%New()
			.s resultSubObj.Parref=resultObj
			.s resultSubObj.SubItem=qualSubObj.SubDesc
			.s resultSubObj.SubStandard=qualSubObj.SubStandard
			.s resultSubObj.SubStandardScore=qualSubObj.SubScore
			.s resultSubObj.SubReference=qualSubObj
			.s resultSubObj.SubSort=qualSubObj.SubSort
			.i $l(resultSubObj.SubSort,".")>2 d
			..s resultSubParSort=$e(resultSubObj.SubSort,1,*-$l($p(resultSubObj.SubSort,".",$L(resultSubObj.SubSort,".")))-1)
			..s resultSubParId=$o(^DHCINM.CHK.MgCheckResultSubI("Sort",resultObj.%Id()," "_resultSubParSort,""))
			..s resultSubParObj=##class(DHCINM.CHK.MgCheckResultSub).%OpenId(resultObj.%Id()_"||"_resultSubParId)
			..i '$IsObject(resultSubParObj) s flag=1 q
			..s resultSubObj.SubParent=resultSubParObj
			.s resultSubObj.SubStandardList=qualSubObj.SubStandardList
			e  s resultSubObj=##class(DHCINM.CHK.MgCheckResultSub).%OpenId(resultObj.%Id()_"||"_resultSubId)
			q:flag'=0
			i '$IsObject(resultSubObj) s flag=1 q
			s resultSubObj.SubScore=value
			s resultSubObj.SubRemark=remark
			s resultSubObj.SubAccordScore=subAccordScore
			s sc=resultSubObj.%Save()
			i $$$ISERR(sc) s flag=1,msg="检查结果保存失败"
			q:flag'=0
		}
	}
	
	i flag=0 tc
	else  tro
	
	q ##class(DHCINM.WebService.INMServerUtilComm).returnJson(flag,msg,"")
error
	tro
	q "{""status"":""1"",""msg"":""保存失败"",""data"":""""}"
}

/// Description:获取质控检查成绩
/// Date:2020-09-25
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input:userId 开始日期 结束日期 质控类型Id 质控级别(空:全部,H:护理部,L:科级,W:病区) 类型(S:按管辖病区,L:按检查人) 类型(P:排行榜,F:分数统计分析)
/// Output:质控检查成绩
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindCheckScoreListByType(0,"2020-08-01","2020-09-30","","","L","F")
ClassMethod FindCheckScoreListByType(loginId As %String, startDate As %String, endDate As %String, type As %String, checklevel As %String, flag As %String, clicktype As %String) As %String
{
	///按检查人:未指定检查人时,该病区人员都视为检查人
	q:(loginId="")||(startDate'["-")||(endDate'["-")||(flag="")||(clicktype="") "{""data"":[],""total"":""0""}"
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s type=$tr(type,"_","|")
	
	k tmpWard
	d ##class(DHCINM.WebService.INMServerUtilComm).SetRoleWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	k tmpScore,tmpScoreType,tmpItemDesc,tmpWardDesc
	s checkDate=startDate-1 f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:(checkDate>endDate)||(checkDate="")  d
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:(flag="S")&&('$d(tmpWard(checkWard)))
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	....q:'$IsObject(resultObj)
	....q:(loginId'=0)&&(flag="L")&&(('$IsObject(resultObj.CheckTask))||((resultObj.CheckTask.TaskCheckPerson.Count()>0)&&(resultObj.CheckTask.TaskCheckPerson.Find(loginId)=""))||((resultObj.CheckTask.TaskCheckPerson.Count()=0)&&('$d(tmpWard(checkWard)))))
	....q:(type'="")&&(type'=resultObj.CheckType.%Id())
	....q:(checklevel'="")&&(('$IsObject(resultObj.CheckTask))||(resultObj.CheckTask.TaskLevel'=checklevel))
	....i '$d(tmpItemDesc(checkItem)) d
	.....i '$IsObject(resultObj.CheckTask) s tmpItemDesc(checkItem)="" q
	.....s tmpFalg=0
	.....s itemKey="" f  s itemStr=resultObj.CheckTask.TaskItem.GetNext(.itemKey) q:(tmpFalg=1)||(itemKey="")  d
	......s taskItemDesc=$p(itemStr,"「")
	......s taskItemId=$p(itemStr,"「",2)
	......q:checkItem'=taskItemId
	......s tmpItemDesc(checkItem)=taskItemDesc
	......s tmpFalg=1
	....s:'$d(tmpWardDesc(checkWard)) tmpWardDesc(checkWard)=$lg($g(^CF.DHCINM.DB.MgWardD(checkWard)),4)
	....s resultScore=+$fn(resultObj.CheckScore,"",2)
	....i resultScore>90 s tmpScoreType(checkItem,">90")=$g(tmpScoreType(checkItem,">90"))+1
	....e  i (resultScore>80) s tmpScoreType(checkItem,"80-90")=$g(tmpScoreType(checkItem,"80-90"))+1
	....e  i (resultScore>70) s tmpScoreType(checkItem,"70-80")=$g(tmpScoreType(checkItem,"70-80"))+1
	....e  i (resultScore>60) s tmpScoreType(checkItem,"60-70")=$g(tmpScoreType(checkItem,"60-70"))+1
	....e  s tmpScoreType(checkItem,"<60")=$g(tmpScoreType(checkItem,"<60"))+1
	....s tmpScore(checkItem,resultScore)=$g(tmpScore(checkItem,resultScore))_$lb(checkWard)
	
	s ret=""
	i clicktype="P" d
	.s ret="{""data"":["
	.s itemIndex=0
	.s item="" f  s item=$o(tmpScore(item)) q:item=""  d
	..s wardIndex=0
	..s ret=ret_$case(itemIndex,0:"",:",")_"{""Qid"":"""_item_""",""Qdesc"":"""_tmpItemDesc(item)_""",""items"":["
	..s score="" f  s score=$o(tmpScore(item,score),-1) q:score=""  d
	...s wardKey=0 f  s status=$listnext(tmpScore(item,score),wardKey,wardId) q:status'=1  d
	....s ret=ret_$case(wardIndex,0:"",:",")_"{""Wid"":"""_wardId_""",""Wdesc"":"""_tmpWardDesc(wardId)_""",""Score"":"""_score_"""}"
	....s wardIndex=wardIndex+1
	..s ret=ret_"]}"
	..s itemIndex=itemIndex+1
	.s ret=ret_"],""total"":"""_itemIndex_"""}"
	e  d
	.s scoreTypeList=$lb(">90","80-90","70-80","60-70","<60")
	.s ret="{""data"":["
	.s itemIndex=0
	.s item="" f  s item=$o(tmpScoreType(item)) q:item=""  d
	..s ret=ret_$case(itemIndex,0:"",:",")_"{""Qid"":"""_item_""",""Qdesc"":"""_tmpItemDesc(item)_""""
	..s typeKey=0 f  s status=$listnext(scoreTypeList,typeKey,typeStr) q:status'=1  d
	...s ret=ret_","""_typeStr_""":"""_+$g(tmpScoreType(item,typeStr))_""""
	..s ret=ret_"}"
	..s itemIndex=itemIndex+1
	.s ret=ret_"],""total"":"""_itemIndex_"""}"
	
	q ret
}

/// Description:获取质控问题
/// Date:2020-09-27
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 级别(空:全部,H:护理部,L:科级,W:病区) 质控类型Id 质控项目Id 状态(空:全部,N:待解决,S:已处理,A:已解决,Q:问题上诉,B:驳回,I:忽略) 类型(S:按管辖病区,L:按检查人)
/// Output:质控问题
/// Other:d ##class(%ResultSet).RunQuery("DHCINM.WebService.INMMobileComm","FindCheckQuestions",0,"2020-08-01","2020-09-30","","","","","S")
Query FindCheckQuestions(loginId As %String, startDate As %String, endDate As %String, level As %String, checkType As %String, checkproId As %String, status As %String, Scopt As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckQuestionsExecute(ByRef qHandle As %Binary, loginId As %String, startDate As %String, endDate As %String, level As %String, checkType As %String, checkproId As %String, status As %String, Scopt As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (loginId="")||(startDate'["-")||(endDate'["-")||(Scopt=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s checkType=$tr(checkType,"_","|")
	
	k tmpWard
	s isAll=##class(DHCINM.WebService.INMServerUtilComm).SetRoleWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	s checkDate=startDate-1 f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:(checkDate>endDate)||(checkDate="")  d
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:(Scopt="S")&&('$d(tmpWard(checkWard)))
	..s checkWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(checkWard)),4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(checkproId'="")&&(checkproId'=checkItem)
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s checkItemDesc=$lg(checkItemGlo,4)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s taskLevel="",taskLevelDesc="",flag=0
	....s taskId=$lg(resultGlo,3)
	....i taskId'="" d
	.....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	.....s taskLevel=$lg(taskGlo,8)
	.....s:taskLevel="" taskLevel="H"
	.....q:(level'="")&&(level'=taskLevel)
	.....s taskLevelDesc=$case(taskLevel,"H":"护理部","L":"科室","W":"病区",:"")
	.....s taskCheckPerson=$lg(taskGlo,4)
	.....q:(loginId'=0)&&(Scopt="L")&&((($ll(taskCheckPerson)>0)&&($lf(taskCheckPerson,loginId)=0))||(($ll(taskCheckPerson)=0)&&(isAll'=1)&&('$d(tmpWard(checkWard)))))
	.....i checkItemDesc="" d
	......s taskItemList=$lg(taskGlo,1)
	......s itemFlag=0
	......s itemKey=0 f  s itemSatus=$listnext(taskItemList,itemKey,itemStr) q:(itemFlag=1)||(itemSatus'=1)  d
	.......s taskItemDesc=$p(itemStr,"「")
	.......s taskItemId=$p(itemStr,"「",2)
	.......q:checkItem'=taskItemId
	.......s checkItemDesc=taskItemDesc
	.......s itemFlag=1
	.....s flag=1
	....q:flag'=1
	....s resultType=$lg(resultGlo,4)
	....q:(checkType'="")&&(checkType'=resultType)
	....s resultTypeDesc=""
	....i resultType'="" d
	.....s typePar=$p(resultType,"||")
	.....s typeSub=$p(resultType,"||",2)
	.....s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	.....s resultTypeDesc=$lg(typeGlo,3)
	....s quesId=$o(^DHCINM.CHK.MgCheckQuesI("Result",resultId,""))
	....i (quesId="")||('$d(^DHCINM.CHK.MgCheckQuesD(quesId))) s quesStatus="N"
	....e  d
	.....s quesGlo=^DHCINM.CHK.MgCheckQuesD(quesId)
	.....s quesStatus=$lg(quesGlo,12)
	....q:(status'="")&&(status'=quesStatus)
	....s quesStatusDesc=$case(quesStatus,"N":"待处理","S":"已处理","A":"已解决","Q":"问题上诉","B":"驳回","I":"忽略",:"")
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s quesDesc="",mistakeFlag=0,counter=0
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:resultSubScore=""
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s deductFlag=##class(web.INMQualControlComm).IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.....q:deductFlag'=1
	.....s mistakeFlag=1
	.....s resultSubItem=$lg(resultSubGlo,2)
	.....s resultSubRemark=$lg(resultSubGlo,6)
	.....i counter=0 d
	......s quesDesc=resultSubItem
	......s:resultSubRemark'="" quesDesc=quesDesc_"【"_resultSubRemark_"】"
	.....e  d
	......s quesDesc=quesDesc_";"_resultSubItem
	......s:resultSubRemark'="" quesDesc=quesDesc_"【"_resultSubRemark_"】"
	.....s counter=counter+1
	....q:mistakeFlag'=1
	....s quesAnalyze="",quesNurRea="",quesPatRea="",quesDeviceRea="",quesWorkRea=""
	....s quesGoodsRea="",quesOtherRea="",quesStep="",quesGoal="",quesHLBView=""
	....i quesStatus'="N" d
	.....s quesGlo=^DHCINM.CHK.MgCheckQuesD(quesId)
	.....s quesAnalyze=$lg(quesGlo,16)
	.....s quesNurRea=$lg(quesGlo,17)
	.....s quesPatRea=$lg(quesGlo,18)
	.....s quesDeviceRea=$lg(quesGlo,19)
	.....s quesWorkRea=$lg(quesGlo,20)
	.....s quesGoodsRea=$lg(quesGlo,21)
	.....s quesOtherRea=$lg(quesGlo,22)
	.....s quesStep=$lg(quesGlo,23)
	.....s quesGoal=$lg(quesGlo,24)
	.....s quesHLBView=$lg(quesGlo,25)
	....s ret="QuesDate|"_$zd(checkDate,3)_"^QuesWard|"_checkWard_"^QuesWardDesc|"_checkWardDesc_"^QuesItem|"_checkItem_"^QuesItemDesc|"_checkItemDesc_"^QuesType|"_$tr(resultType,"|","_")
	....s ret=ret_"^QuesTypeDesc|"_resultTypeDesc_"^QuesDesc|"_quesDesc_"^QuesStatus|"_quesStatus_"^QuesStatusDesc|"_quesStatusDesc_"^ResultId|"_resultId
	....s ret=ret_"^QuesAnalyze|"_quesAnalyze_"^QuesNurRea|"_quesNurRea_"^QuesPatRea|"_quesPatRea_"^QuesDeviceRea|"_quesDeviceRea_"^QuesWorkRea|"_quesWorkRea
	....s ret=ret_"^QuesGoodsRea|"_quesGoodsRea_"^QuesOtherRea|"_quesOtherRea_"^QuesStep|"_quesStep_"^QuesGoal|"_quesGoal_"^QuesHLBView|"_quesHLBView
	....s ret=ret_"^TaskId|"_taskId_"^TaskLevel|"_taskLevel_"^TaskLevelDesc|"_taskLevelDesc
	....d OutQuesList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuesList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckQuestionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckQuestionsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckQuestionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckQuestionsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:获取质控问题项
/// Date:2020-09-27
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:质控问题项
/// Other:w ##class(DHCINM.WebService.INMMobileComm).SetQuesRateTMP(0,"2020-08-01","2020-09-30","","","S","P",.tmpItem,.tmpCheck,.tmpError)
ClassMethod SetQuesRateTMP(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String, ByRef tmpItem As %String = "", ByRef tmpCheck As %String = "", ByRef tmpError As %String = "", ByRef tmpErrorWard As %String = "", ByRef tmpCheckWard As %String = "", ByRef tmpChange As %String = "", ByRef tmpChangeWard As %String = "") As %String
{
	k tmpWard
	s isAll=##class(DHCINM.WebService.INMServerUtilComm).SetRoleWard(loginId,.tmpWard)
	
	s:loginId'=0 loginId=$lg($g(^CF.DHCINM.DB.MgUserD(loginId)),5)
	s:loginId="" loginId=" "
	
	k tmpItem,tmpCheck,tmpError,tmpErrorWard,tmpCheckWard,tmpChange
	s checkDate=startDate-1 f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:(checkDate>endDate)||(checkDate="")  d
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:(scopt="S")&&('$d(tmpWard(checkWard)))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...i $d(tmpItem(checkItem))#2'=1 d
	....s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	....s tmpItem(checkItem)=$lg(checkItemGlo,4)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(checkType'="")&&(checkType'=resultType)
	....s flag=0
	....s taskId=$lg(resultGlo,3)
	....i taskId'="" d
	.....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	.....s taskCheckPerson=$lg(taskGlo,4)
	.....q:(loginId'=0)&&(scopt="L")&&((($ll(taskCheckPerson)>0)&&($lf(taskCheckPerson,loginId)=0))||(($ll(taskCheckPerson)=0)&&('$d(tmpWard(checkWard)))))
	.....i $d(tmpItem(checkItem))#2'=1 d
	......s taskItemList=$lg(taskGlo,1)
	......s itemFlag=0
	......s itemKey=0 f  s itemSatus=$listnext(taskItemList,itemKey,itemStr) q:(itemFlag=1)||(itemSatus'=1)  d
	.......s taskItemDesc=$p(itemStr,"「")
	.......s taskItemId=$p(itemStr,"「",2)
	.......q:checkItem'=taskItemId
	.......s tmpItem(checkItem)=taskItemDesc
	.......s itemFlag=1
	.....s flag=1
	....q:flag'=1
	....s mistakeFlag=0
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....q:$d(^DHCINM.CHK.MgCheckResultSubI("Par",resultId_"||"_resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....s checkItemSubId=$p($lg(resultSubGlo,7),"||",2)
	.....s tmpCheck(checkItem,checkItemSubId)=$g(tmpCheck(checkItem,checkItemSubId))+1
	.....s tmpCheckWard(checkItem,checkWard,"WardTotal")=$g(tmpCheckWard(checkItem,checkWard,"WardTotal"))+1
	.....s:'$d(tmpCheckWard(checkItem,checkWard,"WardDesc")) tmpCheckWard(checkItem,checkWard,"WardDesc")=checkWardDesc
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:resultSubScore=""
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s deductFlag=##class(web.INMQualControlComm).IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.....q:deductFlag'=1
	.....s mistakeFlag=1
	.....s resultSubItem=$lg(resultSubGlo,2)
	.....s resultSubRemark=$lg(resultSubGlo,6)
	.....s:'$d(tmpItem(checkItem,checkItemSubId)) tmpItem(checkItem,checkItemSubId)=resultSubItem
	.....s tmpError(checkItem,checkItemSubId)=$g(tmpError(checkItem,checkItemSubId))+1
	.....s tmpErrorWard(checkItem,checkWard)=$g(tmpErrorWard(checkItem,checkWard))+1
	....q:mistakeFlag'=1
	....s quesId=$o(^DHCINM.CHK.MgCheckQuesI("Result",resultId,""))
	....i (quesId="")||('$d(^DHCINM.CHK.MgCheckQuesD(quesId))) s quesStatus="N"
	....e  d
	.....s quesGlo=^DHCINM.CHK.MgCheckQuesD(quesId)
	.....s quesStatus=$lg(quesGlo,12)
	....s tmpChange(checkItem,quesStatus)=$g(tmpChange(checkItem,quesStatus))+1
	....s tmpChange(checkItem,"Total")=$g(tmpChange(checkItem,"Total"))+1
	....s:'$d(tmpChangeWard(checkItem,checkWard,"WardDesc")) tmpChangeWard(checkItem,checkWard,"WardDesc")=checkWardDesc
	....s tmpChangeWard(checkItem,checkWard,quesStatus)=$g(tmpChangeWard(checkItem,checkWard,quesStatus))+1
	....s tmpChangeWard(checkItem,checkWard,"Total")=$g(tmpChangeWard(checkItem,checkWard,"Total"))+1
}

/// Description:获取质控问题项错误率Top6(按问题项)
/// Date:2020-09-27
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:质控问题项错误率Top6
/// Other:d ##class(%ResultSet).RunQuery("DHCINM.WebService.INMMobileComm","FindErrRateForQues",0,"2020-08-01","2020-08-31","","S")
Query FindErrRateForQues(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindErrRateForQuesExecute(ByRef qHandle As %Binary, loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (loginId="")||(startDate'["-")||(endDate'["-")||(scopt="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s checkType=$tr(checkType,"_","|")
	
	d ..SetQuesRateTMP(loginId,startDate,endDate,checkType,scopt,.tmpItem,.tmpCheck,.tmpError)
	
	k tmpRate
	s qualId="" f  s qualId=$o(tmpError(qualId)) q:qualId=""  d
	.s subId="" f  s subId=$o(tmpError(qualId,subId)) q:subId=""  d
	..s rate=+$fn(tmpError(qualId,subId)/tmpCheck(qualId,subId)*100,"",2)
	..s tmpRate(rate)=$g(tmpRate(rate))_$lb(qualId_","_subId)
	
	s count=0,limit=5
	s rate="" f  s rate=$o(tmpRate(rate),-1) q:(count>limit)||(rate="")  d
	.s rateKey=0 f  s status=$listnext(tmpRate(rate),rateKey,quesStr) q:(count>limit)||(status'=1)  d
	..s qualId=$p(quesStr,",")
	..s subId=$p(quesStr,",",2)
	..s ret="qualDesc|"_tmpItem(qualId)_"^itemDesc|"_tmpItem(qualId,subId)_"^rate|"_rate_"%"
	..s count=count+1
	..d OutQuesList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuesList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindErrRateForQuesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindErrRateForQuesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindErrRateForQuesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindErrRateForQuesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:获取质控问题项错误率Top10(按质控项目)
/// Date:2020-09-27
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:质控问题项错误率Top10
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindErrRateForQuesColumn(0,"2020-08-01","2020-08-31","","S")
ClassMethod FindErrRateForQuesColumn(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String) As %Status
{
	i (loginId="")||(startDate'["-")||(endDate'["-")||(scopt="") q "{""data"":[],""total"":""0""}"
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s checkType=$tr(checkType,"_","|")
	
	d ..SetQuesRateTMP(loginId,startDate,endDate,checkType,scopt,.tmpItem,.tmpCheck,.tmpError)
	
	k tmpRate
	s qualId="" f  s qualId=$o(tmpError(qualId)) q:qualId=""  d
	.s subId="" f  s subId=$o(tmpError(qualId,subId)) q:subId=""  d
	..s rate=+$fn(tmpError(qualId,subId)/tmpCheck(qualId,subId)*100,"",2)
	..s tmpRate(qualId,rate)=$g(tmpRate(qualId,rate))_$lb(subId)
	
	s total=0,limit=9
	s ret="{""data"":["
	s qualId="" f  s qualId=$o(tmpRate(qualId)) q:qualId=""  d
	.s qualRet="{""qualDesc"":"""_tmpItem(qualId)_""",""items"":["
	.s index=0
	.s rate="" f  s rate=$o(tmpRate(qualId,rate),-1) q:(index>limit)||(rate="")  d
	..s subKey=0 f  s status=$listnext(tmpRate(qualId,rate),subKey,subId) q:(index>limit)||(status'=1)  d
	...s qualRet=qualRet_$case(index,0:"",:",")_"{""itemDesc"":"""_tmpItem(qualId,subId)_""",""rate"":"""_rate_"%""}"
	...s index=index+1
	.s qualRet=qualRet_"]}"
	.s ret=ret_$case(total,0:"",:",")_qualRet
	.s total=total+1
	s ret=ret_"],""total"":"""_total_"""}"
	
	q ret
}

/// Description:获取质控问题项错误率Top10(按病区)
/// Date:2020-09-27
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:质控问题项错误率Top10
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindErrRateForWard(0,"2020-08-01","2020-08-31","","S")
ClassMethod FindErrRateForWard(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String) As %Status
{
	i (loginId="")||(startDate'["-")||(endDate'["-")||(scopt="") q "{""data"":[],""total"":""0""}"
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s checkType=$tr(checkType,"_","|")
	
	d ..SetQuesRateTMP(loginId,startDate,endDate,checkType,scopt,.tmpItem,.tmpCheck,.tmpError,.tmpErrorWard,.tmpCheckWard)
	
	k tmpRate
	s qualId="" f  s qualId=$o(tmpErrorWard(qualId)) q:qualId=""  d
	.s wardId="" f  s wardId=$o(tmpErrorWard(qualId,wardId)) q:wardId=""  d
	..s rate=+$fn(tmpErrorWard(qualId,wardId)/tmpCheckWard(qualId,wardId,"WardTotal")*100,"",2)
	..b ;01
	..s tmpRate(qualId,rate)=$g(tmpRate(qualId,rate))_$lb(wardId)
	
	s total=0,limit=9
	s ret="{""data"":["
	s qualId="" f  s qualId=$o(tmpRate(qualId)) q:qualId=""  d
	.s qualRet="{""qualDesc"":"""_tmpItem(qualId)_""",""items"":["
	.s index=0
	.s rate="" f  s rate=$o(tmpRate(qualId,rate),-1) q:(index>limit)||(rate="")  d
	..s wardKey=0 f  s status=$listnext(tmpRate(qualId,rate),wardKey,wardId) q:(index>limit)||(status'=1)  d
	...s qualRet=qualRet_$case(index,0:"",:",")_"{""wardDesc"":"""_tmpCheckWard(qualId,wardId,"WardDesc")_""",""rate"":"""_rate_"%""}"
	...s index=index+1
	.s qualRet=qualRet_"]}"
	.s ret=ret_$case(total,0:"",:",")_qualRet
	.s total=total+1
	s ret=ret_"],""total"":"""_total_"""}"
	
	q ret
}

/// Description:获取质控问题项整改率Top6(按质控项目)
/// Date:2020-09-27
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:获取质控问题项整改率Top6
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindUpdateRateForQues(0,"2020-08-01","2020-08-31","","S")
ClassMethod FindUpdateRateForQues(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String) As %Status
{
	i (loginId="")||(startDate'["-")||(endDate'["-")||(scopt="") q "{""data"":[],""total"":""0""}"
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s checkType=$tr(checkType,"_","|")
	
	d ..SetQuesRateTMP(loginId,startDate,endDate,checkType,scopt,.tmpItem,.tmpCheck,.tmpError,.tmpErrorWard,.tmpCheckWard,.tmpChange)
	
	k tmpRate
	s qualId="" f  s qualId=$o(tmpChange(qualId)) q:qualId=""  d
	.s rate=+$fn(+$g(tmpChange(qualId,"A"))+$g(tmpChange(qualId,"I"))/tmpChange(qualId,"Total")*100,"",2)
	.s tmpRate(rate)=$g(tmpRate(rate))_$lb(qualId)
	
	s count=0,limit=5
	s ret="{""data"":["
	s rate="" f  s rate=$o(tmpRate(rate),-1) q:(count>limit)||(rate="")  d
	.s rateKey=0 f  s status=$listnext(tmpRate(rate),rateKey,qualId) q:(count>limit)||(status'=1)  d
	..s ARate=+$fn(+$g(tmpChange(qualId,"A"))/tmpChange(qualId,"Total")*100,"",2)_"%"
	..s NRate=+$fn(+$g(tmpChange(qualId,"N"))/tmpChange(qualId,"Total")*100,"",2)_"%"
	..s SRate=+$fn(+$g(tmpChange(qualId,"S"))/tmpChange(qualId,"Total")*100,"",2)_"%"
	..s QRate=+$fn(+$g(tmpChange(qualId,"Q"))/tmpChange(qualId,"Total")*100,"",2)_"%"
	..s BRate=+$fn(+$g(tmpChange(qualId,"B"))/tmpChange(qualId,"Total")*100,"",2)_"%"
	..s IRate=+$fn(+$g(tmpChange(qualId,"I"))/tmpChange(qualId,"Total")*100,"",2)_"%"
	..s qualRet="{""qualDesc"":"""_tmpItem(qualId)_""",""ARate"":"""_ARate_""",""NRate"":"""_NRate_""",""SRate"":"""_SRate_""",""QRate"":"""_QRate_""""
	..s qualRet=qualRet_",""BRate"":"""_BRate_""",""IRate"":"""_IRate_"""}"
	..s ret=ret_$case(count,0:"",:",")_qualRet
	..s count=count+1
	s ret=ret_"],""total"":"""_count_"""}"
	
	q ret
}

/// Description:获取质控问题项整改率Top10(按病区)
/// Date:2020-09-28
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:获取质控问题项整改率Top10
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindUpdateRateForWard(0,"2020-08-01","2020-08-31","","S")
ClassMethod FindUpdateRateForWard(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String) As %Status
{
	i (loginId="")||(startDate'["-")||(endDate'["-")||(scopt="") q "{""data"":[],""total"":""0""}"
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s checkType=$tr(checkType,"_","|")
	
	d ..SetQuesRateTMP(loginId,startDate,endDate,checkType,scopt,.tmpItem,.tmpCheck,.tmpError,.tmpErrorWard,.tmpCheckWard,.tmpChange,.tmpChangeWard)
	
	k tmpRate
	s qualId="" f  s qualId=$o(tmpChangeWard(qualId)) q:qualId=""  d
	.s wardId="" f  s wardId=$o(tmpChangeWard(qualId,wardId)) q:wardId=""  d
	..s rate=+$fn(+$g(tmpChangeWard(qualId,wardId,"A"))+$g(tmpChangeWard(qualId,wardId,"I"))/tmpChangeWard(qualId,wardId,"Total")*100,"",2)
	..s tmpRate(qualId,rate)=$g(tmpRate(qualId,rate))_$lb(wardId)
	
	s count=0,limit=9
	s ret="{""data"":["
	s qualId="" f  s qualId=$o(tmpRate(qualId),-1) q:qualId=""  d
	.s qualRet="{""qualDesc"":"""_tmpItem(qualId)_""",""items"":["
	.s index=0
	.s rate="" f  s rate=$o(tmpRate(qualId,rate),-1) q:(index>limit)||(rate="")  d
	..s rateKey=0 f  s status=$listnext(tmpRate(qualId,rate),rateKey,wardId) q:(index>limit)||(status'=1)  d
	...s ARate=+$fn(+$g(tmpChangeWard(qualId,wardId,"A"))/tmpChangeWard(qualId,wardId,"Total")*100,"",2)_"%"
	...s NRate=+$fn(+$g(tmpChangeWard(qualId,wardId,"N"))/tmpChangeWard(qualId,wardId,"Total")*100,"",2)_"%"
	...s SRate=+$fn(+$g(tmpChangeWard(qualId,wardId,"S"))/tmpChangeWard(qualId,wardId,"Total")*100,"",2)_"%"
	...s QRate=+$fn(+$g(tmpChangeWard(qualId,wardId,"Q"))/tmpChangeWard(qualId,wardId,"Total")*100,"",2)_"%"
	...s BRate=+$fn(+$g(tmpChangeWard(qualId,wardId,"B"))/tmpChangeWard(qualId,wardId,"Total")*100,"",2)_"%"
	...s IRate=+$fn(+$g(tmpChangeWard(qualId,wardId,"I"))/tmpChangeWard(qualId,wardId,"Total")*100,"",2)_"%"
	...s qualRet=qualRet_$case(index,0:"",:",")_"{""wardDesc"":"""_tmpChangeWard(qualId,wardId,"WardDesc")_""",""ARate"":"""_ARate_""""
	...s qualRet=qualRet_",""NRate"":"""_NRate_""",""SRate"":"""_SRate_""",""QRate"":"""_QRate_""""_",""BRate"":"""_BRate_""",""IRate"":"""_IRate_"""}"
	...s index=index+1
	.s qualRet=qualRet_"]}"
	.s ret=ret_$case(count,0:"",:",")_qualRet
	.s count=count+1
	s ret=ret_"],""total"":"""_count_"""}"
	
	q ret
}

/// Description:保存pad版本信息
/// Date:2020-09-28
/// Creator:wangpf
/// Table:CF.DHCINM.Set.MgVersion
/// Input:parr:版本信息
/// Output:
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).SavePadVersion("AppId|com.mediway.nqc","修复Bug","有新版本更新","2.1.2","http://172.22.31.13/dthealth/web/csp/static/pad/nqc.wgt")
ClassMethod SavePadVersion(AppId, AppNote, AppTitle, AppVersion, AppUrl) As %String [ WebMethod ]
{
	k tmp
	;d ##class(DHCINM.WebService.INMServerUtilComm).SplitStr(parr,"^","|",.tmp)
	s obj=##class(CF.DHCINM.Set.MgVersion).%OpenId(1)
	s:'$IsObject(obj) obj=##class(CF.DHCINM.Set.MgVersion).%New()
	s obj.AppId=$g(AppId)
	s obj.AppNote=$g(AppNote)
	s obj.AppTitle=$g(AppTitle)
	s obj.AppVersion=$g(AppVersion)
	s obj.AppUrl=$g(AppUrl)
	s sc=obj.%Save()
	
	s code=1,msg="",ret=""
    s:$$$ISERR(sc) code=0,msg="保存pad版本信息失败"
    q ##class(DHCINM.WebService.INMServerUtilComm).returnJson(code,msg,ret)
}

/// Description:获取pad版本信息
/// Date:2020-09-28
/// Creator:wangpf
/// Table:CF.DHCINM.Set.MgVersion
/// Input:
/// Output:pad版本信息
/// Other:w ##class(DHCINM.WebService.INMMobileComm).GetPadVersion()
ClassMethod GetPadVersion() As %String [ WebMethod ]
{
	s obj=##class(CF.DHCINM.Set.MgVersion).%OpenId(1)
	s ret=##class(%ArrayOfDataTypes).%New()
	s AppId=""
    s AppNote=""
    s AppTitle=""
    s AppVersion=""
    s AppUrl=""
	i $IsObject(obj) d
	.s AppId=obj.AppId
    .s AppNote=obj.AppNote
    .s AppTitle=obj.AppTitle
    .s AppVersion=obj.AppVersion
    .s AppUrl=obj.AppUrl
    d ret.SetAt(AppId,"AppId")
    d ret.SetAt(AppNote,"AppNote")
    d ret.SetAt(AppTitle,"AppTitle")
    d ret.SetAt(AppUrl,"AppUrl")
    d ret.SetAt(AppVersion,"AppVersion")
    d ret.SetAt("1","RowID")
    s ret1=##class(Nur.JSON).Encode(ret)
    s code=0,msg=""
    s:ret1="" code=1,msg="获取pad版本信息失败"
    q ##class(DHCINM.WebService.INMServerUtilComm).returnJson(code,msg,ret1)
}

/// Description:获取病区在院病人列表
/// Date:2020-09-28
/// Creator:wangpf
/// Table:PAADM
/// Input:
/// Output:病区在院病人列表
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindWardPatList(1)
ClassMethod FindWardPatList(ward As %String = "") As %String [ WebMethod ]
{
	q:ward="" "{""data"":[],""total"":""0""}"
	k retTmp
	s retTmp=""
	s wardGlo=^CF.DHCINM.DB.MgWardD(ward)
	s ret="{""data"":[",count=0
	s ctLoc=$lg(wardGlo,2)
	i ctLoc'="" d
	.s pacWard=$o(^PAWARD(0,"WARD_LocationDR",ctLoc,""))
	.q:pacWard=""
	.s room="" f  s room=$o(^PAADMi("CurrWard",pacWard,room)) q:room=""  d
	..s episodeId=0 f  s episodeId=$o(^PAADMi("CurrWard",pacWard,room,episodeId)) q:episodeId=""  d
	...s admType=$p(^PAADM(episodeId),"^",2)
	...q:admType'="I"
	...s regId=$p(^PAADM(episodeId),"^",1)
	...s regNo=$tr($justify(regId,10)," ","0")
	...s patName=$p(^PAPER(regId,"ALL"),"^",1)
	...s patAge=$p(^PAPER(regId,"ALL"),"^",6)
	...s patSex=$p(^PAPER(regId,"ALL"),"^",7)
	...s:patSex'="" patSex=$p(^CT("SEX",patSex),"^",2)
	...s:patAge'="" patAge=$e($zd(+$h,3),1,4)-$e($zd(patAge,3),1,4)
	...s bedCode="",bedSort=9999
	...s bedId=$p(^PAADM(episodeId),"^",73)
	...i bedId'="" d
	....s bedWardId=$p(bedId,"||")
	....s bedSubId=$p(bedId,"||",2)
	....s bedCode=$p(^PAWARD(bedWardId,"BED",bedSubId),"^",1)
	....s bedSort=$p(^PAWARD(bedWardId,"BED",bedSubId),"^",24)
	...s diagnos=""
	...s mrAdm=$p(^PAADM(episodeId),"^",61)
	...i mrAdm'="" d
	....s index=1,mrDiagnosId=0 f  s mrDiagnosId=$o(^MR(mrAdm,"DIA",mrDiagnosId)) q:mrDiagnosId=""  d
	.....s icd=$p(^MR(mrAdm,"DIA",mrDiagnosId),"^",1)
	.....q:icd=""
	.....s icdDesc=$p(^MRC("ID",icd),"^",2)
	.....s icdSuffix=$g(^MR(mrAdm,"DIA",mrDiagnosId,"DES",1))
	.....s diagStat=$p(^MR(mrAdm,"DIA",mrDiagnosId),"^",9)
	.....s:diagStat'="" diagStat=$p(^MRC("DSTAT",diagStat),"^",2)
	.....s diagnos=diagnos_$case(index,1:"",:" ")_index_"."_icdDesc_$select(icdSuffix'="":"("_icdSuffix_")",1:"")_$select(diagStat'="":" "_diagStat,1:"")
	.....s index=index+1
	...s:bedCode'="" patName=patName_"("_bedCode_")"
	...s tRet="{""AdmId"":"""_episodeId_""",""PAPatMasId"":"""_regId_""",""PatientName"":"""_patName_""",""PatientAge"":"""_patAge_""",""PatientSex"":"""_patSex_""",""PatientDiagnos"":"""_diagnos_""""
	...s tRet=tRet_",""BedCode"":"""_bedCode_""",""RegNo"":"""_regNo_"""}"
	...s:bedCode="" bedCode="ZZZZ"
	...s bedCode="+"_bedCode
	...s:bedSort'="" bedCode=bedSort
	...s retTmp(bedCode,episodeId)=tRet
	s bedCode="" f  s bedCode=$O(retTmp(bedCode)) q:bedCode=""  d
	.s episodeId="" f  s episodeId=$O(retTmp(bedCode,episodeId)) q:episodeId=""  d
	..s ret=ret_$case(count,0:"",:",")_$g(retTmp(bedCode,episodeId))
	..s count=count+1
	s ret=ret_"],""total"":"""_count_"""}"
	q ret
}

/// Description:获取病区护士列表
/// Date:2020-09-28
/// Creator:wangpf
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output:病区护士列表
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindWardNurseList(1)
ClassMethod FindWardNurseList(ward As %String = "") As %String [ WebMethod ]
{
	q:ward="" "{""data"":[],""total"":""0""}"
 	
 	s ret="{""data"":[",count=0
 	s wardId="" f  s wardId=$o(^CF.DHCINM.HR.PersonsI("DepID",wardId)) q:wardId=""  d
 	.s tmpWard=$tr(wardId," ","")
 	.q:tmpWard'=ward
 	.k tmp
 	.s perId="" f  s perId=$o(^CF.DHCINM.HR.PersonsI("DepID",wardId,perId)) q:perId=""  d
 	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
 	..q:'$IsObject(obj)
 	..s perID=obj.PerID
 	..s:perID="" perID=" "
 	..s tmp(perID,perId)="{""Per"":"""_perId_""",""PerName"":"""_obj.PerName_"""}"
 	.s perID="" f  s perID=$o(tmp(perID)) q:perID=""  d
 	..s perId="" f  s perId=$o(tmp(perID,perId)) q:perId=""  d
 	...s ret=ret_$case(count,0:"",:",")_tmp(perID,perId)
 	...s count=count+1
 	
 	s ret=ret_"],""total"":"""_count_"""}"
 	q ret
}

/// Description:获取患者姓名
/// Date:2020-09-28
/// Creator:wangpf
/// Table:
/// Input:
/// Output:患者姓名
/// Other:w ##class(DHCINM.WebService.INMMobileComm).GetPatName(1)
ClassMethod GetPatName(PAPatMasId As %String = "") As %String [ WebMethod ]
{
	s patName=""
	s:PAPatMasId'="" patName=$p($g(^PAPER(PAPatMasId,"ALL")),"^",1)
	s ret="PatientName|"_patName
	s result=##class(DHCINM.WebService.INMServerUtilComm).StrToJson(ret,"^","|")
	q ##class(DHCINM.WebService.INMServerUtilComm).returnJson(1,"",result)
}

/// 获取患者年龄
ClassMethod GetPatAge(patAge) As %String
{
	q:patAge="" ""
	s patage=##class(web.INMVueComm).CalAge(patAge,+$h)
	s years=""
	i +patage>6 s years=+patage_"岁"
	e  i +patage'=0 d
	.i +$P(patage," ")'=0 s years=years_+$P(patage," ")_"岁"
	.i +$P(patage," ",2)'=0 s years=years_+$P(patage," ",2)_"月"
	.s:years="" years="<1天"
	e  d
	.i +$P(patage," ",2)'=0 s years=years_+$P(patage," ",2)_"月"
	.i +$P(patage," ",3)'=0 s years=years_+$P(patage," ",3)_"天"
	.s:years="" years="<1天"
	q years
}

/// 获取诊断名称【产品部要求格式统一】
ClassMethod GetDiagnosDesc(mrAdm As %String = "", mrDiagnosId As %String = "") As %String
{
	q:((mrAdm="")||(mrDiagnosId="")) ""
	s icd=$p(^MR(mrAdm,"DIA",mrDiagnosId),"^",1) ;MRCICDDx
	q:icd="" ""
	s icdDesc=$p(^MRC("ID",icd),"^",2)
	s Prefix=$p($g(^MR(mrAdm,"DIA",mrDiagnosId,1)),"^",26)
	s Suffix=$g(^MR(mrAdm,"DIA",mrDiagnosId,"DES",1))
	s diagStat=$p($g(^MR(mrAdm,"DIA",mrDiagnosId)),"^",9)
	s:diagStat'="" diagStat=$p(^MRC("DSTAT",diagStat),"^",2)
	s diagnos=Prefix_icdDesc_Suffix_$select(diagStat'="":" "_diagStat,1:"")
	q diagnos
}

/// Description:根据住院号获取患者就诊记录
/// Date:2020-09-27
/// Creator:wangpf
/// Table:
/// Input:住院号
/// Output:就诊记录
/// Other:d ##class(%ResultSet).RunQuery("DHCINM.WebService.INMMobileComm","FindAdmList","100004")
Query FindAdmList(medicalNo As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindAdmListExecute(ByRef qHandle As %Binary, medicalNo As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i medicalNo=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s medicalNo=$zcvt(medicalNo,"U")
	s regId=$o(^PAPERi("Medicare1",medicalNo,""))
	
	k tmp
	i regId'="" d
	.s regNo=$p(^PAPER(regId,"ALL"),"^",1)
	.s patientName=$p(^PAPER(regId,"ALL"),"^",1)
	.s patientAge=$p(^PAPER(regId,"ALL"),"^",6)
	.s patientSex=$p(^PAPER(regId,"ALL"),"^",7)
	.s:patientSex'="" patientSex=$p(^CT("SEX",patientSex),"^",2)
	.s patientAge=..GetPatAge(patientAge)
	.s admType="" f  s admType=$o(^PAPERdr(regId,"ADM",admType)) q:admType=""  d
	..s adTypeDesc=$case(admType,"I":"住院","O":"门诊","E":"急诊","N":"新生儿","H":"体检",:"")
	..s admId="" f  s admId=$o(^PAPERdr(regId,"ADM",admType,admId)) q:admId=""  d
	...s admDate=$p(^PAADM(admId),"^",6)
	...s admDateH=admDate
	...s:admDate'="" admDate=$zd(admDate,3)
	...s admTime=$p(^PAADM(admId),"^",7)
	...s:admTime'="" admTime=$zt(admTime,1)
	...s admCTLoc=$p(^PAADM(admId),"^",4)
	...s admCTLocDesc=""
	...s:admCTLoc'="" admCTLocDesc=$p(^CTLOC(admCTLoc),"^",2)
	...s mrAdm=$p(^PAADM(admId),"^",61)
	...s diagnos=""
	...i mrAdm'="" d
	....s index=1,mrDiagnosId=0 f  s mrDiagnosId=$o(^MR(mrAdm,"DIA",mrDiagnosId)) q:mrDiagnosId=""  d
	.....s icd=$p(^MR(mrAdm,"DIA",mrDiagnosId),"^",1)
	.....q:icd=""
	.....s icdDesc=..GetDiagnosDesc(mrAdm,mrDiagnosId)
	.....q:icdDesc=""
	.....s diagnos=diagnos_$case(index,1:"",:" ")_index_"."_icdDesc
	.....s index=index+1
	...s bedCode=""
	...s ret="AdmId|"_admId_"^PAPatMasId|"_regId_"^PatientName|"_patientName_"^PatientAge|"_patientAge_"^PatientSex|"_patientSex_"^PatientDiagnos|"_diagnos
	...s ret=ret_"^BedCode|"_bedCode_"^RegNo|"_regNo
	...s tmp(admDateH,admId)=ret
	
	s date="" f  s date=$o(tmp(date),-1) q:date=""  d
	.s id="" f  s id=$O(tmp(date,id)) q:id=""  d
	..s ret=tmp(date,id)
	..d OutAdmList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAdmList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
