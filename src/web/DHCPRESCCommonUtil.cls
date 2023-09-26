Import SQLUser

Class web.DHCPRESCCommonUtil Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Descript:	计数器
/// w ##class(web.DHCPRESCCommonUtil).NewPid()
ClassMethod NewPid() As %String
{
	Q $I(^DHCAPP("DHCPRESC"))
}

/// Descript:初始化审方表
/// CreateDate:2021-09-09
/// Creator:sufan
/// Input:msgId
/// OutPut:0:成功，其他:失败
/// w ##class(web.DHCPRESCCommonUtil).CreatePatPrescList(1,"2022-02-10")
ClassMethod CreatePatPrescListO(userId, stDate)
{
	
	s ^temptest("444")=$lb(userId, stDate)
	Q:userId="" "-1"							//入参有误
	s dateTimeList = ##class(web.DHCPRESCCommonUtil).GetOnDutyTime()		//取用户上岗时间
	Q:stDate="" "-2"
	s:stDate'="" stDate = $zdh(stDate,3)
	s locList = ..GetAuditLocList(userId)			//取用户审核的科室
	s ret = 0
	s msgId = ""
	for  s msgId = $o(^CKB.PDSS.MonMasterI("DatePass",stDate,"0",msgId))  Q:msgId=""  d
	.;Q:msgId'=8329585
	.;Q:msgId'=1
	.s monData = $g(^CKB.PDSS.MonMasterD(msgId))
	.s level = $lg(monData,8) 
	.Q:(level'="warn")&&(level'="forbid")
	.s time = $lg(monData,4)
	.Q:$p($h,",",2)-time>30
	.Q:$d(^PHA.PREADT.AuditI("linkMon",msgId))
	.s mainList = ##class(web.DHCPRESCAudit).GetMainInfo(msgId)			//主表数据
	.s subMainList = ##class(web.DHCPRESCAudit).GetSubMainInfo(msgId)		//子表数据(处方信息)
	.s ret = ##class(web.DHCPRESCAudit).saveAuditData(mainList,subMainList)
	.d ##class(web.DHCPRESCCommonUtil).AutoAudit(msgId) //
	Q ret
}

/// Descript:初始化审方表    
/// CreateDate:2021-09-09
/// Creator:sufan
/// Input:msgId
/// OutPut:0:成功，其他:失败
/// w ##class(web.DHCPRESCCommonUtil).CreatePatPrescList(1,"2021-10-28")
ClassMethod CreatePatPrescList(msgId, tmpArr)
{
	s ret = 0   
	s index=""
	for  s index=$o(tmpArr(index)) Q:index=""  d
	.s oeordList=tmpArr(index)
	.s mainList = ##class(web.DHCPRESCAudit).GetMainInfo(msgId,oeordList)		//主表数据
	.;q:mainList=""
	.s subMainList = ##class(web.DHCPRESCAudit).GetSubMainInfo(oeordList)		//子表数据(处方信息)
	.s ret = ##class(web.DHCPRESCAudit).saveAuditData(mainList,subMainList)
	Q ret
}

/// Descript:取药师审核科室
/// CreateDate:2021-09-09
/// Creator:sufan
/// Input:userId
/// OutPut:科室列表
/// w ##class(web.DHCPRESCCommonUtil).GetAuditLocList(10213)
ClassMethod GetAuditLocList(userId)
{
	
	Q:'$d(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId)) ""
	s scheId = $o(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId,""),-1)
	s status = $lg(^CF.PHA.PREADT.DicSchemeD(scheId))
	Q:status="离线" ""
	s locList = ""
	s linkId = ""
	for  s linkId = $o(^CF.PHA.PREADT.SchLinkLocI("ItemCodeIndex",scheId,linkId))  Q:linkId=""  d
	.s type = $lg(^CF.PHA.PREADT.SchLinkLocD(linkId),4) //hxy 2022-02-15 st
	.Q:type'="CTLoc" //ed
	.s locId = $lg(^CF.PHA.PREADT.SchLinkLocD(linkId),3)
	.s locDesc = $p(^CTLOC(locId),"^",2)
	.i locList = "" s locList = locDesc
	.e  s locList = locList_","_locDesc
	Q locList
}

/// Descript:取药审核处方类型
/// CreateDate:2021-09-09
/// Creator:sufan
/// Input:userId
/// OutPut:处方类型
/// w ##class(web.DHCPRESCCommonUtil).GetAuditPrescList(10213)
ClassMethod GetAuditPrescList(userId)
{

	Q:'$d(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId)) ""
	s scheId = $o(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId,""),-1)
	s status = $lg(^CF.PHA.PREADT.DicSchemeD(scheId))
	Q:status="离线" ""
	s preList = ""
	s linkId = ""
	for  s linkId = $o(^CF.PHA.PREADT.SchLinkLocI("ItemCodeIndex",scheId,linkId))  Q:linkId=""  d
	.s type = $lg(^CF.PHA.PREADT.SchLinkLocD(linkId),4)
	.Q:type'="MedType"
	.s prescId = $lg(^CF.PHA.PREADT.SchLinkLocD(linkId),3)
	.s presc = $s(prescId=1:"西药方",prescId=2:"中成药方",prescId=3:"中草药方",1:"")
	.i preList = "" s preList = presc
	.e  s preList = preList_","_presc
	Q preList
}

/// Descript:取用户上岗时间
/// CreateDate:2021-09-09
/// Creator:sufan
/// Input:userId
/// OutPut:上岗时间和日期
/// w ##class(web.DHCPRESCCommonUtil).GetOnDutyTime()
ClassMethod GetOnDutyTime(userId)
{
	s date = ""
	s time = ""
	Q date_"^"_time
}

/// Descript:取字典字典维护内容
/// CreateDate:2021-09-15
/// Creator:sufan
/// Input:code  ,字典代码
/// OutPut:字典内容数组
/// w ##class(web.DHCPRESCCommonUtil).QueryDicItem("RIT",2)
ClassMethod QueryDicItem(code, hospId)
{
	Q:(code="")||(hospId="") "[]"
	Q:'$d(^CT.PHA.PREADT.DicTypeI("Code",code,hospId)) "[]"
	w "["
	s count = 0
	s Id = ""
	for  s Id = $o(^CT.PHA.PREADT.DicTypeI("Code",code,hospId,Id))  Q:Id=""  d
	.s typeFlag = $lg(^CT.PHA.PREADT.DicTypeD(Id),4)
	.Q:typeFlag'="Y"
	.s itmId = ""
	.for  s itmId = $o(^CT.PHA.PREADT.DicItemI("TypePar",Id,itmId))  Q:itmId=""  d
	..s itmFlag = $lg(^CT.PHA.PREADT.DicItemD(itmId),4)
	..Q:itmFlag'="Y"
	..s itmcode = $lg(^CT.PHA.PREADT.DicItemD(itmId),2)
	..s itmdesc = $lg(^CT.PHA.PREADT.DicItemD(itmId),3)
	..s parId = $lg(^CT.PHA.PREADT.DicItemD(itmId),7)
	..Q:parId'=""
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonTreeStart(itmId,itmdesc,itmcode)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(itmId,itmdesc,itmcode)
	..s subId = $o(^CT.PHA.PREADT.DicItemI("parref",itmId,""))
	..i subId'="" d
	...w ",""children"":"
	...d ..GetsubTreeJson(itmId)   ///是否有叶子节点
	..w "}"
	w "]"
	Q ""
}

ClassMethod GetsubTreeJson(parId)
{
	s count=0
	w "["
	//按code排序

	s subItmId = "" 
	f  s subItmId = $o(^CT.PHA.PREADT.DicItemI("parref",parId,subItmId)) q:subItmId=""  d
	.s itmFlag = $lg(^CT.PHA.PREADT.DicItemD(subItmId),4)
	.Q:itmFlag'="Y"
	.s itmcode = $lg(^CT.PHA.PREADT.DicItemD(subItmId),2)
	.s itmdesc = $lg(^CT.PHA.PREADT.DicItemD(subItmId),3)
	.s subparId = $lg(^CT.PHA.PREADT.DicItemD(subItmId),7)
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(subItmId,itmdesc,itmcode)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(subItmId,itmdesc,itmcode)
	.s subId = $o(^CT.PHA.PREADT.DicItemI("parref",subItmId,""))
	.i subId'="" d
	..w ",""children"":"
	..d ..GetsubTreeJson(subItmId)   ///是否有叶子节点
	.w "}"	
	w "]"	
	
	q ""
}

/// Descript:取字典字典维护内容
/// CreateDate:2021-09-15
/// Creator:sufan
/// Input:code  ,字典代码
/// OutPut:字典内容数组
/// w ##class(web.DHCPRESCCommonUtil).QueryDicItemCombox("COLLECT",2)
ClassMethod QueryDicItemCombox(code, hospId)
{
	Q:(code="")||(hospId="") "[]"
	Q:'$d(^CT.PHA.PREADT.DicTypeI("Code",code,hospId)) "[]"
	w "["
	s count = 0
	s Id = ""
	for  s Id = $o(^CT.PHA.PREADT.DicTypeI("Code",code,hospId,Id))  Q:Id=""  d
	.s typeFlag = $lg(^CT.PHA.PREADT.DicTypeD(Id),4)
	.Q:typeFlag'="Y"
	.s itmId = ""
	.for  s itmId = $o(^CT.PHA.PREADT.DicItemI("TypePar",Id,itmId))  Q:itmId=""  d
	..s itmFlag = $lg(^CT.PHA.PREADT.DicItemD(itmId),4)
	..Q:itmFlag'="Y"
	..s itmcode = $lg(^CT.PHA.PREADT.DicItemD(itmId),2)
	..s itmdesc = $lg(^CT.PHA.PREADT.DicItemD(itmId),3)
	..s parId = $lg(^CT.PHA.PREADT.DicItemD(itmId),7)
	..Q:parId'=""
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData("value^text",itmId_"^"_itmdesc)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",itmId_"^"_itmdesc)
	w "]"
	Q ""
}

/// Descript:取处方类型
/// Creator:sufan
/// CreateDate:2021-05-23
/// Input:医嘱项代码
/// w ##Class(web.DHCPRESCCommonUtil).GetRecipType("XWY000152")
ClassMethod GetRecipType(arcCode)
{
	Q:arcCode="" ""
	s subscript = $o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcCode),""))
	s version = $o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcCode),subscript,""))
	s itmmastId = subscript_"||"_version
	Q:subscript="" ""
	s ordCatId = $p(^ARCIM(subscript,version,1),"^",10)			//医嘱子类
	s ordCatgloryId = $p(^ARC("IC",ordCatId),"^",8)				//医嘱大类Id
	s catDesc = $p(^OEC("ORCAT",ordCatgloryId),"^",2)			//医嘱大类
	Q:(catDesc="西药")||(catDesc="中成药") "西药方"
	Q:(catDesc="草药颗粒")||(catDesc="草药饮片") "草药方"
	Q ""
}

/// Creator:    hxy
/// CreateDate: 2022-02-10
/// Descript:	智能审方产品配置
/// InPut:      PrescCode-参数类型, Params-医院id^科室id^用户id^安全组id
/// OutPut:     参数类型值
/// w ##class(web.DHCPRESCCommonUtil).GetSysConfig("SWITCH","2")
ClassMethod GetSysConfig(PrescCode As %String, Params As %String) As %String
{
	s LgHospID=$p(Params,"^",1)	  /// 医院ID
	s LgCtLocID=$p(Params,"^",2)  /// 科室ID
	s LgUserID=$p(Params,"^",3)   /// 用户ID
	s LgGroupID=$p(Params,"^",4)  /// 安全组ID
	s Val=##Class(web.DHCEMComPar).GetAppPropValue("DHCPRESC",PrescCode,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	q Val
}

/// Creator:    hxy
/// CreateDate: 2022-02-10
/// Descript:	自动审核通过
/// InPut:      PrescCode-参数类型, Params-医院id^科室id^用户id^安全组id
/// OutPut:     参数类型值
/// w ##class(web.DHCPRESCCommonUtil).AutoAudit("8416465")
ClassMethod AutoAudit(msgId As %String) As %String
{
	s AuditId=$o(^PHA.PREADT.AuditI("linkMon",msgId,""))
	s HospID=##class(web.DHCPRESCCommonUtil).GetHospIDByAuditID(AuditId)
	s LocID=##class(web.DHCPRESCCommonUtil).GetLocIDDByAuditID(AuditId)
	s ret=##class(web.DHCPRESCCommonUtil).GetSysConfig("SWITCH",HospID)
	q:ret=1 ""
	s res=##class(web.DHCPRESCCommonUtil).IsHavePhaAction(LocID)    //shy  如果没有正在上班监测本科室的药师 自动通过  2022-4-6
	q:res=1 ""
	s LgUserID=##class(web.DHCPRESCCommonUtil).GetAutoAuditUser()
	s StateCode="STA04"
	s Remark="自动通过"
	s ListData=AuditId_"^^"_LgUserID_"^"_StateCode_"^^"_Remark
	s ret=##class(web.DHCPRESCAudit).saveAuditInfo(ListData)
	q ret
}

/// Creator:    Shy
/// CreateDate: 2022-04-06
/// Descript:	是否有该科室上班药师
/// InPut:      没有：0 有：1
/// OutPut:     Loc
/// w ##class(web.DHCPRESCCommonUtil).IsHavePhaAction("272")
ClassMethod IsHavePhaAction(LocID As %String) As %String
{
	s ret=0
	s LocDesc = $p($g(^CTLOC(+LocID)),"^",2)
	s ID="" f  s ID=$o(^CF.PHA.PREADT.DicSchemeD(ID))  q:ID=""  d
	.s UserID=$lg(^CF.PHA.PREADT.DicSchemeD(ID),2)
	.s AudLocList = ##class(web.DHCPRESCCommonUtil).GetAuditLocList(UserID)
	.i (AudLocList'="")&&((","_AudLocList_",")[(","_LocDesc_",")) d
	..s ret=1
	q ret
}

/// Descript:       取药师审方结果
/// Creator:    	hxy
/// CreateDate: 	2022-03-12
/// InPut:      	EpisodeID
/// OutPut:     	审方结果Code
/// w ##Class(web.DHCPRESCCommonUtil).GetResStaCode("106")
ClassMethod GetResStaCode(AuditId As %String) As %String
{
	Q:+AuditId=0 ""
	s ret=""
	s AudResId = $o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	q:AudResId="" ""
	s DocAudResId = $o(^PHA.PREADT.AuditResultI("Parref",AuditId,""),-1)
	q:AudResId'=DocAudResId ""
	s ResSta = $lg(^PHA.PREADT.AuditResultD(AudResId),6)
	s ret = $lg(^CT.PHA.PREADT.DicItemD(ResSta),2)
	q ret
}

/// Creator:    hxy
/// CreateDate: 2022-02-12
/// Descript:	取值自动审核通过人
/// InPut:      
/// OutPut:     UserID
/// w ##class(web.DHCPRESCCommonUtil).GetAutoAuditUser()
ClassMethod GetAutoAuditUser() As %String
{
	s LgUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4("demo"),"")) //默认自动审核通过人为demo
	q LgUserID
}

/// Creator:    hxy
/// CreateDate: 2022-02-12
/// Descript:	取超时时间秒数配置
/// InPut:      审方主表ID
/// OutPut:     超时秒数
/// w ##class(web.DHCPRESCCommonUtil).GetOverTime("1916")
ClassMethod GetOverTime(AuditId As %String) As %String
{
	s ret="30" //默认30秒
	s admId = $lg(^PHA.PREADT.AuditD(AuditId),3)
	s patType=$p($g(^PAADM(+admId)),"^",2) 	
	s HospID=##class(web.DHCPRESCCommonUtil).GetHospIDByAuditID(AuditId)
	i patType="I" d
	.s Seconds=##class(web.DHCPRESCCommonUtil).GetSysConfig("INOVERTIME",HospID)
	e  d
	.s Seconds=##class(web.DHCPRESCCommonUtil).GetSysConfig("OVERTIME",HospID)
	S:+Seconds'=0 ret=Seconds
	q ret
}

/// Creator:    hxy
/// CreateDate: 2022-02-15
/// Descript:	取药师的审方科室分配开关
/// InPut:      审方主表ID
/// OutPut:     分配开关配置
/// w ##class(web.DHCPRESCCommonUtil).GetByLocsSwitch("1916")
ClassMethod GetByLocsSwitch(AuditId As %String) As %String
{
	s HospID=##class(web.DHCPRESCCommonUtil).GetHospIDByAuditID(AuditId)
	s ret=##class(web.DHCPRESCCommonUtil).GetSysConfig("BYLOCSWITCH",HospID)
	q ret
}

/// Creator:    hxy
/// CreateDate: 2022-02-10
/// Descript:	根据审方主表RowID取其所在医院的RowID
/// InPut:      审方主表RowID
/// OutPut:     医院的RowID
/// w ##class(web.DHCPRESCCommonUtil).GetHospIDByAuditID(1879)
ClassMethod GetHospIDByAuditID(AuditId)
{
	q:AuditId="" ""
	s HospID=$lg(^PHA.PREADT.AuditD(AuditId),10)
	q HospID
}

/// Creator:    Shy
/// CreateDate: 2022-02-10
/// Descript:	根据审方主表RowID取其所在科室的RowID
/// InPut:      审方主表RowID
/// OutPut:     科室的RowID
/// w ##class(web.DHCPRESCCommonUtil).GetLocIDByAuditID(1879)
ClassMethod GetLocIDByAuditID(AuditId)
{
	q:AuditId="" ""
	s HospID=$lg(^PHA.PREADT.AuditD(AuditId),9)
	q HospID
}

/// Creator:    hxy
/// CreateDate: 2020-05-07
/// Descript:   取病案号
/// InPut:      EpisodeID- 就诊ID
/// OutPut:     病案号
/// w ##Class(web.DHCPRESCCommonUtil).GetMrNo("509")
ClassMethod GetMrNo(EpisodeID As %String) As %String
{
	q:(+EpisodeID=0) ""
	q:'$d(^PAADM(EpisodeID)) ""
	s MrNo=""
	s MedType=$p($g(^PAADM(+EpisodeID)),"^",2)	
	s IfHaveMethodByEpis=##class(websys.Conversions).IsValidMethodName("DHCWMR.IO.OutService","IGetMrNoByEpisodeID")
	;s IfHaveMethodByPati=##class(websys.Conversions).IsValidMethodName("DHCWMR.IO.OutService","IGetMrNoByPatientID")
	i IfHaveMethodByEpis=1 d
	.s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
    .;s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,MedType,HosptialID,.ErrMsg)
    e  d
    .s MrNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)
    .;s PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
    .;s MrNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",22) //病案号
	q MrNo
}

/// Description: 公共 (页面日期 转为 M中的日期数字)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-03
/// Table: 		 
/// Input:       页面日期  例如：2017-03-03、28/2/2017等
/// Output:  	 M中日期数字 64338
/// Others:	w ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical("2017-03-03")	
ClassMethod DateHtmlToLogical(date As %String) As %String
{
	q:date=""""
	s DHCEMCommonDate=""
	s DHCEMCommonDate=##class(websys.Conversions).DateHtmlToLogical(date)
	q DHCEMCommonDate
}

/// Description: 公共 (M中的日期数字 转为 demo配置日期)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-03
/// Table: 		 
/// Input:       M中日期数字 64345
/// Output:  	 demo配置的日期格式
/// Others:	w ##class(web.DHCPRESCCommonUtil).DateLogicalToHtml("64345")	
ClassMethod DateLogicalToHtml(date As %String) As %String
{
	q:date=""""
	s DHCEMCommonDate=""
	s DHCEMCommonDate=##class(websys.Conversions).DateLogicalToHtml(date)
	q DHCEMCommonDate
}

/// Creator:    hxy
/// CreateDate: 2022-02-10
/// Descript:	根据就诊RowID取其所在医院的RowID
/// InPut:      就诊RowID
/// OutPut:     医院的RowID
/// w ##class(web.DHCPRESCCommonUtil).GetHospIDByAdm()
ClassMethod GetHospIDByAdm(Adm)
{
#;	q:Adm="" ""
#;	s LocDr=$p($g(^PAADM(+Adm)),"^",4)
#;	s HospID=##class(web.DHCPRESCCommonUtil).GetHospIDByLocID(LocDr)
#;	q HospID
}

/// Creator:    hxy
/// CreateDate: 2022-02-10
/// Descript:	根据科室RowID取其所在医院的RowID
/// InPut:      科室RowID
/// OutPut:     医院的RowID
/// w ##class(web.DHCPRESCCommonUtil).GetHospIDByLocID()      
ClassMethod GetHospIDByLocID(LocID As %String) As %String
{
#;	s HospitalID=""
#;	s HospitalID=$p($g(^CTLOC(+LocID)),"^",22)
#;	q HospitalID
}

/// Creator:    hxy
/// CreateDate: 2012-02-22
/// Descript:	科室下拉框
/// InPut:      
/// OutPut:     所有科室
/// w ##class(web.DHCPRESCCommonUtil).GetLoc("")
ClassMethod GetLoc(q As %String, HospID = "")
{
	s Count = 0
	w "["
	s LocID="0"
	f  s LocID = $o(^CTLOC(LocID)) q:LocID=""  d
	.s LocDesc = $p(^CTLOC(LocID),"^",2)
	.s LocCode = $p(^CTLOC(LocID),"^",43)
	.s dateFrom = $p(^CTLOC(LocID),"^",24)
	.s dateActiveTo = $p(^CTLOC(LocID),"^",25)
	.s activeFlag = $p(^CTLOC(LocID),"^",14)
	.Q:(dateFrom>+$h)&(dateFrom'="")
	.Q:(dateActiveTo'="")&&(dateActiveTo<+$h)
	.q:(HospID'="")&($p(^CTLOC(LocID),"^",22)'=HospID)
	.;Q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocID,HospID)'="Y"
	.Q:(LocDesc["停")||(LocDesc["工作量")
	.Q:(activeFlag'="")&&(activeFlag'="Y")
	.s LocCode = $ZCVT(LocCode,"U") 
	.s LocAllDesc = LocCode_LocDesc
	.q:(q'="")&&(LocAllDesc'[$$ALPHAUP^SSUTIL4(q))
	.s Count = Count+1
	.s Tmp=LocID_"^"_LocDesc
	.i Count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

/// 导出global： d ##class(web.DHCPRESCCommonUtil).ExportGlobal()
/// 导入global： d $SYSTEM.OBJ.ImportDir("D:\","CKBGlobal2021-07-7ne22w.gof")
ClassMethod ExportGlobal()
{
	
	k CList
	k myIdx
	
	//字典表
	s CList($i(CList))="PHA.PREADT.AuditD.GBL" // 数据对照表
	s CList($i(CList))="PHA.PREADT.AuditLabD.GBL" // 知识库码表字典
	s CList($i(CList))="PHA.PREADT.AuditListD.GBL" // 数据关联表
	s CList($i(CList))="PHA.PREADT.AuditMsgD.GBL" // 字典日志表
	s CList($i(CList))="PHA.PREADT.AuditResultD.GBL" // 外部代码表
	s CList($i(CList))="CT.PHA.PREADT.DicItemD.GBL"  // 规则主表
	s CList($i(CList))="CT.PHA.PREADT.DicTypeD.GBL"  // 
	s CList($i(CList))="CT.PHA.PREADT.ItemPropD.GBL"  // 规则明细表
	s CList($i(CList))="CF.PHA.PREADT.LocTempLinkD.GBL"  // 规则数据日志
 	s CList($i(CList))="CF.PHA.PREADT.SchLinkLocD.GBL" // 
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)_$zts
	s filename = "D:\CKBGlobal"_time_"new"_".gof"
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
}

/// Creator:    shy
/// CreateDate: 2022-03-07
/// Descript:	取阅读标记
/// InPut:      审方主表ID
/// OutPut:     Y   N   ""
/// w ##class(web.DHCPRESCCommonUtil).GetReadFlag("1")
ClassMethod GetReadFlag(AuditId As %String) As %String
{
	s ret=$lg(^PHA.PREADT.AuditD(AuditId),19)

	q ret
}

/// Creator:    shy
/// CreateDate: 2022-03-07
/// Descript:	取审方结果
/// InPut:      审方主表ID
/// OutPut:     Y   N   ""
/// w ##class(web.DHCPRESCCommonUtil).GetAuditResult("2198")
ClassMethod GetAuditResult(AuditId As %String) As %String
{
	s res=""
	i $d(^PHA.PREADT.AuditResultI("Parref",AuditId)) d
	.s res=1
	q res
}

/// Descript:查询当前待处理处方个数
/// CreateDate:2022-03-16
/// Creator:shy
/// Input:
/// OutPut:subMainList
/// w ##class(web.DHCPRESCCommonUtil).QueryAuditNum()
ClassMethod QueryAuditNum()
{
	s date=+$h
	s resNum=0
	s time = ""
	for  s time = $o(^PHA.PREADT.AuditI("Date",date,time))  Q:time=""  d
	.s auditId = ""
	.for  s auditId = $o(^PHA.PREADT.AuditI("Date",date,time,auditId))  Q:auditId=""  d
	..s admId = $lg(^PHA.PREADT.AuditD(auditId),3)					//就诊Id
	..s status = $lg(^PHA.PREADT.AuditD(auditId),16)					//状态
	..s resStatus = ""
	..i $d(^PHA.PREADT.AuditResultI("Parref",auditId))  d
	...s resId = ""
	...for  s resId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,resId)) Q:resId=""  d
	....s resStatus = $lg(^PHA.PREADT.AuditResultD(resId),6)
	..Q:status'=0     ;0
	..Q:resStatus'=0      ;1
	..s resNum=resNum+1
	
	q resNum
}

/// w ##class(web.DHCPRESCCommonUtil).auditPremise(2,"呼吸内科门诊")
ClassMethod auditPremise(hosp, Loc)
{
	
	k PremiseNameArr
	s Id=""
	s rtn=1   //默认通过，每个条件单独判断，如果有一个0，则不通过
	f  s Id=$o(^CF.PHA.PREADT.PremiseNameD(Id)) q:Id=""  d
	.q:Id=0
	.s code=$lg(^CF.PHA.PREADT.PremiseNameD(Id),2)
	.s hospId=$lg(^CF.PHA.PREADT.PremiseNameD(Id),3)
	.s moduleId=$lg(^CF.PHA.PREADT.PremiseNameD(Id),4)
	.q:moduleId=0
	.s:+moduleId'=0 module=$lg(^PHA.PREADT.CaseCollectModuleD(moduleId),3)
	.q:module'="智能审方"
	.s active=$lg(^CF.PHA.PREADT.PremiseNameD(Id),5)
	.q:active'="Y"
	.q:hosp'=hospId
	.s PremiseNameArr(Id)=0  //每个条件默认是验证不通过
	.s NodeId=""    		 ///该条件的前提定义
	.f  s NodeId=$o(^CF.PHA.PREADT.PremiseNodeI("PPNName",Id,NodeId)) q:NodeId=""  d
	..q:NodeId=0
	..s NameDr=$lg(^CF.PHA.PREADT.PremiseNodeD(NodeId),2)
	..s Name=$lg(^CF.PHA.PREADT.PremiseNameD(NameDr),2)
	..s DicDr=$lg(^CF.PHA.PREADT.PremiseNodeD(NodeId),3)
	..s DicName = $lg(^CF.PHA.PREADT.PremiseDicD(DicDr),3)
	..s DicType = $lg(^CF.PHA.PREADT.PremiseDicD(DicDr),2)   //验证类型
	..s PPNOp=$lg(^CF.PHA.PREADT.PremiseNodeD(NodeId),4)
	..s PremiseNameArr(Id,NodeId)=0    //每个前提默认不通过
	..s DataID="", cflag=0  //默认0,和下面的值进行或判断  
	..f  s DataID=$o(^CF.PHA.PREADT.PremiseDataI("PPDNode",NodeId,DataID)) q:(DataID="")||(rtn=0)  d
	...q:DataID=0
	...s PPDNodeDr=$lg(^CF.PHA.PREADT.PremiseDataD(DataID),2)
	...s PPDValue=$lg(^CF.PHA.PREADT.PremiseDataD(DataID),3)
	...s PPDNameDr=$lg(^CF.PHA.PREADT.PremiseDataD(DataID),4)
	...s PPDName=$lg(^CF.PHA.PREADT.PremiseNameD(PPDNameDr),2)
	...s PPDLimit=$lg(^CF.PHA.PREADT.PremiseDataD(DataID),5)
	...s PPDStTime=$lg(^CF.PHA.PREADT.PremiseDataD(DataID),6)
	...s PPDEdTime=$lg(^CF.PHA.PREADT.PremiseDataD(DataID),7)
	...s PPDType=$lg(^CF.PHA.PREADT.PremiseDataD(DataID),8)
	...s data=DataID_"^"_PPDNodeDr_"^"_PPDValue_"^"_PPDNameDr _"^"_PPDName_"^"_PPDLimit_"^"_PPDStTime_"^"_PPDEdTime_"^"_PPDType
	...i DicType="Time" s flag= ..getTimeFlag(PPDValue,PPDStTime,PPDLimit,PPDEdTime,PPNOp)
	...e  i DicType="Loc" s flag = ..getFlag(PPDValue,Loc,PPNOp)
	...s cflag = flag||cflag
	..i cflag=0 s rtn=0
	
	q rtn
}

/// 验证值类型等不等于
ClassMethod getFlag(PPDValue, value, PPNOp)
{
	
	s flag=0
	i PPDValue=value s flag=1
	i PPNOp="N" s flag='flag  //不等于的 'flag
	
	q flag
}

/// 验证时间
/// w ##class(web.DHCPRESCCommonUtil).getTimeFlag("2022-08-11","01:02","2022-08-11","11:02","")
ClassMethod getTimeFlag(startDate, startTime, endDate, endTime, PPNOp)
{
	
	s flag=0
	s thisDate = +$h
	s thisTime=$p($h,",",2)
	s:endDate'="" endDate=$zdh(endDate,3)
	s:startTime'="" startTime=$zth(startTime,3)
	s:endTime'="" endTime=$zth(endTime,3)
	i (startDate<=thisDate)&&(endDate>=thisDate)&&(startTime<thisTime)&&(endTime>thisTime) s flag=1
	
	i PPNOp="N" s flag='flag  //不等于的 'flag
	
	q flag
}

/// Description: 判断用户密码是否正确
/// Table：SS_User,CT_CareProv,CT_CarPrvTp
/// Input：userCode: 用户登陆名 passWord: 用户密码
/// Return：成功返回 0^用户ID 失败返回 密码错误
/// Others:		 w ##class(web.DHCPRESCCommonUtil).ConfirmPassWord("1","1")
ClassMethod ConfirmPassWord(userCode As %String, passWord As %String, LocId = "") As %String
{
	s retStr=0
	i userCode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	q:userId="" "用户有误!"
	;s IfSameFlag=##class(web.DHCEMSkinTest).IfSameLoc(userId,LocId)
	;q:IfSameFlag="0" "非本科室用户，不能进行皮试确认!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	
	s active=$p($g(^SSU("SSUSR",userId)),"^",19)
	q:active'="Y" "用户未激活!"
	
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
	.i pin'=$p($G(^SSU("SSUSR",userId)),"^",15) s retStr="密码错误"  /// 改为验证用户签名密码 bianshuai 2020-02-21
	zn oldnamespace
	i retStr=0 s retStr=0_"^"_userId
	q retStr
}

/// Descript:初始化审方表
/// CreateDate:2021-09-09
/// Creator:sufan
/// Input:医嘱信息串：医嘱id^回调记录表id^标识
/// OutPut:0:成功，其他:失败
/// w ##class(web.DHCPRESCCommonUtil).SysOrdInfo("2262384||650^1713943^!!2262384||651^1713944^")
ClassMethod SysOrdInfo(oeordItemStr)
{
	k tmpArr
	s ^temptest("oeordItemStr") = oeordItemStr
	s $ZT="ErrMsg"
	s len = $l(oeordItemStr,"!!")
	s msgId = ""
	for i=1:1:len   d
	.s oeordTmpStr = $p(oeordItemStr,"!!",i)
	.s oeorId = $p(oeordTmpStr,"^",1)
	.s feedId = $p(oeordTmpStr,"^",2)
	.Q:feedId=""
	.s msgId = $lg($g(^CKB.PDSS.FeedBackD(feedId)),2) 
	.s level = $lg($g(^CKB.PDSS.MonMasterD(msgId)) ,8) 
	.s levNum = ##class(web.DHCCKBCommon).GetManLevelNum(level)
	.;Q:(levNum=3)
	.s prescNo = $p(^OEORD(+oeorId,"I",$p(oeorId,"||",2),1),"^",14)
	.Q:prescNo=""
	.s index = prescNo
	.s adm=+^OEORD(+oeorId)
	.s patType=$p($g(^PAADM(+adm)),"^",2)
	.s:patType="I" index=patType
	.i $d(tmpArr(index))   d
	..s tmpArr(index) = tmpArr(index)_"^"_oeorId
	.e  d
	..s tmpArr(index) = oeorId
	
	s ret = 0
	s ret = ##class(web.DHCPRESCCommonUtil).CreatePatPrescList(msgId,.tmpArr)
	q ret
ErrMsg
	Q -1
}

/// Creator:    sufan
/// CreateDate: 2021-01-11
/// Descript:	处方审核配置
/// InPut:      PrescCode-处方审核参数类型, Params-医院id^科室id^用户id^安全组id
/// OutPut:     处方审核配置参数类型值
/// w ##class(web.DHCPRESCCommonUtil).GetPrescSysConfig("PRESCSWITCH","2")
ClassMethod GetPrescSysConfig(PrescCode As %String, Params As %String) As %String
{
	s LgHospID=$p(Params,"^",1)	  /// 医院ID
	s LgCtLocID=$p(Params,"^",2)  /// 科室ID
	s LgUserID=$p(Params,"^",3)   /// 用户ID
	s LgGroupID=$p(Params,"^",4)  /// 安全组ID
	s ResType=##Class(web.DHCAppComPar).GetAppPropValue("DHCPRESC",PrescCode,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	Q ResType
}

/// Descript:       取患者体重
/// Creator:    	hxy
/// CreateDate: 	2022-03-11
/// InPut:      	EpisodeID
/// OutPut:     	体重
/// w ##Class(web.DHCPRESCCommonUtil).GetPatWeight("3284")
ClassMethod GetPatWeight(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
    s mradm=$p(^PAADM(EpisodeID),"^",61)
    s Weight=##Class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"weight")
    s:Weight="" Weight=$p($g(^MR(mradm,"PRO",1)),"^",27)
    Q Weight_"Kg"
}

/// Descript:       取患者身高
/// Creator:    	hxy
/// CreateDate: 	2022-03-11
/// InPut:      	EpisodeID
/// OutPut:     	身高
/// w ##Class(web.DHCPRESCCommonUtil).GetPatHeight("3284")
ClassMethod GetPatHeight(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
    s mradm=$p(^PAADM(EpisodeID),"^",61)
    s Height=##Class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"height")
    s:Height="" Height=$p($g(^MR(mradm,"PRO",1)),"^",20)
    Q Height_"CM"
}

/// Descript:获取医嘱的剂量
/// w ##class(web.DHCPRESCCommonUtil).GetdoseQtyUnit()
ClassMethod GetdoseQtyUnit(ord, itm)
{
	//s doseQty=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",4)
	s doseQty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
    i doseQty'="" s unitUomId=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
    
    i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
    i (doseQty'="")&($g(unitDesc)'="") s doseQtyUnit=doseQty_" "_unitDesc
    e  s doseQtyUnit=""
    q doseQtyUnit
}

/// Descript:取用法
/// w ##class(web.DHCPRESCCommonUtil).getPhcinDesc()
ClassMethod getPhcinDesc(ord As %String, itm As %String) As %String
{
	s methDr=$P($G(^OEORD(ord,"I",itm,2)),"^",7)
    i methDr'="" q $p(^PHCIN(methDr),"^",2)
    e  q ""
}

/// Descript:取频次
/// w ##class(web.DHCPRESCCommonUtil).getPhcfrCode(233,12)
ClassMethod getPhcfrCode(ord As %String, itm As %String) As %String
{
	s OrderFreq=""
	s freqDr=$P($G(^OEORD(ord,"I",itm,2)),"^",4) 
	i freqDr'="" d
	. s OrderFreq=$P(^PHCFR(freqDr),"^",1)
	. s WeekFlag=$P(^PHCFR(freqDr),"^",9)
	. i WeekFlag="Y" d
	..s OrderFreqWeek=$p($g(^OEORD(+ord,"I",itm,"DHC")),"^",55)
	..s:OrderFreqWeek="undefined" OrderFreqWeek=""
	..s OrderFreq=OrderFreq_" "_$TR(OrderFreqWeek,"|","")
    q OrderFreq
}

/// Descript:取疗程 
/// w ##class(web.DHCPRESCCommonUtil).getDurat(233,12)
ClassMethod getDurat(oeordId As %String, oeoriSub As %String) As %String
{
	i $d(^OEORD(oeordId,"I",oeoriSub,2)) s duratdr=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",6)
    i $g(duratdr)'="" q $p(^PHCDU(duratdr),"^",3)  
    e  q ""
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:   	剂型
/// InPut:      	
/// OutPut:     	
/// w ##Class(web.DHCPRESCCommonUtil).GetDrugForm("")
ClassMethod GetDrugForm(ord As %String, itm As %String) As %String
{
	s InciDr=..GetInci(ord, itm)
	Q:InciDr="" ""
    s FormStr=##Class(web.DHCST.Common.DrugInfoCommon).GetForm(InciDr)
    Q $p(FormStr,"^",2)
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:   	库存项ID
/// InPut:      	
/// OutPut:     	
/// w ##Class(web.DHCCKBHisBusiExp).GetInci("")
ClassMethod GetInci(ord As %String, itm As %String) As %String
{
    s itmmastid=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
    Q:itmmastid="" ""
    Q $o(^INCI(0,"ARCIM_DR",+itmmastid,""))
}

/// Descript:审方对接[医生站调用]
/// CreateDate:2023-02-22
/// Creator:sufan
/// Input:医嘱信息串
/// Output:插入成功信息
/// w ##class(web.DHCPRESCCommonUtil).SysOrdInfoDoc("{""MsgID"":"""",""AdtMsgID"":"""",""Action"":""Audit"",""PatName"":""zl7004"",""SexProp"":""男"",""AgeProp"":""1935-05-06"",""Height"":"""",""Weight"":"""",""BillType"":""市医保"",""BloodPress"":""~"",""SpecGrps"":[],""ProfessProp"":"""",""PatType"":""住院"",""PatLoc"":""神经外科"",""MainDoc"":""韩玮"",""Group"":""Inpatient Doctor"",""Hospital"":""东华标准版数字化医院[总院]"",""LgCtLoc"":""神经外科"",""LgUser"":""韩玮"",""Profess"":"""",""EpisodeID"":""142"",""ItemDis"":[{""id"":""A02.900"",""item"":""沙门菌感染""},{""id"":""A10.01.08"",""item"":""鹅口疮""},{""id"":""B02.01.02.03.01"",""item"":""少腹寒凝证""}],""ItemOrder"":[{""OrdSeNum"":""230524000209"",""ArciMastId"":""440||1"",""DrugType"":""XY"",""SeqNo"":""1"",""PhCode"":""XKF000404"",""PhDesc"":""复合维生素片(爱乐维)[CO*30]"",""FormProp"":""片剂"",""OnceDose"":""1"",""Unit"":""片"",""DayDose"":1,""DrugPreMet"":""口服"",""DrugFreq"":""St"",""Treatment"":""1天"",""id"":""XKF000404"",""LinkSeqNo"":"""",""OrdDate"":""2023-05-24"",""IsFirstUseProp"":"""",""DurgSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""OrdEndDate"":"""",""OrdStartDate"":66618,""OrderPackQty"":"""",""OrderPackQtyUnit"":""瓶"",""SkinTest"":"""",""OrderPriority"":""ONE"",""RecDeptCode"":""ZYYX006"",""RecDeptName"":""住院药房"",""OrdQuaty"":"""",""OrdPrice"":""141.9990"",""OrdToatlPrice"":0}],""ItemAyg"":[{""id"":""101"",""item"":""青霉素类抗生素""},{""id"":""XZS000067"",""item"":""注射用青霉素钠[400万U]""},{""id"":""104"",""item"":""含碘药品""}],""ItemOper"":[],""UseType"":""Doc""}","402&警示&1&warn")
ClassMethod SysOrdInfoDoc(ordParamObj, pdssres)
{
	s ^temptest("ordParamObj") = $lb(ordParamObj,pdssres)
	s $ZT="ErrMsg"
	s ordParamObj = {}.%FromJSON(ordParamObj)
	s mainList = ##class(web.DHCPRESCAudit).GetMainInfo(ordParamObj,pdssres)					//主表数据
	s subMainList = ##class(web.DHCPRESCAudit).GetSubMainInfo(ordParamObj)						//子表数据(处方信息)
	s ret = ##class(web.DHCPRESCAudit).saveAuditData(mainList,subMainList)		
	Q:ret>0 ..TakErrMsg(ret_"^保存成功！")
	Q ..TakErrMsg("-99^保存出错！"_$ze)
ErrMsg
	Q ..TakErrMsg("-99^保存出错！"_$ze)
}

/// Descript:	返回错误信息
/// w ##class(web.DHCPRESCCommonUtil).TakErrMsg()
ClassMethod TakErrMsg(ListData As %String) As %String
{
	w ##Class(web.DHCAPPJsonCommon).getJsonData("RetCode^RetMessage",ListData)  
	Q ""
}

/// Descript:判断处方是否审核结束/是否需要审核
/// Creator:sufan
/// CreateDate:2022-06-28
/// w ##class(web.DHCPRESCCommonUtil).IsEndCountdown(1890,2)
ClassMethod IsEndCountdown(auditId, hospId)
{
	Q:auditId="" ""
	s ^temptest(1113) = $lb(auditId,hospId)
	s retFlag = 0
	s msgId = $lg(^PHA.PREADT.AuditD(auditId),2)
	s manLev = $lg(^CKB.PDSS.MonMasterD(msgId),"^",8)				//级别
	s manLevDesc = $s(manLev="forbid":"禁止",manLev="warn":"警示",manLev="tips":"提醒",manLev="normal":"提示",1:"正常")
	s conManLev = ##class(web.DHCPRESCCommonUtil).GetPrescSysConfig("LEVEL",hospId)
	Q:conManLev'[manLevDesc retFlag
	B  ///22
	s locId = $lg(^PHA.PREADT.AuditD(auditId),9)
	s schId = ""
	for  s schId = $o(^CF.PHA.PREADT.DicSchemeD(schId)) Q:(schId="")||(retFlag=1)  d
	.;s onLinestate = $lg(^CF.PHA.PREADT.DicSchemeD(schId),5)
	.s logId = $o(^PHA.PREADT.DicSchemelogI("PrDate",+$h,schId,""),-1)
	.q:logId=""
	.s onLinestate = $lg(^PHA.PREADT.DicSchemelogD(logId),3)
	.B  //SS
	.Q:onLinestate'="在线"
	.s itmId = ""
	.for  s itmId = $o(^CF.PHA.PREADT.SchLinkLocI("ItemCodeIndex",schId,itmId))  Q:(itmId="")||(retFlag=1)  d
	..s type = $lg(^CF.PHA.PREADT.SchLinkLocD(itmId),4)
	..Q:type'="CTLoc"
	..s typeId = $lg(^CF.PHA.PREADT.SchLinkLocD(itmId),3)
	..Q:typeId'=locId
	..s retFlag = 1
	Q retFlag
}

/// w ##class(web.DHCPRESCCommonUtil).GetAuditTime(362,2)
ClassMethod GetAuditTime(auditId, hospId)
{
	s seconds=30
	Q:auditId="" ""
	s admId = $lg(^PHA.PREADT.AuditD(auditId),3)
	s admType = $p(^PAADM(admId),"^",2)
	s seconds=##class(web.DHCPRESCCommonUtil).GetPrescSysConfig("OVERTIME",hospId)
	s:admType="I" seconds=##class(web.DHCPRESCCommonUtil).GetPrescSysConfig("INOVERTIME",hospId) //住院不配置默认30s
	
	Q seconds
}

/// Descript:判断处方是否审核结束
/// Creator:sufan
/// CreateDate:2022-06-28PHA.PREADT.AuditResult
/// w ##class(web.DHCPRESCCommonUtil).IsAuditEnd(328)
ClassMethod IsAuditEnd(auditId)
{
	
	s ^temptest("333auditId")=$lb(auditId)
	s retFlag = 0
	Q:auditId="" ""
	Q:'$d(^PHA.PREADT.AuditResultI("Parref",auditId)) ""
	s auditResId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,""))
	s statusId = $lg(^PHA.PREADT.AuditResultD(auditResId),6)
	s statusCode = $lg(	^CT.PHA.PREADT.DicItemD(statusId),2)
	s statusDesc = $lg(	^CT.PHA.PREADT.DicItemD(statusId),3)
	s auditUserId = $lg(^PHA.PREADT.AuditResultD(auditResId),3)
	s auditUser = ""
	s:auditUserId'="" auditUser = $p(^SSU("SSUSR",auditUserId),"^",2)
	s resId = $lg(^PHA.PREADT.AuditResultD(auditResId),7)
	s resDesc = ""
	s:resId'="" resDesc = $lg(	^CT.PHA.PREADT.DicItemD(resId),3)
	s remark = $lg(^PHA.PREADT.AuditResultD(auditResId),8)
	i (statusCode="STA04")&&(remark["自动") s retFlag = "A"
	i (statusCode="STA04")&&(remark'["自动") s retFlag = "Y"
	i (statusCode="STA01") s retFlag = "N"
	i (statusCode="STA03") s retFlag = "N"
	s ret = ..GetAuditRes(auditId)
	Q retFlag_"&"_ret_"&"_statusCode_"&"_statusDesc_"&"_auditUser_"&"_resDesc_"&"_remark
}

/// w ##class(web.DHCPRESCCommonUtil).GetAuditRes(1655)
ClassMethod GetAuditRes(auditId)
{
	s auditResId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,""))
	s statusId = "",statusCode = "",remark = ""
	s:auditResId'="" statusId = $lg(^PHA.PREADT.AuditResultD(auditResId),6)
	s:auditResId'="" statusCode = $lg(	^CT.PHA.PREADT.DicItemD(statusId),2)
	s:auditResId'="" remark = $lg(^PHA.PREADT.AuditResultD(auditResId),8)
	s retFlag = ""
	i (statusCode="STA04")&&(remark["自动") s retFlag = "A"
	i (statusCode="STA04")&&(remark'["自动") s retFlag = "Y"
	i (statusCode="STA01") s retFlag = "N"
	s retData = ""
	s auditItmId = ""
	for  s auditItmId = $o(^PHA.PREADT.AuditListI("IndexParref",auditId,auditItmId))  Q:auditItmId=""  d
	.s ordseNum = $lg(^PHA.PREADT.AuditListD(auditItmId),18)
	.s arcItemCode = $lg(^PHA.PREADT.AuditListD(auditItmId),4)
	.s seqNo = $lg(^PHA.PREADT.AuditListD(auditItmId),3)
	.i retData = ""  d
	..s retData = auditItmId_"^"_arcItemCode_"^"_seqNo_"^"_retFlag
	.e  d
	..s retData = retData_"!!"_auditItmId_"^"_arcItemCode_"^"_seqNo_"^"_retFlag
	Q retData
}

/// w ##class(web.DHCPRESCCommonUtil).GetPdssRes(912)
ClassMethod GetPdssRes(auditId)
{
	s result = $lg(^PHA.PREADT.AuditD(auditId),17)
	Q result
}

/// Descript:获取当日在线科室列表
/// Creator:sufan
/// CreateDate:2022-06-14
/// w ##class(web.DHCPRESCCommonUtil).GetOnlineLocList()
ClassMethod GetOnlineLocList()
{
	s locList = ""
	s schId = ""
	for  s schId = $o(^CF.PHA.PREADT.DicSchemeD(schId)) Q:schId=""  d
	.;s onLinestate = $lg(^CF.PHA.PREADT.DicSchemeD(schId),5)
	.s logId = $o(^PHA.PREADT.DicSchemelogI("PrDate",+$h,schId,""),-1)
	.q:logId=""
	.s onLinestate = $lg(^PHA.PREADT.DicSchemelogD(logId),3)
	.Q:onLinestate'="在线"
	.s itmId = ""
	.for  s itmId = $o(^CF.PHA.PREADT.SchLinkLocI("ItemCodeIndex",schId,itmId))  Q:itmId=""  d
	..s type = $lg($g(^CF.PHA.PREADT.SchLinkLocD(itmId)),4)
	..Q:type'="CTLoc"
	..s typeId = $lg(^CF.PHA.PREADT.SchLinkLocD(itmId),3)
	..s locDesc = ""
	..s:typeId'="" locDesc = $p(^CTLOC(typeId),"^",2)
	..Q:locDesc=""
	..i locList=""  s locList = locDesc
	..e  s locList = locList_","_locDesc
	Q locList
}

/// w ##class(web.DHCPRESCCommonUtil).SynPrescAuditStatus("4245348^I211001014544^66018^86340")
ClassMethod SynPrescAuditStatus(auditId)
{
	
	Q:$d(^PHA.PREADT.AuditResultI("Parref",auditId)) "0"
	s ^temptest("33xxx") = auditId
	s itemId = ""				//审核原因
	s userId = "1"				//审核药师
	s stateCode = "STA04"		//状态代码
	s readCode = ""				//已读标识
	s remark = "自动通过"		//备注
	s createDate = +$h
	s createTime = $p($h,",",2)  
	s listData = auditId_"^"_itemId_"^"_userId_"^"_stateCode_"^"_readCode_"^"_remark_"^"_createDate_"^"_createTime
	s ret = 0
	s ret = ##class(web.DHCPRESCAudit).saveAuditInfo(listData)
	
	q ret
}

/// Descript:获取过敏记录
/// Input:admId,就诊id
/// w ##class(web.DHCPRESCCommonUtil).GetAlleList()
ClassMethod GetAlleList(admId)
{
	s patientId = $p($g(^PAADM(admId)),"^",1)
	s retList = ""
	s count = 0
	s sub = 0
	for  s sub = $o(^PAPER(patientId,"ALG",sub))	Q:sub=""  d
	.s allerName = ""
	.s checkConFlag = $p($g(^PAPER(patientId,"ALG",sub,"DHC")),"^",3)
	.;Q:checkConFlag'="Y"
	.s status = $p($g(^PAPER(patientId,"ALG",sub)),"^",8)
	.Q:status="I"
	.s alleGicId = $p($g(^PAPER(patientId,"ALG",sub)),"^",9)
	.if alleGicId'="" d
	..s allerCode = $p($g(^PAC("ALG",alleGicId)),"^",1)
	..s allerName = $p($g(^PAC("ALG",alleGicId)),"^",2)
	.else  d
	..s externalId = $p($g(^PAPER(patientId,"ALG",sub)),"^",30)
	..if externalId'="" d
	...s allerCode = $p($g(^ARCIM(+externalId,$p(externalId,"||",2),1)),"",1)
	...s allerName = $p($g(^ARCIM(+externalId,$p(externalId,"||",2),1)),"^",2)
	.s count = count+1
	.i (retList="")&&(allerName'="") d
	..s retList = count_":"_allerName
	.e  if (retList'="")&&(allerName'="")  d
	..s retList = retList_","_count_":"_allerName
	Q retList
}

ClassMethod UpdAuditOrd(auditResList)
{
	s len = $l(auditResList,"!!")
	s ret = 0
	for i=1:1:len  d
	.s subList = $p(auditResList,"!!",i)
	.s oeordId = $p(subList,"^",1)
	.s unique = $p(subList,"^",2)
	.&sql(update PHA_PREADT.AuditList set PAL_OEORI_Dr=:oeordId where PAL_RowID=:unique)
	.s ret = SQLCODE
	q ret
}

/// Descript:获取医嘱下拉框[药品]
/// w ##class(web.DHCPRESCCommonUtil).QueryDrugList("2")
ClassMethod QueryDrugList(hospId, q = "")
{
	
	s q = $$ALPHAUP^SSUTIL4(q)
	w "["
	set count = 0
	s subcript = "0"
	for  s subcript = $o(^ARCIM(subcript)) Q:subcript=""  d
	.s version = "0"
	.for  s version = $o(^ARCIM(subcript,version))  Q:version=""  d
	..s arcItmId = subcript_"||"_version
	..s code = $p(^ARCIM(subcript,version,1),"^",1)
	..s desc = $p(^ARCIM(subcript,version,1),"^",2)
	..s isHospFlag = ..getArcHosp(subcript,version,hospId)
	..Q:isHospFlag'="Y"
	..s alias = ..GetArcAlias(arcItmId)
	..q:(q'="")&&(alias'[q)&&(desc'[q)
	..s itmcatId = $p(^ARCIM(subcript,version,1),"^",10)
	..s ordType = $p(^ARC("IC",itmcatId),"^",7)
	..Q:ordType'="R"
	..s count = count+1
	..i count = 1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData("value^text",arcItmId_"^"_desc)	
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",arcItmId_"^"_desc)		
	
	w "]"
	q ""
}

ClassMethod getArcHosp(subscript, version, hospId)
{
	s isThisHospFlag = "N"
	s subId = "0"
	for  s subId = $o(^ARCIM(subscript,version,"HOSP",subId)) Q:(subId="")||(isThisHospFlag="Y")  d
	.s linkHospId = $p(^ARCIM(subscript,version,"HOSP",subId),"^",1)
	.Q:hospId'=linkHospId
	.s isThisHospFlag = "Y"
	Q isThisHospFlag
}

/// Descript:获取医嘱别名
/// w ##class(web.DHCPRESCCommonUtil).GetArcAlias("FFSJXJ")
ClassMethod GetArcAlias(arcItmId)
{
	s aliasId = ""
	s aliasRet = ""
	for  s aliasId = $o(^ARC("ALIAS",0,"ARCIM",arcItmId,aliasId)) Q:aliasId=""  d
	.s alias = $p(^ARC("ALIAS",aliasId),"^",6)
	.i aliasRet = "" s aliasRet = alias
	.e  s aliasRet = aliasRet_","_alias
	Q aliasRet
}

/// Descript:获取合理用药医生批注信息
/// w ##class(web.DHCPRESCCommonUtil).QueryDocNote("FFSJXJ")
ClassMethod QueryDocNote(auditId)
{
	s noteList = ""
	s msgId = $lg(^PHA.PREADT.AuditD(auditId),2)
	Q:msgId="" noteList
	s feedBackId = ""
	for  s feedBackId = $o(^CKB.PDSS.FeedBackI("MsgIDType",msgId,"Doc",feedBackId))  Q:feedBackId=""  d
	.s note = $lg(^CKB.PDSS.FeedBackD(feedBackId),9)
	.i noteList="" s noteList = note
	.e  s noteList = noteList_","_note
	Q noteList
}

/// Creator:    sufan
/// CreateDate: 2023-04-18
/// Descript:	取药师的审方阅读时间
/// InPut:      审方主表ID
/// OutPut:     分配开关配置
/// w ##class(web.DHCPRESCCommonUtil).GetOverReadTime("1916")
ClassMethod GetOverReadTime(AuditId As %String) As %String
{
	s HospID=##class(web.DHCPRESCCommonUtil).GetHospIDByAuditID(AuditId)
	s ret=##class(web.DHCPRESCCommonUtil).GetSysConfig("OVERREADTIME",HospID)
	q ret
}

/// Description: 科室(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 科室(下拉框) 信息
/// Others:		 w ##class(web.DHCPRESCCommonUtil).QueryLocDescCombo("12")
ClassMethod QueryLocDescCombo(hospId, q)
{
  s q=$$ALPHAUP^SSUTIL4(q)
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  s LocDr="",LocDesc=""
  F  S LocDr=$o(^CTLOC(LocDr)) Q:LocDr=""  D
  .S LocDesc=$p(^CTLOC(LocDr),"^",2) //描述
  .Q:LocDesc=""
  .Q:(hospId'="")&(hospId'=$p(^CTLOC(LocDr),"^",22))
  .S DateActiveFrom=$p(^CTLOC(LocDr),"^",24) // 科室 开始日期 
  .S DateActiveTo=$p(^CTLOC(LocDr),"^",25) // 科室  结束日期
  .Q:((DateActiveFrom'="")&&(DateActiveFrom>+$h))||((DateActiveTo'="")&&(DateActiveTo<+$h))
  .S ContactName=$p(^CTLOC(LocDr),"^",43) // 科室编码  
  .Q:(q'="")&&(ContactName'[q)&&(LocDesc'[q)
  .d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",LocDr).Put("text",LocDesc))
  w jsonObj.ListToJson(listObj)
  q ""
}

/// Description: 医生(下拉框) 
/// Creator:     sufan
/// CreateDate:  2023-04-24
/// Input:  	 
/// Return: 	 医生(下拉框) 信息
/// Others:		 w ##class(web.DHCPRESCCommonUtil).QueryDocDescComb(2)
ClassMethod QueryDocDescComb(hospId = "", q = "")
{
	s q=$$ALPHAUP^SSUTIL4(q)
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
  	s listObj=##class(%ListOfObjects).%New()
	s careProId = "0"
	for  s careProId = $o(^CTPCP(careProId)) Q:careProId=""  d
	.s careName = $p(^CTPCP(careProId,1),"^",2)
	.Q:(q'="")&&(LocDesc'[q)
	.s carPrvTpId = $p(^CTPCP(careProId,1),"^",4)
	.s internalType = $p(^CT("CPT",carPrvTpId),"^",4)
	.Q:internalType'="DOCTOR"
	.s userId = $o(^SSU("SSUSR",0,"CTPCP",careProId,""))
	.Q:userId=""
	.s hospitalId = $p(^SSU("SSUSR",userId),"^",98)
	.Q:(hospId'="")&&(hospId'=hospitalId)
	.d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",careProId).Put("text",careName))
  	w jsonObj.ListToJson(listObj)
  	q ""
}

/// Description: 药师(下拉框) 
/// Creator:     sufan
/// CreateDate:  2023-04-24
/// Input:  	 
/// Return: 	 药师(下拉框) 信息
/// Others:		 w ##class(web.DHCPRESCCommonUtil).QueryPhaDescComb()
ClassMethod QueryPhaDescComb(q = "", hospId)
{
	s q=$$ALPHAUP^SSUTIL4(q)
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
  	s listObj=##class(%ListOfObjects).%New()
	s careProId = "0"
	for  s careProId = $o(^CTPCP(careProId)) Q:careProId=""  d
	.s careName = $p(^CTPCP(careProId,1),"^",2)
	.Q:(q'="")&&(LocDesc'[q)
	.s carPrvTpId = $p(^CTPCP(careProId,1),"^",4)
	.s internalType = $p(^CT("CPT",carPrvTpId),"^",4)
	.Q:internalType'="Pharmacist"
	.s userId = $o(^SSU("SSUSR",0,"CTPCP",careProId,""))
	.Q:userId=""
	.s hospitalId = $p(^SSU("SSUSR",userId),"^",98)
	.Q:(hospId'="")&&(hospId'=hospitalId)
	.d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",careProId).Put("text",careName))
  	w jsonObj.ListToJson(listObj)
  	q ""
}

/// Creator:    sufan
/// CreateDate: 2023-04-18
/// Descript:	取最大审核张数
/// InPut:      审方主表ID
/// OutPut:     分配开关配置w ##class(web.DHCPRESCCommonUtil).GetMaxViewCount("2^^20725^")
/// 
ClassMethod GetMaxViewCount(userId As %String) As %String
{

	s ret=##class(web.DHCPRESCCommonUtil).GetSysConfig("MAXVIEWCOUNT",userId)
	q ret
}

/// Creator:sufan
/// Descript:判断在线的药师是否达到最大审核张数
/// Input:处方科室
/// w ##class(web.DHCPRESCCommonUtil).IsOverMaxViewNum("神经外科")
ClassMethod IsOverMaxViewNum(locDesc)
{
	s overFlag = ""
	s overList = ""
	s schId = ""
	for  s schId = $o(^CF.PHA.PREADT.DicSchemeD(schId)) Q:schId=""  d
	.s overFlag = "N"
	.;s onLinestate = $lg(^CF.PHA.PREADT.DicSchemeD(schId),5)
	.s logId = $o(^PHA.PREADT.DicSchemelogI("PrDate",+$h,schId,""),-1)
	.q:logId=""
	.s onLinestate = $lg(^PHA.PREADT.DicSchemelogD(logId),3)
	.Q:onLinestate'="在线"
	.s locList = ""
	.s itmId = ""
	.for  s itmId = $o(^CF.PHA.PREADT.SchLinkLocI("ItemCodeIndex",schId,itmId))  Q:itmId=""  d
	..s type = $lg($g(^CF.PHA.PREADT.SchLinkLocD(itmId)),4)
	..Q:type'="CTLoc"
	..s typeId = $lg(^CF.PHA.PREADT.SchLinkLocD(itmId),3)
	..s locDesc = "",hospId = ""
	..s:typeId'="" locDesc = $p(^CTLOC(typeId),"^",2)
	..s:typeId'="" hospId = $p(^CTLOC(typeId),"^",22)
	..Q:locDesc=""
	..i locList=""  s locList = locDesc
	..e  s locList = locList_","_locDesc
	.Q:((locList'="")&&((","_locList_",")'[(","_locDesc_","))) 
	.s userId = $lg(^CF.PHA.PREADT.DicSchemeD(schId),2)
	.s viewNum = ##class(web.DHCPRESCCommonUtil).GetMaxViewCount(hospId_"^^"_userId_"^")
	.;Q:+viewNum="0"
	.s auditNum = ..GetAuditNum(userId,viewNum)
	.s:(auditNum>viewNum)&&(+viewNum'=0) overFlag = "Y"
	.s overList= overList_overFlag
	s:(overList["Y")&&(overList'["N") overFlag="Y"
	Q overFlag
}

/// Creator:取本人当天审核的数量
/// w ##class(web.DHCPRESCCommonUtil).GetAuditNum("20755",1)
ClassMethod GetAuditNum(userId, viewNum)
{
	q:viewNum="" ""
	s resId = 0
	s count = 0
	for  s resId = $o(^PHA.PREADT.AuditResultI("UserDate",+$H,userId,resId)) q:(resId="")||(count>viewNum)  d
	.s count = count+1
	Q count
}

}
