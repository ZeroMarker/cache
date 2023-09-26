Import sqluser

/// Descript:   急诊医生相关统计查询类
/// Creator:    bianshuai
/// CreateDate: 2018-10-22
Class web.DHCEMDocMainQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:    bianshuai
/// CreateDate: 2018-04-10
/// Descript:   医生收治病人统计
/// InPut:      CstID - 会诊申请ID
/// OutPut:     医生收治病人列表
/// w ##Class(web.DHCEMDocMainQuery).JsGetDocTakPat("30","1","2019-09-03^2019-11-13^1^")
ClassMethod JsGetDocTakPat(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	s:StartDate="" StartDate=+$h-1
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:EndDate="" EndDate=+$h
	s EmDocID=$p(Params,"^",3)   /// 急诊医生ID
	s Pid=$p(Params,"^",4)       /// 计数器
	s LgHospID=$p(Params,"^",5)  /// 登录医院 hxy 2020-06-04

    i Pid="" s Pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(Pid) //k掉临时global
	k TMPEmDocArr
    s Num=0
	F dd=StartDate:1:EndDate D
    .s sTime=""
    .F  s sTime=$o(^PAADMi("PAADM_DateTime",dd,sTime)) Q:sTime=""  D
    ..s EpisodeID=""
    ..F  s EpisodeID=$o(^PAADMi("PAADM_DateTime",dd,sTime,EpisodeID))  Q:EpisodeID=""  D
	...Q:$p(^PAADM(EpisodeID),"^",2)'="E"            /// 申请状态
	...s PatLocID=$p($g(^PAADM(+EpisodeID)),"^",4) // 就诊科室 hxy 2020-06-04 st
	...s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
    ...Q:CurHospID'=LgHospID //ed
	...s WardDr = $p(^PAADM(EpisodeID),"^",70)
	...s WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)
	...s:WalkStatus'="" WalkStatus=$P(WalkStatus,"^",2)  //到达
	...s Compted = $p(^PAADM(EpisodeID,1),"^",23) 			   //界面处点击完成就诊按钮置标志
	...s:Compted="Y" WalkStatus = "到达"
	...s IsCESFlag=##Class(DHCDoc.Interface.StandAlone.Service).IsCESFlag("pa_adm",EpisodeID)
	...q:(WalkStatus'="到达")&&(WardDr="")&&(IsCESFlag'=1)
	...s CPrvID=$P($g(^PAADM(EpisodeID)),"^",9) 
	...Q:CPrvID="" //取医生ID
	...Q:(EmDocID'="")&(EmDocID'=CPrvID)
	...s CPrvUser=$p($g(^CTPCP(CPrvID,1)),"^",2)
	...s CPrvUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",CPrvUser)
	.../// 病人信息
	...s CPrvCode=$p($g(^CTPCP(+CPrvID,1)),"^",1)    /// 会诊工号
	...s CarePrvUser=$p($g(^CTPCP(+CPrvID,1)),"^",2) /// 会诊医生
	...s IndexNode=Pid_"||"_CPrvID
	...s PatEssInfo=##Class(web.DHCEMEmPatCheckLevStat).GetPatEssInfo(EpisodeID)
	...i '$d(TMPEmDocArr(CPrvID)) D
	....s Num=Num+1
	....s TMPEmDocArr(CPrvID)=CPrvID_"^"_CPrvCode_"^"_CPrvUser_"^"_1_"^"_Pid
	...E  s $p(TMPEmDocArr(CPrvID),"^",4)=$p(TMPEmDocArr(CPrvID),"^",4)+1
	...s ^TMP("DHCEM","web.DHCEMDocMainQuery","JsGetDocTakPat",Pid,CPrvID,$i(EmDoc(IndexNode)))=PatEssInfo
	
	i Num=0 W ##Class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="CPrvID^CPrvCode^CPrvUser^PatNums^Pid"
	W ##Class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPEmDocArr(index),-1) Q:index=""  D
	.s ListData=$g(TMPEmDocArr(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##Class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##Class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	//d ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-10
/// Descript:   医生收治病人统计
/// InPut:      Pid - 计数器, CPrvID - 医生ID 
/// OutPut:     就诊ID^病人ID^登记号^姓名^姓别^年龄^诊断^费别^就诊科室^病区^床号^更新人
/// w ##Class(web.DHCEMDocMainQuery).JsGetDocTakPatDetail("10","1","990","12610")
ClassMethod JsGetDocTakPatDetail(rows As %String, page As %String, Pid As %String, CPrvID) As %String
{
	n (rows,page,Pid,CPrvID,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
	
	///转换数据为Json格式
	s ListTitle="EpisodeID^PatientID^PatNo^PatName^PatSex^PatAge^PatDiag^BillType^PatLoc^PatWard^PatBed^UpdateUser"
	W ##Class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s index="",count=0
	F  s index=$o(^TMP("DHCEM","web.DHCEMDocMainQuery","JsGetDocTakPat",Pid,CPrvID,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCEM","web.DHCEMDocMainQuery","JsGetDocTakPat",Pid,CPrvID,index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##Class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##Class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCEM","web.DHCEMDocMainQuery","JsGetDocTakPat",pid)
	Q ""
}

}
