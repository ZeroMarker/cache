Class web.DHCPRESCInterventQueryByLoc Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Descript:	详细数据
/// Creator:    hxy
/// CreateDate: 2022-02-28
/// InPut:      
/// OutPut:     科室名称
///             处方开具次数（合理用药总数）
///             系统审查拦截次数(率)（合理用药禁止）
///             系统审查不通过次数(率)（合理用药警示）
///             医生选择药师审核次数(率)（审方数）
///             药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
///             双签执行次数(率)（审方结果为双签通过的数量）
///             返回修改次数(率)（审方结果为必须修改的数量）
/// w ##class(web.DHCPRESCInterventQueryByLoc).QueryByLoc("10","1","01/04/2023^24/04/2023^^350204")
ClassMethod QueryByLoc(rows, page, Params)
{
	s End=page*rows
	s Start=(page-1)*rows+1
	s ^temptest("rows") = $lb(rows, page, Params)
	s StDate = $p(Params,"^",1)
	s EdDate = $p(Params,"^",2)
	s LocDesc= $p(Params,"^",3)
	s Pid = $p(Params,"^",4)
	s StDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(StDate)
	s EdDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(EdDate)
	s:StDate="" StDate=+$h
	s:EdDate="" EdDate=+$h
	;k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc")
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid)
	
	s LocNum=0,TotalNum=0,Hook=0,NoPass=0,HumanRefuse=0,HumanDouble=0
	s LocStr="*"
	f Date = StDate:1:EdDate  d
	.s CreTime = ""
	.f  s CreTime = $o(^PHA.PREADT.AuditI("Date",Date,CreTime))  q:CreTime=""  d
	..s AuditId = ""
	..for  s AuditId = $o(^PHA.PREADT.AuditI("Date",Date,CreTime,AuditId)) Q:AuditId=""  d
	...s Adm = $lg(^PHA.PREADT.AuditD(AuditId),3)   // 就诊id
	...s Loc = ""
	...s LocId = $lg(^PHA.PREADT.AuditD(AuditId),9)	// 科室
	...Q:LocId=""
	...s Loc = $p(^CTLOC(LocId),"^",2)
	...q:(LocDesc'="")&(Loc'=LocDesc)
	...i LocStr'[("*"_Loc_"*") d
	....s LocNum=LocNum+1                        // 监测科室数
	....s LocStr=LocStr_Loc_"*"
	...s TotalNum=TotalNum+1                     // 合理用药总数
	...s MonId = $lg(^PHA.PREADT.AuditD(AuditId),2)
	...Q:MonId=""
	...s MonData = $lg(^CKB.PDSS.MonMasterD(MonId))
	...s ManLev = $lg(MonData,8) 				// 审查级别
	...s:ManLev="forbid" Hook=Hook+1             // 合理用药禁止
	...s:ManLev="warn" NoPass=NoPass+1           // 合理用药警示
	...i AuditId'="" d
	....s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	....s ResStatus=""
	....s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	....s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	....s:ResStatus="STA01" HumanRefuse=HumanRefuse + 1
	....s:ResStatus="STA03" HumanRefuse=HumanRefuse + 1 // 审方结果为必须修改+双签通过的数量
	....s:ResStatus="STA03" HumanDouble=HumanDouble + 1 // 审方结果为双签通过的数量
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocAudit")) d //医生选择药师审核次数(率)（审方数）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocAudit")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocAudit")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocAudit")+1
	....i ResStatus="STA01" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanNoPass")) d //药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanNoPass")+1
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc",Pid,Loc,"LocHumanReturn")) d //返回修改次数(率)（审方结果为必须修改的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanReturn")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanReturn")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanReturn")+1
	....i ResStatus="STA03" d
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanNoPass")) d //药师审核后不通过次数(率)（审方结果为必须修改+双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanNoPass")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanNoPass")+1
	.....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc",Pid,Loc,"LocHumanDouble")) d //双签执行次数(率)（审方结果为双签通过的数量）
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanDouble")=1
	.....e  d
	......s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanDouble")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanDouble")+1
	...
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocTotalNum")) d //处方开具次数（合理用药总数）
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocTotalNum")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocTotalNum")+1
	...i ManLev="forbid" d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHook")) d //系统审查拦截次数(率)（合理用药禁止）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHook")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHook")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHook")+1
	...i ManLev="warn" d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocNoPass")) d //系统审查不通过次数(率)（合理用药警示）
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocNoPass")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocNoPass")+1
	....
	...
	..
	.
	i LocNum'=0 d
	.s TotalNum=$fn(TotalNum/LocNum,"",1)
	.s Hook=$fn(Hook/LocNum,"",1)
	.s NoPass=$fn(NoPass/LocNum,"",1)
	.s HumanRefuse=$fn(HumanRefuse/LocNum,"",1)
	.s HumanDouble=$fn(HumanDouble/LocNum,"",1)
	
	s count=0
	w "{""rows"":["
	s listTitle ="Loc^LocTotalNum^LocHook^LocNoPass^LocAudit^LocHumanNoPass^LocHumanDouble^LocHumanReturn"
	s Loc = ""
	f  s Loc = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc)) Q:(Loc="")  d
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocTotalNum"))
	.s LocHook=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHook"))
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocNoPass"))
	.s LocAudit=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocAudit"))
	.s LocHumanNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanNoPass"))
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanDouble")) 
	.s LocHumanReturn=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid,Loc,"LocHumanReturn"))
	.i LocTotalNum'=0 d
	..s LocHook=LocHook_" ("_$fn(LocHook/LocTotalNum*100,"",2)_"%)"					
	..s LocNoPass=LocNoPass_"("_$fn(LocNoPass/LocTotalNum*100,"",2)_"%)"		
	..s LocAudit=LocAudit_" ("_$fn(LocAudit/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanNoPass=LocHumanNoPass_" ("_$fn(LocHumanNoPass/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanDouble=LocHumanDouble_" ("_$fn(LocHumanDouble/LocTotalNum*100,"",2)_"%)"	
	..s LocHumanReturn=LocHumanReturn_" ("_$fn(LocHumanReturn/LocTotalNum*100,"",2)_"%)"
	.s list = Loc_"^"_LocTotalNum_"^"_LocHook_"^"_LocNoPass_"^"_LocAudit_"^"_LocHumanNoPass_"^"_LocHumanDouble_"^"_LocHumanReturn
	.s count=count+1	
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)

 	w "],""total"":"_count
 	w ",""LocNum"":"_LocNum_",""TotalNum"":"_TotalNum_",""Hook"":"_Hook_",""NoPass"":"_NoPass_",""HumanRefuse"":"_HumanRefuse
 	w ",""HumanDouble"":"_HumanDouble
 	w "}"
 	
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryByLoc",Pid)
 	q ""
}

/// Description:	处方总通过率排行
/// Creator:		hxy
/// CreateDate:		2022-03-08
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByLoc).QueryLocPassAll("27/04/2023^28/04/2023^asc^95162")
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid)
	
	s time = ""
	for date=StDate:1:EdDate  d
	.for  s time = $o(^PHA.PREADT.AuditI("Date",date,time))  Q:time=""  d
	..s AuditId = ""
	..for  s AuditId = $o(^PHA.PREADT.AuditI("Date",date,time,AuditId))  Q:AuditId=""  d
	...s LocId = $lg(^PHA.PREADT.AuditD(AuditId),9)					//科室
	...s Loc = $p($g(^CTLOC(+LocId)),"^",2)
	...Q:Loc=""
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	...i (ResStatus="STA03")!(ResStatus="STA04") d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocPass")) d //审方结果为通过的数量
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocPass")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocPass")+1
	...
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocTotalNum")) d //处方开具次数（合理用药总数）
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocTotalNum")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocTotalNum")+1
	
	s Loc = ""
	f  s Loc = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc)) Q:(Loc="")  d
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocTotalNum"))
	.s LocPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocPass")) 
	.i LocTotalNum'=0 d
	..s LocPassAll=$fn(LocPass/LocTotalNum*100,"",2)
	..s Rate=LocPassAll
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAllRat",Pid,"LocPassAll",LocPassAll)) s LocPassAll=LocPassAll+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAllRat",Pid,"LocPassAll",LocPassAll) = Loc_"^"_Rate
	
	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAllRat",Pid,"LocPassAll",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAllRat",Pid,"LocPassAll",Rate)
	.s count=count+1
	.q:(count>11)	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAllRat",Pid)
	q ""
}

/// Description:	处方总通过率排行Old
/// Creator:		hxy
/// CreateDate:		2022-03-08
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByLoc).QueryLocPassAll("^^asc^1")
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid)
	
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2)   // 就诊id
	..;q:Adm=""
	..s Loc = $lg(MonData,6)	// 科室
	..q:Loc=""
	..s ManLev = $lg(MonData,8) // 审查级别
	..s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	..i AuditId'="" d
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	...i ResStatus="STA04" d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocHumanPass")) d //审方结果为通过的数量
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocHumanPass")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocHumanPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocHumanPass")+1
	..
	..i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocTotalNum")) d //处方开具次数（合理用药总数）
	...s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocTotalNum")=1
	..e  d
	...s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocTotalNum")+1
	..i ManLev="forbid" d
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocHook")) d //系统审查拦截次数(率)（合理用药禁止）
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocHook")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocHook")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocHook")+1
	..i ManLev="warn" d
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocNoPass")) d //系统审查不通过次数(率)（合理用药警示）
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocNoPass")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocNoPass")+1
	
	s Loc = ""
	f  s Loc = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc)) Q:(Loc="")  d
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocTotalNum"))
	.s LocHook=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocHook"))
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocNoPass"))
	.s LocHumanPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,Loc,"LocHumanPass")) 
	.i LocTotalNum'=0 d
	..s LocPassAll=$fn(LocTotalNum-LocHook-LocNoPass+LocHumanPass/LocTotalNum*100,"",2)
	..s Rate=LocPassAll
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,"LocPassAll",LocPassAll)) s LocPassAll=LocPassAll+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,"LocPassAll",LocPassAll) = Loc_"^"_Rate

	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,"LocPassAll",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid,"LocPassAll",Rate)
	.s count=count+1
	.q:(count>11)	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassAll",Pid)
	q ""
}

/// Description:	系统审查通过率排行
/// Creator:		hxy
/// CreateDate:		2022-03-08
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByLoc).QueryLocPass("2023-02-01^2023-03-13^asc^95162")
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid)
	
	s time = ""
	for date=StDate:1:EdDate  d
	.for  s time = $o(^PHA.PREADT.AuditI("Date",date,time))  Q:time=""  d
	..s AuditId = ""
	..for  s AuditId = $o(^PHA.PREADT.AuditI("Date",date,time,AuditId))  Q:AuditId=""  d
	...s LocId = $lg(^PHA.PREADT.AuditD(AuditId),9)					//科室
	...s Loc = $p($g(^CTLOC(+LocId)),"^",2)
	...Q:Loc=""
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus="",Remark=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:AuditResult'="" Remark=$lg(^PHA.PREADT.AuditResultD(AuditResult),8)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocTotalNum")) d //处方开具次数
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocTotalNum")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocTotalNum")+1
	...i (ResStatus="STA04")&&(Remark["自动通过") d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"SysPass")) d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"SysPass")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"SysPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"SysPass")+1
	
	s Loc = ""
	f  s Loc = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc)) Q:(Loc="")  d
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocTotalNum"))
	.s SysPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"SysPass"))
	.i LocTotalNum'=0 d
	..s LocPass=$fn(SysPass/LocTotalNum*100,"",2)
	..s Rate=LocPass
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassRat",Pid,"LocPass",LocPass)) s LocPass=LocPass+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassRat",Pid,"LocPass",LocPass) = Loc_"^"_Rate

	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassRat",Pid,"LocPass",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassRat",Pid,"LocPass",Rate)
	.s count=count+1
	.q:(count>11)	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPassRat",Pid)
	q ""
}

/// Description:	系统审查通过率排行Old
/// Creator:		hxy
/// CreateDate:		2022-03-08
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByLoc).QueryLocPass("^^asc^1")
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid)
	
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2)  // 就诊id
	..;q:Adm=""
	..s Loc = $lg(MonData,6) // 科室
	..q:Loc=""
	..s ManLev = $lg(MonData,8) // 审查级别
	..i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocTotalNum")) d //处方开具次数（合理用药总数）
	...s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocTotalNum")=1
	..e  d
	...s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocTotalNum")+1
	..i ManLev="forbid" d
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocHook")) d //系统审查拦截次数(率)（合理用药禁止）
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocHook")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocHook")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocHook")+1
	..i ManLev="warn" d
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocNoPass")) d //系统审查不通过次数(率)（合理用药警示）
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocNoPass")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocNoPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocNoPass")+1
	
	s Loc = ""
	f  s Loc = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc)) Q:(Loc="")  d
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocTotalNum"))
	.s LocHook=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocHook"))
	.s LocNoPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,Loc,"LocNoPass"))
	.i LocTotalNum'=0 d
	..s LocPass=$fn(LocTotalNum-LocHook-LocNoPass/LocTotalNum*100,"",2)
	..s Rate=LocPass
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,"LocPass",LocPass)) s LocPass=LocPass+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,"LocPass",LocPass) = Loc_"^"_Rate


	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,"LocPass",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid,"LocPass",Rate)
	.s count=count+1
	.q:(count>11)	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryLocPass",Pid)
	q ""
}

/// Description:	人工审核通过率排行
/// Creator:		hxy
/// CreateDate:		2022-03-01	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByLoc).QueryHumanPass("2022-11-23^2022-11-23^desc^1")
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid)
	
	s time = ""
	for date=StDate:1:EdDate  d
	.for  s time = $o(^PHA.PREADT.AuditI("Date",date,time))  Q:time=""  d
	..s AuditId = ""
	..for  s AuditId = $o(^PHA.PREADT.AuditI("Date",date,time,AuditId))  Q:AuditId=""  d
	...s LocId = $lg(^PHA.PREADT.AuditD(AuditId),9)					//科室
	...s Loc = $p($g(^CTLOC(+LocId)),"^",2)
	...Q:Loc=""
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus="",Remark=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:AuditResult'="" Remark=$lg(^PHA.PREADT.AuditResultD(AuditResult),8)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocTotalNum")) d //处方开具次数
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocTotalNum")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocTotalNum")+1
	...i (ResStatus="STA04")&&(Remark'["自动通过") d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocHumanPass")) d //审方结果为通过的数量
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocHumanPass")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocHumanPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocHumanPass")+1

		
	s Loc = ""
	f  s Loc = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc)) Q:(Loc="")  d
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocTotalNum"))
	.s LocHumanPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocHumanPass"))
	.i LocTotalNum'=0 d
	..s LocHumanPass=$fn(LocHumanPass/LocTotalNum*100,"",2)
	..s Rate=LocHumanPass
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,"HumanPass",LocHumanPass)) s LocHumanPass=LocHumanPass+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,"HumanPass",LocHumanPass) = Loc_"^"_Rate			
	
	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,"HumanPass",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,"HumanPass",Rate)
	.s count=count+1
	.q:(count>11)	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid)
	q ""
}

/// Description:	人工审核通过率排行Old
/// Creator:		hxy
/// CreateDate:		2022-03-01	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByLoc).QueryHumanPass("^^desc^1")
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid)
	
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2)    // 就诊id
	..;q:Adm=""
	..s Loc = $lg(MonData,6)	// 科室
	..q:Loc=""
	..s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	..i AuditId'="" d
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	...i ResStatus="STA04" d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocHumanPass")) d //审方结果为通过的数量
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocHumanPass")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocHumanPass")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocHumanPass")+1
	..
	..i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocTotalNum")) d //处方开具次数（合理用药总数）
	...s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocTotalNum")=1
	..e  d
	...s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocTotalNum")+1
		
	s Loc = ""
	f  s Loc = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc)) Q:(Loc="")  d
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocTotalNum"))
	.s LocHumanPass=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,Loc,"LocHumanPass"))
	.i LocTotalNum'=0 d
	..s LocHumanPass=$fn(LocHumanPass/LocTotalNum*100,"",2)
	..s Rate=LocHumanPass
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,"HumanPass",LocHumanPass)) s LocHumanPass=LocHumanPass+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,"HumanPass",LocHumanPass) = Loc_"^"_Rate			
	
	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,"HumanPass",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid,"HumanPass",Rate)
	.s count=count+1
	.q:(count>11)	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanPass",Pid)
	q ""
}

/// Description:	双签执行率排行
/// Creator:		hxy
/// CreateDate:		2022-03-08
/// Input:			
/// return:			
/// other:			w ##class(web.DHCPRESCInterventQueryByLoc).QueryHumanDouble("27/04/2023^28/04/2023^desc^1")
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
	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid)
	
	s time = ""
	for date=StDate:1:EdDate  d
	.for  s time = $o(^PHA.PREADT.AuditI("Date",date,time))  Q:time=""  d
	..s AuditId = ""
	..for  s AuditId = $o(^PHA.PREADT.AuditI("Date",date,time,AuditId))  Q:AuditId=""  d
	...s LocId = $lg(^PHA.PREADT.AuditD(AuditId),9)					//科室
	...s Loc = $p($g(^CTLOC(+LocId)),"^",2)
	...Q:Loc=""
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus="",Remark=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:AuditResult'="" Remark=$lg(^PHA.PREADT.AuditResultD(AuditResult),8)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	...i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocTotalNum")) d //处方开具次数
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocTotalNum")=1
	...e  d
	....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocTotalNum")+1
	...i ResStatus="STA03" d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocHumanDouble")) d //审方结果为双签通过的数量
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocHumanDouble")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocHumanDouble")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocHumanDouble")+1
	
	s Loc = ""
	f  s Loc = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc)) Q:(Loc="")  d
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocTotalNum"))
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocHumanDouble"))
	.i LocTotalNum'=0 d
	..s LocHumanDouble=$fn(LocHumanDouble/LocTotalNum*100,"",2)
	..s Rate=LocHumanDouble
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDoubleRat",Pid,"HumanDouble",Loc)) s LocHumanDouble=LocHumanDouble+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDoubleRat",Pid,"HumanDouble",Loc) = Loc_"^"_Rate		
	
	
	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDoubleRat",Pid,"HumanDouble",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDoubleRat",Pid,"HumanDouble",Rate)
	.s count=count+1
	.q:(count>11)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid)
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDoubleRat",Pid)
	q ""
}

/// Description:	双签执行率排行Old
/// Creator:		hxy
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
	
	f Date = StDate:1:EdDate  d
	.s MonId = ""
	.f  s MonId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,MonId))  q:MonId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(MonId))
	..s Adm = $lg(MonData,2)   // 就诊id
	..;q:Adm=""
	..s Loc = $lg(MonData,6)	// 科室
	..q:Loc=""
	..s AuditId=$o(^PHA.PREADT.AuditI("linkMon",MonId,""))
	..i AuditId'="" d
	...s AuditResult=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,""))
	...s ResStatus=""
	...s:AuditResult'="" ResStatus=$lg(^PHA.PREADT.AuditResultD(AuditResult),6)
	...s:ResStatus'="" ResStatus=$lg(^CT.PHA.PREADT.DicItemD(ResStatus),2)
	...i ResStatus="STA03" d
	....i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocHumanDouble")) d //审方结果为双签通过的数量
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocHumanDouble")=1
	....e  d
	.....s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocHumanDouble")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocHumanDouble")+1
	..
	..i '$d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocTotalNum")) d //处方开具次数（合理用药总数）
	...s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocTotalNum")=1
	..e  d
	...s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocTotalNum")=^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocTotalNum")+1
		
	s Loc = ""
	f  s Loc = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc)) Q:(Loc="")  d
	.s LocTotalNum=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocTotalNum"))
	.s LocHumanDouble=+$g(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,Loc,"LocHumanDouble"))
	.i LocTotalNum'=0 d
	..s LocHumanDouble=$fn(LocHumanDouble/LocTotalNum*100,"",2)
	..s Rate=LocHumanDouble
	..i $d(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,"HumanDouble",LocHumanDouble)) s LocHumanDouble=LocHumanDouble+0.01   //相同数量，为了防止数据覆盖，后者加0.01
	..s ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,"HumanDouble",LocHumanDouble) = Loc_"^"_Rate		

	
	s count=0
	s ListTitle="name^value"
	w "["
	s Rate = ""
	f  s Rate = $o(^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,"HumanDouble",Rate),order) Q:(Rate="")  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid,"HumanDouble",Rate)
	.s count=count+1
	.q:(count>11)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

 	w "]"
 	k ^TMP("DHCPRESC","web.DHCPRESCInterventQueryByLoc","QueryHumanDouble",Pid)
	q ""
}

}
