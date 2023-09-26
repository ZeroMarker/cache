Class web.DHCPRESCOverview Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	今日审核动态
/// Creator:    hxy
/// CreateDate: 2022-02-25
/// InPut:      
/// OutPut:     今日处方总数（合理用药总数）
///             今日系统拦截（合理用药禁止）
///             今日系统审查不通过（合理用药警示）
///             今日人工审核（审方已审且非自动通过的数量）
///             今日人工审核后拒绝发药（审方结果为必须修改+双签通过的数量）
///             今日沟通后返回修改（审方结果为必须修改的数量）
/// w ##class(web.DHCPRESCOverview).GetTodayAuditDynamic()
ClassMethod GetTodayAuditDynamic()
{
	s Date=+$h
	s TotalNum=0,Hook=0,NoPass=0,Human=0,HumanRefuse=0,HumanReturn=0
	s MonId = ""
	f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	.s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	.s Adm = $lg(MonData,2)   // 就诊id
	.;q:Adm=""
	.s TotalNum=TotalNum+1                     // 合理用药总数
	.s ManLev = $lg(MonData,8) // 审查级别
	.s:ManLev="forbid" Hook=Hook+1             // 合理用药禁止
	.s:ManLev="warn" NoPass=NoPass+1           // 合理用药警示
	.s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	.i AuditId'="" d
	..s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	..s Remark="",ResStatus=""
	..s:AuditResult'="" Remark=$lg(^PHA.PREADT.AuditResultD(AuditResult),7)
	..s:(AuditResult'="")&(Remark'["自动通过") Human=Human+1   // 审方非自动通过的数量
	..s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	..s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	..s:ResStatus="STA01" HumanRefuse=HumanRefuse + 1
	..s:ResStatus="STA03" HumanRefuse=HumanRefuse + 1 // 审方结果为必须修改+双签通过的数量
	..s:ResStatus="STA01" HumanReturn=HumanReturn + 1 // 审方结果为必须修改的数量
	.
	s ListData=TotalNum_"^"_Hook_"^"_NoPass_"^"_Human_"^"_HumanRefuse_"^"_HumanReturn
	s ListTitle="TotalNum^Hook^NoPass^Human^HumanRefuse^HumanReturn"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// w ##class(web.DHCPRESCOverview).GetYearAuditDynamic("2022-06-01","2022-06-20",1)
ClassMethod GetYearAuditDynamic(startDate, endDate, Pid)
{
	n (startDate, endDate, Pid)
	
	s DrugDataID=##class(web.DHCCKBCommon).GetDrugData()  				// 西药
	s ChineseDrugDataID=##class(web.DHCCKBCommon).GetChineseDrugData()  // 中成药
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(startDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(endDate)
	
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	s dateNum = EdDate-StDate
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	k ^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCOverview",Pid)
	s LocNum=0,DoctorNum=0,phaNum=0,DrugNum=0,ChineseDrugDataNum=0,DrugDataNum=0,HumanNum=0,allDrug=0
	s LocStr="*"
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2)   // 就诊id
	..s ExaParam = $lg(MonData,9)	//入参
	..q:ExaParam["UNDEFINED"
	..s allDrug=allDrug+1   //处方数
	..s Loc = $lg(MonData,6) // 科室
	..q:Loc=""
	..s doctor = $lg(MonData,5)	// 医生
	..q:doctor=""
	..i '$d(^TMP("DHCPRESC","web.DHCPRESCOverview",Pid,"Loc",Loc)) d
	...s ^TMP("DHCPRESC","web.DHCPRESCOverview",Pid,"Loc",Loc)=""
	...s LocNum=LocNum+1   //科室数量
	..i '$d(^TMP("DHCPRESC","web.DHCPRESCOverview",Pid,"Doctor",doctor)) d
	...s ^TMP("DHCPRESC","web.DHCPRESCOverview",Pid,"Doctor",doctor)=""
	...s DoctorNum=DoctorNum+1  //医生数量
	..;s ExaParamObj = ##class(%DynamicArray).%FromJSON(ExaParam)
	..s DregLength = ..getDregLength(ExaParam)
	..s DrugNum = DrugNum + DregLength  		// 处方所包含的药品总数
	..s ManLev = $lg(MonData,8) // 审查级别
	..s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	..i AuditId'="" d
	...s HumanNum=HumanNum+1
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus="",pha=""
	...s:AuditResult'="" pha=$lg(^PHA.PREADT.AuditResultD(AuditResult),3)
	...s:pha'="" pha=$p(^SSU("SSUSR",pha),"^",2)
	...q:pha=""
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCOverview",Pid,"pha",pha)) d
	....s ^TMP("DHCPRESC","web.DHCPRESCOverview",Pid,"pha",pha)=""
	....s phaNum=phaNum+1  //药师数量

	s ListData=dateNum_"^"_LocNum_"^"_DoctorNum_"^"_phaNum_"^"_DrugNum_"^"_allDrug_"^"_HumanNum
	s ListTitle="dateNum^LocNum^DoctorNum^phaNum^Drugum^allDrug^HumanNum"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// 药品数量
ClassMethod getDregLength(ExaParam)
{
	n (ExaParam)
	S $ZT="WSSSERROR"
	s ExaParamObj = ##class(%DynamicArray).%FromJSON(ExaParam)
	s DrugArr = ExaParamObj.%Get("Drug")	 	// 医嘱
	s DregLength = DrugArr.%Size()
	q DregLength
WSSSERROR
	q 0
}

/// Descript:	审查统计图表
/// Creator:    xww
/// CreateDate: 2022-06-23
/// InPut:      
/// OutPut:     今日处方总数（合理用药总数）
///             今日系统拦截（合理用药禁止）
///             今日系统审查不通过（合理用药警示）
///             今日人工审核（审方已审且非自动通过的数量）
///             今日人工审核后拒绝发药（审方结果为必须修改+双签通过的数量）
///             今日沟通后返回修改（审方结果为必须修改的数量）
/// w ##class(web.DHCPRESCOverview).GetAuditStatPie()
ClassMethod GetAuditStatPie()
{
	s Date=+$h-3
	s TotalNum=0,SysPassNum=0,SysInterceptNum=0,SysNoPassNum=0,ModifyNum=0,HumanPassNum=0
	s HumanRefuseNum=0,HumanReturnNum=0,CounterSignNum=0
	s MonId = ""
	f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	.s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	.s Adm = $lg(MonData,2)  // 就诊id
	.;q:Adm=""
	.s TotalNum=TotalNum+1     // 合理用药总数
	.s ManLev = $lg(MonData,8) // 审查级别
	.i ManLev = "" d
	..s SysPassNum = SysPassNum + 1 		   // 系统审查通过数量(审核级别为正常的数量)
	.e  i ManLev="forbid" d
	..s SysInterceptNum = SysInterceptNum + 1  // 系统审查拦截数(审核级别为禁止的数量)
	.e  d
	..s SysNoPassNum = SysNoPassNum + 1 	   // 系统审查不通过数(审核级别为提示，提醒，警示数量)
	.s CMLastId = $lg(MonData,18) // 关联上一次的日志id(流转信息用)
	.i CMLastId'="" d
	..s ModifyNum = ModifyNum + 1 // 医生对系统审查结果返回修改次数
	
	.s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	.i AuditId'="" d
	..s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	..s Remark="",ResStatus=""
	..s:AuditResult'="" Remark=$lg(^PHA.PREADT.AuditResultD(AuditResult),7)
	..;s:(AuditResult'="")&(Remark'["自动通过") Human=Human+1   // 审方非自动通过的数量
	..s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	..s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	..s:ResStatus="STA04" HumanPassNum=HumanPassNum + 1  // 人工审核通过的数量
	..s:ResStatus="STA01" HumanRefuseNum=HumanRefuseNum + 1
	..i ResStatus="STA03" d
	...s CounterSignNum=CounterSignNum+1  // 双签执行
	...s HumanRefuseNum=HumanRefuseNum + 1 // 人工审核拒绝发药数量(审方结果为必须修改+双签通过的数量)
	..s:ResStatus="STA01" HumanReturnNum=HumanReturnNum + 1 // 人工审核不通过数量(审方结果为必须修改的数量)
	
	s ListData=TotalNum_"^"_SysPassNum_"^"_SysInterceptNum_"^"_SysNoPassNum_"^"_ModifyNum_"^"_HumanPassNum
	s ListData=ListData_"^"_HumanRefuseNum_"^"_HumanReturnNum_"^"_CounterSignNum
	q ListData
}

}
