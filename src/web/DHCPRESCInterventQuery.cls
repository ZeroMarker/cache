/// 审核干预查询
/// 2022-2-14
Class web.DHCPRESCInterventQuery Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 取药师干预情况记录
/// Creator : Shy
/// OutPut:     药师名称
///             处方开具次数（合理用药总数）
///             系统审查拦截次数(率)（合理用药禁止）
///             系统审查不通过次数(率)（合理用药警示）
///             医生选择药师审核次数(率)（审方数）
///             药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
///             双签执行次数(率)（审方结果为双签通过的数量）
///             返回修改次数(率)（审方结果为必须修改的数量）
/// w ##Class(web.DHCPRESCInterventQuery).JsGetInterventPha("10","1","2023-03-01^2023-04-25^^353629")
ClassMethod JsGetInterventPha(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params)
	s ^temptest("123") = $lb(rows,page,Params)
	s End=page*rows
	s Start=(page-1)*rows+1
	// 就诊  病人  年龄  身高   体重   诊断     药师   职称    审方日期时间   处方号  审方结果
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s phaDesc= $p(Params,"^",3)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	q:Pid="" "{}"
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid)
	
	s LocNum=0,TotalNum=0,Hook=0,NoPass=0,HumanRefuse=0,HumanDouble=0,PhaNum=0
	s LocStr="*",PhaStr="*"
	f Date = StDate:1:EdDate  d
	.s Time = ""
	.for  s Time = $o(^PHA.PREADT.AuditI("Date",Date,Time))  Q:Time=""  d
	..s AuditId = ""   //^PHA.PREADT.AuditI("Date",PACreateDate,PACreateTime,ID)
	..f  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId))  q:AuditId=""  d
	...s MonId = $lg(^PHA.PREADT.AuditD(AuditId),2)
	...Q:MonId=""
	...s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	...s Adm = $lg(MonData,2)    // 就诊id
	...;q:Adm=""
	...s doctor = $lg(MonData,5)	// 医生
	...q:doctor=""
	...s Loc = $lg(MonData,6) 		// 科室
	...q:Loc=""
	...s doctor = doctor_"（"_Loc_"）"
	...i LocStr'[("*"_doctor_"*") d
	....s LocNum=LocNum+1                        // 监测科室数
	....s LocStr=LocStr_doctor_"*"
	...s TotalNum=TotalNum+1                     // 合理用药总数
	...s ManLev = $lg(MonData,8)  // 审查级别
	...s:ManLev="forbid" Hook=Hook+1             // 合理用药禁止
	...s:ManLev="warn" NoPass=NoPass+1           // 合理用药警示
	...s pha=""
	...i AuditId'="" d
	....s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	....s:AuditResult'="" pha=$lg(^PHA.PREADT.AuditResultD(AuditResult),3)
	....s:pha'="" pha=$p(^SSU("SSUSR",pha),"^",2)
	....q:pha=""
	....i PhaStr'[("*"_pha_"*") d
	.....s PhaNum=PhaNum+1                        // 监测药师数
	.....s PhaStr=PhaStr_pha_"*"
	....s ResStatus=""
	....s:AuditResult'="" ResStatus=$lg($g(^PHA.PREADT.AuditResultD(AuditResult)),6)
	....s:ResStatus'="" ResStatus=$lg($g(^CT.PHA.PREADT.DicItemD(ResStatus)),2)
	....s:ResStatus="STA01" HumanRefuse=HumanRefuse + 1
	....s:ResStatus="STA03" HumanRefuse=HumanRefuse + 1 // 审方结果为必须修改+双签通过的数量
	....s:ResStatus="STA03" HumanDouble=HumanDouble + 1 // 审方结果为必须修改的数量
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocAudit")) d //医生选择药师审核次数(率)（审方数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocAudit")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocAudit")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocAudit")+1
	....i ResStatus="STA01" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")) d //药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")+1
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanReturn")) d //返回修改次数(率)（审方结果为必须修改的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanReturn")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanReturn")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanReturn")+1
	....i ResStatus="STA03" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")) d //药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")+1
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanDouble")) d //双签执行次数(率)（审方结果为双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanDouble")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanDouble")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanDouble")+1
	...
	...q:pha=""
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocTotalNum")) d //处方开具次数（合理用药总数）
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocTotalNum")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocTotalNum")+1
	...i ManLev="forbid" d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHook")) d //系统审查拦截次数(率)（合理用药禁止）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHook")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHook")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHook")+1
	...i ManLev="warn" d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocNoPass")) d //系统审查不通过次数(率)（合理用药警示）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocNoPass")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocNoPass")+1
	...
	..
	.
	i PhaNum'=0 d
	.s TotalNum=$fn(LocNum/PhaNum,"",1)    //TotalNum
	.s Hook=$fn(TotalNum/PhaNum,"",1)   //Hook
	.;s NoPass=$fn(NoPass/PhaNum,"",1)   //NoPass
	.s HumanRefuse=$fn(HumanRefuse/PhaNum,"",1)
	.s HumanDouble=$fn(HumanDouble/PhaNum,"",1)
	.s AllNoPass=0
	.s Per="" f  s Per=$o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,Per))  q:Per=""  d
	..s AllNoPass=AllNoPass+(+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,Per,"LocHumanNoPass")))
	.s NoPass=$fn(AllNoPass/PhaNum,"",1)
	
	s count=0
	w "{""rows"":["
	s listTitle ="Pha^LocTotalNum^LocHook^LocNoPass^LocAudit^LocHumanNoPass^LocHumanDouble^LocHumanReturn"
	s pha = ""
	f  s pha = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha)) Q:(pha="")  d
	.q:(phaDesc'="")&(pha'=phaDesc)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocTotalNum"))
	.s LocHook=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHook"))
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocNoPass"))
	.s LocAudit=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocAudit"))
	.s LocHumanNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass"))
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanDouble")) 
	.s LocHumanReturn=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanReturn"))
	.i LocTotalNum'=0 d
	..s LocHook=LocHook_" ("_$fn(LocHook/LocTotalNum*100,"",2)_"%)"					
	..s LocNoPass=LocNoPass_"("_$fn(LocNoPass/LocTotalNum*100,"",2)_"%)"		
	..s LocAudit=LocAudit_" ("_$fn(LocAudit/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanNoPass=LocHumanNoPass_" ("_$fn(LocHumanNoPass/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanDouble=LocHumanDouble_" ("_$fn(LocHumanDouble/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanReturn=LocHumanReturn_" ("_$fn(LocHumanReturn/LocTotalNum*100,"",2)_"%)"						
	.s list = pha_"^"_LocTotalNum_"^"_LocHook_"^"_LocNoPass_"^"_LocAudit_"^"_LocHumanNoPass_"^"_LocHumanDouble_"^"_LocHumanReturn
	.s count=count+1	
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)

 	w "],""total"":"_count
 	w ",""LocNum"":"_LocNum_",""TotalNum"":"_TotalNum_",""Hook"":"_Hook_",""NoPass"":"_NoPass_",""HumanRefuse"":"_HumanRefuse
 	w ",""HumanDouble"":"_HumanDouble_",""PhaNum"":"_PhaNum
 	w "}"
 	q ""
}

/// Descript:	详细数据
/// Creator:    ylp
/// CreateDate: 2022-03-01
/// InPut:      
/// OutPut:     科室名称
///             处方开具次数（合理用药总数）
///             系统审查拦截次数(率)（合理用药禁止）
///             系统审查不通过次数(率)（合理用药警示）
///             医生选择药师审核次数(率)（审方数）
///             药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
///             双签执行次数(率)（审方结果为双签通过的数量）
///             返回修改次数(率)（审方结果为必须修改的数量）
/// w ##class(web.DHCPRESCInterventQuery).QueryByDoc("10","1","2023-03-1^2023-03-13^^95175")
ClassMethod QueryByDoc(rows, page, Params)
{
	
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid)
	s DrugNum=0,DrugTrementNum=0,QueErrNum=0,ChineseDrugDataNum=0,DrugDataNum=0,DrugSignNum=0
	s DocNum=0,TotalNum=0,Hook=0,NoPass=0,HumanRefuse=0,HumanDouble=0
	s LocStr="*"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId = ""
	..f  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId))  Q:AuditId=""  d
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)        // 就诊id
	...s Loc = ""
	...s LocId = $lg(^PHA.PREADT.AuditD(AuditId),9)	// 科室
	...Q:LocId=""
	...s LocName = $p(^CTLOC(LocId),"^",2)
	...q:(LocDesc'="")&(LocName'=LocDesc)
	...s DocID = $lg(^PHA.PREADT.AuditD(AuditId),11)  		// 医生
	...q:DocID=""
	...s Doctor = $p(^SSU("SSUSR",DocID),"^",2)
	...s Doctor = Doctor_"("_LocName_")"
	...;q:(LocDesc'="")&(Loc'=LocDesc)
	...s TotalNum=TotalNum+1                     // 合理用药总数
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg($g(^CT.PHA.PREADT.DicItemD(ResStatus)),2)	
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
	.....b:Doctor["薛珊"
	.....s:ResStatus="STA01" HumanRefuse=HumanRefuse + 1
	.....s:ResStatus="STA03" HumanRefuse=HumanRefuse + 1 // 审方结果为必须修改+双签通过的数量
	.....s:ResStatus="STA03" HumanDouble=HumanDouble + 1 // 审方结果为必须修改的数量
	.....//医生选择药师审核次数(率)（审方数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocAudit")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocAudit"))+1
	.....i ResStatus="STA01" d
	......//药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocHumanNoPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocHumanNoPass"))+1
	......//返回修改次数(率)（审方结果为必须修改的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocHumanReturn")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocHumanReturn"))+1
	.....i ResStatus="STA03" d
	......//药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocHumanNoPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocHumanNoPass"))+1
	......//双签执行次数(率)（审方结果为双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocHumanDouble")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocHumanDouble"))+1
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
	...s ExaParam = $lg($g(^CKB.PDSS.MonMasterD(MonId)),9)	//入参
	...Q:ExaParam=""
	...s ExaParamObj = ##class(%DynamicArray).%FromJSON(ExaParam)
	...s DrugArr = ExaParamObj.%Get("Drug")	 	// 医嘱
	...s DregLength = DrugArr.%Size()
	...s DrugNum = DrugNum + DregLength  		// 处方所包含的药品总数
	...s ManLev = $lg(^CKB.PDSS.MonMasterD(MonId),8) // 审查级别
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
	.....i '$d(^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid,DrugSignId)) d
	......s DrugSignNum=DrugSignNum+1			// 监测药品标识数
	......s ^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid,DrugSignId)=""
	.....//处方开具次数（合理用药总数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocTotalNum")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocTotalNum"))+1
	.....i ManLev="forbid" d
	......//系统审查拦截次数(率)（合理用药禁止）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocHook")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocHook"))+1
	.....i ManLev="warn" d
	......//系统审查不通过次数(率)（合理用药警示）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocNoPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Doctor,"LocNoPass"))+1
	
	b
	s DocTotalNum=0  	// 处方总数
	s DocHookTotal =0  //系统审查拦截次数 总数
	s DocNoPassTotal =0  //系统审查不通过次数(率)总数
	s DocHumanNoPass=0   //人工审查不通过次数(率)总数
	s DocHumanDouble=0  //双签次数
	s count=0
	w "{""rows"":["
 	s listTitle ="Doc^DocTotalNum^DocHook^DocNoPass^DocAudit^DocHumanNoPass^DocHumanDouble^DocHumanReturn"
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Sign)) Q:(Sign="")  d
	.;q:(LocDesc'="")&(Loc'=LocDesc)
	.;s DrugSignDesc=$lg(^CT.CKB.PDSS.CommonDictionD(Sign),3)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Sign,"LocTotalNum"))
	.s LocHook=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Sign,"LocHook"))
	.s DocHookTotal=DocHookTotal+LocHook
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Sign,"LocNoPass"))
	.s DocNoPassTotal=DocNoPassTotal+LocNoPass
	.s LocAudit=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Sign,"LocAudit"))
	.s LocHumanNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Sign,"LocHumanNoPass"))
	.s DocHumanNoPass=DocHumanNoPass+LocHumanNoPass
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Sign,"LocHumanDouble")) 
	.s DocHumanDouble=DocHumanDouble+LocHumanDouble
	.s LocHumanReturn=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid,Sign,"LocHumanReturn"))
	.s DocTotalNum=DocTotalNum+LocTotalNum
	.i LocTotalNum'=0 d
	..s LocHook=LocHook_" ("_$fn(LocHook/LocTotalNum*100,"",2)_"%)"					
	..s LocNoPass=LocNoPass_"("_$fn(LocNoPass/LocTotalNum*100,"",2)_"%)"		
	..s LocAudit=LocAudit_" ("_$fn(LocAudit/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanNoPass=LocHumanNoPass_" ("_$fn(LocHumanNoPass/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanDouble=LocHumanDouble_" ("_$fn(LocHumanDouble/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanReturn=LocHumanReturn_" ("_$fn(LocHumanReturn/LocTotalNum*100,"",2)_"%)"						
	.s list = Sign_"^"_LocTotalNum_"^"_LocHook_"^"_LocNoPass_"^"_LocAudit_"^"_LocHumanNoPass_"^"_LocHumanDouble_"^"_LocHumanReturn
	.s count=count+1	
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	
	s PrescAvgNum=0,PreDocHookNum=0,PreDocNoPassNum=0,DocHumanNoPassNum=0,DocHumanDoubleNum=0,PrescTrementAvgNum=0
	i count'=0 d
	.s PrescAvgNum=$fn(DocTotalNum/count,"",1)   // 医生处方平均数
	.s PreDocHookNum=$fn(DocHookTotal/count,"",1)	// 人均被系统拦截数
	.s PreDocNoPassNum=$fn(DocNoPassTotal/count,"",1)		// 人均被系统审查不通过次数
	.s DocHumanNoPassNum=$fn(DocHumanNoPass/count,"",1)		//人均药师审核不通过
	.s DocHumanDoubleNum=$fn(DocHumanDouble/count,"",1)		//人均双签
 	w "],""total"":"_count
 	w ",""DocSignNum"":"_count_",""PrescAvgNum"":"_PrescAvgNum_",""PreDocHookNum"":"_PreDocHookNum_",""PreDocNoPassNum"":"_PreDocNoPassNum_",""DocHumanNoPassNum"":"_DocHumanNoPassNum_",""DocHumanDoubleNum"":"_DocHumanDoubleNum
 	w ",""PrescTrementAvgNum"":"_PrescTrementAvgNum
 	w "}"
 	k ^TMP("DHCPRESC","QueryByDrug","DrugSignNum",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery",Pid)
 	;w $zts


 	q ""
}

/// Descript:	系统审查通过率排行
/// Creator:    ylp
/// CreateDate: 2022-03-01
/// InPut:      
/// OutPut:     科室名称
/// w ##class(web.DHCPRESCInterventQuery).jsonSystemReview("2022-11-28^2022-11-30^^266727")
ClassMethod jsonSystemReview(Params)
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId = ""
	..f  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId))  Q:AuditId=""  d
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)        // 就诊id
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...s DocID = $lg(^PHA.PREADT.AuditD(AuditId),11)  		// 医生
	...q:DocID=""
	...s Doctor = $p(^SSU("SSUSR",DocID),"^",2)

	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus="",Remark=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:AuditResult'="" Remark=$lg(^PHA.PREADT.AuditResultD(AuditResult),8)
	...s:ResStatus'="" ResStatus=$lg($g(^CT.PHA.PREADT.DicItemD(ResStatus)),2)	
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
	.....q:$d(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid,AuditId,DrugSignId))
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(AuditLibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid,AuditId,DrugSignId)=""
	.....// 包含监测标识总处方数
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,Doctor,"LocTotalNum")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,Doctor,"LocTotalNum"))+1
	.....//审方结果为通过的数量
	.....s:(ResStatus="STA04")&&(Remark["自动通过") ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,Doctor,"SysPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,Doctor,"SysPass"))+1
	
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=Sign
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,Sign,"LocTotalNum"))
	.s SysPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,Sign,"SysPass"))
	.i LocTotalNum'=0 d
	..s LocPassAll=$fn(SysPass/LocTotalNum*100,"",2)
	..s Rate=LocPassAll
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,"LocPass",LocPassAll,Sign) = DrugSignDesc_"^"_Rate

	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,"LocPass",Rate),order) Q:(Rate="")  d
	.s Sign=""
	.f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,"LocPass",Rate,Sign)) Q:(Sign="")  d
	..s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid,"LocPass",Rate,Sign)
	..s count=count+1
	..q:(count>11)	
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPass",Pid)
	q ""
}

/// Descript:	人工审核通过率排行
/// Creator:    ylp
/// CreateDate: 2022-03-01
/// InPut:      
/// OutPut:     科室名称
/// w ##class(web.DHCPRESCInterventQuery).jsonHumanReview("2022-11-28^2022-11-30^^266727")
ClassMethod jsonHumanReview(Params)
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId = ""
	..f  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId))  Q:AuditId=""  d
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)         // 就诊id
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...s DocID = $lg(^PHA.PREADT.AuditD(AuditId),11)  		// 医生
	...q:DocID=""
	...s Doctor = $p(^SSU("SSUSR",DocID),"^",2)

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
	.....q:$d(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid,AuditId,DrugSignId))
	.....s DrugSignCode=##class(web.DHCCKBCommon).GetDicIdByCode(DrugSignId)
	.....s DrugSignAttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(AuditLibDicId,DrugSignCode) // 取维护的属性值
	.....q:DrugSignAttrValue=""
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid,AuditId,DrugSignId)=""
	.....// 包含监测标识总处方数
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,Doctor,"LocTotalNum")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,Doctor,"LocTotalNum"))+1
	.....//审方结果为通过(不包括自动通过)的数量
	.....s:(ResStatus="STA04")&&(Remark'["自动通过") ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,Doctor,"LocHumanPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,Doctor,"LocHumanPass"))+1
	
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=Sign
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,Sign,"LocTotalNum"))
	.s LocHumanPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,Sign,"LocHumanPass"))
	.i LocTotalNum'=0 d
	..s LocHumanPass=$fn(LocHumanPass/LocTotalNum*100,"",2)
	..s Rate=LocHumanPass
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,"HumanPass",LocHumanPass,Sign) = DrugSignDesc_"^"_Rate			
	
	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,"HumanPass",Rate),order) Q:(Rate="")  d
	.s Sign=""
	.f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,"HumanPass",Rate,Sign)) Q:(Sign="")  d
	..s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid,"HumanPass",Rate,Sign)
	..s count=count+1
	..q:(count>11)	
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryHumanPass",Pid)
	q ""
}

/// Descript:	双签审核通过率排行
/// Creator:    ylp
/// CreateDate: 2022-03-01
/// InPut:      
/// OutPut:     科室名称
/// w ##class(web.DHCPRESCInterventQuery).jsonDoubleReview("2022-11-28^2022-11-30^^266727")
ClassMethod jsonDoubleReview(Params)
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
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)         // 就诊id
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...s DocID = $lg(^PHA.PREADT.AuditD(AuditId),11)  		// 医生
	...q:DocID=""
	...s Doctor = $p(^SSU("SSUSR",DocID),"^",2)
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
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Doctor,"LocTotalNum")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Doctor,"LocTotalNum"))+1
	.....//审方结果为双签通过的数量
	.....s:ResStatus="STA03" ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Doctor,"LocHumanDouble")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Doctor,"LocHumanDouble"))+1
	
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=Sign
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Sign,"LocTotalNum"))
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,Sign,"LocHumanDouble"))
	.i LocTotalNum'=0 d
	..s LocHumanDouble=$fn(LocHumanDouble/LocTotalNum*100,"",2)
	..s Rate=LocHumanDouble
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,"HumanDouble",LocHumanDouble,Sign) = DrugSignDesc_"^"_Rate		

	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,"HumanDouble",Rate),order) Q:(Rate="")  d
	.s Sign=""
	.f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,"HumanDouble",Rate,Sign)) Q:(Sign="")  d
	..s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid,"HumanDouble",Rate,Sign)
	..s count=count+1
	..q:(count>11)
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","PRESC",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",Pid)
	q ""
}

/// Descript:	总审核通过率排行
/// Creator:    ylp
/// CreateDate: 2022-03-01
/// InPut:      
/// OutPut:     科室名称
/// w ##class(web.DHCPRESCInterventQuery).jsonSysAndHumanReview("2023-03-13^2023-03-13^asc^95176")
ClassMethod jsonSysAndHumanReview(Params)
{
		s ^temptest("3322") = $lb(Params)
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s order= $p(Params,"^",3)
	s order=$case(order,"asc":1,"desc":-1,"":1)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid)
	s drugsign="FDAPregnancyDrugLevel^OTCProp^LactationLevel^SkinTestDrugProp^HighDangerFlag^EssDrugFlagProp"

	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId = ""
	..f  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId))  Q:AuditId=""  d
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)         // 就诊id
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...s LocName = $p(^CTLOC(Loc),"^",2)
	...s DocID = $lg(^PHA.PREADT.AuditD(AuditId),11)  		// 医生
	...q:DocID=""
	...s Doctor = $p(^SSU("SSUSR",DocID),"^",2)
	...s Doctor = Doctor_"("_LocName_")"
	...;q:(LocDesc'="")&(Loc'=LocDesc)
	...;s TotalNum=TotalNum+1                     // 合理用药总数
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

	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid,AuditId,DrugSignId)=""
	.....// 包含监测标识总处方数
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,Doctor,"LocTotalNum")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,Doctor,"LocTotalNum"))+1
	.....//审方结果为通过的数量
	.....s:(ResStatus="STA03")!(ResStatus="STA04") ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,Doctor,"LocPass")=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,Doctor,"LocPass"))+1
	b
	s Sign = ""
	f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,Sign)) Q:(Sign="")  d
	.s DrugSignDesc=Sign
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,Sign,"LocTotalNum"))
	.s LocPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,Sign,"LocPass"))
	.i LocTotalNum'=0 d
	..s LocPassAll=$fn(LocPass/LocTotalNum*100,"",2)
	..s Rate=LocPassAll
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,"LocPassAll",LocPassAll,Sign) = DrugSignDesc_"^"_Rate

	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,"LocPassAll",Rate),order) Q:(Rate="")  d
	.s Sign=""
	.f  s Sign = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,"LocPassAll",Rate,Sign)) Q:(Sign="")  d
	..s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid,"LocPassAll",Rate,Sign)
	..s count=count+1
	..q:(count>11)	
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","PRESC",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQuery","QueryLocPassAll",Pid)
	q ""
}

/// Descript:	药师处理处方数量排行(药师)
/// Creator:    shy
/// CreateDate: 2022-03-09
/// w ##class(web.DHCPRESCInterventQuery).GetPhaPassData("2022-03-10^2022-03-11^asc^170441")
ClassMethod GetPhaPassData(Params)
{
	//q ""
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s order= $p(Params,"^",3)
	s order=$case(order,"asc":1,"desc":-1,"":1)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid)
	
	s LocNum=0,TotalNum=0,Hook=0,NoPass=0,HumanRefuse=0,HumanDouble=0
	s LocStr="*"
	f Date = StDate:1:EdDate  d 
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId=""  f  s AuditId=$o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId)) q:AuditId=""  d
	...
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)          // 就诊id
	...;q:Adm=""
	...s doctor = $lg(^PHA.PREADT.AuditD(AuditId),11)		// =药师
	...q:doctor=""
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...;s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	...s Pha="",PhaId=""
	...i AuditId'="" d
	....s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	....s:AuditResult'="" PhaId=$lg(^PHA.PREADT.AuditResultD(AuditResult),3)
	....s:PhaId'="" Pha=$p(^SSU("SSUSR",PhaId),"^",2)
	....q:Pha=""
	....s ResStatus=""
	....s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	....s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	....s TotalNum=TotalNum+1                           // 审方总数
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid,Pha,"AllNum")) d 
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid,Pha,"AllNum")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid,Pha,"AllNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid,Pha,"AllNum")+1

	s Pha = ""
	f  s Pha = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid,Pha)) Q:(Pha="")  d
	.s AllNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid,Pha,"AllNum"))
	.i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid,"AllNumRes",AllNum)) s AllNum=AllNum+1   //相同数量，为了防止数据覆盖，后者加1
	.s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid,"AllNumRes",AllNum) = Pha_"^"_AllNum   //系统通过次数
	b
	s count=0
	w "["
	s listTitle ="name^value"
	s allnum = ""
	f  s allnum = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid,"AllNumRes",allnum),order) Q:(allnum="")  d
	.s list = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryPhaNum",Pid,"AllNumRes",allnum)
	.s count=count+1	
	.q:(count>11)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)

 	w "]"
 	q ""
}

/// Descript:	系统审查通过率排行(药师)
/// Creator:    shy
/// CreateDate: 2022-03-09
/// w ##class(web.DHCPRESCInterventQuery).GetSystemPassData("2022-03-10^2022-03-11^asc^170459")
ClassMethod GetSystemPassData(Params)
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAllRes",Pid)
	
	s LocNum=0,TotalNum=0,Hook=0,NoPass=0,HumanRefuse=0,HumanDouble=0
	s LocStr="*"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId=""  f  s AuditId=$o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId)) q:AuditId=""  d
	...
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)           // 就诊id
	...;q:Adm=""
	...s doctor = $lg(^PHA.PREADT.AuditD(AuditId),11)		// =药师
	...q:doctor=""
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...;s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	...s Pha="",PhaId=""
	...i AuditId'="" d
	....s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	....s:AuditResult'="" PhaId=$lg(^PHA.PREADT.AuditResultD(AuditResult),3)
	....s:PhaId'="" Pha=$p(^SSU("SSUSR",PhaId),"^",2)
	....q:Pha=""
	....s ResStatus=""
	....s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	....s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	....s TotalNum=TotalNum+1                           // 审方总数
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha,"AllNum")) d 
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha,"AllNum")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha,"AllNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha,"AllNum")+1
	....i (ResStatus="STA01")||(ResStatus="STA03")   d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha,"LocNoPass")) d //系统审查不通过次数(率)（合理用药警示）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha,"LocNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha,"LocNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha,"LocNoPass")+1

	s Pha = ""
	f  s Pha = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha)) Q:(Pha="")  d
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha,"LocNoPass"))
	.s AllNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAll",Pid,Pha,"AllNum"))
	.s LocPass=AllNum-LocNoPass
	.s LocPassRate=$fn(LocPass/AllNum*100,"",2)
	.s passRate=LocPassRate*100
	.	
	.i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAllRes",Pid,"LocPassRes",passRate)) s passRate=passRate+1   //相同数量，为了防止数据覆盖，后者加1
	.s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAllRes",Pid,"LocPassRes",passRate) = Pha_"^"_LocPassRate   //系统通过次数
	b
	s count=0
	w "["
	s listTitle ="name^value"
	s rate = ""
	f  s rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAllRes",Pid,"LocPassRes",rate),order) Q:(rate="")  d
	.s list = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByAllRes",Pid,"LocPassRes",rate)
	.s count=count+1	
	.q:(count>11)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)

 	w "]"
 	q ""
}

/// Descript:	人工审核通过率排行(药师)
/// Creator:    shy
/// CreateDate: 2022-03-09
/// w ##class(web.DHCPRESCInterventQuery).GetPersonPassData("2022-03-10^2022-03-11^asc^170459")
ClassMethod GetPersonPassData(Params)
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPerRes",Pid)
	
	s LocNum=0,TotalNum=0,Hook=0,NoPass=0,HumanRefuse=0,HumanDouble=0
	s LocStr="*"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId=""  f  s AuditId=$o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId)) q:AuditId=""  d
	...
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)            // 就诊id
	...;q:Adm=""
	...s doctor = $lg(^PHA.PREADT.AuditD(AuditId),11)		// =药师
	...q:doctor=""
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...;s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	...s Pha="",PhaId=""
	...i AuditId'="" d
	....s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	....s:AuditResult'="" PhaId=$lg(^PHA.PREADT.AuditResultD(AuditResult),3)
	....s:PhaId'="" Pha=$p(^SSU("SSUSR",PhaId),"^",2)
	....q:Pha=""
	....s ResStatus=""
	....s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	....s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	....s TotalNum=TotalNum+1                           // 审方总数
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha,"AllNum")) d 
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha,"AllNum")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha,"AllNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha,"AllNum")+1
	....i ResStatus="STA01"   d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha,"LocNoPass")) d //系统审查不通过次数(率)（合理用药警示）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha,"LocNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha,"LocNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha,"LocNoPass")+1

	s Pha = ""
	f  s Pha = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha)) Q:(Pha="")  d
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha,"LocNoPass"))
	.s AllNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPer",Pid,Pha,"AllNum"))
	.s LocPass=AllNum-LocNoPass
	.s LocPassRate=$fn(LocPass/AllNum*100,"",2)
	.s passRate=LocPassRate*100
	.	
	.i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPerRes",Pid,"LocPassRes",passRate)) s passRate=passRate+1   //相同数量，为了防止数据覆盖，后者加1
	.s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPerRes",Pid,"LocPassRes",passRate) = Pha_"^"_LocPassRate   //系统通过次数
	b
	s count=0
	w "["
	s listTitle ="name^value"
	s rate = ""
	f  s rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPerRes",Pid,"LocPassRes",rate),order) Q:(rate="")  d
	.s list = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPerRes",Pid,"LocPassRes",rate)
	.s count=count+1	
	.q:(count>11)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)

 	w "]"
 	q ""
}

/// Descript:	双签执行率排行(药师)
/// Creator:    shy
/// CreateDate: 2022-03-09
/// w ##class(web.DHCPRESCInterventQuery).GetDobPersonPassData("2022-03-10^2022-03-11^asc^170459")
ClassMethod GetDobPersonPassData(Params)
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid)
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPerRes",Pid)
	
	s LocNum=0,TotalNum=0,Hook=0,NoPass=0,HumanRefuse=0,HumanDouble=0
	s LocStr="*"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId=""  f  s AuditId=$o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId)) q:AuditId=""  d
	...
	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)          // 就诊id
	...;q:Adm=""
	...s doctor = $lg(^PHA.PREADT.AuditD(AuditId),11)		// =药师
	...q:doctor=""
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...;s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	...s Pha="",PhaId=""
	...i AuditId'="" d
	....s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	....s:AuditResult'="" PhaId=$lg(^PHA.PREADT.AuditResultD(AuditResult),3)
	....s:PhaId'="" Pha=$p(^SSU("SSUSR",PhaId),"^",2)
	....q:Pha=""
	....s ResStatus=""
	....s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	....s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	....s TotalNum=TotalNum+1                           // 审方总数
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha,"AllNum")) d 
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha,"AllNum")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha,"AllNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha,"AllNum")+1
	....i ResStatus="STA03"   d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha,"DobPass")) d 
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha,"DobPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha,"DobPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha,"DobPass")+1

	s Pha = ""
	f  s Pha = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha)) Q:(Pha="")  d
	.s DobPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha,"DobPass"))
	.s AllNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPer",Pid,Pha,"AllNum"))
	.s LocPassRate=$fn(DobPass/AllNum*100,"",2)
	.s passRate=LocPassRate*100
	.	
	.i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPerRes",Pid,"LocPassRes",passRate)) s passRate=passRate+1   //相同数量，为了防止数据覆盖，后者加1
	.s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPerRes",Pid,"LocPassRes",passRate) = Pha_"^"_LocPassRate   //系统通过次数
	b
	s count=0
	w "["
	s listTitle ="name^value"
	s rate = ""
	f  s rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPerRes",Pid,"LocPassRes",rate),order) Q:(rate="")  d
	.s list = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByDobPerRes",Pid,"LocPassRes",rate)
	.s count=count+1	
	.q:(count>11)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)

 	w "]"
 	q ""
}

/// Descript: 处方审核总览查询
/// Creator : Shy
/// OutPut:     
/// w ##Class(web.DHCPRESCInterventQuery).JsGetInterventAll("10","1","2022-07-01^2022-07-07^^142212")
ClassMethod JsGetInterventAll(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s count=0
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s SearchDesc=$p(Params,"^",3)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	s Str="Adm^DateTime^PatName^Doctor^Loc^ResStatusDesc^WardDesc^Pha^OeType^OeDrugNum^OeDrugMoney^CkbTipsNum^Sick^Level"
	q:Pid="" "{}"
	w "{"
	w """"_"rows"_""""_":"_"["
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2)      // 就诊id
	..;q:Adm=""
	..s Date = $lg(MonData,3) 
	..s Time = $lg(MonData,4) 
	..s DateTime = $zd(Date,3)_" "_$zt(Time)        //开方时间
	..s PatName=""
	..s WardDesc=""     							//病区
	..s OeType=""                                   //处方类型
	..s OeDrugNum=""                                //处方上的药品数量
	..s OeDrugMoney=""  							//处方金额
	..s CkbTipsNum=""                               //不合理数
	..s Sick=""                                     //危急值
	..s Level=$lg(MonData,8)	//处理级别
	..i Adm  d
	...s PatientID=$p(^PAADM(Adm),"^",1)
	...s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	..s Doctor = $lg(MonData,5)	// 开方医生
	..;q:doctor=""
	..s Loc = $lg(MonData,6)	// 开方科室
	..q:(SearchDesc'="")&&(Loc'[SearchDesc)&&((PatName'[SearchDesc))
	..;q:Loc=""
	..s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	..s Pha=""
	..i AuditId'="" d
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s:AuditResult'="" Pha=$lg(^PHA.PREADT.AuditResultD(AuditResult),3)
	...s:Pha'="" Pha=$p(^SSU("SSUSR",Pha),"^",2)
	...;q:pha=""
	...s ResStatusDesc=""
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	...s:ResStatus="STA01" ResStatusDesc="必须修改"        //处方状态
	...s:ResStatus="STA03" ResStatusDesc="双签通过"
	...s:ResStatus="STA04" ResStatusDesc="通过"
	...s Data=Adm_"^"_DateTime_"^"_PatName_"^"_Doctor_"^"_Loc_"^"_ResStatusDesc_"^"_WardDesc_"^"_Pha_"^"_OeType_"^"_OeDrugNum_"^"_OeDrugMoney_"^"_CkbTipsNum_"^"_Sick_"^"_Level
	...s count = count+1
	...Q:(count<Start)||(count>End)
	...I count=Start d
	....w ##class(web.DHCAPPJsonCommon).getJsonData(Str,Data)
	...e  d
	....w ","_##class(web.DHCAPPJsonCommon).getJsonData(Str,Data)
	w "]"
	w ","
	w """"_"total"_""""_":"_count
	w "}"
 	q ""
}

/// Descript: 取药师干预情况记录
/// Creator : Shy
/// OutPut:     药师名称
///             处方开具次数（合理用药总数）
///             系统审查拦截次数(率)（合理用药禁止）
///             系统审查不通过次数(率)（合理用药警示）
///             医生选择药师审核次数(率)（审方数）
///             药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
///             双签执行次数(率)（审方结果为双签通过的数量）
///             返回修改次数(率)（审方结果为必须修改的数量）
/// w ##Class(web.DHCPRESCInterventQuery).JsGetInterventPha("10","1","2022-03-07^2022-03-07^^142212")
ClassMethod JsGetInterventPhaWithOutCKB(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params)
	s End=page*rows
	s Start=(page-1)*rows+1
	// 就诊  病人  年龄  身高   体重   诊断     药师   职称    审方日期时间   处方号  审方结果
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s phaDesc= $p(Params,"^",3)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	q:Pid="" "{}"
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid)
	
	s LocNum=0,TotalNum=0,Hook=0,NoPass=0,HumanRefuse=0,HumanDouble=0,PhaNum=0
	s LocStr="*",PhaStr="*"
	f Date = StDate:1:EdDate  d
	.s Time=""  f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time))  q:Time=""  d
	..s AuditId=""  f  s AuditId=$o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId)) q:AuditId=""  d
	...

	...s Adm =$lg(^PHA.PREADT.AuditD(AuditId),3)             // 就诊id
	...;q:Adm=""
	...s doctor = $lg(^PHA.PREADT.AuditD(AuditId),11)		// =药师
	...q:doctor=""
	...s Loc = $lg(^PHA.PREADT.AuditD(AuditId),9)  		// 科室
	...q:Loc=""
	...s doctor = doctor_"（"_Loc_"）"
	...i LocStr'[("*"_doctor_"*") d
	....s LocNum=LocNum+1                        // 监测科室数
	....s LocStr=LocStr_doctor_"*"
	...s TotalNum=TotalNum+1                     // 合理用药总数
	...s ManLev = "" //需要第三方提供接口？// 审查级别
	...s:ManLev="forbid" Hook=Hook+1             // 合理用药禁止
	...s:ManLev="warn" NoPass=NoPass+1           // 合理用药警示
	...;s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	...s pha=""
	...i AuditId'="" d
	....s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	....s:AuditResult'="" pha=$lg(^PHA.PREADT.AuditResultD(AuditResult),3)
	....s:pha'="" pha=$p(^SSU("SSUSR",pha),"^",2)
	....q:pha=""
	....i PhaStr'[("*"_pha_"*") d
	.....s PhaNum=PhaNum+1                        // 监测药师数
	.....s PhaStr=PhaStr_pha_"*"
	....s ResStatus=""
	....s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	....s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	....s:ResStatus="STA01" HumanRefuse=HumanRefuse + 1
	....s:ResStatus="STA03" HumanRefuse=HumanRefuse + 1 // 审方结果为必须修改+双签通过的数量
	....s:ResStatus="STA03" HumanDouble=HumanDouble + 1 // 审方结果为必须修改的数量
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocAudit")) d //医生选择药师审核次数(率)（审方数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocAudit")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocAudit")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocAudit")+1
	....i ResStatus="STA01" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")) d //药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")+1
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanReturn")) d //返回修改次数(率)（审方结果为必须修改的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanReturn")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanReturn")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanReturn")+1
	....i ResStatus="STA03" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")) d //药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass")+1
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanDouble")) d //双签执行次数(率)（审方结果为双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanDouble")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanDouble")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanDouble")+1
	...
	...q:pha=""
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocTotalNum")) d //处方开具次数（合理用药总数）
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocTotalNum")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocTotalNum")+1
	...i ManLev="forbid" d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHook")) d //系统审查拦截次数(率)（合理用药禁止）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHook")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHook")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHook")+1
	...i ManLev="warn" d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocNoPass")) d //系统审查不通过次数(率)（合理用药警示）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocNoPass")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocNoPass")+1
	
	i PhaNum'=0 d
	.s TotalNum=$fn(LocNum/PhaNum,"",1)    //TotalNum
	.s Hook=$fn(TotalNum/PhaNum,"",1)   //Hook
	.;s NoPass=$fn(NoPass/PhaNum,"",1)   //NoPass
	.s HumanRefuse=$fn(HumanRefuse/PhaNum,"",1)
	.s HumanDouble=$fn(HumanDouble/PhaNum,"",1)
	.s AllNoPass=0
	.s Per="" f  s Per=$o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,Per))  q:Per=""  d
	..s AllNoPass=AllNoPass+(+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,Per,"LocHumanNoPass")))
	.s NoPass=$fn(AllNoPass/PhaNum,"",1)
	
	s count=0
	w "{""rows"":["
	s listTitle ="Pha^LocTotalNum^LocHook^LocNoPass^LocAudit^LocHumanNoPass^LocHumanDouble^LocHumanReturn"
	s pha = ""
	f  s pha = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha)) Q:(pha="")  d
	.q:(phaDesc'="")&(pha'=phaDesc)
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocTotalNum"))
	.s LocHook=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHook"))
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocNoPass"))
	.s LocAudit=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocAudit"))
	.s LocHumanNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanNoPass"))
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanDouble")) 
	.s LocHumanReturn=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByPha",Pid,pha,"LocHumanReturn"))
	.i LocTotalNum'=0 d
	..s LocHook=LocHook_" ("_$fn(LocHook/LocTotalNum*100,"",2)_"%)"					
	..s LocNoPass=LocNoPass_"("_$fn(LocNoPass/LocTotalNum*100,"",2)_"%)"		
	..s LocAudit=LocAudit_" ("_$fn(LocAudit/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanNoPass=LocHumanNoPass_" ("_$fn(LocHumanNoPass/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanDouble=LocHumanDouble_" ("_$fn(LocHumanDouble/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanReturn=LocHumanReturn_" ("_$fn(LocHumanReturn/LocTotalNum*100,"",2)_"%)"						
	.s list = pha_"^"_LocTotalNum_"^"_LocHook_"^"_LocNoPass_"^"_LocAudit_"^"_LocHumanNoPass_"^"_LocHumanDouble_"^"_LocHumanReturn
	.s count=count+1	
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)

 	w "],""total"":"_count
 	w ",""LocNum"":"_LocNum_",""TotalNum"":"_TotalNum_",""Hook"":"_Hook_",""NoPass"":"_NoPass_",""HumanRefuse"":"_HumanRefuse
 	w ",""HumanDouble"":"_HumanDouble_",""PhaNum"":"_PhaNum
 	w "}"
 	q ""
}

}
