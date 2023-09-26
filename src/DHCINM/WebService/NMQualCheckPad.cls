/// DHCINM.WebService.NMQualCheckPad
Class DHCINM.WebService.NMQualCheckPad Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "NMQualCheckPad";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://www.dhcc.com.cn";

// Parameter LOCATION = "http://10.37.2.6:57772/imedical/webservice/";

Parameter LOCATION = "http://10.1.20.210:57772/dthealth/web/";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

/// Code:001
/// Creator: jyc
/// CreatDate: 2019-10-09
/// Description: 验证工号、密码，返回登录信息
/// Other:w ##class(DHCNMG.WebService.MgNurCheckPad).InterfaceLogon("hs01","1")
ClassMethod InterfaceLogon(userCode As %String, password As %String) As %String [ WebMethod ]
{
	s InResult=""
	s InResult=##class(DHCINM.WebService.INMMobileComm).Logon(userCode,password)
	q InResult
}

/// Description:获取查房单数量(按状态)
/// CreateDate:2020-09-22
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 检查月份
/// Output:待检查数量、已保存数量、已检查数量、全部数量
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).GetCheckSurvey("158","2020-09")
ClassMethod GetCheckSurvey(loginId As %String, checkMonth As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).GetCheckSurvey(loginId,checkMonth)
	s resultCode=0,msg=""
	q ##class(DHCINM.WebService.INMServerUtilComm).returnJson(resultCode,msg,InResult)
}

/// Description:获取查房单数量(按级别)
/// CreateDate:2020-09-22
/// Creator: wangpf
/// Table:HCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 检查月份 状态(A:全部,N:未检查,Y:已检查,S:已保存)
/// Output:护理部级别数量、科室级别数量、病区级别数量、全部数量
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).GetCheckLevelNum("158","2020-09","A")
ClassMethod GetCheckLevelNum(loginId As %String, checkMonth As %String, checkStatus As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).GetCheckLevelNum(loginId,checkMonth,checkStatus)
	s resultCode=0,msg=""
	q ##class(DHCINM.WebService.INMServerUtilComm).returnJson(resultCode,msg,InResult)
}

/// Description:获取查房单数量(按质控类型)
/// CreateDate:2020-09-22
/// Creator: wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 检查月份 状态(A:全部,N:未检查,Y:已检查,S:已保存) 级别(A:全部,H:护理部,L:科级,W:病区)
/// Output:查房单数量(按质控类型)
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).GetCheckType("158","2020-09","A","A")
ClassMethod GetCheckType(loginId As %String, checkMonth As %String, status As %String, level As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).GetCheckType(loginId,checkMonth,status,level)
	s resultCode=0,msg=""
	q ##class(DHCINM.WebService.INMServerUtilComm).returnJson(resultCode,msg,InResult)
}

/// Description:获取检查单(按质控项目或病区)
/// CreateDate:2020-09-22
/// Creator: wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 检查月份 状态(A:全部,N:未检查,Y:已检查,S:已保存) 级别(A:全部,H:护理部,L:科级,W:病区) 质控类型Id 模式(T:任务模式,W:病区模式)
/// Output:检查单(按质控项目或病区)
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindCheckForm("158","2020-09","A","A","5__1","T")
ClassMethod FindCheckForm(loginId As %String, checkMonth As %String, status As %String, level As %String, type As %String, flag As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindCheckForm(loginId,checkMonth,status,level,type,flag)
	q InResult
}

/// Description:获取检查单(按日期)
/// CreateDate:2020-09-23
/// Creator: wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 检查月份 质控类型Id
/// Output:检查单(按日期)
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindCheckDateList("158","2020-09","5__1^5__2")
ClassMethod FindCheckDateList(loginId As %String, checkMonth As %String, type As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindCheckDateList(loginId,checkMonth,$tr(type,$c(0)))
	q InResult
}

/// Description:获取全部质控类型
/// CreateDate:2020-09-23
/// Creator: wangpf
/// Table:CT.DHCINM.Set.MgSysParam CT.DHCINM.Set.MgSysParamSub
/// Input:
/// Output:全部质控类型
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindCheckTypeList()
ClassMethod FindCheckTypeList() As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindCheckTypeList()
	q InResult
}

/// Description:获取指定日期之间的质控检查项目
/// CreateDate:2020-09-23
/// Creator: wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 质控类型Id 开始日期 结束日期
/// Output:指定日期之间的质控检查项目
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).GetCheckProject(0,"5__1","2020-08-01","2020-08-31")
ClassMethod GetCheckProject(loginID As %String, checkTypeI As %String, startDate As %String, endDate As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).GetCheckProject(loginID,checkTypeI,startDate,endDate)
	q InResult
}

/// Description:获取指定日期之间的质控检查病区
/// CreateDate:2020-09-23
/// Creator: wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 质控类型Id 开始日期 结束日期
/// Output:指定日期之间的质控检查病区
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).GetCheckWard(0,"5__1","2020-08-01","2020-08-31")
ClassMethod GetCheckWard(loginID As %String, checkTypeI As %String, startDate As %String, endDate As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).GetCheckWard(loginID,checkTypeI,startDate,endDate)
	q InResult
}

/// Description:获取指定日期之间的质控检查类型及数量
/// Date:2020-09-23
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 质控类型Id 开始日期 结束日期 类型(S:按管辖病区,L:按检查人)
/// Output:指定日期之间的质控检查类型及数量
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindCheckTypeListByDate(0,"2020-08-01","2020-08-31","S")
ClassMethod FindCheckTypeListByDate(loginId As %String, startDate As %String, endDate As %String, flag As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindCheckTypeListByDate(loginId,startDate,endDate,flag)
	q InResult
}

/// Description:获取指定日期之间的检查单
/// Date:2020-09-24
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 开始日期 结束日期 质控类型Id 状态(空:全部,N:未检查,Y:已检查,S:已保存) 级别(空:全部,H:护理部,L:科级,W:病区) 质控项目Id 病区Id 类型(S:按管辖病区,L:按检查人)
/// Output:指定日期之间的检查单
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindCheckItemListByType(0,"2020-08-01","2020-09-30","5__2","","","","","")
ClassMethod FindCheckItemListByType(loginId As %String, startDate As %String, endDate As %String, type As %String, checkstatus As %String, checklevel As %String, checkitem As %String, checkward As %String, flag As %String, start As %String = "", limit As %String = "") As %String [ WebMethod ]
{
	k tmp
	s tmp("loginId")=loginId,tmp("startDate")=startDate,tmp("endDate")=endDate,tmp("type")=type
	s tmp("checkstatus")=checkstatus,tmp("checklevel")=checklevel,tmp("checkitem")=checkitem
	s tmp("checkward")=checkward,tmp("flag")=flag
	s ret=##class(DHCINM.WebService.INMServerUtilComm).RecQueryExcute("DHCINM.WebService.INMMobileComm","FindCheckItemListByType",.tmp,start,limit)
	q ret
}

/// Description:获取检查单内容
/// Date:2020-09-25
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 质控任务Id 质控项目Id 质控类型Id 病区Id
/// Output:检查单内容
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).GetCheckScoreForm(0,4,1,"5__2",1)
ClassMethod GetCheckScoreForm(loginId As %String, releaseId As %String, qualId As %String, type As %String, wardId As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).GetCheckScoreForm(loginId,releaseId,qualId,type,wardId)
	q InResult
}

/// Description:获取检查结果
/// Date:2020-09-28
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input:夜查房基本信息 质控任务Id 病区Id 质控项目Id 打分表信息 总分 userId
/// Output:status=0:成功 status=1:失败
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).SaveCheckScoreForm()
ClassMethod SaveCheckScoreForm(basic As %String = "", taskId As %String = "", wardId As %String = "", qualId As %String = "", parr As %String = "", score As %String = "", status As %String = "", remark As %String = "", insert As %String = "", loginId As %String = "", checkDate As %String = "", checkAccordScore As %String = "", checkAccordScoreSum As %String = "", signName As %String = "", Picture As %String = "") As %String [ WebMethod ]
{
	;s ^Tmp("SaveCheckScoreForm")=basic_"^"_taskId_"^"_wardId_"^"_qualId_"^"_parr_"^"_score_"^"_status_"^"_remark_"^"_insert_"^"_loginId_"^"_checkDate
	s InResult=##class(DHCINM.WebService.INMMobileComm).SaveCheckScoreForm(basic,taskId,wardId,qualId,parr,score,status,remark,insert,loginId,checkDate,checkAccordScore,checkAccordScoreSum,signName,Picture)
	q InResult
}

/// Description:获取质控检查成绩
/// Date:2020-09-25
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 质控级别(空:全部,H:护理部,L:科级,W:病区) 类型(S:按管辖病区,L:按检查人) 类型(P:排行榜,F:分数统计分析)
/// Output:质控检查成绩
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindCheckScoreListByType(0,"2020-08-01","2020-09-30","","","S","P")
ClassMethod FindCheckScoreListByType(loginId As %String, startDate As %String, endDate As %String, type As %String, checklevel As %String, flag As %String, clicktype As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindCheckScoreListByType(loginId,startDate,endDate,type,$tr(checklevel,$c(0)),flag,clicktype)
	q InResult
}

/// Description:获取质控问题
/// Date:2020-09-25
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:userId 开始日期 结束日期 级别(空:全部,H:护理部,L:科级,W:病区) 质控类型Id 质控项目Id 状态(空:全部,N:待解决,S:已处理,A:已解决,Q:问题上诉,B:驳回,I:忽略) 类型(S:按管辖病区,L:按检查人)
/// Output:质控问题
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindCheckQuestions(0,"2020-08-01","2020-09-30","","","","","S")
ClassMethod FindCheckQuestions(loginId As %String, startDate As %String, endDate As %String, level As %String, checkType As %String, checkproId As %String, status As %String, Scopt As %String, start As %String = "", limit As %String = "") As %String [ WebMethod ]
{
	k tmp
	s tmp("loginId")=loginId,tmp("startDate")=startDate,tmp("endDate")=endDate,tmp("level")=level
	s tmp("checkType")=checkType,tmp("checkproId")=checkproId,tmp("status")=status,tmp("Scopt")=Scopt
	s ret=##class(DHCINM.WebService.INMServerUtilComm).RecQueryExcute("DHCINM.WebService.INMMobileComm","FindCheckQuestions",.tmp,start,limit)
	q ret
}

/// Description:获取质控问题项错误率(按问题项)
/// Date:2020-09-27
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:质控问题项错误率
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindErrRateForQues(0,"2020-08-01","2020-08-31","","S")
ClassMethod FindErrRateForQues(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String, start As %String = "", limit As %String = "") As %String [ WebMethod ]
{
	k tmp
	s tmp("loginId")=loginId,tmp("startDate")=startDate,tmp("endDate")=endDate,tmp("checkType")=checkType,tmp("scopt")=scopt
	s ret=##class(DHCINM.WebService.INMServerUtilComm).RecQueryExcute("DHCINM.WebService.INMMobileComm","FindErrRateForQues",.tmp,start,limit)
	q ret
}

/// Description:获取质控问题项错误率(按质控项目)
/// Date:2020-09-27
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:质控问题项错误率
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindErrRateForQuesColumn(0,"2020-08-01","2020-08-31","","S")
ClassMethod FindErrRateForQuesColumn(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindErrRateForQuesColumn(loginId,startDate,endDate,checkType,scopt)
	q InResult
}

/// Description:获取质控问题项错误率(按病区)
/// Date:2020-09-27
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:质控问题项错误率
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindErrRateForWard(0,"2020-08-01","2020-08-31","","S")
ClassMethod FindErrRateForWard(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindErrRateForWard(loginId,startDate,endDate,checkType,scopt)
	q InResult
}

/// Description:获取质控问题项整改率Top6(按质控项目)
/// Date:2020-09-27
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:获取质控问题项整改率Top6
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindUpdateRateForQues(0,"2020-08-01","2020-08-31","","S")
ClassMethod FindUpdateRateForQues(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindUpdateRateForQues(loginId,startDate,endDate,checkType,scopt)
	q InResult
}

/// Description:获取质控问题项整改率Top10(按病区)
/// Date:2020-09-28
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:userId 开始日期 结束日期 质控类型Id 类型(S:按管辖病区,L:按检查人)
/// Output:获取质控问题项整改率Top10
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindUpdateRateForWard(0,"2020-08-01","2020-08-31","","S")
ClassMethod FindUpdateRateForWard(loginId As %String, startDate As %String, endDate As %String, checkType As %String, scopt As %String) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindUpdateRateForWard(loginId,startDate,endDate,checkType,scopt)
	q InResult
}

/// Description:保存pad版本信息
/// Date:2020-09-28
/// Creator:wangpf
/// Table:DHCINM.Set.MgVersion
/// Input:parr:版本信息
/// Output:
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).SavePadVersion("RowID|1^AppId|HelloMUI^AppNote|修复Bug^AppTitle|MUI版本更新^AppVersion|1.0.0^AppUrl|192.168.42.140/dthealth/web/csp/static/pad/pad.apk")
ClassMethod SavePadVersion(AppId, AppNote, AppTitle, AppVersion, AppUrl) As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).SavePadVersion(AppId, AppNote, AppTitle, AppVersion, AppUrl)
	q InResult
}

/// Description:获取pad版本信息
/// Date:2020-09-28
/// Creator:wangpf
/// Table:DHCINM.Set.MgVersion
/// Input:
/// Output:pad版本信息
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).GetPadVersion()
ClassMethod GetPadVersion() As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).GetPadVersion()
	q InResult
}

/// Description:获取病区在院病人列表
/// Date:2020-09-28
/// Creator:wangpf
/// Table:PAADM
/// Input:
/// Output:病区在院病人列表
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindWardPatList(3)
ClassMethod FindWardPatList(ward As %String = "") As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindWardPatList(ward)
	q InResult
}

/// Description:获取病区护士列表
/// Date:2020-09-28
/// Creator:wangpf
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output:病区护士列表
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindWardNurseList(1)
ClassMethod FindWardNurseList(ward As %String = "") As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).FindWardNurseList(ward)
	q InResult
}

/// Description:获取患者姓名
/// Date:2020-09-28
/// Creator:wangpf
/// Table:
/// Input:
/// Output:患者姓名
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).GetPatName(1)
ClassMethod GetPatName(PAPatMasId As %String = "") As %String [ WebMethod ]
{
	s InResult=##class(DHCINM.WebService.INMMobileComm).GetPatName(PAPatMasId)
	q InResult
}

/// Description:根据住院号获取患者就诊记录
/// Date:2020-09-27
/// Creator:wangpf
/// Table:
/// Input:住院号
/// Output:就诊记录
/// Other:w ##class(DHCINM.WebService.NMQualCheckPad).FindAdmList("100004",0,1)
ClassMethod FindAdmList(medicalNo As %String = "", start As %String = "", limit As %String = "") As %String [ WebMethod ]
{
	k tmp
	s tmp("medicalNo")=medicalNo
	s ret=##class(DHCINM.WebService.INMServerUtilComm).RecQueryExcute("DHCINM.WebService.INMMobileComm","FindAdmList",.tmp,start,limit)
	q ret
}

}
