Class web.DHCPRESCInterventQueryByDrug Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Test()
{
	w ##class(web.DHCPRESCInterventQueryByDrug).QueryByDrug(10,1,"2022-03-29^2022-03-29^^184577")
}

/// Descript:	详细数据(审核干预情况按药品)
/// Creator:    xww
/// CreateDate: 2022-03-25
/// InPut:      
/// OutPut:     科室名称
///             监测药品标识数（合理用药总数）
///             系统审查拦截次数(率)（合理用药禁止）
///             系统审查不通过次数(率)（合理用药警示）
///             医生选择药师审核次数(率)（审方数）
///             药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
///             双签执行次数(率)（审方结果为双签通过的数量）
///             返回修改次数(率)（审方结果为必须修改的数量）
/// w ##class(web.DHCPRESCInterventQueryByDrug).QueryByDrug("10","1","2022-06-06^2022-06-06^^251607")
ClassMethod QueryByDrugOld(rows, page, Params)
{
	//n (rows, page, Params)
	s ^TMPTEST("QueryByDrug")=$lb(rows, page, Params)
	;w $zts
	s End=page*rows
	s Start=(page-1)*rows+1	
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s LocDesc= $p(Params,"^",3)
	s Pid = $p(Params,"^",4)
	q:Pid="" ""
	s DrugDataID=##class(web.DHCCKBCommon).GetDrugData()  				// 西药
	s ChineseDrugDataID=##class(web.DHCCKBCommon).GetChineseDrugData()  // 中成药
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	k ^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid)
	s DrugNum=0,DrugTrementNum=0,QueErrNum=0,ChineseDrugDataNum=0,DrugDataNum=0,DrugSignNum=0
	s LocNum=0,TotalNum=0,Hook=0,NoPass=0,HumanRefuse=0,HumanDouble=0
	s LocStr="*"
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2) // 就诊id
	..;q:Adm=""
	..s Loc = $lg(MonData,6) // 科室
	..q:Loc=""
	..s ExaParam = $lg(MonData,9)	//入参
	..q:ExaParam["UNDEFINED"
	..s ExaParamObj = ##class(%DynamicArray).%FromJSON(ExaParam)
	..s DrugArr = ExaParamObj.%Get("Drug")	 	// 医嘱
	..s DregLength = DrugArr.%Size()
	..s DrugNum = DrugNum + DregLength  		// 处方所包含的药品总数
	..s TotalNum=TotalNum+1                     // 合理用药总数
	..s ManLev = $lg(MonData,8) // 审查级别
	..s DrugParrf=""
	..f Len=0:1:DregLength-1  d
	...s DrugObj = DrugArr.%Get(Len)
	...s DrugTrement = DrugObj.Treatment 		 //疗程
	...s DrugTrementNum = DrugTrementNum + (+DrugTrement)  //所有处方的疗程 
	...s DrugName = DrugObj.item
	...s Libvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugName,"Drug")	 // 获取对照的药品
	...s LibDicId = +$listtostring(Libvalue)
	...;b
	...q:LibDicId=0
	...f DrugSignLen=1:1:$l(drugsign,"^") d
	....s DrugSignId=$p(drugsign,"^",DrugSignLen)
	....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(LibDicId,DrugSignCode)   // 取维护的属性值
	....q:DrugSignAttrValue=""
	....i '$d(^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid,DrugSignId)) d
	.....s DrugSignNum=DrugSignNum+1			// 监测药品标识数
	.....s ^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid,DrugSignId)=""
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocTotalNum")) d //处方开具次数（合理用药总数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocTotalNum")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocTotalNum")+1
	....i ManLev="forbid" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHook")) d //系统审查拦截次数(率)（合理用药禁止）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHook")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHook")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHook")+1
	....i ManLev="warn" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocNoPass")) d //系统审查不通过次数(率)（合理用药警示）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocNoPass")+1

	...q:(DrugParrf=DrugDataID)||(DrugParrf=ChineseDrugDataID)
	...s DrugParrf = $lg(^CT.CKB.PDSS.CommonDictionD(LibDicId),"^",4)   // 获取药品是西药还是中药
	
	..i DrugParrf=DrugDataID  d
	...s DrugDataNum=DrugDataNum+1				 // 西药处方数
	..e  i DrugParrf=ChineseDrugDataID d	
	...s ChineseDrugDataNum=ChineseDrugDataNum+1 // 中药处方数
	..s MonItmId=""
	..for  s MonItmId = $o(^CKB.PDSS.MonQueListI("Parref",MonId,MonItmId)) Q:MonItmId=""  d
	...s QueErrNum = QueErrNum + 1    			// 不合理问题数
	
	..s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	..i AuditId'="" d
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)	
	...s subId = ""
	...f  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",AuditId,subId))  Q:subId=""  d
	....s DrugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	....s DrugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	....s AuditLibvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugDesc,"Drug")	 // 获取对照的药品
	....s AuditLibDicId = +$listtostring(AuditLibvalue)

	....q:AuditLibDicId=0
	....f AuditDrugSignLen=1:1:$l(drugsign,"^") d
	.....s DrugSignId=$p(drugsign,"^",AuditDrugSignLen)
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(AuditLibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""
	.....s:ResStatus="STA01" HumanRefuse=HumanRefuse + 1
	.....s:ResStatus="STA03" HumanRefuse=HumanRefuse + 1 // 审方结果为必须修改+双签通过的数量
	.....s:ResStatus="STA03" HumanDouble=HumanDouble + 1 // 审方结果为必须修改的数量
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocAudit")) d //医生选择药师审核次数(率)（审方数）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocAudit")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocAudit")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocAudit")+1
	.....i ResStatus="STA01" d
	......i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass")) d //药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass")=1
	......e  d
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass")+1
	......i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanReturn")) d //返回修改次数(率)（审方结果为必须修改的数量）
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanReturn")=1
	......e  d
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanReturn")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanReturn")+1
	.....i ResStatus="STA03" d
	......i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass")) d //药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass")=1
	......e  d
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass")+1
	......i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanDouble")) d //双签执行次数(率)（审方结果为双签通过的数量）
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanDouble")=1
	......e  d
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanDouble")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanDouble")+1
	....
	....
	
	s PrescAvgNum=0,QueErrAvgNum=0,PrescTrementAvgNum=0
	i TotalNum'=0 d
	.s PrescAvgNum=$fn(DrugNum/TotalNum,"",1)   // 处方平均包含药品数
	.s QueErrAvgNum=$fn(QueErrNum/TotalNum,"",1)	// 处方平均不合理问题数
	.s PrescTrementAvgNum=$fn(DrugTrementNum/DrugNum,"",1)		// 处方平均用药天数
	
	
	s count=0
	w "{""rows"":["
	s listTitle ="DrugSign^DrugTotalNum^DrugHook^DrugNoPass^DrugAudit^DrugHumanNoPass^DrugHumanDouble^DrugHumanReturn"
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign)) Q:(Sign="")  d
	.;q:(LocDesc'="")&(Loc'=LocDesc)
	.s DrugSignDesc= $lg(^CT.CKB.PDSS.CommonDictionD(Sign),3)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocTotalNum"))
	.s LocHook=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocHook"))
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocNoPass"))
	.s LocAudit=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocAudit"))
	.s LocHumanNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocHumanNoPass"))
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocHumanDouble")) 
	.s LocHumanReturn=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocHumanReturn"))
	.i LocTotalNum'=0 d
	..s LocHook=LocHook_" ("_$fn(LocHook/LocTotalNum*100,"",2)_"%)"					
	..s LocNoPass=LocNoPass_"("_$fn(LocNoPass/LocTotalNum*100,"",2)_"%)"		
	..s LocAudit=LocAudit_" ("_$fn(LocAudit/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanNoPass=LocHumanNoPass_" ("_$fn(LocHumanNoPass/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanDouble=LocHumanDouble_" ("_$fn(LocHumanDouble/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanReturn=LocHumanReturn_" ("_$fn(LocHumanReturn/LocTotalNum*100,"",2)_"%)"						
	.s list = DrugSignDesc_"^"_LocTotalNum_"^"_LocHook_"^"_LocNoPass_"^"_LocAudit_"^"_LocHumanNoPass_"^"_LocHumanDouble_"^"_LocHumanReturn
	.s count=count+1	
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)

 	w "],""total"":"_count
 	w ",""DrugSignNum"":"_DrugSignNum_",""PrescAvgNum"":"_PrescAvgNum_",""QueErrAvgNum"":"_QueErrAvgNum_",""DrugDataNum"":"_DrugDataNum_",""ChineseDrugDataNum"":"_ChineseDrugDataNum
 	w ",""PrescTrementAvgNum"":"_PrescTrementAvgNum
 	w "}"
 	;w $zts
 	q ""
}

/// Description:	处方总通过率排行
/// Creator:		xww
/// CreateDate:		2022-03-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByDrug).QueryLocPassAll("2022-03-29^2022-03-29^asc^185043")
ClassMethod QueryLocPassAllOld(Params)
{
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s order= $p(Params,"^",3)
	s order=$case(order,"asc":1,"desc":-1,"":1)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2)   // 就诊id
	..;q:Adm=""
	..s Loc = $lg(MonData,6)	// 科室
	..q:Loc=""
	..s ExaParam = $lg(MonData,9)	//入参
	..q:ExaParam["UNDEFINED"
	..s ExaParamObj = ##class(%DynamicArray).%FromJSON(ExaParam)
	..s DrugArr = ExaParamObj.%Get("Drug")	 	// 医嘱
	..s DregLength = DrugArr.%Size()
	..s ManLev = $lg(MonData,8) // 审查级别
	..s DrugParrf=""
	..f Len=0:1:DregLength-1  d
	...s DrugObj = DrugArr.%Get(Len) 
	...s DrugName = DrugObj.item
	...s Libvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugName,"Drug")	 // 获取对照的药品
	...s LibDicId = +$listtostring(Libvalue)
	...q:LibDicId=0
	...f DrugSignLen=1:1:$l(drugsign,"^") d
	....s DrugSignId=$p(drugsign,"^",DrugSignLen)
	....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(LibDicId,DrugSignCode)   // 取维护的属性值
	....q:DrugSignAttrValue=""
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocTotalNum")) d //处方开具次数（合理用药总数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocTotalNum")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocTotalNum")+1
	....i ManLev="forbid" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocHook")) d //系统审查拦截次数(率)（合理用药禁止）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocHook")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocHook")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocHook")+1
	....i ManLev="warn" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocNoPass")) d //系统审查不通过次数(率)（合理用药警示）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocNoPass")+1
	
	..s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	..i AuditId'="" d
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)	
	...s subId = ""
	...f  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",AuditId,subId))  Q:subId=""  d
	....s DrugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	....s DrugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	....s AuditLibvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugDesc,"Drug")	 // 获取对照的药品
	....s AuditLibDicId = +$listtostring(AuditLibvalue)
	....q:AuditLibDicId=0
	....f AuditDrugSignLen=1:1:$l(drugsign,"^") d
	.....s DrugSignId=$p(drugsign,"^",DrugSignLen)
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(LibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""	
	.....i ResStatus="STA04" d
	......i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocHumanPass")) d //审方结果为通过的数量
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocHumanPass")=1
	......e  d
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocHumanPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocHumanPass")+1

	
	

	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=$lg(^CT.CKB.PDSS.CommonDictionD(Sign),3)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,Sign,"LocTotalNum"))
	.s LocHook=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,Sign,"LocHook"))
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,Sign,"LocNoPass"))
	.s LocHumanPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,Sign,"LocHumanPass")) 
	.i LocTotalNum'=0 d
	..s LocPassAll=$fn(LocTotalNum-LocHook-LocNoPass+LocHumanPass/LocTotalNum*100,"",2)
	..s Rate=LocPassAll
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,"LocPassAll",LocPassAll)) s LocPassAll=LocPassAll+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,"LocPassAll",LocPassAll) = DrugSignDesc_"^"_Rate

	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,"LocPassAll",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,"LocPassAll",Rate)
	.s count=count+1
	.q:(count>11)	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid)
	q ""
}

/// Description:	系统审查通过率排行
/// Creator:		xww
/// CreateDate:		2022-03-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByDrug).QueryLocPass("2022-03-29^2022-03-29^asc^185043")
ClassMethod QueryLocPassOld(Params)
{
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s order= $p(Params,"^",3)
	s order=$case(order,"asc":1,"desc":-1,"":1)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2)   // 就诊id
	..;q:Adm=""
	..s Loc = $lg(MonData,6)	// 科室
	..q:Loc=""
	..s ExaParam = $lg(MonData,9)	//入参
	..q:ExaParam["UNDEFINED"
	..s ExaParamObj = ##class(%DynamicArray).%FromJSON(ExaParam)
	..s DrugArr = ExaParamObj.%Get("Drug")	 	// 医嘱
	..s DregLength = DrugArr.%Size()
	..s ManLev = $lg(MonData,8) // 审查级别
	..s DrugParrf=""
	..f Len=0:1:DregLength-1  d
	...s DrugObj = DrugArr.%Get(Len) 
	...s DrugName = DrugObj.item
	...s Libvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugName,"Drug")	 // 获取对照的药品
	...s LibDicId = +$listtostring(Libvalue)
	...q:LibDicId=0
	...f DrugSignLen=1:1:$l(drugsign,"^") d
	....s DrugSignId=$p(drugsign,"^",DrugSignLen)
	....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(LibDicId,DrugSignCode)   // 取维护的属性值
	....q:DrugSignAttrValue=""
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocTotalNum")) d //处方开具次数（合理用药总数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocTotalNum")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocTotalNum")+1
	....i ManLev="forbid" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocHook")) d //系统审查拦截次数(率)（合理用药禁止）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocHook")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocHook")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocHook")+1
	....i ManLev="warn" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocNoPass")) d //系统审查不通过次数(率)（合理用药警示）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocNoPass")+1

	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=$lg(^CT.CKB.PDSS.CommonDictionD(Sign),3)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,Sign,"LocTotalNum"))
	.s LocHook=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,Sign,"LocHook"))
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,Sign,"LocNoPass"))
	.i LocTotalNum'=0 d
	..s LocPass=$fn(LocTotalNum-LocHook-LocNoPass/LocTotalNum*100,"",2)
	..s Rate=LocPass
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,"LocPass",LocPass)) s LocPass=LocPass+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,"LocPass",LocPass) = DrugSignDesc_"^"_Rate


	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,"LocPass",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,"LocPass",Rate)
	.s count=count+1
	.q:(count>11)	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid)
	q ""
}

/// Description:	人工审核通过率排行
/// Creator:		xww
/// CreateDate:		2022-03-01	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByDrug).QueryHumanPass("^^desc^1")
ClassMethod QueryHumanPassOld(Params)
{
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s order= $p(Params,"^",3)
	s order=$case(order,"asc":1,"desc":-1,"":1)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2)   // 就诊id
	..;q:Adm=""
	..s Loc = $lg(MonData,6)	// 科室
	..q:Loc=""
	..s ExaParam = $lg(MonData,9)	//入参
	..q:ExaParam["UNDEFINED"
	..s ExaParamObj = ##class(%DynamicArray).%FromJSON(ExaParam)
	..s DrugArr = ExaParamObj.%Get("Drug")	 	// 医嘱
	..s DregLength = DrugArr.%Size()
	..s ManLev = $lg(MonData,8) // 审查级别
	..s DrugParrf=""
	..f Len=0:1:DregLength-1  d
	...s DrugObj = DrugArr.%Get(Len) 
	...s DrugName = DrugObj.item
	...s Libvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugName,"Drug")	 // 获取对照的药品
	...s LibDicId = +$listtostring(Libvalue)
	...q:LibDicId=0
	...f DrugSignLen=1:1:$l(drugsign,"^") d
	....s DrugSignId=$p(drugsign,"^",DrugSignLen)
	....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(LibDicId,DrugSignCode)   // 取维护的属性值
	....q:DrugSignAttrValue=""
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocTotalNum")) d //处方开具次数（合理用药总数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocTotalNum")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocTotalNum")+1
	
	..s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	..i AuditId'="" d
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)	
	...s subId = ""
	...f  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",AuditId,subId))  Q:subId=""  d
	....s DrugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	....s DrugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	....s AuditLibvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugDesc,"Drug")	 // 获取对照的药品
	....s AuditLibDicId = +$listtostring(AuditLibvalue)
	....q:AuditLibDicId=0
	....f AuditDrugSignLen=1:1:$l(drugsign,"^") d
	.....s DrugSignId=$p(drugsign,"^",DrugSignLen)
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(LibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""	
	.....i ResStatus="STA04" d
	......i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocHumanPass")) d //审方结果为通过的数量
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocHumanPass")=1
	......e  d
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocHumanPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocHumanPass")+1
	
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=$lg(^CT.CKB.PDSS.CommonDictionD(Sign),2)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,Sign,"LocTotalNum"))
	.s LocHumanPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,Sign,"LocHumanPass"))
	.i LocTotalNum'=0 d
	..s LocHumanPass=$fn(LocHumanPass/LocTotalNum*100,"",2)
	..s Rate=LocHumanPass
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,"HumanPass",LocHumanPass)) s LocHumanPass=LocHumanPass+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,"HumanPass",LocHumanPass) = DrugSignDesc_"^"_Rate			
	
	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,"HumanPass",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,"HumanPass",Rate)
	.s count=count+1
	.q:(count>11)	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid)
	q ""
}

/// Description:	双签执行率排行
/// Creator:		xww
/// CreateDate:		2022-03-08
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByLoc).QueryHumanDouble("^^desc^1")
ClassMethod QueryHumanDoubleOld(Params)
{
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s order= $p(Params,"^",3)
	s order=$case(order,"asc":1,"desc":-1,"":1)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2) // 就诊id
	..;q:Adm=""
	..s Loc = $lg(MonData,6) // 科室
	..q:Loc=""
	..s ExaParam = $lg(MonData,9)	//入参
	..q:ExaParam["UNDEFINED"
	..s ExaParamObj = ##class(%DynamicArray).%FromJSON(ExaParam)
	..s DrugArr = ExaParamObj.%Get("Drug")	 	// 医嘱
	..s DregLength = DrugArr.%Size()
	..s ManLev = $lg(MonData,8) // 审查级别
	..s DrugParrf=""
	..f Len=0:1:DregLength-1  d
	...s DrugObj = DrugArr.%Get(Len) 
	...s DrugName = DrugObj.item
	...s Libvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugName,"Drug")	 // 获取对照的药品
	...s LibDicId = +$listtostring(Libvalue)
	...q:LibDicId=0
	...f DrugSignLen=1:1:$l(drugsign,"^") d
	....s DrugSignId=$p(drugsign,"^",DrugSignLen)
	....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(LibDicId,DrugSignCode)   // 取维护的属性值
	....q:DrugSignAttrValue=""
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocTotalNum")) d //处方开具次数（合理用药总数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocTotalNum")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocTotalNum")+1
	
	..s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	..i AuditId'="" d
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)	
	...s subId = ""
	...f  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",AuditId,subId))  Q:subId=""  d
	....s DrugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	....s DrugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	....s AuditLibvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugDesc,"Drug")	 // 获取对照的药品
	....s AuditLibDicId = +$listtostring(AuditLibvalue)
	....q:AuditLibDicId=0
	....f AuditDrugSignLen=1:1:$l(drugsign,"^") d
	.....s DrugSignId=$p(drugsign,"^",DrugSignLen)
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(LibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""	
	.....i ResStatus="STA03" d
	......i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocHumanDouble")) d //审方结果为通过的数量
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocHumanDouble")=1
	......e  d
	.......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocHumanDouble")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocHumanDouble")+1
	
	
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=$lg(^CT.CKB.PDSS.CommonDictionD(Sign),3)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Sign,"LocTotalNum"))
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Sign,"LocHumanDouble"))
	.i LocTotalNum'=0 d
	..s LocHumanDouble=$fn(LocHumanDouble/LocTotalNum*100,"",2)
	..s Rate=LocHumanDouble
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,"HumanDouble",LocHumanDouble)) s LocHumanDouble=LocHumanDouble+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,"HumanDouble",LocHumanDouble) = DrugSignDesc_"^"_Rate		

	
	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,"HumanDouble",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,"HumanDouble",Rate)
	.s count=count+1
	.q:(count>11)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid)
	q ""
}

/// Descript:	详细数据(审核干预情况按药品)（按审方表遍历查）
/// Creator:    xww
/// CreateDate: 2022-03-25
/// InPut:      
/// OutPut:     科室名称
///             监测药品标识数（合理用药总数）
///             系统审查拦截次数(率)（合理用药禁止）
///             系统审查不通过次数(率)（合理用药警示）
///             医生选择药师审核次数(率)（审方数）
///             药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
///             双签执行次数(率)（审方结果为双签通过的数量）
///             返回修改次数(率)（审方结果为必须修改的数量）
/// w ##class(web.DHCPRESCInterventQueryByDrug).QueryByDrug("10","1","2022-06-06^2022-06-06^^251607")
ClassMethod QueryByDrug(rows, page, Params)
{
	//n (rows, page, Params)
	s ^TMPTEST("QueryByDrug")=$lb(rows, page, Params)
	;w $zts
	s End=page*rows
	s Start=(page-1)*rows+1	
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s LocDesc= $p(Params,"^",3)
	s Pid = $p(Params,"^",4)
	q:Pid="" ""
	s DrugDataID=##class(web.DHCCKBCommon).GetDrugData()  				// 西药
	s ChineseDrugDataID=##class(web.DHCCKBCommon).GetChineseDrugData()  // 中成药
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	k ^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid)
	s DrugNum=0,DrugTrementNum=0,QueErrNum=0,ChineseDrugDataNum=0,DrugDataNum=0,DrugSignNum=0
	s LocNum=0,TotalNum=0,Hook=0,NoPass=0,HumanRefuse=0,HumanDouble=0
	s LocStr="*"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId = ""
	..f  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId))  Q:AuditId=""  d
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)        // 就诊id
	...s Loc = ""
	...s LocId = $lg(^PHA.PREADT.AuditD(AuditId),9)	// 科室
	...Q:LocId=""
	...s Loc = $p(^CTLOC(LocId),"^",2)
	...q:(LocDesc'="")&(Loc'=LocDesc)
	...s TotalNum=TotalNum+1                     // 合理用药总数
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)	
	...s DrugParrf=""
	...s subId = ""
	...f  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",AuditId,subId))  Q:subId=""  d
	....s DrugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	....s DrugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	....s AuditLibvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugDesc,"Drug")	 // 获取对照的药品
	....s AuditLibDicId = +$listtostring(AuditLibvalue)
	....q:AuditLibDicId=0
	....f AuditDrugSignLen=1:1:$l(drugsign,"^") d
	.....s DrugSignId=$p(drugsign,"^",AuditDrugSignLen)
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(AuditLibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""
	.....s:ResStatus="STA01" HumanRefuse=HumanRefuse + 1
	.....s:ResStatus="STA03" HumanRefuse=HumanRefuse + 1 // 审方结果为必须修改+双签通过的数量
	.....s:ResStatus="STA03" HumanDouble=HumanDouble + 1 // 审方结果为必须修改的数量
	.....//医生选择药师审核次数(率)（审方数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocAudit")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocAudit"))+1
	.....i ResStatus="STA01" d
	......//药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass"))+1
	......//返回修改次数(率)（审方结果为必须修改的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanReturn")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanReturn"))+1
	.....i ResStatus="STA03" d
	......//药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanNoPass"))+1
	......//双签执行次数(率)（审方结果为双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanDouble")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHumanDouble"))+1
	....//获取药品对应的类型（西药 or 中药）
	....q:(DrugParrf=DrugDataID)||(DrugParrf=ChineseDrugDataID)
	....s DrugParrf = $lg(^CT.CKB.PDSS.CommonDictionD(AuditLibDicId),4)   // 获取药品是西药还是中药
	...//获取处方对应的类型（西药 or 中药）
	...i DrugParrf=DrugDataID  d
	....s DrugDataNum=DrugDataNum+1				  // 西药处方数
	...e  i DrugParrf=ChineseDrugDataID d	
	....s ChineseDrugDataNum=ChineseDrugDataNum+1 // 中药处方数
	...
	...// 从合理用药表取的数据
	...s MonId=$lg(^PHA.PREADT.AuditD(AuditId),2)   // 合理用药主表ID 
	...q:MonId=""
	...s MonItmId=""
	...for  s MonItmId = $o(^CKB.PDSS.MonQueListI("Parref",MonId,MonItmId)) Q:MonItmId=""  d
	....s QueErrNum = QueErrNum + 1    			// 不合理问题数
	...s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	...s ExaParam = $lg(MonData,9)				//入参
	...s ExaParamObj = ##class(%DynamicArray).%FromJSON(ExaParam)
	...s DrugArr = ExaParamObj.%Get("Drug")	 	// 医嘱
	...s DregLength = DrugArr.%Size()
	...s DrugNum = DrugNum + DregLength  		// 处方所包含的药品总数
	...s ManLev = $lg(MonData,8) // 审查级别
	...f Len=0:1:DregLength-1  d
	....s DrugObj = DrugArr.%Get(Len)
	....s DrugTrement = DrugObj.Treatment 		 //疗程
	....s DrugTrementNum = DrugTrementNum + (+DrugTrement)  //所有处方的疗程 
	....s DrugName = DrugObj.item
	....s Libvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugName,"Drug")	 // 获取对照的药品
	....s LibDicId = +$listtostring(Libvalue)
	....q:LibDicId=0
	....//遍历标识
	....f DrugSignLen=1:1:$l(drugsign,"^") d
	.....s DrugSignId=$p(drugsign,"^",DrugSignLen)
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(LibDicId,DrugSignCode)   // 取维护的属性值
	.....q:DrugSignAttrValue=""
	.....b ;12
	.....i '$d(^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid,DrugSignId)) d
	......s DrugSignNum=DrugSignNum+1			// 监测药品标识数
	......s ^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid,DrugSignId)=""
	.....//处方开具次数（合理用药总数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocTotalNum")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocTotalNum"))+1
	.....i ManLev="forbid" d
	......//系统审查拦截次数(率)（合理用药禁止）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHook")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocHook"))+1
	.....i ManLev="warn" d
	......//系统审查不通过次数(率)（合理用药警示）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocNoPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,DrugSignCode,"LocNoPass"))+1

	s PrescAvgNum=0,QueErrAvgNum=0,PrescTrementAvgNum=0
	i TotalNum'=0 d
	.s PrescAvgNum=$fn(DrugNum/TotalNum,"",1)   // 处方平均包含药品数
	.s QueErrAvgNum=$fn(QueErrNum/TotalNum,"",1)	// 处方平均不合理问题数
	.s PrescTrementAvgNum=$fn(DrugTrementNum/DrugNum,"",1)		// 处方平均用药天数

	s count=0
	w "{""rows"":["
	s listTitle ="DrugSign^DrugTotalNum^DrugHook^DrugNoPass^DrugAudit^DrugHumanNoPass^DrugHumanDouble^DrugHumanReturn"
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign)) Q:(Sign="")  d
	.;q:(LocDesc'="")&(Loc'=LocDesc)
	.s DrugSignDesc=$lg(^CT.CKB.PDSS.CommonDictionD(Sign),3)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocTotalNum"))
	.s LocHook=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocHook"))
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocNoPass"))
	.s LocAudit=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocAudit"))
	.s LocHumanNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocHumanNoPass"))
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocHumanDouble")) 
	.s LocHumanReturn=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid,Sign,"LocHumanReturn"))
	.i LocTotalNum'=0 d
	..s LocHook=LocHook_" ("_$fn(LocHook/LocTotalNum*100,"",2)_"%)"					
	..s LocNoPass=LocNoPass_"("_$fn(LocNoPass/LocTotalNum*100,"",2)_"%)"		
	..s LocAudit=LocAudit_" ("_$fn(LocAudit/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanNoPass=LocHumanNoPass_" ("_$fn(LocHumanNoPass/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanDouble=LocHumanDouble_" ("_$fn(LocHumanDouble/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanReturn=LocHumanReturn_" ("_$fn(LocHumanReturn/LocTotalNum*100,"",2)_"%)"						
	.s list = DrugSignDesc_"^"_LocTotalNum_"^"_LocHook_"^"_LocNoPass_"^"_LocAudit_"^"_LocHumanNoPass_"^"_LocHumanDouble_"^"_LocHumanReturn
	.s count=count+1	
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)

 	w "],""total"":"_count
 	w ",""DrugSignNum"":"_DrugSignNum_",""PrescAvgNum"":"_PrescAvgNum_",""QueErrAvgNum"":"_QueErrAvgNum_",""DrugDataNum"":"_DrugDataNum_",""ChineseDrugDataNum"":"_ChineseDrugDataNum
 	w ",""PrescTrementAvgNum"":"_PrescTrementAvgNum
 	w "}"
 	k ^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug",Pid)
 	;w $zts
 	q ""
}

/// Description:	处方总通过率排行（按审方表遍历查）
/// Creator:		xww
/// CreateDate:		2022-11-28
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByDrug).QueryLocPassAll("2023-02-01^2023-03-13^asc^95153")
ClassMethod QueryLocPassAll(Params)
{
	
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s order= $p(Params,"^",3)
	s order=$case(order,"asc":1,"desc":-1,"":1)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId = ""
	..f  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId))  Q:AuditId=""  d
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)        // 就诊id
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)	
	...s DrugParrf=""
	...s subId = ""
	...f  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",AuditId,subId))  Q:subId=""  d
	....s DrugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	....s DrugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	....s AuditLibvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugDesc,"Drug")	 // 获取对照的药品
	....s AuditLibDicId = +$listtostring(AuditLibvalue)
	....q:AuditLibDicId=0
	....f AuditDrugSignLen=1:1:$l(drugsign,"^") d
	.....s DrugSignId=$p(drugsign,"^",AuditDrugSignLen)
	.....q:$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid,AuditId,DrugSignId))
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(AuditLibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid,AuditId,DrugSignId)=""
	.....// 包含监测标识总处方数
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocTotalNum")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocTotalNum"))+1
	.....//审方结果为通过的数量
	.....s:(ResStatus="STA03")!(ResStatus="STA04") ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,DrugSignCode,"LocHumanPass"))+1
	b  //s1
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,Sign)) Q:(Sign="")  d
	.b  //s2
	.s DrugSignDesc=$lg(^CT.CKB.PDSS.CommonDictionD(Sign),3)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,Sign,"LocTotalNum"))
	.s LocPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid,Sign,"LocPass"))
	.i LocTotalNum'=0 d
	..s LocPassAll=$fn(LocPass/LocTotalNum*100,"",2)
	..s Rate=LocPassAll
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAllRat",Pid,"LocPassAll",LocPassAll,Sign) = DrugSignDesc_"^"_Rate

	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAllRat",Pid,"LocPassAll",Rate),order) Q:(Rate="")  d
	.s Sign=""
	.f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAllRat",Pid,"LocPassAll",Rate,Sign)) Q:(Sign="")  d
	..s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAllRat",Pid,"LocPassAll",Rate,Sign)
	..s count=count+1
	..q:(count>11)	
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassAllRat",Pid)
 	
	q ""
}

/// Description:	系统审查通过率排行（按审方表遍历查）
/// Creator:		xww
/// CreateDate:		2022-11-28
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByDrug).QueryLocPass("2022-03-29^2022-03-29^asc^185043")
ClassMethod QueryLocPass(Params)
{
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s order= $p(Params,"^",3)
	s order=$case(order,"asc":1,"desc":-1,"":1)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId = ""
	..f  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId))  Q:AuditId=""  d
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)         // 就诊id
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus="",Remark=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:AuditResult'="" Remark=$lg(^PHA.PREADT.AuditResultD(AuditResult),8)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)	
	...s DrugParrf=""
	...s subId = ""
	...f  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",AuditId,subId))  Q:subId=""  d
	....s DrugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	....s DrugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	....s AuditLibvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugDesc,"Drug")	 // 获取对照的药品
	....s AuditLibDicId = +$listtostring(AuditLibvalue)
	....q:AuditLibDicId=0
	....f AuditDrugSignLen=1:1:$l(drugsign,"^") d
	.....s DrugSignId=$p(drugsign,"^",AuditDrugSignLen)
	.....q:$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid,AuditId,DrugSignId))
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(AuditLibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid,AuditId,DrugSignId)=""
	.....// 包含监测标识总处方数
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocTotalNum")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"LocTotalNum"))+1
	.....//审方结果为通过的数量
	.....s:(ResStatus="STA04")&&(Remark["自动通过") ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"SysPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,DrugSignCode,"SysPass"))+1
	
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=$lg(^CT.CKB.PDSS.CommonDictionD(Sign),3)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,Sign,"LocTotalNum"))
	.s SysPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid,Sign,"SysPass"))
	.i LocTotalNum'=0 d
	..s LocPassAll=$fn(SysPass/LocTotalNum*100,"",2)
	..s Rate=LocPassAll
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassRat",Pid,"LocPass",LocPassAll,Sign) = DrugSignDesc_"^"_Rate

	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassRat",Pid,"LocPass",Rate),order) Q:(Rate="")  d
	.s Sign=""
	.f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassRat",Pid,"LocPass",Rate,Sign)) Q:(Sign="")  d
	..s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassRat",Pid,"LocPass",Rate,Sign)
	..s count=count+1
	..q:(count>11)	
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPass",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryLocPassRat",Pid)
	q ""
}

/// Description:	人工审核通过率排行（按审方表遍历查）
/// Creator:		xww
/// CreateDate:		2022-11-28	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByDrug).QueryHumanPass("^^desc^1")
ClassMethod QueryHumanPass(Params)
{
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s order= $p(Params,"^",3)
	s order=$case(order,"asc":1,"desc":-1,"":1)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId = ""
	..f  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId))  Q:AuditId=""  d
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)        // 就诊id
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus="",Remark=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:AuditResult'="" Remark=$lg(^PHA.PREADT.AuditResultD(AuditResult),8)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)	
	...s subId = ""
	...f  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",AuditId,subId))  Q:subId=""  d
	....s DrugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	....s DrugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	....s AuditLibvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugDesc,"Drug")	 // 获取对照的药品
	....s AuditLibDicId = +$listtostring(AuditLibvalue)
	....q:AuditLibDicId=0
	....f AuditDrugSignLen=1:1:$l(drugsign,"^") d
	.....s DrugSignId=$p(drugsign,"^",AuditDrugSignLen)
	.....q:$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid,AuditId,DrugSignId))
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(AuditLibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid,AuditId,DrugSignId)=""
	.....// 包含监测标识总处方数
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocTotalNum")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocTotalNum"))+1
	.....//审方结果为通过(不包括自动通过)的数量
	.....s:(ResStatus="STA04")&&(Remark'["自动通过") ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocHumanPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,DrugSignCode,"LocHumanPass"))+1
	
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=$lg(^CT.CKB.PDSS.CommonDictionD(Sign),3)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,Sign,"LocTotalNum"))
	.s LocHumanPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid,Sign,"LocHumanPass"))
	.i LocTotalNum'=0 d
	..s LocHumanPass=$fn(LocHumanPass/LocTotalNum*100,"",2)
	..s Rate=LocHumanPass
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPassRat",Pid,"HumanPass",LocHumanPass,Sign) = DrugSignDesc_"^"_Rate			
	
	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPassRat",Pid,"HumanPass",Rate),order) Q:(Rate="")  d
	.s Sign=""
	.f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPassRat",Pid,"HumanPass",Rate,Sign)) Q:(Sign="")  d
	..s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPassRat",Pid,"HumanPass",Rate,Sign)
	..s count=count+1
	..q:(count>11)	
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPass",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanPassRat",Pid)
	q ""
}

/// Description:	双签执行率排行（按审方表遍历查）
/// Creator:		xww
/// CreateDate:		2022-11-28
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByDrug).QueryHumanDouble("^^desc^1")
ClassMethod QueryHumanDouble(Params)
{
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s order= $p(Params,"^",3)
	s order=$case(order,"asc":1,"desc":-1,"":1)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId = ""
	..f  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId))  Q:AuditId=""  d
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)       // 就诊id
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus="",Remark=""
	...s:AuditResult'="" Remark=$lg(^PHA.PREADT.AuditResultD(AuditResult),8)
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)	
	...s subId = ""
	...f  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",AuditId,subId))  Q:subId=""  d
	....s DrugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	....s DrugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	....s AuditLibvalue = ##class(web.DHCCKBPassNew).GetComDicIdNew(DrugDesc,"Drug")	 // 获取对照的药品
	....s AuditLibDicId = +$listtostring(AuditLibvalue)
	....q:AuditLibDicId=0
	....f AuditDrugSignLen=1:1:$l(drugsign,"^") d
	.....s DrugSignId=$p(drugsign,"^",AuditDrugSignLen)
	.....q:$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid,AuditId,DrugSignId))
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(AuditLibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid,AuditId,DrugSignId)=""	
	.....// 包含监测标识总处方数
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocTotalNum")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocTotalNum"))+1
	.....//审方结果为双签通过的数量
	.....s:ResStatus="STA03" ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocHumanDouble")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,DrugSignCode,"LocHumanDouble"))+1
	
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=$lg(^CT.CKB.PDSS.CommonDictionD(Sign),3)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Sign,"LocTotalNum"))
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Sign,"LocHumanDouble"))
	.i LocTotalNum'=0 d
	..s LocHumanDouble=$fn(LocHumanDouble/LocTotalNum*100,"",2)
	..s Rate=LocHumanDouble
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDoubleRat",Pid,"HumanDouble",LocHumanDouble,Sign) = DrugSignDesc_"^"_Rate		

	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDoubleRat",Pid,"HumanDouble",Rate),order) Q:(Rate="")  d
	.s Sign=""
	.f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDoubleRat",Pid,"HumanDouble",Rate,Sign)) Q:(Sign="")  d
	..s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDoubleRat",Pid,"HumanDouble",Rate,Sign)
	..s count=count+1
	..q:(count>11)
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDoubleRat",Pid)
	q ""
}

}
