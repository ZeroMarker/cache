Import sqluser

Class web.DHCSTPHCMADRREPORTQUERY Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询不良反应报告
/// w ##class(web.DHCSTPHCMADRREPORTQUERY).QueryAdrReport("30","1","2016-10-30^2016-11-01^^^198^36^578^W^2^^")
ClassMethod QueryAdrReport(rows As %String, page As %String, StrParam As %String) As %String
{
	n (rows,page,StrParam)
    s ^tlq("StrParam")=StrParam
	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	s StDate=$p(StrParam,"^",1)    //开始日期
	s EndDate=$p(StrParam,"^",2)   //结束日期
	s DeptID=$p(StrParam,"^",3)    //科室
	s PatNo=$p(StrParam,"^",4)     //登记号
	s GroupId=$p(StrParam,"^",5)   //安全组ID
    s LocId=$p(StrParam,"^",6)     //科室ID
    s UserId=$p(StrParam,"^",7)    //用户ID
    s StatType=$p(StrParam,"^",8)
    s HospID=$p(StrParam,"^",9)    //医院ID
    s UnitEvaFlag=$p(StrParam,"^",10)    //单位评价
    s Inci=$p(StrParam,"^",11)    //库存项ID
    s Params=GroupId_"^"_LocId_"^"_UserId

    ///获取授权审批状态
	s StatusGrantID=##class(web.DHCSTPHCMCOMMON).GetUserStatusGrant("",Params)
	q:StatusGrantID="" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //未设置任何权限
	s retStatusID=##Class(web.DHCSTPHCMCOMMON).GetAdrStatusIDByCode("99")  ///退回状态ID
   	d ..killTmpGlobal(pid)
	s StDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StDate) ;$zdh(StDate,3)
	s EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)
	s QuitFlag=0
	s Num=0
	f dd=StDate:1:EndDate d
	.s adrRepID=""
	.f  S adrRepID=$o(^DHCPHADRR(0,"RepDate",dd,adrRepID)) Q:adrRepID=""  D
	..s AdrRepStatusID=$p(^DHCPHADRR(adrRepID),"^",45) //当前状态  未提交的时候没有值，提交以后就有值了（提交以后就自动变成8即新建状态的值了）
	..s NextStatus="",AdrRepStatus=""
	..s:AdrRepStatusID'="" AdrRepStatus=$p($G(^DHCPHADRS(AdrRepStatusID)),"^",2)  
	..i AdrRepStatus="" s AdrRepStatus="未提交" s AdrRepStatusID=""               //如果没有值（可能将那个维护的数据删掉了，导致没值）又将他置成未提交状态
	..s NextStatusID=##class(web.DHCSTPHCMCOMMON).getNextStauts("",AdrRepStatusID) // 获取下一个状态的id
	..;s:NextStatusID'="" NextStatus=$p(^DHCPHADRS(NextStatusID),"^",2) //wyx add 2015-02-12
	..s:NextStatusID'="" NextStatus=$p($G(^DHCPHADRS(NextStatusID)),"^",2)  //wangxuejian 2016-10-27
	..
	..q:(AdrRepStatusID'=retStatusID)&(StatType="R") //当前下拉框的判断条件是退回，当前状态的id和退回状态的id不相同（这个可以将不是退回状态的全部退出）
	..q:((AdrRepStatusID="")||(AdrRepStatusID=retStatusID))&(StatType="C") //当前下拉框的条件为已提交状态，那么未提交状态和退回状态就退出 wangxuejian 2016/10/28
	..q:(AdrRepStatusID'="")&(StatType="N")  //当前下拉框是未提交状态，那么已提交和退回状态的全部退出
	..q:((AdrRepStatusID="")||(NextStatusID'=StatusGrantID))&(StatType="W")    //下一状态不是登录人的授权状态时,退出
	..q:(AdrRepStatusID'=StatusGrantID)&(StatType="A")
	..s adrrEvtCDept=$p(^DHCPHADRR(adrRepID),"^",31)   //报告单位评价
	..q:(UnitEvaFlag'="")&(UnitEvaFlag'=adrrEvtCDept)
	..
	..s quitflag=1
	..i Inci'="" s quitflag=..CheckIfConSpecDrug(adrRepID,Inci)
	..q:quitflag=0
	..
	..s AdrRepNo=$p(^DHCPHADRR(adrRepID),"^",1)   //编号
	..s AdrRepDate=$p(^DHCPHADRR(adrRepID),"^",2) //日期
	..i AdrRepDate'="" S AdrRepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdrRepDate) ;$zd(AdrRepDate,3)
	..s AdrPatID=$p(^DHCPHADRR(adrRepID),"^",7)     //病人ID
	..s AdrPatName=$p(^DHCPHADRR(adrRepID),"^",8)   //病人姓名
	..s AdrPatMedNo=$p(^DHCPHADRR(adrRepID),"^",15) //病历号/门诊号
	..s AdrReporter=$p(^DHCPHADRR(adrRepID),"^",30) //报告人
	..s AdrRepLoc=+$p(^DHCPHADRR(adrRepID),"^",37)   //报告科室
	..s AdrRetReason=$p(^DHCPHADRR(adrRepID),"^",48)   //退回原因
	..q:(HospID'="")&(HospID'=$p(^CTLOC(AdrRepLoc),"^",22))
	..q:(DeptID'="")&(DeptID'=AdrRepLoc)
	..s:AdrRepLoc'="" AdrRepLoc=$p($p(^CTLOC(AdrRepLoc),"^",2),"-",2)
	..s AdrPatNo="",InMedicare=""
	..s AdrPatNo=$p($G(^PAPER(AdrPatID,"PAT",1)),"^",1)       //登记号
	..s InMedicare=$p($g(^PAPER(AdrPatID,"PAT",3)),"^",4) //病案号
	..q:(PatNo'="")&(PatNo'=AdrPatNo)
	..s ListData=adrRepID_"^"_AdrRepNo_"^"_AdrPatNo_"^"_AdrPatName_"^"_AdrRepStatus_"^"_AdrRepLoc_"^"_AdrReporter_"^"_AdrRepDate_"^"_NextStatusID_"^"_AdrRetReason
	..
	..s Num=Num+1
	..s ^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAdrReport",pid,Num)=ListData
	
	q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAdrReport",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAdrReport",pid,index)
	.S Title="AdrReqID^AdrReqNo^PatNo^PatName^AdrRepStatus^AdrRepLoc^AdrReporter^AdrRepDate^AdrNextStatus^AdrRetReason"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:查询审核界面的不良反应报告
/// w ##class(web.DHCSTPHCMADRREPORTQUERY).QueryCompAdrReport("30","1","2016-10-03^2016-10-31^^^177^36^578^^2")
ClassMethod QueryCompAdrReport(rows As %String, page As %String, StrParam As %String) As %String
{
	n (rows,page,StrParam)
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	s StDate=$p(StrParam,"^",1)    //开始日期
	s StDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StDate) ;$zdh(StDate,3)
	s EndDate=$p(StrParam,"^",2)   //结束日期
	s EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)
	s DeptID=$p(StrParam,"^",3)    //科室
	s PatNo=$p(StrParam,"^",4)     //登记号
	s GroupId=$p(StrParam,"^",5)   //安全组ID
    s LocId=$p(StrParam,"^",6)     //科室ID
    s UserId=$p(StrParam,"^",7)    //用户ID
    s StatType=$p(StrParam,"^",8)
    s HospID=$p(StrParam,"^",9)    //医院ID

	s retStatusID=##Class(web.DHCSTPHCMCOMMON).GetAdrStatusIDByCode("99")  ///退回状态ID
	s QuitFlag=0
	s Num=0
	f dd=StDate:1:EndDate d
	.s adrRepID=""
	.f  S adrRepID=$o(^DHCPHADRR(0,"RepDate",dd,adrRepID)) Q:adrRepID=""  D
	..s AdrRepStatusID=$p(^DHCPHADRR(adrRepID),"^",45) //当前状态
	..s NextStatus="",AdrRepStatus=""
	..s:AdrRepStatusID'="" AdrRepStatus=$p($G(^DHCPHADRS(AdrRepStatusID)),"^",2)
	..i AdrRepStatus="" s AdrRepStatus="未提交"
	..s NextStatusID=##class(web.DHCSTPHCMCOMMON).getNextStauts("",AdrRepStatusID)
	..;s:NextStatusID'="" NextStatus=$p(^DHCPHADRS(NextStatusID),"^",2) //wyx add 2015-02-12
	..s:NextStatusID'="" NextStatus=$p($G(^DHCPHADRS(NextStatusID)),"^",2)  //wangxuejian 2016-10-27		
	..q:(AdrRepStatusID'=retStatusID)&(StatType="R")
	..;q:(AdrRepStatusID="")&(StatType'="N")  //wangxuejian 2016/10/31
	..q:((AdrRepStatusID="")||(AdrRepStatusID=retStatusID))&(StatType="C")
	..q:(AdrRepStatusID'="")&(StatType="N")
	..;q:StatType="N"


	..s AdrRepNo=$p(^DHCPHADRR(adrRepID),"^",1)   //编号
	..s AdrRepDate=$p(^DHCPHADRR(adrRepID),"^",2) //日期
	..i AdrRepDate'="" S AdrRepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdrRepDate) ;$zd(AdrRepDate,3)
	..s AdrPatID=$p(^DHCPHADRR(adrRepID),"^",7)     //病人ID
	..s AdrPatName=$p(^DHCPHADRR(adrRepID),"^",8)   //病人姓名
	..s AdrPatMedNo=$p(^DHCPHADRR(adrRepID),"^",15) //病历号/门诊号
	..s AdrReporter=$p(^DHCPHADRR(adrRepID),"^",30) //报告人
	..s AdrRepLoc=+$p(^DHCPHADRR(adrRepID),"^",37)   //报告科室
	..q:(HospID'="")&(HospID'=$p(^CTLOC(AdrRepLoc),"^",22))
	..s AdrRetReason=$p(^DHCPHADRR(adrRepID),"^",48)   //退回原因
	..q:(DeptID'="")&(DeptID'=AdrRepLoc)
	..s:AdrRepLoc'="" AdrRepLoc=$p($p(^CTLOC(AdrRepLoc),"^",2),"-",2)
	..s AdrPatNo="",InMedicare=""
	..s AdrPatNo=$p($G(^PAPER(AdrPatID,"PAT",1)),"^",1)       //登记号
	..s InMedicare=$p($g(^PAPER(AdrPatID,"PAT",3)),"^",4) //病案号
	..q:(PatNo'="")&(PatNo'=AdrPatNo)
	..s ListData=adrRepID_"^"_AdrRepNo_"^"_AdrPatNo_"^"_AdrPatName_"^"_AdrRepStatus_"^"_AdrRepLoc_"^"_AdrReporter_"^"_AdrRepDate_"^"_NextStatusID_"^"_AdrRetReason
	..
	..s Num=Num+1
	..s ^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAdrReport",pid,Num)=ListData
	
	q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAdrReport",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAdrReport",pid,index)
	.S Title="AdrReqID^AdrReqNo^PatNo^PatName^AdrRepStatus^AdrRepLoc^AdrReporter^AdrRepDate^AdrNextStatus^AdrRetReason"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:查询某个患者的不良反应报告列表
ClassMethod QueryPatAdrReport(rows As %String, page As %String, EpisodeID As %String) As %String
{
	n (rows,page,EpisodeID)

	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行

	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	d ..killTmpGlobal(pid)
	s QuitFlag=0
	s Num=0
	s adrRepID=""
	f  S adrRepID=$o(^DHCPHADRR(0,"PatientID",PatientID,adrRepID)) Q:adrRepID=""  D
	.s AdrRepStatusID=$p(^DHCPHADRR(adrRepID),"^",45) //当前状态
	.s:AdrRepStatusID'="" AdrRepStatus=$p(^DHCPHADRS(AdrRepStatusID),"^",2)
	.s:AdrRepStatusID="" AdrRepStatus="未提交"
	.s AdrRepNo=$p(^DHCPHADRR(adrRepID),"^",1)     //编号
	.s AdrRepDate=$p(^DHCPHADRR(adrRepID),"^",2)   //日期
	.i AdrRepDate'="" S AdrRepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdrRepDate) ;$zd(AdrRepDate,3)
	.s AdrPatID=$p(^DHCPHADRR(adrRepID),"^",7)     //病人ID
	.s AdrPatName=$p(^DHCPHADRR(adrRepID),"^",8)   //病人姓名
	.s AdrReporter=$p(^DHCPHADRR(adrRepID),"^",30) //报告人
	.s AdrPatNo=""
	.i AdrPatID'="" d
	..s AdrPatNo=$p(^PAPER(AdrPatID,"PAT",1),"^",1)       //登记号
	.s ListData=adrRepID_"^"_AdrRepDate_"^"_AdrRepNo_"^"_AdrPatNo_"^"_AdrPatName_"^"_AdrRepStatus_"^"_AdrReporter
	.
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAdrReport",pid,Num)=ListData
	
	q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAdrReport",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAdrReport",pid,index)
	.S Title="AdrReqID^AdrRepDate^AdrReqNo^PatNo^PatName^AdrRepStatus^AdrReporter"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:审核日志
ClassMethod QueryAuditLog(AdrReqID As %String) As %String
{
	N (AdrReqID)
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	S Num=0
	S childsub=""
	F  S childsub=$o(^DHCPHADRR(AdrReqID,"ADRRA",childsub)) Q:childsub=""  D
	.S AuditStatus=$p(^DHCPHADRR(AdrReqID,"ADRRA",childsub),"^",1) //状态
	.S:AuditStatus'="" AuditStatus=$p(^DHCPHADRS(AuditStatus),"^",2)
	.S AuditUserID=$p(^DHCPHADRR(AdrReqID,"ADRRA",childsub),"^",2) //人员
	.S:AuditUserID'="" AuditUser=$p(^SSU("SSUSR",AuditUserID),"^",2)
	.S AuditDate=$p(^DHCPHADRR(AdrReqID,"ADRRA",childsub),"^",3) //日期
	.S:AuditDate'="" AuditDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AuditDate) ;$zd(AuditDate,3)
	.S AuditTime=$p(^DHCPHADRR(AdrReqID,"ADRRA",childsub),"^",4) //时间
	.S:AuditTime'="" AuditTime=$zt(AuditTime,1)
	.S ListData=AuditStatus_"^"_AuditUser_"^"_AuditDate_"^"_AuditTime
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAuditLog",pid,Num)=ListData

	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAuditLog",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAuditLog",pid,index)
	.S Title="Status^AuditUser^AuditDate^AuditTime"
	.S Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:报告列表是否包含指定药品
ClassMethod CheckIfConSpecDrug(adrRepID As %String, inInciDesc As %String) As %String
{
	n (adrRepID,inInciDesc)
	s quitflag=0
	s inInci=""
	f  s inInci=$o(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(inInciDesc),inInci))  q:inInci=""  d
	.s ch=""
	.f  s ch=$o(^DHCPHADRR(adrRepID,"ADRRDI",ch)) q:(ch="")||(quitflag=1)  d
	..s oeori=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",2) //医嘱ID
	..s arcItmid=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcItmid,"||",1),"")) 
	..q:inci=""  //医嘱名称
	..q:(inInci'="")&(inInci'=inci)
	..s quitflag=1
	q quitflag
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAdrReport",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRREPORTQUERY","QueryAuditLog",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMADRREPORTQUERY"))
}

}
