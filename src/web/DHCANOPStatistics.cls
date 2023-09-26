Class web.DHCANOPStatistics Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator: wangxinlei
/// CreatDate: 2009-11-30
/// Description: 手术医师工作量统计,手术规模统计在手术上
/// Table：DHC_AN_OPArrange,DHC_ANC_OPLevel,OR_Anaesthesia,OR_Anaest_Operation,OR_An_Oper_Assistant
/// Input：StartDate:开始日期, EndDate:结束日期, WardLoc:手术科室, WardDoc:手术医生
/// Return：返回手术医师工作量统计
/// 			手术科室:opLoc,手术医师:opDoc,手术I:opDocSP,手术II:opDocB,手术III:opDocM,手术IV:opDocSM,手术合计:opDocAll等
Query GetAnOpStatWardDoc(StartDate As %String, EndDate As %String, WardLoc As %String, WardDoc As %String) As %Query(ROWSPEC = "opLoc,opDoc,opDocSP,opDocB,opDocM,opDocSM,opDocAll,assistDocISP,assistDocIB,assistDocIM,assistDocISM,assistDocIAll,assistDocIISP,assistDocIIB,assistDocIIM,assistDocIISM,assistDocIIAll,assistDocIIISP,assistDocIIIB,assistDocIIIM,assistDocIIISM,assistDocIIIAll,assistDocIVSP,assistDocIVB,assistDocIVM,assistDocIVSM,assistDocIVAll,assistDocVSP,assistDocVB,assistDocVM,assistDocVSM,assistDocVAll")
{
}

ClassMethod GetAnOpStatWardDocExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, WardLoc As %String, WardDoc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    k ^TMPAN("Stat",$j)
    s ^Tmpcc(1)=StartDate_"*"_EndDate_"*"_WardLoc_"*"_WardDoc
    if (StartDate="")!(EndDate="") s sdate=+$H,edate=+$H
	e  s sdate=StartDate,edate=EndDate
    f date=sdate:1:edate
    {  
		s opaId="" 
        f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
	    .q:$d(^DHCANOPArrange(opaId))<1
	    .s OPAStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.;q:OPAStatus'="F"   	//手术申请状态非完成退出
	    .s PatDeptDr=$P(^DHCANOPArrange(opaId),"^",21)
	    .q:(PatDeptDr="")!((WardLoc'="")&(WardLoc'=PatDeptDr))
	    .s opaAnDr=$P(^DHCANOPArrange(opaId),"^",2)
	    .s admId="",ANASub=""
	   	.i opaAnDr'="" d
	   	..s admId=$P(opaAnDr,"||",1)
	   	..s ANASub=$P(opaAnDr,"||",2)
	   	.q:(admId="")!(ANASub="")
	   	.s anLevelDr=$P(^DHCANOPArrange(opaId),"^",28) //OPA_OPLevel_Dr 原手术规模,现为麻醉规模
		.s anLevelCode=""
		.i anLevelDr'="" s anLevelCode=$P($g(^DHCANC("OPLevel",anLevelDr)),"^",1)  			//DHC_ANC_OPLevel->ANCOPL_Code 手术规模代码
		.q:anLevelCode=""
	   	.s OpDocDr=""
	   	.s i=0
	   	.s ANAOPSub=0 f  s ANAOPSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub)) q:(ANAOPSub="")  d
	   	..s i=i+1										//对同一条手术申请计算主附手术数
	   	..s opLevelDr=$P($g(^OR(admId,"ANA",ANASub,"OP",ANAOPSub,"DHC")),"^",1) 			//取手术规模 ^OR({PA_Adm.PAADM_RowID},"ANA",{ANA_Childsub},"OP",{ANAOP_Childsub},"DHC")
	   	..s opLevelCode=""
	   	..i opLevelDr'="" s opLevelCode=$P($g(^DHCANC("OPLevel",opLevelDr)),"^",1)  		//DHC_ANC_OPLevel->ANCOPL_Code 手术规模代码
	   	..e  d
	   	...i anLevelDr'="" d
	   	....s $P(^OR(admId,"ANA",ANASub,"OP",ANAOPSub,"DHC"),"^",1)=anLevelDr
	   	....s opLevelCode=anLevelCode					//如果手术没有规模则用现麻醉规模更新
	   	..q:opLevelCode=""
	   	..s OPSub=$O(^OR(admId,"ANA",ANASub,"OP",0)) 	//如有主附手术,总取主手术的ANAOPSub,再取手术医生与助手
	   	..s OpDocDr=$P(^OR(admId,"ANA",ANASub,"OP",OPSub),"^",8)      						//OR_Anaest_Operation->ANAOP_Surgeon_DR 手术医师
	   	..i OpDocDr'="" d
	   	...q:(WardDoc'="")&(WardDoc'=OpDocDr)
	   	...s ^TMPAN("Stat",$j,PatDeptDr,OpDocDr,"OpDoc",opLevelCode)=+$g(^TMPAN("Stat",$j,PatDeptDr,OpDocDr,"OpDoc",opLevelCode))+1  			//保存手术医师
	   	..s p=0
	   	..s OPASSub=0 f  s OPASSub=$O(^OR(admId,"ANA",ANASub,"OP",OPSub,"ASS",OPASSub)) q:(OPASSub="")!(p=4)  d
	   	...s AssDocDr=$P($g(^OR(admId,"ANA",ANASub,"OP",OPSub,"ASS",OPASSub)),"^",1)  		//OR_An_Oper_Assistant 手术助手
	   	...s p=p+1
	   	...i AssDocDr'="" d
	   	....q:(WardDoc'="")&(WardDoc'=AssDocDr)
	   	....s ^TMPAN("Stat",$j,PatDeptDr,AssDocDr,"AssDoc",p,opLevelCode)=+$g(^TMPAN("Stat",$j,PatDeptDr,AssDocDr,"AssDoc",p,opLevelCode))+1  //保存手术助手
	}
	
	s OpLocDr=""  f  s OpLocDr=$O(^TMPAN("Stat",$j,OpLocDr)) q:OpLocDr=""  d
	.s OpDocDr="" f  s OpDocDr=$O(^TMPAN("Stat",$j,OpLocDr,OpDocDr))  q:OpDocDr=""  d
	..s opLoc=$P($P($g(^CTLOC(OpLocDr)),"^",2),"-",2)
	..s opDoc=$p($P($g(^CTPCP(OpDocDr,1)),"^",2),"-",1)
	..s opDocSP=0,opDocB=0,opDocM=0,opDocSM=0,opDocAll=0,assistDocISP=0,assistDocIB=0,assistDocIM=0,assistDocISM=0,assistDocIAll=0,assistDocIISP=0,assistDocIIB=0,assistDocIIM=0,assistDocIISM=0,assistDocIIAll=0,assistDocIIISP=0,assistDocIIIB=0,assistDocIIIM=0,assistDocIIISM=0,assistDocIIIAll=0,assistDocIVSP=0,assistDocIVB=0,assistDocIVM=0,assistDocIVSM=0,assistDocIVAll=0,assistDocVSP=0,assistDocVB=0,assistDocVM=0,assistDocVSM=0,assistDocVAll=0
	..s opDocSP=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"OpDoc","SP"))
	..s opDocB=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"OpDoc","B"))
	..s opDocM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"OpDoc","M"))
	..s opDocSM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"OpDoc","SM"))
	..s assistDocISP=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",1,"SP"))
	..s assistDocIB=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",1,"B"))
	..s assistDocIM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",1,"M"))
	..s assistDocISM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",1,"SM"))
	..s assistDocIISP=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",2,"SP"))
	..s assistDocIIB=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",2,"B"))
	..s assistDocIIM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",2,"M"))
	..s assistDocIISM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",2,"SM"))
	..s assistDocIIISP=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",3,"SP"))
	..s assistDocIIIB=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",3,"B"))
	..s assistDocIIIM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",3,"M"))
	..s assistDocIIISM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",3,"SM"))
	..s assistDocIVSP=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",4,"SP"))
	..s assistDocIVB=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",4,"B"))
	..s assistDocIVM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",4,"M"))
	..s assistDocIVSM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",4,"SM"))
	..s assistDocVSP=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",5,"SP"))
	..s assistDocVB=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",5,"B"))
	..s assistDocVM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",5,"M"))
	..s assistDocVSM=+$g(^TMPAN("Stat",$j,OpLocDr,OpDocDr,"AssDoc",5,"SM"))
	..s opDocAll=opDocSP+opDocB+opDocM+opDocSM
	..s assistDocIAll=assistDocISP+assistDocIB+assistDocIM+assistDocISM
	..s assistDocIIAll=assistDocIISP+assistDocIIB+assistDocIIM+assistDocIISM
	..s assistDocIIIAll=assistDocIIISP+assistDocIIIB+assistDocIIIM+assistDocIIISM
	..s assistDocIVAll=assistDocIVSP+assistDocIVB+assistDocIVM+assistDocIVSM
	..s assistDocVAll=assistDocVSP+assistDocVB+assistDocVM+assistDocVSM
	..do OutRow
	//清除临时Global
	k ^TMPAN("Stat",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$lb(opLoc,opDoc,opDocSP,opDocB,opDocM,opDocSM,opDocAll,assistDocISP,assistDocIB,assistDocIM,assistDocISM,assistDocIAll,assistDocIISP,assistDocIIB,assistDocIIM,assistDocIISM,assistDocIIAll,assistDocIIISP,assistDocIIIB,assistDocIIIM,assistDocIIISM,assistDocIIIAll,assistDocIVSP,assistDocIVB,assistDocIVM,assistDocIVSM,assistDocIVAll,assistDocVSP,assistDocVB,assistDocVM,assistDocVSM,assistDocVAll)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpStatWardDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpStatWardDocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpStatWardDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpStatWardDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-11-30
/// Description: 麻醉医师工作量统计
/// Table：DHC_AN_OPArrange,DHC_ANC_OPLevel,OR_Anaesthesia,OR_Anaest_Operation,OR_An_Oper_Anaest_Assista
/// Input：StartDate:开始日期, EndDate:结束日期, AnLoc:麻醉科室, WardDoc:麻醉医生
/// Return：返回麻醉医师工作量统计
/// 			麻醉科室:anLoc,麻醉医生:anDoc,特大手术:anDocSP,大手术:anDocB,中手术:anDocM,小手术:anDocSM,合计:anDocAll
Query GetAnOpStatAnDoc(StartDate As %String, EndDate As %String, AnLocId As %String, AnDocId As %String) As %Query(ROWSPEC = "anLoc,anDoc,anDocSP,anDocB,anDocM,anDocSM,anDocAll,assAnDocSP,assAnDocB,assAnDocM,assAnDocSM,assAnDocAll,anNurSP,anNurB,anNurM,anNurSM,anNurAll")
{
}

ClassMethod GetAnOpStatAnDocExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, AnLocId As %String, AnDocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    k ^TMPAN("Stat",$j)
    if (StartDate="")!(EndDate="") s sdate=+$H,edate=+$H
	e  s sdate=StartDate,edate=EndDate
	i AnLocId="" s AnLocId="52"
	s anLoc=$p($P($g(^CTLOC(AnLocId)),"^",2),"-",2)
	e  s anLoc=""
    f date=sdate:1:edate
    {  
		s opaId="" 
        f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
	    .q:$d(^DHCANOPArrange(opaId))<1
	    .s OPAStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.;q:OPAStatus'="F"   //手术申请状态非完成退出
	    .s opaAnDr=$P(^DHCANOPArrange(opaId),"^",2)
	    .s admId="",ANASub=""
	   	.i opaAnDr'="" d
	   	..s admId=$P(opaAnDr,"||",1)
	   	..s ANASub=$P(opaAnDr,"||",2)
	   	.q:(admId="")!(ANASub="")
	   	.s opLevelDr=$P(^DHCANOPArrange(opaId),"^",28) 		//OPA_OPLevel_Dr 手术规模
		.s opLevelCode=""
		.i opLevelDr'="" s opLevelCode=$P($g(^DHCANC("OPLevel",opLevelDr)),"^",1)  //DHC_ANC_OPLevel->ANCOPL_Code 手术规模代码
		.q:opLevelCode=""
	   	.s AnDocDr=$P(^OR(admId,"ANA",ANASub),"^",6)        //ANA_Anaesthetist_Dr 麻醉医师
	   	.i AnDocDr'="" d
	   	..q:(AnDocId'="")&(AnDocId'=AnDocDr)
	   	..s ^TMPAN("Stat",$j,AnDocDr,"AnDoc",opLevelCode)=+$g(^TMPAN("Stat",$j,AnDocDr,"AnDoc",opLevelCode))+1  //保存麻醉医师
	   	.;s AnsupervisId=$P(^OR(admId,"ANA",ANASub),"^",7)        //ANA_Anaesthetist_Dr 麻醉指导医师
	   	.;i AnsupervisId'="" d  
	   	..;q:(AnDocId'="")&(AnDocId'=AnsupervisId)
	   	..;s ^TMPAN("Stat",$j,AnDocDr,"Ansupervisor",opLevelCode)=+$g(^TMPAN("Stat",$j,AnsupervisId,"AnDoc",opLevelCode))+1  //保存麻醉指导医师
	   	.s AnNurDr=$P(^OR(admId,"ANA",ANASub),"^",8)		//ANA_ORAnaNurse_DR   麻醉护士
	   	.i AnNurDr'="" d
	   	..q:(AnDocId'="")&(AnDocId'=AnNurDr)
	   	..s ^TMPAN("Stat",$j,AnNurDr,"AnNur",opLevelCode)=+$g(^TMPAN("Stat",$j,AnNurDr,"AnNur",opLevelCode))+1  //保存麻醉护士	   	
	   	.s i=0
	   	.s ANAOPSub=0 f  s ANAOPSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub)) q:(ANAOPSub="")!(i=1)  d
	   	..s i=i+1
	   	..s ANASSSub=0 f  s ANASSSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub,"ANASS",ANASSSub)) q:(ANASSSub="")  d
	   	...q:ANASSSub>20		//小于20为麻醉助手或其它麻醉医师,大于20为交麻醉医师
	   	...s AssAnDocDr=$P($g(^OR(admId,"ANA",ANASub,"OP",ANAOPSub,"ANASS",ANASSSub)),"^",1)  //OR_An_Oper_Anaest_Assista 麻醉助手或其它麻醉医师
	   	...i AssAnDocDr'="" d
	   	....q:(AnDocId'="")&(AnDocId'=AssAnDocDr)
		....s ^TMPAN("Stat",$j,AssAnDocDr,"AssDoc",opLevelCode)=+$g(^TMPAN("Stat",$j,AssAnDocDr,"AssDoc",opLevelCode))+1  //保存麻醉助手或其它麻醉医师	   	
	}
	
	s AnDocDr=""  f  s AnDocDr=$O(^TMPAN("Stat",$j,AnDocDr)) q:AnDocDr=""  d
	.;s anDoc=$P(^CTPCP(AnDocDr,1),"^",2)
	.s anDoc=##class(web.DHCANOPCom).GetNameById(AnDocDr)
	.s anDocSP=0,anDocB=0,anDocM=0,anDocSM=0,anDocAll=0,assAnDocSP=0,assAnDocB=0,assAnDocM=0,assAnDocSM=0,assAnDocAll=0,anNurSP=0,anNurB=0,anNurM=0,anNurSM=0,anNurAll=0
	.s anDocSP=+$g(^TMPAN("Stat",$j,AnDocDr,"AnDoc","SP"))
	.s anDocB=+$g(^TMPAN("Stat",$j,AnDocDr,"AnDoc","B"))
	.s anDocM=+$g(^TMPAN("Stat",$j,AnDocDr,"AnDoc","M"))
	.s anDocSM=+$g(^TMPAN("Stat",$j,AnDocDr,"AnDoc","SM"))
	.s assAnDocSP=+$g(^TMPAN("Stat",$j,AnDocDr,"AssDoc","SP"))
	.s assAnDocB=+$g(^TMPAN("Stat",$j,AnDocDr,"AssDoc","B"))
	.s assAnDocM=+$g(^TMPAN("Stat",$j,AnDocDr,"AssDoc","M"))
	.s assAnDocSM=+$g(^TMPAN("Stat",$j,AnDocDr,"AssDoc","SM"))
	.s anNurSP=+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","SP"))
	.s anNurB=+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","B"))
	.s anNurM=+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","M"))
	.s anNurSM=+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","SM"))	
	.s anDocAll=anDocSP+anDocB+anDocM+anDocSM
	.s assAnDocAll=assAnDocSP+assAnDocB+assAnDocM+assAnDocSM
	.s anNurAll=anNurSP+anNurB+anNurM+anNurSM
	.do OutRow
	//清除临时Global
	k ^TMPAN("Stat",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$lb(anLoc,anDoc,anDocSP,anDocB,anDocM,anDocSM,anDocAll,assAnDocSP,assAnDocB,assAnDocM,assAnDocSM,assAnDocAll,anNurSP,anNurB,anNurM,anNurSM,anNurAll)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpStatAnDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpStatAnDocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpStatAnDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpStatAnDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-11-30
/// Description: 手术护士工作量统计
/// Table：DHC_AN_OPArrange,DHC_ANC_OPLevel,OR_Anaesthesia,OR_Anaest_Operation,OR_An_Oper_Scrub_Nurse,
/// Input：StartDate:开始日期, EndDate:结束日期, OpLocId:手术室, OpNurId:手术护士
/// Return：返回手术护士工作量统计
/// 			手术室:opLoc,手术护士:opNur,台上I例数:instrNurSP,台上I小时数:instrNurSPH,台上II例数:instrNurB,台上II小时数:instrNurBH,台上III例数:instrNurM,台上III小时数:instrNurMH,台上IV例数:instrNurSM,台上IV小时数:instrNurSMH,台上例数:instrNurAll,台上小时数:instrNurAllH等
Query GetAnOpStatOpNur(StartDate As %String, EndDate As %String, OpLocId As %String, OpNurId As %String) As %Query(ROWSPEC = "opLoc,opNur,instrNurSP,instrNurSPH,instrNurB,instrNurBH,instrNurM,instrNurMH,instrNurSM,instrNurSMH,instrNurAll,instrNurAllH,cirNurSP,cirNurSPH,cirNurB,cirNurBH,cirNurM,cirNurMH,cirNurSM,cirNurSMH,cirNurAll,cirNurAllH,opNurAll,opNurAllH")
{
}

ClassMethod GetAnOpStatOpNurExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, OpLocId As %String, OpNurId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    k ^TMPAN("Stat",$j)
    if (StartDate="")!(EndDate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(StartDate),edate=##Class(web.DHCANOPCom).ConvertToDateH(EndDate)
    f date=sdate:1:edate
    {  
		s opaId="" 
        f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
	    .q:$d(^DHCANOPArrange(opaId))<1
	    .s OPAStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.;q:OPAStatus'="F"   //手术申请状态非完成退出
	    .s opaAnDr=$P(^DHCANOPArrange(opaId),"^",2)
	    .s admId="",ANASub=""
	   	.i opaAnDr'="" d
	   	..s admId=$P(opaAnDr,"||",1)
	   	..s ANASub=$P(opaAnDr,"||",2)
	   	.q:(admId="")!(ANASub="")
	   	.s opLevelDr=$P(^DHCANOPArrange(opaId),"^",28) 								//OPA_OPLevel_Dr 手术规模
		.s opLevelCode=""
		.i opLevelDr'="" s opLevelCode=$P($g(^DHCANC("OPLevel",opLevelDr)),"^",1)   //DHC_ANC_OPLevel->ANCOPL_Code 手术规模代码
		.q:opLevelCode=""
		.s opTime=0
		.//原来取DHC_AN_OPArrange表中手术登记时间
		.s oldStDate=$P(^DHCANOPArrange(opaId),"^",14) 	//OPA_StartDate 开始日期
		.s oldStTime=$P(^DHCANOPArrange(opaId),"^",15) 	//OPA_StartTime 开始时间
		.s oldEnDate=$P(^DHCANOPArrange(opaId),"^",16) 	//OPA_EndDate   结束日期
		.s oldEnTime=$P(^DHCANOPArrange(opaId),"^",17) 	//OPA_EndTime	结束时间
		.//新的取OR_Anaesthesia表中手术登记时间,如为空则取排班表时间
		.s StDate=$P(^OR(admId,"ANA",ANASub),"^",39) 	//ANA_TheatreInDate  	开始日期
		.i StDate="" d
		..s $P(^OR(admId,"ANA",ANASub),"^",39)=oldStDate	
		..s StDate=oldStDate
		.s StTime=$P(^OR(admId,"ANA",ANASub),"^",40) 	//ANA_TheatreInTime  	开始时间
		.i StTime="" d
		..s $P(^OR(admId,"ANA",ANASub),"^",40)=oldStTime
		..s StTime=oldStTime
		.s EnDate=$P(^OR(admId,"ANA",ANASub),"^",41) 	//ANA_TheatreOutDate  	结束日期
		.i EnDate="" d
		..s $P(^OR(admId,"ANA",ANASub),"^",41)=oldEnDate
		..s EnDate=oldEnDate
		.s EnTime=$P(^OR(admId,"ANA",ANASub),"^",42) 	//ANA_TheatreOutTime	结束时间		
		.i EnTime="" d
		..s $P(^OR(admId,"ANA",ANASub),"^",42)=oldEnTime
		..s EnTime=oldEnTime
		.i StDate'="",StTime'="",EnDate'="",EnTime'=""  d
		..s opTime=((EnDate-StDate)*24+(EnTime-StTime))/3600
	   	.s i=0
	   	.s ANAOPSub=0 f  s ANAOPSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub)) q:(ANAOPSub="")!(i=1)  d
	   	..s i=i+1
	   	..s ANAOPLocId=$p(^OR(admId,"ANA",ANASub,"OP",ANAOPSub),"^",10) //OR_Anaest_Operation->ANAOP_CTLOC_DR 手术室 
	   	..q:ANAOPLocId=""
	   	..q:(OpLocId'="")&(OpLocId'=ANAOPLocId)
	   	..s OPSCNSub=0 f  s OPSCNSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub,"SCN",OPSCNSub)) q:(OPSCNSub="")  d
	   	...q:OPSCNSub>20	//小于20为洗手护士,大于20是交洗手护士
	   	...s InstrNurDr=$P($g(^OR(admId,"ANA",ANASub,"OP",ANAOPSub,"SCN",OPSCNSub)),"^",1)  //OR_An_Oper_Scrub_Nurse 洗手护士或器材护士
	   	...i InstrNurDr'="" d
	   	....q:(OpNurId'="")&(OpNurId'=InstrNurDr)
	   	....s ^TMPAN("Stat",$j,ANAOPLocId,InstrNurDr,"SNur",opLevelCode)=+$g(^TMPAN("Stat",$j,ANAOPLocId,InstrNurDr,"SNur",opLevelCode))+1  //保存洗手护士或器材护士例数
	   	....s ^TMPAN("Stat",$j,ANAOPLocId,InstrNurDr,"SNur",opLevelCode,"TIME")=+$g(^TMPAN("Stat",$j,ANAOPLocId,InstrNurDr,"SNur",opLevelCode,"TIME"))+opTime  //保存洗手护士或器材护士小时数
	   	..s CIRNSub=0 f  s CIRNSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub,"CIRN",CIRNSub)) q:(CIRNSub="")  d
	   	...q:CIRNSub>20	//小于20为巡回护士,大于20是交巡回护士
	   	...s cirNurDr=$P($g(^OR(admId,"ANA",ANASub,"OP",ANAOPSub,"CIRN",CIRNSub)),"^",1)  //OR_An_Oper_Circul_Nurse 巡回护士
	   	...i cirNurDr'="" d
	   	....q:(OpNurId'="")&(OpNurId'=cirNurDr)
	   	....s ^TMPAN("Stat",$j,ANAOPLocId,cirNurDr,"CNur",opLevelCode)=+$g(^TMPAN("Stat",$j,ANAOPLocId,cirNurDr,"CNur",opLevelCode))+1  //保存巡回护士例数
	   	....s ^TMPAN("Stat",$j,ANAOPLocId,cirNurDr,"CNur",opLevelCode,"TIME")=+$g(^TMPAN("Stat",$j,ANAOPLocId,cirNurDr,"CNur",opLevelCode,"TIME"))+opTime  //保存巡回护士小时数
	}
	
	s ANAOPLocId=""  f  s ANAOPLocId=$O(^TMPAN("Stat",$j,ANAOPLocId)) q:ANAOPLocId=""  d
	.s OpNurDr="" f  s OpNurDr=$O(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr))  q:OpNurDr=""  d
	..s opLoc=$p($P(^CTLOC(ANAOPLocId),"^",2),"-",2)
	..;s opNur=$P(^CTPCP(OpNurDr,1),"^",2)
	..s opNur=##class(web.DHCANOPCom).GetNameById(OpNurDr)
	..s instrNurSP=0,instrNurSPH=0,instrNurB=0,instrNurBH=0,instrNurM=0,instrNurMH=0,instrNurSM=0,instrNurSMH=0,instrNurAll=0,instrNurAllH=0,cirNurSP=0,cirNurSPH=0,cirNurB=0,cirNurBH=0,cirNurM=0,cirNurMH=0,cirNurSM=0,cirNurSMH=0,cirNurAll=0,cirNurAllH=0,opNurAll=0,opNurAllH=0
	..s instrNurSP=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"SNur","SP"))
	..s instrNurSPH=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"SNur","SP","TIME"))
	..s instrNurB=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"SNur","B"))
	..s instrNurBH=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"SNur","B","TIME"))
	..s instrNurM=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"SNur","M"))
	..s instrNurMH=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"SNur","M","TIME"))
	..s instrNurSM=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"SNur","SM"))
	..s instrNurSMH=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"SNur","SM","TIME"))
	..s cirNurSP=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"CNur","SP"))
	..s cirNurSPH=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"CNur","SP","TIME"))
	..s cirNurB=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"CNur","B"))
	..s cirNurBH=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"CNur","B","TIME"))
	..s cirNurM=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"CNur","M"))
	..s cirNurMH=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"CNur","M","TIME"))
	..s cirNurSM=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"CNur","SM"))
	..s cirNurSMH=+$g(^TMPAN("Stat",$j,ANAOPLocId,OpNurDr,"CNur","SM","TIME"))
	..s instrNurAll=instrNurSP+instrNurB+instrNurM+instrNurSM
	..s instrNurAllH=instrNurSPH+instrNurBH+instrNurMH+instrNurSM
	..s instrNurSPH=$fn(instrNurSPH,"",1)
	..s instrNurBH=$fn(instrNurBH,"",1)
	..s instrNurMH=$fn(instrNurMH,"",1)
	..s instrNurSMH=$fn(instrNurSMH,"",1)
	..s cirNurAll=cirNurSP+cirNurB+cirNurM+cirNurSM
	..s cirNurAllH=cirNurSPH+cirNurBH+cirNurMH+cirNurSMH
	..s cirNurSPH=$fn(cirNurSPH,"",1)
	..s cirNurBH=$fn(cirNurBH,"",1)
	..s cirNurMH=$fn(cirNurMH,"",1)
	..s cirNurSMH=$fn(cirNurSMH,"",1)
	..s opNurAll=instrNurAll+cirNurAll
	..s opNurAllH=instrNurAllH+cirNurAllH
	..s instrNurAllH=$fn(instrNurAllH,"",1)
	..s cirNurAllH=$fn(cirNurAllH,"",1)
	..s opNurAllH=$fn(opNurAllH,"",1)
	..do OutRow
	//清除临时Global
	//k ^TMPAN("Stat",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(opLoc,opNur,instrNurSP,instrNurSPH,instrNurB,instrNurBH,instrNurM,instrNurMH,instrNurSM,instrNurSMH,instrNurAll,instrNurAllH,cirNurSP,cirNurSPH,cirNurB,cirNurBH,cirNurM,cirNurMH,cirNurSM,cirNurSMH,cirNurAll,cirNurAllH,opNurAll,opNurAllH)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpStatOpNurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpStatOpNurExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpStatOpNurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpStatOpNurExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/*Query GetAnOpStatWardLoc(StartDate As %String, EndDate As %String, WardLocId As %String, OpLocId As %String = "") As %Query(ROWSPEC = "wardLoc,opSP,opB,opM,opSM,opAll,opAllOP,opTotal,opLoc,opCancel")
{
}

ClassMethod GetAnOpStatWardLocExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, WardLocId As %String, OpLocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    k ^TMPAN("Stat",$j)
    if (StartDate="")!(EndDate="") s sdate=+$H,edate=+$H
	e  s sdate=StartDate,edate=EndDate
    f date=sdate:1:edate
    {  
		s opaId="" 
        f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
	    .q:$d(^DHCANOPArrange(opaId))<1
	    .s OPAStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.;q:OPAStatus'="F"   //手术申请状态非完成退出
	    .s PatDeptDr=$P(^DHCANOPArrange(opaId),"^",21)
	    .q:(PatDeptDr="")!((WardLocId'="")&(WardLocId'=PatDeptDr))
	    .s opaAnDr=$P(^DHCANOPArrange(opaId),"^",2)
	    .s admId="",ANASub=""
	   	.i opaAnDr'="" d
	   	..s admId=$P(opaAnDr,"||",1)
	   	..s ANASub=$P(opaAnDr,"||",2)
	   	.q:(admId="")!(ANASub="")
	   	.s admType=$P(^PAADM(admId),"^",2)
	    .s OpType=$P($g(^OR(admId,"ANA",ANASub)),"^",32)   			//OR_Anaesthesia->ANA_SourceType 急诊手术Emergency(E)
	    .i OpType="" d
	    ..s SourceType=$p($g(^DHCANARRAGE("ch",opaId)),"^",5)		//急诊手术,新字段中无值则取原保存位置
	    ..i SourceType=1  s anaSourceType="E"					
		..e  s anaSourceType="B"							
	    ..s $P(^OR(admId,"ANA",ANASub),"^",32)=anaSourceType
	    ..s OpType=anaSourceType
	   	.s opLevelDr=$P(^DHCANOPArrange(opaId),"^",28)				//OPA_OPLevel_Dr 手术规模
		.s opLevelCode=""
		.i opLevelDr'="" s opLevelCode=$P($g(^DHCANC("OPLevel",opLevelDr)),"^",1)  //DHC_ANC_OPLevel->ANCOPL_Code 手术规模代码
		.q:opLevelCode=""
		.s i=0
	   	.s ANAOPSub=0 f  s ANAOPSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub)) q:(ANAOPSub="")!(i=1)  d
	   	..s i=i+1
	   	..s ANAOPLocId=$p($g(^OR(admId,"ANA",ANASub,"OP",ANAOPSub)),"^",10) 	//OR_Anaest_Operation->ANAOP_CTLOC_DR 手术室 
	   	..q:ANAOPLocId=""
	   	..q:(OpLocId'="")&(OpLocId'=ANAOPLocId)
	   	..i admType="O" s ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,"O",OPAStatus)=+$g(^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,"O",OPAStatus))+1 q	//保存门诊手术
	   	..i OpType="E" s ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"E",OPAStatus)=+$g(^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"E",OPAStatus))+1 q	//保存急诊手术
	   	..s ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"I",OPAStatus)=+$g(^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"I",OPAStatus))+1	   				//保存普通手术
	}
	
	s TotalNum=0,count=0,TotalSP=0,TotalSPEM=0,TotalB=0,TotalBEM=0,TotalM=0,TotalMEM=0,TotalSM=0,TotalSMEM=0,TotalAll=0,TotalO=0,TotalZQ=0,TotalEM=0,TotalCancel=0,TotalEMCancel=0
	s OpLocDr=""  f  s OpLocDr=$O(^TMPAN("Stat",$j,OpLocDr)) q:OpLocDr=""  d
	.s opLoc=$P($G(^CTLOC(OpLocDr)),"^",2)
	.i $l(opLoc,"-")>1 s opLoc=$P(opLoc,"-",2)
	.s WardLocDr=""  f  s WardLocDr=$O(^TMPAN("Stat",$j,OpLocDr,WardLocDr)) q:WardLocDr=""  d
	..s TotalNum=TotalNum+1
	..s wardLoc=$P(^CTLOC(WardLocDr),"^",2)
	..i $l(wardLoc,"-")>1 s wardLoc=$P(wardLoc,"-",2)
	..s opSP=0,opSPEM=0,opB=0,opBEM=0,opM=0,opMEM=0,opSM=0,opSMEM=0,opAll=0,opAllEM=0,opAllOP=0,opTotal=0,opCancel=0,opEMCancel=0
	..s opSP=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","I","F"))
	..s opSPEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","E","F"))
	..s opB=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","I","F"))
	..s opBEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","E","F"))
	..s opM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","I","F"))
	..s opMEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","E","F"))
	..s opSM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","I","F"))
	..s opSMEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","E","F"))
	..s opAllOP=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"O","F"))
	..s opAll=opSP+opB+opM+opSM
	..s opAllEM=opSPEM+opBEM+opMEM+opSMEM
	..s opTotal=opAll+opAllEM+opAllOP
	..//ck 20110705
	..s opCancel=(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","I","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","I","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","I","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","I","D")))
	..s opEMCancel=(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","E","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","E","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","E","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","E","D")))
	..s TotalSP=TotalSP+opSP
	..s TotalSPEM=TotalSPEM+opSPEM
	..s TotalB=TotalB+opB
	..s TotalBEM=TotalBEM+opBEM
	..s TotalM=TotalM+opM
	..s TotalMEM=TotalMEM+opMEM
	..s TotalSM=TotalSM+opSM
	..s TotalSMEM=TotalSMEM+opSMEM
	..s TotalO=TotalO+opAllOP
	..s TotalZQ=TotalZQ+opAll
	..s TotalEM=TotalEM+opAllEM
	..s TotalCancel=TotalCancel+opCancel
	..s TotalEMCancel=TotalEMCancel+opEMCancel
	..s TotalAll=TotalAll+opTotal
	..s opSP=opSP_"/"_opSPEM,opB=opB_"/"_opBEM,opM=opM_"/"_opMEM,opSM=opSM_"/"_opSMEM,opCancel=opCancel_"/"_opEMCancel,TotalCancel=TotalCancel_"/"_TotalEMCancel,opAll=opAll_"/"_opAllEM
	..s TotalSP=TotalSP_"/"_TotalSPEM,TotalB=TotalB_"/"_TotalBEM,TotalM=TotalM_"/"_TotalMEM,TotalSM=TotalSM_"/"_TotalSMEM,TotalZQ=TotalZQ_"/"_TotalEM
	..do OutRow
	s wardLoc="合计",opSP=TotalSP,opB=TotalB,opM=TotalM,opSM=TotalSM,opAll=TotalZQ,opAllOP=TotalO,opTotal=TotalAll,opCancel=TotalCancel
	do OutRow
	//清除临时Global
	k ^TMPAN("Stat",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(wardLoc,opSP,opB,opM,opSM,opAll,opAllOP,opTotal,opLoc,opCancel)
	;set Data=$lb(wardLoc,opSP,opSPEM,opB,opBEM,opM,opMEM,opSM,opSMEM,opAll,opAllEM,opAllOP,opTotal,opLoc,opCancel,opEMCancel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpStatWardLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpStatWardLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpStatWardLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpStatWardLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}*/

/*Query GetAnOpStatWardLoc(StartDate As %String, EndDate As %String, WardLocId As %String, OpLocId As %String = "") As %Query(ROWSPEC = "wardLoc,opSP,opB,opM,opSM,opAll,opAllOP,opTotal,opLoc,opCancel")
{
}

ClassMethod GetAnOpStatWardLocExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, WardLocId As %String, OpLocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    k ^TMPAN("Stat",$j)
    if (StartDate="")!(EndDate="") s sdate=+$H,edate=+$H
	e  s sdate=StartDate,edate=EndDate
    f date=sdate:1:edate
    {  
		s opaId="" 
        f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
	    .q:$d(^DHCANOPArrange(opaId))<1
	    .s OPAStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.;q:OPAStatus'="F"   //手术申请状态非完成退出
	    .s PatDeptDr=$P(^DHCANOPArrange(opaId),"^",21)
	    .q:(PatDeptDr="")!((WardLocId'="")&(WardLocId'=PatDeptDr))
	    .s opaAnDr=$P(^DHCANOPArrange(opaId),"^",2)
	    .s admId="",ANASub=""
	   	.i opaAnDr'="" d
	   	..s admId=$P(opaAnDr,"||",1)
	   	..s ANASub=$P(opaAnDr,"||",2)
	   	.q:(admId="")!(ANASub="")
	   	.s admType=$P(^PAADM(admId),"^",2)
	    .s OpType=$P($g(^OR(admId,"ANA",ANASub)),"^",32)   			//OR_Anaesthesia->ANA_SourceType 急诊手术Emergency(E)
	    .i OpType="" d
	    ..s SourceType=$p($g(^DHCANARRAGE("ch",opaId)),"^",5)		//急诊手术,新字段中无值则取原保存位置
	    ..i SourceType=1  s anaSourceType="E"					
		..e  s anaSourceType="B"							
	    ..s $P(^OR(admId,"ANA",ANASub),"^",32)=anaSourceType
	    ..s OpType=anaSourceType
	   	.s opLevelDr=$P(^DHCANOPArrange(opaId),"^",28)				//OPA_OPLevel_Dr 手术规模
		.s opLevelCode=""
		.i opLevelDr'="" s opLevelCode=$P($g(^DHCANC("OPLevel",opLevelDr)),"^",1)  //DHC_ANC_OPLevel->ANCOPL_Code 手术规模代码
		.q:opLevelCode=""
		.s i=0
	   	.s ANAOPSub=0 f  s ANAOPSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub)) q:(ANAOPSub="")!(i=1)  d
	   	..s i=i+1
	   	..s ANAOPLocId=$p($g(^OR(admId,"ANA",ANASub,"OP",ANAOPSub)),"^",10) 	//OR_Anaest_Operation->ANAOP_CTLOC_DR 手术室 
	   	..q:ANAOPLocId=""
	   	..q:(OpLocId'="")&(OpLocId'=ANAOPLocId)
	   	..i admType="O" s ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,"O",OPAStatus)=+$g(^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,"O",OPAStatus))+1 q	//保存门诊手术
	   	..i OpType="E" s ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"E",OPAStatus)=+$g(^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"E",OPAStatus))+1 q	//保存急诊手术
	   	..s ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"I",OPAStatus)=+$g(^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"I",OPAStatus))+1	   				//保存普通手术
	}
	
	s TotalNum=0,count=0,TotalSP=0,TotalSPEM=0,TotalB=0,TotalBEM=0,TotalM=0,TotalMEM=0,TotalSM=0,TotalSMEM=0,TotalAll=0,TotalO=0,TotalZQ=0,TotalEM=0,TotalCancel=0,TotalEMCancel=0
	s OpLocDr=""  f  s OpLocDr=$O(^TMPAN("Stat",$j,OpLocDr)) q:OpLocDr=""  d
	.s opLoc=$P($G(^CTLOC(OpLocDr)),"^",2)
	.i $l(opLoc,"-")>1 s opLoc=$P(opLoc,"-",2)
	.s WardLocDr=""  f  s WardLocDr=$O(^TMPAN("Stat",$j,OpLocDr,WardLocDr)) q:WardLocDr=""  d
	..s TotalNum=TotalNum+1
	..s wardLoc=$P(^CTLOC(WardLocDr),"^",2)
	..i $l(wardLoc,"-")>1 s wardLoc=$P(wardLoc,"-",2)
	..s opSP=0,opSPEM=0,opB=0,opBEM=0,opM=0,opMEM=0,opSM=0,opSMEM=0,opAll=0,opAllEM=0,opAllOP=0,opTotal=0,opCancel=0,opEMCancel=0
	..s opSP=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","I","F"))
	..s opSPEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","E","F"))
	..s opB=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","I","F"))
	..s opBEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","E","F"))
	..s opM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","I","F"))
	..s opMEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","E","F"))
	..s opSM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","I","F"))
	..s opSMEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","E","F"))
	..s opAllOP=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"O","F"))
	..s opAll=opSP+opB+opM+opSM
	..s opAllEM=opSPEM+opBEM+opMEM+opSMEM
	..s opTotal=opAll+opAllEM+opAllOP
	..//ck 20110705
	..s opCancel=(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","I","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","I","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","I","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","I","D")))
	..s opEMCancel=(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","E","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","E","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","E","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","E","D")))
	..s TotalSP=TotalSP+opSP
	..s TotalSPEM=TotalSPEM+opSPEM
	..s TotalB=TotalB+opB
	..s TotalBEM=TotalBEM+opBEM
	..s TotalM=TotalM+opM
	..s TotalMEM=TotalMEM+opMEM
	..s TotalSM=TotalSM+opSM
	..s TotalSMEM=TotalSMEM+opSMEM
	..s TotalO=TotalO+opAllOP
	..s TotalZQ=TotalZQ+opAll
	..s TotalEM=TotalEM+opAllEM
	..s TotalCancel=TotalCancel+opCancel
	..s TotalEMCancel=TotalEMCancel+opEMCancel
	..s TotalAll=TotalAll+opTotal
	..s opSP=opSP_"/"_opSPEM,opB=opB_"/"_opBEM,opM=opM_"/"_opMEM,opSM=opSM_"/"_opSMEM,opCancel=opCancel_"/"_opEMCancel,TotalCancel=TotalCancel_"/"_TotalEMCancel,opAll=opAll_"/"_opAllEM
	..s TotalSP=TotalSP_"/"_TotalSPEM,TotalB=TotalB_"/"_TotalBEM,TotalM=TotalM_"/"_TotalMEM,TotalSM=TotalSM_"/"_TotalSMEM,TotalZQ=TotalZQ_"/"_TotalEM
	..do OutRow
	s wardLoc="合计",opSP=TotalSP,opB=TotalB,opM=TotalM,opSM=TotalSM,opAll=TotalZQ,opAllOP=TotalO,opTotal=TotalAll,opCancel=TotalCancel
	do OutRow
	//清除临时Global
	k ^TMPAN("Stat",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(wardLoc,opSP,opB,opM,opSM,opAll,opAllOP,opTotal,opLoc,opCancel)
	;set Data=$lb(wardLoc,opSP,opSPEM,opB,opBEM,opM,opMEM,opSM,opSMEM,opAll,opAllEM,opAllOP,opTotal,opLoc,opCancel,opEMCancel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpStatWardLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpStatWardLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpStatWardLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpStatWardLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}  */
/// Creator: wangxinlei
/// CreatDate: 2009-11-30
/// Description: 手术科室工作量统计
/// Table：DHC_AN_OPArrange,DHC_ANC_OPLevel,OR_Anaesthesia,PA_Adm
/// Input：StartDate:开始日期, EndDate:结束日期, WardLocId:手术科室, OpLocId:手术室
/// Return：返回手术科室工作量统计
/// 			手术科室:opLoc,I类普通:opSP,I类急诊:opSPEM,II类普通:opB,II类急诊:opBEM,III类普通:opM,III类急诊:opMEM,IV类普通:opSM,IV类急诊:opSME,普通合计:opAll,急诊合计:opAllEM,门诊手术:opAllOP,合计:opTotal,手术室:opLoc
Query GetAnOpStatWardLoc(StartDate As %String, EndDate As %String, WardLocId As %String, OpLocId As %String = "") As %Query(ROWSPEC = "wardLoc,opSP,opSPEM,opB,opBEM,opM,opMEM,opSM,opSMEM,opAll,opAllEM,opAllOP,opTotal,opCancel,opEMCancel,opLoc")
{
}

ClassMethod GetAnOpStatWardLocExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, WardLocId As %String, OpLocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    k ^TMPAN("Stat",$j)
    if (StartDate="")!(EndDate="") s sdate=+$H,edate=+$H
	e  s sdate=StartDate,edate=EndDate
    f date=sdate:1:edate
    {  
		s opaId="" 
        f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
	    .q:$d(^DHCANOPArrange(opaId))<1
	    .s OPAStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:OPAStatus'="F"   //手术申请状态非完成退出
	    .s PatDeptDr=$P(^DHCANOPArrange(opaId),"^",21)
	    .q:(PatDeptDr="")!((WardLocId'="")&(WardLocId'=PatDeptDr))
	    .s opaAnDr=$P(^DHCANOPArrange(opaId),"^",2)
	    .s admId="",ANASub=""
	   	.i opaAnDr'="" d
	   	..s admId=$P(opaAnDr,"||",1)
	   	..s ANASub=$P(opaAnDr,"||",2)
	   	.q:(admId="")!(ANASub="")
	   	.s admType=$P(^PAADM(admId),"^",2)
	    .s OpType=$P($g(^OR(admId,"ANA",ANASub)),"^",32)   			//OR_Anaesthesia->ANA_SourceType 急诊手术Emergency(E)
	    .i OpType="" d
	    ..s SourceType=$p($g(^DHCANARRAGE("ch",opaId)),"^",5)		//急诊手术,新字段中无值则取原保存位置
	    ..i SourceType=1  s anaSourceType="E"					
		..e  s anaSourceType="B"							
	    ..s $P(^OR(admId,"ANA",ANASub),"^",32)=anaSourceType
	    ..s OpType=anaSourceType
	   	.s opLevelDr=$P(^DHCANOPArrange(opaId),"^",28)				//OPA_OPLevel_Dr 手术规模
		.s opLevelCode=""
		.i opLevelDr'="" s opLevelCode=$P($g(^DHCANC("OPLevel",opLevelDr)),"^",1)  //DHC_ANC_OPLevel->ANCOPL_Code 手术规模代码
		.q:opLevelCode=""
		.s i=0
	   	.s ANAOPSub=0 f  s ANAOPSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub)) q:(ANAOPSub="")!(i=1)  d
	   	..s i=i+1
	   	..s ANAOPLocId=$p($g(^OR(admId,"ANA",ANASub,"OP",ANAOPSub)),"^",10) 	//OR_Anaest_Operation->ANAOP_CTLOC_DR 手术室 
	   	..q:ANAOPLocId=""
	   	..q:(OpLocId'="")&(OpLocId'=ANAOPLocId)
	   	..i admType="O" s ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,"O",OPAStatus)=+$g(^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,"O",OPAStatus))+1 q	//保存门诊手术
	   	..i OpType="E" s ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"E",OPAStatus)=+$g(^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"E",OPAStatus))+1 q	//保存急诊手术
	   	..s ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"I",OPAStatus)=+$g(^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"I",OPAStatus))+1	   				//保存普通手术
	}
	;b
	;w ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"E",OPAStatus)
	;w ^TMPAN("Stat",$j,ANAOPLocId,PatDeptDr,opLevelCode,"I",OPAStatus)
	s TotalNum=0,count=0,TotalSP=0,TotalSPEM=0,TotalB=0,TotalBEM=0,TotalM=0,TotalMEM=0,TotalSM=0,TotalSMEM=0,TotalAll=0,TotalO=0,TotalZQ=0,TotalEM=0,TotalCancel=0,TotalEMCancel=0
	s OpLocDr=""  f  s OpLocDr=$O(^TMPAN("Stat",$j,OpLocDr)) q:OpLocDr=""  d
	.s opLoc=$P($G(^CTLOC(OpLocDr)),"^",2)
	.i $l(opLoc,"-")>1 s opLoc=$P(opLoc,"-",2)
	.s WardLocDr=""  f  s WardLocDr=$O(^TMPAN("Stat",$j,OpLocDr,WardLocDr)) q:WardLocDr=""  d
	..s TotalNum=TotalNum+1
	..s wardLoc=$P(^CTLOC(WardLocDr),"^",2)
	..i $l(wardLoc,"-")>1 s wardLoc=$P(wardLoc,"-",2)
	..s opSP=0,opSPEM=0,opB=0,opBEM=0,opM=0,opMEM=0,opSM=0,opSMEM=0,opAll=0,opAllEM=0,opAllOP=0,opTotal=0,opCancel=0,opEMCancel=0
	..s opSP=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","I","F"))
	..s opSPEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","E","F"))
	..s opB=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","I","F"))
	..s opBEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","E","F"))
	..s opM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","I","F"))
	..s opMEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","E","F"))
	..s opSM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","I","F"))
	..s opSMEM=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","E","F"))
	..s opAllOP=+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"O","F"))
	..s opAll=opSP+opB+opM+opSM
	..s opAllEM=opSPEM+opBEM+opMEM+opSMEM
	..s opTotal=opAll+opAllEM+opAllOP
	..//ck 20110705
	..s opCancel=(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","I","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","I","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","I","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","I","D")))
	..s opEMCancel=(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SP","E","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"B","E","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"M","E","D")))+(+$g(^TMPAN("Stat",$j,OpLocDr,WardLocDr,"SM","E","D")))
	..s TotalSP=TotalSP+opSP
	..s TotalSPEM=TotalSPEM+opSPEM
	..s TotalB=TotalB+opB
	..s TotalBEM=TotalBEM+opBEM
	..s TotalM=TotalM+opM
	..s TotalMEM=TotalMEM+opMEM
	..s TotalSM=TotalSM+opSM
	..s TotalSMEM=TotalSMEM+opSMEM
	..s TotalO=TotalO+opAllOP
	..s TotalZQ=TotalZQ+opAll
	..s TotalEM=TotalEM+opAllEM
	..s TotalCancel=TotalCancel+opCancel
	..s TotalEMCancel=TotalEMCancel+opEMCancel
	..s TotalAll=TotalAll+opTotal
	..;s opSP=opSP_"/"_opSPEM,opB=opB_"/"_opBEM,opM=opM_"/"_opMEM,opSM=opSM_"/"_opSMEM,opCancel=opCancel_"/"_opEMCancel,TotalCancel=TotalCancel_"/"_TotalEMCancel,opAll=opAll_"/"_opAllEM
	..;s TotalSP=TotalSP_"/"_TotalSPEM,TotalB=TotalB_"/"_TotalBEM,TotalM=TotalM_"/"_TotalMEM,TotalSM=TotalSM_"/"_TotalSMEM,TotalZQ=TotalZQ_"/"_TotalEM
	..do OutRow
	s wardLoc="合计",opSP=TotalSP,opSPEM=TotalSPEM,opB=TotalB,opBEM=TotalBEM,opM=TotalM,opMEM=TotalMEM,opSM=TotalSM,opSMEM=TotalSMEM,opAll=TotalZQ,opAllEM=TotalEM,opAllOP=TotalO,opTotal=TotalAll,opCancel=TotalCancel
	do OutRow
	//清除临时Global
	k ^TMPAN("Stat",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(wardLoc,opSP,opSPEM,opB,opBEM,opM,opMEM,opSM,opSMEM,opAll,opAllEM,opAllOP,opTotal,opCancel,opEMCancel,opLoc)
	;set Data=$lb(wardLoc,opSP,opSPEM,opB,opBEM,opM,opMEM,opSM,opSMEM,opAll,opAllEM,opAllOP,opTotal,opLoc,opCancel,opEMCancel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpStatWardLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpStatWardLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpStatWardLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpStatWardLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-11-30
/// Description: 取科室医护人员
/// Table：CT_Loc, RB_Resource
/// Input：ctcptdes:医护人员描述
/// Return：返回所选科室的医护人员
/// 			用户名:username,用户ID:rowid
Query CtCpt(ctcptdes As %String, ctloc As %String = "", opLocId As %String = "") As %Query(ROWSPEC = "username,rowid")
{
}

ClassMethod CtCptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CtCptExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod CtCptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CtCptExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CtCptExecute(ByRef qHandle As %Binary, ctcptdes As %String, ctloc As %String = "", opLocId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	i (ctloc="")&(opLocId="") s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
 	If $g(ind)="" Set ind=1
 	i ctloc'="" s locId=ctloc
 	i opLocId'="" s locId=opLocId
 	s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",locId,rw))  q:rw=""  d
 	.s rowid=$P(^RB("RES",rw),"^",2)
 	.q:rowid=""
 	.s username=$p(^CTPCP(rowid,1),"^",2)
 	.q:(username'[ctcptdes)&(ctcptdes'="")
 	.Do Outputcpt	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK

Outputcpt
	set Data=$lb(username,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Creator: YuPeiZhi
/// CreatDate: 2010-03-20
/// Description: 麻醉科室工作量统计(含麻醉方法,分择期麻醉和急诊麻醉)
/// Table：DHC_AN_OPArrange,DHC_ANC_OPLevel,OR_Anaesthesia,OR_Anaest_Operation,OR_An_Oper_Anaest_Assista
/// Input：StartDate:开始日期, EndDate:结束日期, AnLoc:麻醉科室, WardDoc:麻醉医生
/// Return：返回麻醉科室工作量统计
/// 			麻醉科室:anLoc,麻醉医生:anLoc,特大手术:anLocSP,大手术:anLocB,中手术:anLocM,小手术:anLocSM,合计:anLocAll
Query GetAnOpStatAnLoc(StartDate As %String, EndDate As %String, AnLocId As %String, AnDocId As %String) As %Query(ROWSPEC = "anLoc,anLocItem,bookAnLocSP,bookAnLocB,bookAnLocM,bookAnLocSM,anDocAll,emergAnLocSP,emergAnLocB,emergAnLocM,emergAnLocSM,anLocAll,anNurSP,anNurB,anNurM,anNurSM,anNurAll")
{
}

ClassMethod GetAnOpStatAnLocExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, AnLocId As %String, AnDocId As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnOpStatAnLoc",60000,+$h,"","")
 	Set repid=$I(^CacheTemp)
 	s ind=1
    k ^TMPAN("Stat",$j)
    i (StartDate="")!(EndDate="") s sdate=+$H,edate=+$H
	e  s sdate=StartDate,edate=EndDate
	i AnLocId'="" s anLoc=$P($g(^CTLOC(AnLocId)),"^",2)
	e  s anLoc=""
	
	//s ^DHCANC("PA",89,"C")=全身麻醉^椎管内麻醉^神经阻滞麻醉^镇静麻醉^局部麻醉
	/*i $p($g(^DHCANC("PA",89)),"^")="Y" d
		.q:$p($g(^DHCANC("PA",89)),"^",2)=""
		.s opaPaAnaestTypeStr=$g(^DHCANC("PA",89,$p(^DHCANC("PA",89),"^",2)))
		.q:opaPaAnaestTypeStr=""
		.
		.s opaPaAnaestTypeCount=$l(opaPaAnaestTypeStr,"^")
		.f i=1:1:$l(opaPaAnaestTypeStr,"^") d
			..s opaPaAnaestType=$p(opaPaAnaestTypeStr,"^",i)
			..q:opaPaAnaestType=""
			..s opaPaAnaestTypeList(i)=opaPaAnaestType
	*/
	k anmetList
	s anmetId=0
	f  s anmetId=$o(^ORC("ANMET",anmetId)) q:anmetId=""  d
		.q:$p(^ORC("ANMET",anmetId),"^",1)=""
		.q:$p(^ORC("ANMET",anmetId),"^",2)["+" //过滤JST
	    .s Dateto=$p(^ORC("ANMET",anmetId),"^",6)
	    .q:(Dateto'="")&(Dateto<=+$h)
		.s anmetList($p(^ORC("ANMET",anmetId),"^",1))=$p(^ORC("ANMET",anmetId),"^",2)
	
	s ancefId=0
	k ancefList
	f  s ancefId=$o(^DHCANC("ANEffect",ancefId)) q:ancefId=""  d
		.s ancefList(ancefId)=$p(^DHCANC("ANEffect",ancefId),"^",2)

    f date=sdate:1:edate
    {  
		s opaId="" 
        f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
	    .q:$d(^DHCANOPArrange(opaId))<1
	    .s OPAStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.;q:OPAStatus'="F"   //手术申请状态非完成退出
	    .s opaAnDr=$P(^DHCANOPArrange(opaId),"^",2)
	    .s admId="",ANASub=""
	   	.i opaAnDr'="" d
	   	..s admId=$P(opaAnDr,"||",1)
	   	..s ANASub=$P(opaAnDr,"||",2)
	   	.q:(admId="")!(ANASub="")
	   	.s opLevelDr=$P(^DHCANOPArrange(opaId),"^",28) 		//OPA_OPLevel_Dr 手术规模
		.s opLevelCode=""
		.i opLevelDr'="" s opLevelCode=$P($g(^DHCANC("OPLevel",opLevelDr)),"^",1)  //DHC_ANC_OPLevel->ANCOPL_Code 手术规模代码
		.q:opLevelCode=""
		.
		.
		.s anmetIdStr=$P(^OR(admId,"ANA",ANASub),"^",5)
		.q:anmetIdStr=""
		.
		.f j=1:1:$l(anmetIdStr,"|") d
			..s anmetId=$p(anmetIdStr,"|",j)
			..q:anmetId=""
			..s anmetCode=$p(^ORC("ANMET",anmetId),"^",1)
			..q:anmetCode=""
			..q:$g(anmetList(anmetCode))=""
	        ..s Dateto=$p(^ORC("ANMET",anmetId),"^",6)
	        ..q:(Dateto'="")&(Dateto<=+$h)
			..//w anmetIdStr_"/"_anmetId_"/"_anmetCode,!
			..s anaSourceType=$P(^OR(admId,"ANA",ANASub),"^",32)
			..i anaSourceType="" s anaSourceType="B"
			..//w anaSourceType_anmetList(anmetId),!
			..//w "level:"_opaId_"/"_opLevelDr,!
			..s ^TMPAN("Stat",$j,anaSourceType_anmetCode,"AnLoc",opLevelCode)=$g(^TMPAN("Stat",$j,anaSourceType_anmetCode,"AnLoc",opLevelCode))+1
			..
			..s ancefId=$p($g(^DHCANOPArrange(opaId)),"^",12)
			..//w opaId_"/"_ancefId,!
			..//^DHCANC("ANEffect",ancefId)
			..s ^TMPAN("Stat",$j,anaSourceType_ancefId,"ANEffect",opLevelCode)=$g(^TMPAN("Stat",$j,anaSourceType_ancefId,"AnSatis",opLevelCode))+1
		.q
		./////////////////
	   	.s AnDocDr=$P(^OR(admId,"ANA",ANASub),"^",6)        //ANA_Anaesthetist_Dr 麻醉医师
	   	.i AnDocDr'="" d
	   	..q:(AnDocId'="")&(AnDocId'=AnDocDr)
	   	..s ^TMPAN("Stat",$j,AnDocDr,"BookAnLoc",opLevelCode)=+$g(^TMPAN("Stat",$j,AnDocDr,"BookAnLoc",opLevelCode))+1  //保存麻醉医师
	   	.;s AnsupervisId=$P(^OR(admId,"ANA",ANASub),"^",7)        //ANA_Anaesthetist_Dr 麻醉指导医师
	   	.;i AnsupervisId'="" d  
	   	..;q:(AnDocId'="")&(AnDocId'=AnsupervisId)
	   	..;s ^TMPAN("Stat",$j,AnDocDr,"Ansupervisor",opLevelCode)=+$g(^TMPAN("Stat",$j,AnsupervisId,"AnLoc",opLevelCode))+1  //保存麻醉指导医师
	   	.s AnNurDr=$P(^OR(admId,"ANA",ANASub),"^",8)		//ANA_ORAnaNurse_DR   麻醉护士
	   	.i AnNurDr'="" d
	   	..q:(AnDocId'="")&(AnDocId'=AnNurDr)
	   	..s ^TMPAN("Stat",$j,AnNurDr,"AnNur",opLevelCode)=+$g(^TMPAN("Stat",$j,AnNurDr,"AnNur",opLevelCode))+1  //保存麻醉护士	   	
	   	.s i=0
	   	.s ANAOPSub=0 f  s ANAOPSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub)) q:(ANAOPSub="")!(i=1)  d
	   	..s i=i+1
	   	..s ANASSSub=0 f  s ANASSSub=$O(^OR(admId,"ANA",ANASub,"OP",ANAOPSub,"ANASS",ANASSSub)) q:(ANASSSub="")  d
	   	...q:ANASSSub>20		//小于20为麻醉助手或其它麻醉医师,大于20为交麻醉医师
	   	...s AssAnDocDr=$P($g(^OR(admId,"ANA",ANASub,"OP",ANAOPSub,"ANASS",ANASSSub)),"^",1)  //OR_An_Oper_Anaest_Assista 麻醉助手或其它麻醉医师
	   	...i AssAnDocDr'="" d
	   	....q:(AnDocId'="")&(AnDocId'=AssAnDocDr)
		....s ^TMPAN("Stat",$j,AssAnDocDr,"EmergAnLoc",opLevelCode)=+$g(^TMPAN("Stat",$j,AssAnDocDr,"EmergAnLoc",opLevelCode))+1  //保存麻醉助手或其它麻醉医师	   	
	}
	
	s anmetCode=""
	f  s anmetCode=$o(^ORC("ANMET",0,"Code",anmetCode)) q:anmetCode=""  d
	    .s anmetId=$o(^ORC("ANMET",0,"Code",anmetCode,""))
	    .q:anmetId=""
	    .q:'$d(^ORC("ANMET",anmetId))
	    .q:$p(^ORC("ANMET",anmetId),"^",2)["+" //过滤JST
	    .s Dateto=$p(^ORC("ANMET",anmetId),"^",6)
	    .q:(Dateto'="")&(Dateto<=+$h)
	    .s anLocItem=$p(^ORC("ANMET",anmetId),"^",2)
	    .s bookAnLocSP=0,bookAnLocB=0,bookAnLocM=0,bookAnLocSM=0,anDocAll=0,emergAnLocSP=0,emergAnLocB=0,emergAnLocM=0,emergAnLocSM=0,anLocAll=0,anNurSP=0,anNurB=0,anNurM=0,anNurSM=0,anNurAll=0
	    .s bookAnLocSP=+$g(^TMPAN("Stat",$j,"B"_anmetId,"AnLoc","SP"))
	    .s bookAnLocB=+$g(^TMPAN("Stat",$j,"B"_anmetId,"AnLoc","B"))
	    .s bookAnLocM=+$g(^TMPAN("Stat",$j,"B"_anmetId,"AnLoc","M"))
	    .s bookAnLocSM=+$g(^TMPAN("Stat",$j,"B"_anmetId,"AnLoc","SM"))
	    .s emergAnLocSP=+$g(^TMPAN("Stat",$j,"E"_anmetId,"AnLoc","SP"))
	    .s emergAnLocB=+$g(^TMPAN("Stat",$j,"E"_anmetId,"AnLoc","B"))
	    .s emergAnLocM=+$g(^TMPAN("Stat",$j,"E"_anmetId,"AnLoc","M"))
	    .s emergAnLocSM=+$g(^TMPAN("Stat",$j,"E"_anmetId,"AnLoc","SM"))
	    .
	    .//s ^TMPAN("Stat",$j,anaSourceType_"|"_anmetList(i),"AnLoc",opLevelCode)
	    .
	    .
	    .s anNurSP="" //+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","SP"))
	    .s anNurB="" //+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","B"))
	    .s anNurM="" //+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","M"))
	    .s anNurSM="" //+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","SM"))	
	    .s anDocAll="" //bookAnLocSP+bookAnLocB+bookAnLocM+bookAnLocSM
	    .s anLocAll=bookAnLocSP+bookAnLocB+bookAnLocM+bookAnLocSM+emergAnLocSP+emergAnLocB+emergAnLocM+emergAnLocSM
	    .s anNurAll=anNurSP+anNurB+anNurM+anNurSM
	    .do OutRow
	//清除临时Global
	/*s ancefId=""
	f  s ancefId=$o(ancefList(ancefId)) q:ancefId=""  d
	    .s bookAnLocSP=0,bookAnLocB=0,bookAnLocM=0,bookAnLocSM=0,anDocAll=0,emergAnLocSP=0,emergAnLocB=0,emergAnLocM=0,emergAnLocSM=0,anLocAll=0,anNurSP=0,anNurB=0,anNurM=0,anNurSM=0,anNurAll=0
	    .s anLocItem=ancefList(ancefId)
	    .s bookAnLocSP=+$g(^TMPAN("Stat",$j,"B"_ancefId,"ANEffect","SP"))
	    .s bookAnLocB=+$g(^TMPAN("Stat",$j,"B"_ancefId,"ANEffect","B"))
	    .s bookAnLocM=+$g(^TMPAN("Stat",$j,"B"_ancefId,"ANEffect","M"))
	    .s bookAnLocSM=+$g(^TMPAN("Stat",$j,"B"_ancefId,"ANEffect","SM"))
	    .s emergAnLocSP=+$g(^TMPAN("Stat",$j,"E"_ancefId,"ANEffect","SP"))
	    .s emergAnLocB=+$g(^TMPAN("Stat",$j,"E"_ancefId,"ANEffect","B"))
	    .s emergAnLocM=+$g(^TMPAN("Stat",$j,"E"_ancefId,"ANEffect","M"))
	    .s emergAnLocSM=+$g(^TMPAN("Stat",$j,"E"_ancefId,"ANEffect","SM"))
	    .
	    .s anNurSP="" //+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","SP"))
	    .s anNurB="" //+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","B"))
	    .s anNurM="" //+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","M"))
	    .s anNurSM="" //+$g(^TMPAN("Stat",$j,AnDocDr,"AnNur","SM"))	
	    .s anDocAll="" //bookAnLocSP+bookAnLocB+bookAnLocM+bookAnLocSM
	    .s anLocAll=bookAnLocSP+bookAnLocB+bookAnLocM+bookAnLocSM+emergAnLocSP+emergAnLocB+emergAnLocM+emergAnLocSM
	    .s anNurAll=anNurSP+anNurB+anNurM+anNurSM
	    .do OutRow*/
	
	k ^TMPAN("Stat",$j)
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$lb(anLoc,anLocItem,bookAnLocSP,bookAnLocB,bookAnLocM,bookAnLocSM,anDocAll,emergAnLocSP,emergAnLocB,emergAnLocM,emergAnLocSM,anLocAll,anNurSP,anNurB,anNurM,anNurSM,anNurAll)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpStatAnLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpStatAnLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpStatAnLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpStatAnLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 手术室工作效率记录表
/// w ##class(web.DHCANOPStatistics).GetAnOpEfficiencyRecord("")
ClassMethod GetAnOpEfficiencyRecord(sdate As %String)
{
    i sdate="" s sdate=+$h
    e  s sdate=$zdh(sdate,4)
    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",sdate,opaId)) q:opaId=""  d 
	.q:$d(^DHCANOPArrange(opaId))<1
	.s patLocId="",patLocDesc="",bedNo="",patName="",roomId="",roomDesc="",ordno="",inAreaTime="",inRoomTime="",anaStartTime="",opaStartTime="",opaEndTime="",anaEndTime="",leaveRoomTime=""
	.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	.q:EpisodeID=""
	.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
	.s anaSub=$p(anaId,"||",2)
	.q:anaSub=""
	.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
	.q:(opaStatus="A")!(opaStatus="")!(opaStatus="D")!(opaStatus="N")
	.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
	.i roomId'="" s roomDesc=$p($g(^DHCANC("OPRoom",roomId)),"^",2)_"间"
	.s ordno=$P(^DHCANOPArrange(opaId),"^",26)
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
    .s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
    .i (bedSub'="")&(curWardId'="") s bedNo=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    .s patLocId=$P(^PAADM(EpisodeID),"^",4)
    .s patLocDesc=$P(^CTLOC(patLocId),"^",2)
    .i $l(patLocDesc,"-")>1 s patLocDesc=$p(patLocDesc,"-",2)
    .s inAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
    .i inAreaTime'="" s inAreaTime=$zt(inAreaTime)
    .s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
    .i inRoomTime'="" s inRoomTime=$zt(inRoomTime)
    .s anaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",3)
    .i anaStartTime'="" s anaStartTime=$zt(anaStartTime)
    .s opaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",19)
    .i opaStartTime'="" s opaStartTime=$zt(opaStartTime)
    .s opaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",20)
    .i opaEndTime'="" s opaEndTime=$zt(opaEndTime)
    .s anaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",4)
    .i anaEndTime'="" s anaEndTime=$zt(anaEndTime)
    .s leaveRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
    .i leaveRoomTime'="" s leaveRoomTime=$zt(leaveRoomTime)
	.;s ^TMPAN("Stat",$j,opaId)=patLocDesc_"^"_bedNo_"^"_patNam_"^"_roomDesc_"^"_ordno_"^"_inAreaTime_"^"_inRoomTime_"^"_anaStartTime_"^"_opaStartTime_"^"_opaEndTime_"^"_anaEndTime_"^"_leaveRoomTime
	.s str=""
	.s str=patLocDesc_"^"_bedNo_"^"_patName_"^"_roomDesc_"^"_ordno_"^"_inAreaTime_"^"_inRoomTime_"^"_anaStartTime_"^"_opaStartTime_"^"_opaEndTime_"^"_anaEndTime_"^"_leaveRoomTime
	.s retval="GetAnOpRecord"_"('"_$ZCVT(str,"O","JS")_"');"
	.&javascript<#(retval)#>
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnOpEfficiencyRecord","62294","311")
/// 手术室工作效率 统计
Query GetAnOpEfficiencyRecord(sdate As %Library.String, ctlocId As %String) As %Query(ROWSPEC = "patLocDesc,bedNo,patName,roomDesc,ordno,inAreaTime,inRoomTime,anaStartTime,opaStartTime,opaEndTime,anaEndTime,leaveRoomTime,roomId,patLocId,sdate,opdocStr,tsdate,andocStr,jzstat,Status,retReason")
{
}

ClassMethod GetAnOpEfficiencyRecordExecute(ByRef qHandle As %Binary, sdate As %Library.String, ctlocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TMPAN("Stat",$j)
 	s ^ab(1)=sdate_"^"_ctlocId
 	i sdate="" s sdate=+$h
    ;e  s sdate=##class(web.DHCANOPCom).ConvertToDate(sdate)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    s ^ab(2)=sdate_"^"_ctlocId
    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",sdate,opaId)) q:opaId=""  d 
	.q:$d(^DHCANOPArrange(opaId))<1
	.s patLocId="",patLocDesc="",bedNo="",patName="",roomId="",roomDesc="",ordno="",inAreaTime="",inRoomTime="",anaStartTime="",opaStartTime="",opaEndTime="",anaEndTime="",leaveRoomTime="",opdocStr="",ash="",andocStr="",jzstat="",Status="",retReason=""
	.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	.q:EpisodeID=""
	.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
	.s anaSub=$p(anaId,"||",2)
	.q:anaSub=""
	.s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
	.q:opLocId'=ctlocId
	.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
	.q:(opaStatus="A")!(opaStatus="")!(opaStatus="D")!(opaStatus="N")
	.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
	.q:roomId=""
	.i roomId'="" s roomDesc=$p($g(^DHCANC("OPRoom",roomId)),"^",2)
	.s ordno=$P(^DHCANOPArrange(opaId),"^",26)
	.q:ordno=""
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
    .s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
    .i (bedSub'="")&(curWardId'="") s bedNo=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    .s patLocId=$P(^PAADM(EpisodeID),"^",4)
    .q:patLocId=""
    .s patLocDesc=$P(^CTLOC(patLocId),"^",2)
    .i $l(patLocDesc,"-")>1 s patLocDesc=$p(patLocDesc,"-",2)
    .s inAreaTime=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",8)
    .i inAreaTime'="" s inAreaTime=$zt(inAreaTime)
    .s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
    .i inRoomTime'="" s inRoomTime=$zt(inRoomTime)
    .s anaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",3)
    .i anaStartTime'="" s anaStartTime=$zt(anaStartTime)
    .s opaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",19)
    .i opaStartTime'="" s opaStartTime=$zt(opaStartTime)
    .s opaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",20)
    .i opaEndTime'="" s opaEndTime=$zt(opaEndTime)
    .s anaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",4)
    .i anaEndTime'="" s anaEndTime=$zt(anaEndTime)
    .s leaveRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
    .i leaveRoomTime'="" s leaveRoomTime=$zt(leaveRoomTime)
    
    .s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42)
    .s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d 
	..s sub=subchl
	..s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",8)
	..i +docdr=docdr s opd=##class(web.DHCANOPCom).GetNameById(docdr)
	..e  s opd=$TR($p(opaDocNote,"|",2)," ","")
	..;s ^abc(opaId,1)=opd_"^"_docdr
	.q:sub=""
	.s list=0,asName=""
	.s assDocNum=3
	.s p=0
	.s len=$l(opaDocNote,"|")
	.s as=0 f  s as=$O(^OR(EpisodeID,"ANA",anaSub,"OP",sub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
	..s asdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",sub,"ASS",as),"^",1)
	..q:asdr=""
	..s p=p+1
	..i asName="" s asName=##class(web.DHCANOPCom).GetNameById(asdr)
	..e  s asName=asName_"^"_##class(web.DHCANOPCom).GetNameById(asdr)
	
	.s mzdoc="",mzsupdoc="",anDocAss="",anNurse=""
	.s mzdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)
	.i mzdr'="" s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)
	.s mzsupdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",7)
	.i mzsupdr'="" s mzsupdoc=##class(web.DHCANOPCom).GetNameById(mzsupdr)
	.s ass=0
	.f  s ass=$o(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass)) q:ass=""  d
	..s mzzsdr=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass)),"^",1)
	..q:mzzsdr=""
	..i anDocAss="" s anDocAss=##class(web.DHCANOPCom).GetNameById(mzzsdr)
	..e  s anDocAss=anDocAss_" "_##class(web.DHCANOPCom).GetNameById(mzzsdr)
	.s mzNurseId=$P(^OR(EpisodeID,"ANA",anaSub),"^",8) 
	.i mzNurseId'="" s anNurse=##class(web.DHCANOPCom).GetNameById(mzNurseId)
	.s andocStr=mzsupdoc_" "_mzdoc_" "_anDocAss_" "_anNurse
	
	.i len>assDocNum+2 s len=assDocNum+2
	.f getLen=3:1:len  d
	..i $p(opaDocNote,"|",getLen)'=""  d
	...s getName=$p(opaDocNote,"|",getLen)
	..e  d
	...s list=list+1
	...s getName=$p(asName,"^",list)
	..i ash="" s ash=getName
	..e  s ash=ash_" "_getName
	..;s ^abc(opaId,2)=ash
	.s opdocStr=opd_","_$G(ash)
	.s tsdate=$zd(sdate,3)
	
	.s jz=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
	.i jz="E" s jzstat="急诊"
	.e  s jzstat="择期"
	
	.s Stat=$P(^DHCANOPArrange(opaId),"^",27)
	.i Stat="A" s Status="申请"
	.i Stat="D" s Status="取消"
	.i Stat="R" s Status="安排"
	.i Stat="N" s Status="非预约"
	.i Stat="I" s Status="术中"
	.i Stat="P" s Status="恢复室"
	.i Stat="L" s Status="术毕"
	.i Stat="F" s Status="完成"
	
	.s retReasonId=$P($G(^DHCANOPArrange(opaId)),"^",35)
	.i (retReasonId'="")&(Stat="D") s retReason=$p($g(^ORC("SUSP",retReasonId)),"^",2)
	
	.;s ^TMPAN("Stat",$j,patLocId,roomId,ordno)=patLocDesc_"^"_bedNo_"^"_patName_"^"_roomDesc_"^"_ordno_"^"_inAreaTime_"^"_inRoomTime_"^"_anaStartTime_"^"_opaStartTime_"^"_opaEndTime_"^"_anaEndTime_"^"_leaveRoomTime_"^"_roomId_"^"_patLocId
	.s ^TMPAN("Stat",$j,roomId,ordno,patLocId)=$lb(patLocDesc,bedNo,patName,roomDesc,ordno,inAreaTime,inRoomTime,anaStartTime,opaStartTime,opaEndTime,anaEndTime,leaveRoomTime,roomId,patLocId,sdate,opdocStr,tsdate,andocStr,jzstat,Status,retReason)

	s roomDr="" f  s roomDr=$o(^TMPAN("Stat",$j,roomDr)) q:roomDr=""  d
	.s ord="" f  s ord=$o(^TMPAN("Stat",$j,roomDr,ord)) q:ord=""  d
	..s locId="" f  s locId=$o(^TMPAN("Stat",$j,roomDr,ord,locId)) q:locId=""  d
	...do OutRowRecord
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowRecord
 	Set ^CacheTemp(repid,ind)=^TMPAN("Stat",$j,roomDr,ord,locId)
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpEfficiencyRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpEfficiencyRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpEfficiencyRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpEfficiencyRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnOpOrdno","62294","62294","311")
/// 手术台次统计 人次  按接收科室手术台次
Query GetAnOpOrdno(stratdate As %Library.String, enddate As %Library.String, ctlocId As %String) As %Query(ROWSPEC = "patLocId,patLocDesc,sumSPB,sumSPE,sumBB,sumBE,sumMB,sumME,sumSMB,sumSME,allB,allE,sumDB,sumDE")
{
}

ClassMethod GetAnOpOrdnoExecute(ByRef qHandle As %Binary, stratdate As %Library.String, enddate As %Library.String, ctlocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=stratdate,edate=enddate
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.//SP B  M  SM  // E  B 
		.s sumSPB=0,sumSPE=0,sumBB=0,sumBE=0,sumMB=0,sumME=0,sumSMB=0,sumSME=0,sumDB=0,sumDE=0,allB=0,allE=0
		.s patLocId="",patLocDesc="",opLevelCode=""
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.q:opLocId'=ctlocId
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
    	.;s PatDeptDr=$P(^DHCANOPArrange(opaId),"^",21)  //病人科室
		.s patLocDesc=$P(^CTLOC(patLocId),"^",2)
		.i $l(patLocDesc,"-")>1 s patLocDesc=$p(patLocDesc,"-",2)
		.s jz=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)
		.;"E="急诊" B="择期"
		.s opLevelDr=$P(^DHCANOPArrange(opaId),"^",28)
		.i opLevelDr'="" s opLevelCode=$P($g(^DHCANC("OPLevel",opLevelDr)),"^",1)  //DHC_ANC_OPLevel->ANCOPL_Code 手术规模代码
		.q:opLevelCode=""
		
		.s oeordRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
		.s childOEORDRowId="" f  s childOEORDRowId=$O(^OEORD(oeordRowId,"I",childOEORDRowId)) q:childOEORDRowId=""  d
		..s anaDr=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,4)),"^",9)
		..q:anaDr'=anaId
		..s oeordItemStat=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",13)
		..q:oeordItemStat=4
		..s relocId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,3)),"^",6)   //执行科室
		..q:relocId'=ctlocId
		..s applocId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,7)),"^",2)   //接收科室
		..q:applocId=""
		..s arcItmRowId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",2)  //医嘱RowId
		..s exOeoriDr=oeordRowId_"||"_childOEORDRowId
		..s exRowId=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr,-1))
		..q:exRowId=""
		..s priceStatus=$p($g(^DHCEXDE(exRowId)),"^",17)
		..q:priceStatus'="1"   //不是已收费状态的除外
		..i opaStatus="F" d
		...i (opLevelCode="SP")&(jz="B") s sumSPB=sumSPB+1
		...i (opLevelCode="SP")&(jz="E") s sumSPE=sumSPE+1
		...i (opLevelCode="B")&(jz="B") s sumBB=sumBB+1
		...i (opLevelCode="B")&(jz="E") s sumBE=sumBE+1
		...i (opLevelCode="M")&(jz="B") s sumMB=sumMB+1
		...i (opLevelCode="M")&(jz="E") s sumME=sumME+1
		...i (opLevelCode="SM")&(jz="B") s sumSMB=sumSMB+1
		...i (opLevelCode="SM")&(jz="E") s sumSME=sumSME+1
		.s allB=sumSPB+sumBB+sumMB+sumSMB
		.s allE=sumSPE+sumBE+sumME+sumSME
		.i opaStatus="D" d
		..i jz="B" s sumDB=sumDB+1
		..i jz="E" s sumDE=sumDE+1
		.s ^TMPAN("Stat",$j,patLocId)=$lb(patLocId,patLocDesc,sumSPB,sumSPE,sumBB,sumBE,sumMB,sumME,sumSMB,sumSME,allB,allE,sumDB,sumDE)
		.do OutRowOrdno
    }
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowOrdno
 	Set ^CacheTemp(repid,ind)=^TMPAN("Stat",$j,patLocId)
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpOrdnoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpOrdnoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpOrdnoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpOrdnoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetAnOpOrdno1(stratdate As %Library.String, enddate As %Library.String, ctlocId As %String, delaytime As %String = "")
{
	;n (stratdate,enddate,ctlocId)
	s ^abcd(1)=stratdate_"*"_enddate_"*"_ctlocId
 	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  d
	.s sdate=##Class(web.DHCCLCom).ConvertToDateH(stratdate)
	.s edate=##Class(web.DHCCLCom).ConvertToDateH(enddate)
	i delaytime="" s delaytime="09:05"
	s delaytime=##Class(web.DHCCLCom).ConvertToTimeH(delaytime)
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.//SP B  M  SM  // E  B 
		.;s sumSPB=0,sumSPE=0,sumBB=0,sumBE=0,sumMB=0,sumME=0,sumSMB=0,sumSME=0,sumD=0,sumB=0,sumE=0
		.s patLocId="",patLocDesc="",opLevelCode=""
		.s delayOrder=0,firstOrder=0
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")&(opaStatus'="L")&(opaStatus'="R")&(opaStatus'="I")
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.q:opLocId'=ctlocId
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
		.s jz=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)  ;"E="急诊" B="择期"
		.s opLevelDr=$P(^DHCANOPArrange(opaId),"^",28)
		.i opLevelDr="" s opLevelDr="2"
		.i opLevelDr'="" s opLevelCode=$P($g(^DHCANC("OPLevel",opLevelDr)),"^",1)  //DHC_ANC_OPLevel->ANCOPL_Code 手术规模代码
		.q:opLevelCode=""
		.s ordno=$P(^DHCANOPArrange(opaId),"^",26)
		.i ordno=1 s firstOrder=1
		.s opaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",19)
		.i (opaStartTime'="")&(opaStartTime>delaytime)&(ordno=1) s delayOrder=1
    	.i opaStartTime'="" s opaStartTime=$zt(opaStartTime)
		
		.s ^TMPAN("Stat",$j,patLocId,opaId)=opLevelCode_"^"_jz_"^"_opaStatus_"^"_firstOrder_"^"_delayOrder
		.;s ^TMPAN("Stat",$j,patLocId,opaId)=patLocId_"^"_patLocDesc_"^"_sumSPB_"^"_sumSPE_"^"_sumBB_"^"_sumBE_"^"_sumMB_"^"_sumME_"^"_sumSMB_"^"_sumSME_"^"_sumB_"^"_sumE_"^"_sumD
    }
    
    s retStr=""
    s allSPB=0,allSPE=0,allBB=0,allBE=0,allMB=0,allME=0,allSMB=0,allSME=0,allD=0,allB=0,allE=0
    s allFirstOrder=0,allDelayOrder=0
    s ctlocdr="" f  s ctlocdr=$o(^TMPAN("Stat",$j,ctlocdr)) q:ctlocdr=""  d
    .s sumSPB=0,sumSPE=0,sumBB=0,sumBE=0,sumMB=0,sumME=0,sumSMB=0,sumSME=0,sumD=0,sumB=0,sumE=0
    .s sumFirstOrder=0,sumDelayOrder=0
    .s opadr="" f  s opadr=$o(^TMPAN("Stat",$j,ctlocdr,opadr)) q:opadr=""  d
    ..s opLevelCode=$p(^TMPAN("Stat",$j,ctlocdr,opadr),"^",1)
    ..s jz=$p(^TMPAN("Stat",$j,ctlocdr,opadr),"^",2)
    ..s stat=$p(^TMPAN("Stat",$j,ctlocdr,opadr),"^",3)
    ..s firstOrd=$p(^TMPAN("Stat",$j,ctlocdr,opadr),"^",4)
    ..s delayOrd=$p(^TMPAN("Stat",$j,ctlocdr,opadr),"^",5)
    ..i ((stat="F")!(stat="L")!(stat="P")) d
	...i (opLevelCode="SP")&(jz="B") s sumSPB=sumSPB+1,allSPB=allSPB+1,allB=allB+1
	...i (opLevelCode="SP")&(jz="E") s sumSPE=sumSPE+1,allSPE=allSPE+1,allE=allE+1
	...i (opLevelCode="B")&(jz="B") s sumBB=sumBB+1,allBB=allBB+1,allB=allB+1
	...i (opLevelCode="B")&(jz="E") s sumBE=sumBE+1,allBE=allBE+1,allE=allE+1
	...i (opLevelCode="M")&(jz="B") s sumMB=sumMB+1,allMB=allMB+1,allB=allB+1
	...i (opLevelCode="M")&(jz="E") s sumME=sumME+1,allME=allME+1,allE=allE+1
	...i (opLevelCode="SM")&(jz="B") s sumSMB=sumSMB+1,allSMB=allSMB+1,allB=allB+1
	...i (opLevelCode="SM")&(jz="E") s sumSME=sumSME+1,allSME=allSME+1,allE=allE+1
	...s sumB=sumSPB+sumBB+sumMB+sumSMB
	...s sumE=sumSPE+sumBE+sumME+sumSME
	...s sumFirstOrder=sumFirstOrder+firstOrd,allFirstOrder=allFirstOrder+firstOrd
	...s sumDelayOrder=sumDelayOrder+delayOrd,allDelayOrder=allDelayOrder+delayOrd
    ..i stat="D" d
    ...s sumD=sumD+1
    ...s allD=allD+1
    .s patLocDesc=$P(^CTLOC(ctlocdr),"^",2)
	.i $l(patLocDesc,"-")>1 s patLocDesc=$p(patLocDesc,"-",2)
    .s retStr=ctlocdr_"^"_patLocDesc_"^"_sumSPB_"^"_sumSPE_"^"_sumBB_"^"_sumBE_"^"_sumMB_"^"_sumME_"^"_sumSMB_"^"_sumSME_"^"_sumB_"^"_sumE_"^"_sumD_"^"_sumFirstOrder_"^"_sumDelayOrder
    .s retval="LoadReport"_"('"_$ZCVT(retStr,"O","JS")_"');"
    .&javascript<#(retval)#>
    k ^TMPAN("Stat",$j)
    s retStr="0"_"^"_"合计"_"^"_allSPB_"^"_allSPE_"^"_allBB_"^"_allBE_"^"_allMB_"^"_allME_"^"_allSMB_"^"_allSME_"^"_allB_"^"_allE_"^"_allD_"^"_allFirstOrder_"^"_allDelayOrder
    s retval="LoadReport"_"('"_$ZCVT(retStr,"O","JS")_"');"
  	&javascript<#(retval)#>
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnOpCost","62294","62294","311")
/// 费用统计
Query GetAnOpCost(stratdate As %Library.String, enddate As %Library.String, ctlocId As %String, isClick As %String) As %Query(ROWSPEC = "patLocDesc,patSumCost,ASumCost,BSumCost,CSumCost,DSumCost,ESumCost,FSumCost,GSumCost,HSumCost,ISumCost,JSumCost,KSumCost,LSumCost,ZSumCost,stratdate,enddate,patCtlocId,patName")
{
}

ClassMethod GetAnOpCostExecute(ByRef qHandle As %Binary, stratdate As %Library.String, enddate As %Library.String, ctlocId As %String, isClick As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	i isClick="" s isClick=1
 	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=stratdate,edate=enddate
	s allCost=0,allACost=0,allBCost=0,allCCost=0,allDCost=0,allECost=0,allFCost=0,allGCost=0,allHCost=0,allICost=0,allJCost=0,allKCost=0,allLCost=0,allZCost=0
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s sumCost=0,ACost=0,BCost=0,CCost=0,DCost=0,ECost=0,FCost=0,GCost=0,HCost=0,ICost=0,JCost=0,KCost=0,LCost=0,ZCost=0
		.s patLocId="",patLocDesc="",opLevelCode=""
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.;q:opLocId'=ctlocId
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
    	.;s PatDeptDr=$P(^DHCANOPArrange(opaId),"^",21)  //病人科室
		.;s patLocDesc=$P(^CTLOC(patLocId),"^",2)
		.;i $l(patLocDesc,"-")>1 s patLocDesc=$p(patLocDesc,"-",2)
		.;s jz=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)
		
		.s oeordRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
		.q:oeordRowId=""
		.s childOEORDRowId="" f  s childOEORDRowId=$O(^OEORD(oeordRowId,"I",childOEORDRowId)) q:childOEORDRowId=""  d
		..s anaDr=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,4)),"^",9)
		..q:anaDr'=anaId
		..s oeordItemStat=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",13)
		..q:oeordItemStat=4
		..s relocId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,3)),"^",6)   //执行科室
		..q:relocId'=ctlocId
		..s applocId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,7)),"^",2)   //接收科室
		..q:applocId=""
		..s arcItmRowId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",2)  //医嘱RowId
		..s exOeoriDr=oeordRowId_"||"_childOEORDRowId
		..s exRowId=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr,-1))
		..q:exRowId=""
		..s priceStatus=$p($g(^DHCEXDE(exRowId)),"^",17)
		..q:priceStatus'="1"   //不是已收费状态的除外
		..s exStatus=$p($g(^DHCEXDE(exRowId)),"^",18)
		..q:exStatus'="A"
		..s exCosts=$p($g(^DHCEXDE(exRowId)),"^",10)
		..s ordCatId=##class(web.DHCCLCom).GetOrdCatId(exOeoriDr)
  		..s ordCatCode=$p(^OEC("ORCAT",ordCatId),"^",1)
  		..i ordCatCode="A" s ACost=ACost+exCosts
  		..i ordCatCode="B" s BCost=BCost+exCosts
  		..i ordCatCode="C" s CCost=CCost+exCosts
  		..i ordCatCode="D" s DCost=DCost+exCosts
  		..i ordCatCode="E" s ECost=ECost+exCosts
  		..i ordCatCode="F" s FCost=FCost+exCosts
  		..i ordCatCode="G" s GCost=GCost+exCosts
  		..i ordCatCode="H" s HCost=HCost+exCosts
  		..i ordCatCode="I" s ICost=ICost+exCosts
  		..i ordCatCode="J" s JCost=JCost+exCosts
  		..i ordCatCode="K" s KCost=KCost+exCosts
  		..i ordCatCode="L" s LCost=LCost+exCosts
  		..i ordCatCode="Z" s ZCost=ZCost+exCosts
		..s sumCost=sumCost+exCosts
		.s allACost=allACost+ACost
		.s allBCost=allBCost+BCost
		.s allCCost=allCCost+CCost
		.s allDCost=allDCost+DCost
		.s allECost=allECost+ECost
		.s allFCost=allFCost+FCost
		.s allGCost=allGCost+GCost
		.s allHCost=allHCost+HCost
		.s allICost=allICost+ICost
		.s allJCost=allJCost+JCost
		.s allKCost=allKCost+KCost
		.s allLCost=allLCost+LCost
		.s allZCost=allZCost+ZCost
		.s allCost=allCost+sumCost
		.s ^TMPAN("Stat",$j,patLocId,opaId)=sumCost_"^"_ACost_"^"_BCost_"^"_CCost_"^"_DCost_"^"_ECost_"^"_FCost_"^"_GCost_"^"_HCost_"^"_ICost_"^"_JCost_"^"_KCost_"^"_LCost_"^"_ZCost
    }
    i isClick="1" s patName=""
    s patCtlocId="" f  s patCtlocId=$o(^TMPAN("Stat",$j,patCtlocId)) q:patCtlocId=""  d
    .s patSumCost=0,opaIdStr="",appLocdescStr=""
    .s ASumCost=0,BSumCost=0,CSumCost=0,DSumCost=0,ESumCost=0,FSumCost=0
    .s GSumCost=0,HSumCost=0,ISumCost=0,JSumCost=0,KSumCost=0,LSumCost=0,ZSumCost=0
    .s opaRowId="" f  s opaRowId=$o(^TMPAN("Stat",$j,patCtlocId,opaRowId)) q:opaRowId=""  d
    ..s patSumCost=patSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",1)
    ..s patLocDesc=$P(^CTLOC(patCtlocId),"^",2)
	..i $l(patLocDesc,"-")>1 s patLocDesc=$p(patLocDesc,"-",2)
	..s ASumCost=ASumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",2)
	..s BSumCost=BSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",3)
	..s CSumCost=CSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",4)
	..s DSumCost=DSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",5)
	..s ESumCost=ESumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",6)
	..s FSumCost=FSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",7)
	..s GSumCost=GSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",8)
	..s HSumCost=HSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",9)
	..s ISumCost=ISumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",10)
	..s JSumCost=JSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",11)
	..s KSumCost=KSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",12)
	..s LSumCost=LSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",13)
	..s ZSumCost=ZSumCost+$p(^TMPAN("Stat",$j,patCtlocId,opaRowId),"^",14)
	..i isClick="0" d
	...s adm=$P(^DHCANOPArrange(opaRowId),"^",1)
	...s papmiId=$p($g(^PAADM(adm)),"^",1)
    ...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	...do OutRowAnOpCost
	...s patSumCost=0,ASumCost=0,BSumCost=0,CSumCost=0,DSumCost=0,ESumCost=0,FSumCost=0
	...s GSumCost=0,HSumCost=0,ISumCost=0,JSumCost=0,KSumCost=0,LSumCost=0,ZSumCost=0
	.i isClick="1" do OutRowAnOpCost
	s patLocDesc="合计",patName="",patSumCost=allCost,ASumCost=allACost,BSumCost=allBCost,CSumCost=allCCost,DSumCost=allDCost,ESumCost=allECost,FSumCost=allFCost,GSumCost=allGCost,HSumCost=allHCost,ISumCost=allICost,JSumCost=allJCost,KSumCost=allKCost,LSumCost=allLCost,ZSumCost=allZCost,patCtlocId="ALL"
	do OutRowAnOpCost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowAnOpCost
	set Data=$lb(patLocDesc,patSumCost,ASumCost,BSumCost,CSumCost,DSumCost,ESumCost,FSumCost,GSumCost,HSumCost,ISumCost,JSumCost,KSumCost,LSumCost,ZSumCost,stratdate,enddate,patCtlocId,patName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpCostExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindAnOpStatistics(startDate As %String, endDate As %String, strUser As %String, strPat As %String, strOp As %String, strAna As %String, strIO As %String, guardianshipItemStr As %String = "", medicineStr As %String = "") As %Query(ROWSPEC = "tOther,tLocDesc,tSurgeon,tAssistant,tAnaesthetist,tAnaSupervisor,tAnaAssist,tScrubNurse,tCirculNurse,tASA,tAnLevel,tAnMethod,tAnaDuration,tOpDuration,tAnaSourceType,tPapmiName,tPatSex,tPatAge,tMedicareNo,tOperName,tOperDate,tOtherWholeBlood,tRBCSuspension,tPlasma,tSelfWholeBlood,tOperCollect,tBloodPlatelet,tCoagulationFactor,tColloid,tCrystalloid,tNormalSaline,tTotalBloodTransfuse,tOtherFluid,tUrineAmt,tBloodLoss,tOtherLoss,tInput,tOutput,tIODispersion,tOpaId,tGuardianshipItemDesc,tIndraftDesc,tVenoAnaDesc,tPartAnaDesc,tPaadmType,tPatWeight,tPatHeight,tTheatreTransToDesc,tRecoveryDesc,tIntExtDesc,tIntAnTypeDesc,tIntRouteDesc,tIntTermDesc,tIntVisionDesc")
{
}

ClassMethod FindAnOpStatisticsExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, strUser As %String, strPat As %String, strOp As %String, strAna As %String, strIO As %String, guardianshipItemStr As %String = "", medicineStr As %String = "") As %Status
{
   

   //strUser=loc+"^"+userLocId+"^"+anaSourceType;
   //strPat=fromAge+"^"+toAge+"^"+sex+"^"+ASARowId
   //strOp=opId+"^"+fromOperTime+"^"+toOperTime+"^"+surgeonId+"^"+assistantId+"^"+scrubNurseId+"^"+circulNurseId
   //strAna=anaMethodId+"^"+fromAnaTime+"^"+toAnaTime+"^"+anaesthetistId+"^"+anaSupervisorId+"^"+anaLevelId+"^"+anaAssistId
   //strIO=fluidInfuseCatCode+"^"+bloodTransCatCode+"^"+fromUrineAmount+"^"+toUrineAmount+"^"+fromBloodLoss+"^"+toBloodLoss
 	Set repid=$I(^CacheTemp)
 	s ind=1
    k ^TMPAN("App",$j)
    //k ^Tmpzt
    //s strUser="",strPat="",strOp="",strAna="",strIO=""
    s locId=$p(strUser,"^",1),userLocId=$p(strUser,"^",2),anaSourceTypeCode=$p(strUser,"^",3)
    s fromAge=$p(strPat,"^",1),toAge=$p(strPat,"^",2),sex=$p(strPat,"^",3),ASARowId=$p(strPat,"^",4),paadmType=$p(strPat,"^",5),fromPatWeight=$p(strPat,"^",6),toPatWeight=$p(strPat,"^",7),fromPatHeight=$p(strPat,"^",8),toPatHeight=$p(strPat,"^",9),ageFlag=$p(strPat,"^",10),theatreTransToId=$p(strPat,"^",11),recoveryIdStr=$p(strPat,"^",12),intExtIdStr=$p(strPat,"^",13),intAnTypeId=$p(strPat,"^",14),intRouteId=$p(strPat,"^",15),intTermId=$p(strPat,"^",16),intVisionId=$p(strPat,"^",17)
    s opId=$p(strOp,"^",1),fromOperTime=$p(strOp,"^",2),toOperTime=$p(strOp,"^",3),surgeonId=$p(strOp,"^",4),assistantId=$p(strOp,"^",5),scrubNurseId=$p(strOp,"^",6),circulNurseId=$p(strOp,"^",7),opTimeFlag=$p(strOp,"^",8),operDocIdStr=$p(strOp,"^",9)
    s anaMethodId=$p(strAna,"^",1),fromAnaTime=$p(strAna,"^",2),toAnaTime=$p(strAna,"^",3),anaesthetistId=$p(strAna,"^",4),anaSupervisorId=$p(strAna,"^",5),anaLevelId=$p(strAna,"^",6),anaAssistId=$p(strAna,"^",7),anTimeFlag=$p(strAna,"^",8),anaDocIdStr=$p(strAna,"^",9)
    s fluidInfuseCatCode=$p(strIO,"^",1),bloodTransCatCode=$p(strIO,"^",2),fromUrineAmount=$p(strIO,"^",3),toUrineAmount=$p(strIO,"^",4),fromBloodLoss=$p(strIO,"^",5),toBloodLoss=$p(strIO,"^",6)
    //s opTimeFlag="H",anTimeFlag="H"
    i fromPatWeight="" s fromPatWeight=0
    i toPatWeight="" s toPatWeight=500
    i fromPatHeight="" s fromPatHeight=0
    i toPatHeight="" s toPatHeight=300
    i fromOperTime="" s fromOperTime=0
    i toOperTime="" s toOperTime=20000
    i fromAnaTime="" s fromAnaTime=0
    i toAnaTime="" s toAnaTime=20000
    i fromAge="" s fromAge=0
    i toAge="" s toAge=200
    i fromUrineAmount="" s fromUrineAmount=0
    i toUrineAmount="" s toUrineAmount=100000
    i fromBloodLoss="" s fromBloodLoss=0
    i toBloodLoss="" s toBloodLoss=100000
    if (startDate="")!(endDate="") s sDate=+$H,eDate=+$H
    e  s sDate=startDate,eDate=endDate
    ;s ^Tmpzt("TestDate")=startDate_"/"_endDate 
    s linkLocId=##Class(web.DHCCLCom).GetLinkLocId(userLocId)
    s userLocIdStr=linkLocId_"^"_userLocId
	s userLocTyp=""
    i userLocId'="" s userLocTyp=$P(^CTLOC(userLocId),"^",13)
    s operLocId="",chl=""
    s j=1
    s coMedStr="",arMedStr="",coGuarStr="",arGuarStr=""
    s tColloidAmt=0,tCrystalloidAmt=0,tNormalSalineAmt=0,tTotalBloodTransfuseAmt=0,tOtherFluidAmt=0
    s tOtherWholeBloodAmt=0,tRBCSuspensionAmt=0,tPlasmaAmt=0,tSelfWholeBloodAmt=0,tOperCollectAmt=0,tBloodPlateletAmt=0,tCoagulationFactorAmt=0
    s tUrineAmtAmounts=0,tBloodLossAmt=0,tOtherLossAmt=0
    s tInputAmounts=0,tOutputAmounts=0,tIODispersionAmt=0
    i opTimeFlag="H" d
    .s fromOperTime=(($p(fromOperTime,":",1))*3600)+(($p(fromOperTime,":",2))*60)
    .s toOperTime=(($p(toOperTime,":",1))*3600)+(($p(toOperTime,":",2))*60)
    i opTimeFlag="N" d
    .s fromOperTime=fromOperTime*60
    .s toOperTime=toOperTime*60
    i anTimeFlag="H" d
    .s fromAnaTime=(($p(fromAnaTime,":",1))*3600)+(($p(fromAnaTime,":",2))*60)
    .s toAnaTime=(($p(toAnaTime,":",1))*3600)+(($p(toAnaTime,":",2))*60)
    i anTimeFlag="N" d
    .s fromAnaTime=fromAnaTime*60
    .s toAnaTime=toAnaTime*60
    s SubNode="SDate"
    f date=sDate:1:eDate
    {  
       ;q:userLocId=""
       s opaId=""
       f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
	   .q:$d(^DHCANOPArrange(opaId))<1
	   .s tOperDate="",tMedicareNo="",tPapmiName="",tPatAge="",tPatSex="",tLocDesc="",tOperName="",yy="",tSurgeon="",tScrubNurse="",tCirculNurse="",tColloid=0,tCrystalloid=0,tNormalSaline=0,tTotalBloodTransfuse=0,xsh="",xch="",tOtherFluid=0,tOtherWholeBlood=0,tRBCSuspension=0,tPlasma=0,tSelfWholeBlood=0,tOperCollect=0,tBloodPlatelet=0,tCoagulationFactor=0,tUrineAmt=0,tBloodLoss=0,tOtherLoss=0
	   .s tOther="",tLocDesc="",tSurgeon="",tAssistant="",tAnaesthetist="",tAnaSupervisor="",tAnaAssist="",tScrubNurse="",tCirculNurse="",tASA="",tAnLevel="",tAnMethod="",tAnaDuration="",tOpDuration="",tAnaSourceType="",tPapmiName="",tPatSex="",tPatAge="",tMedicareNo="",tOperName="",tOperDate="",tOpaId="",tGuardianshipItemDesc="",tIndraftDesc="",tVenoAnaDesc="",tPartAnaDesc="",tPaadmType="",tPatWeight="",tPatHeight="",tPostOpCondDesc="",tTheatreTransToDesc="",tRecoveryDesc="",tIntExtDesc="",tIntAnTypeDesc="",tIntRouteDesc="",tIntTermDesc="",tIntVisionDesc=""
	   .;s opaId=38207  //,medicineStr="2*570||1" //test
	   .s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
	   .q:adm=""
	   .s tGuardianshipItemDesc="",tIndraftDesc="",tVenoAnaDesc="",tPartAnaDesc=""
	   .s ancoIdStr="",arcimIdStr=""
	   .s coStr="",arStr=""
	   .s num=$l(guardianshipItemStr,"*")
	   .f gi=1:1:num d     //此处判断监护项目常用医嘱和HIS医嘱，并把HIS医嘱与常用医嘱分开
	   ..s guarId=$p(guardianshipItemStr,"*",gi)
	   ..i $l(guarId,"||")=1 d
	   ...i coStr="" s coStr=guarId
	   ...e  s coStr=coStr_"|"_guarId
	   ..e  d
	   ...i arStr="" s arStr=guarId
	   ...e  s arStr=arStr_"#"_guarId 
	   .s coGuarStr=coStr
	   .s arGuarStr=arStr
	   .s coStr="",arStr=""
	   .s num=$l(medicineStr,"*")
	   .f mi=1:1:num d     //此处判断药品常用医嘱和HIS医嘱，并把HIS医嘱与常用医嘱分开
	   ..s medId=$p(medicineStr,"*",mi)
	   ..i $l(medId,"||")=1 d
	   ...i coStr="" s coStr=medId
	   ...e  s coStr=coStr_"|"_medId
	   ..e  d
	   ...i arStr="" s arStr=medId
	   ...e  s arStr=arStr_"#"_medId 
	   .s coMedStr=coStr
	   .s arMedStr=arStr
	   .s anoId=""
	   .f  s anoId=$O(^DHCANOrder(0,"OPApp",opaId,anoId)) q:anoId=""  d
	   ..s guardianshipItem="",indraft="",venoAna="",partAna=""
	   ..s ancoId=$p(^DHCANOrder(anoId),"^",2)
	   ..s arcimId=$p(^DHCANOrder(anoId),"^",9)
	   ..q:ancoId=""
	   ..s viewCatId=$p(^DHCANC("ComOrd",ancoId),"^",5)
	   ..q:(viewCatId'=157)&&(viewCatId'=110)&&(viewCatId'=1)&&(+$p(viewCatId,"|")'=2)&&(viewCatId'=3)
	   ..i (viewCatId=157)||(viewCatId=110) d
	   ...s guardianshipItem=$p(^DHCANC("ComOrd",ancoId),"^",2)
	   ...i tGuardianshipItemDesc="" s tGuardianshipItemDesc=$g(guardianshipItem)
	   ...e  d
	   ....i (","_tGuardianshipItemDesc_",")'[(","_$g(guardianshipItem)_",")  s tGuardianshipItemDesc=tGuardianshipItemDesc_","_$g(guardianshipItem)
	   ..i viewCatId=1 d
	   ...s indraft=$p(^DHCANC("ComOrd",ancoId),"^",2)
	   ...i tIndraftDesc="" s tIndraftDesc=$g(indraft)
	   ...e  d
	   ....i (","_tIndraftDesc_",")'[(","_$g(indraft)_",") s tIndraftDesc=tIndraftDesc_","_$g(indraft)
	   ..i +$p(viewCatId,"|")=2 d 
	   ...s venoAna=$p(^DHCANC("ComOrd",ancoId),"^",2)
	   ...i tVenoAnaDesc="" s tVenoAnaDesc=$g(venoAna)
	   ...e  d
	   ....i (","_tVenoAnaDesc_",")'[(","_$g(venoAna)_",") s tVenoAnaDesc=tVenoAnaDesc_","_$g(venoAna)
	   ..i viewCatId=3 d 
	   ...s partAna=$p(^DHCANC("ComOrd",ancoId),"^",2)
	   ...i tPartAnaDesc="" s tPartAnaDesc=$g(partAna)
	   ...e  d
	   ....i (","_tPartAnaDesc_",")'[(","_$g(partAna)_",") s tPartAnaDesc=tPartAnaDesc_","_$g(partAna)
	   ..i ancoIdStr="" s ancoIdStr=ancoId
	   ..e  d
	   ...i ("|"_ancoIdStr_"|")'[("|"_ancoId_"|") s ancoIdStr=ancoIdStr_"|"_ancoId
	   ..i (arcimIdStr="")&(arcimId'="") s arcimIdStr=arcimId
	   ..e  d
	   ...i (("#"_arcimIdStr_"#")'[("#"_arcimId_"#"))&(arcimId'="") s arcimIdStr=arcimIdStr_"#"_arcimId
	   .;q:(guardianshipItemStr'="")&(("|"_ancoIdStr_"|")'[("|"_guardianshipItemStr_"|"))
	   .;q:(medicineStr'="")&(("|"_ancoIdStr_"|")'[("|"_medicineStr_"|"))   
	   .s gdsFlag=0,outNum=1
	   .i (ancoIdStr'="")&(coGuarStr'="") d
	   ..s outNum=$l(coGuarStr,"|")
	   ..s inNum=$l(ancoIdStr,"|")
	   ..f m=1:1:outNum d
	   ...s outId=$p(coGuarStr,"|",m)
	   ...f n=1:1:inNum d
	   ....s inId=$p(ancoIdStr,"|",n)
	   ....s outId="^"_outId_"^",inId="^"_inId_"^"
	   ....i outId[inId s gdsFlag=gdsFlag+1
	   .q:(gdsFlag'=outNum)&(coGuarStr'="")
	   .s gdsFlag=0,outNum=1
	   .i (arcimIdStr'="")&(arGuarStr'="") d
	   ..s outNum=$l(arGuarStr,"#")
	   ..s inNum=$l(arcimIdStr,"#")
	   ..f m=1:1:outNum d
	   ...s outId=$p(arGuarStr,"#",m)
	   ...f n=1:1:inNum d
	   ....s inId=$p(arcimIdStr,"#",n)
	   ....s outId="^"_outId_"^",inId="^"_inId_"^"
	   ....i outId[inId s gdsFlag=gdsFlag+1
	   .q:(gdsFlag'=outNum)&(arGuarStr'="")
	   .s medFlag=0,outNum=1
	   .i (ancoIdStr'="")&(coMedStr'="") d
	   ..s outNum=$l(coMedStr,"|")
	   ..s inNum=$l(ancoIdStr,"|")
	   ..f m=1:1:outNum d
	   ...s outId=$p(coMedStr,"|",m)
	   ...;s ^ztTmp("anmetOutId",j,m)=anmetOutId
	   ...f n=1:1:inNum d
	   ....s inId=$p(ancoIdStr,"|",n)
	   ....;s ^ztTmp("anmetInId",j,n)=anmetInId
	   ....s outId="^"_outId_"^",inId="^"_inId_"^"
	   ....i outId[inId s medFlag=medFlag+1
	   .q:(medFlag'=outNum)&(coMedStr'="")
	   .s medFlag=0,outNum=1
	   .i (arcimIdStr'="")&(arMedStr'="") d
	   ..s outNum=$l(arMedStr,"#")
	   ..s inNum=$l(arcimIdStr,"#")
	   ..f m=1:1:outNum d
	   ...s outId=$p(arMedStr,"#",m)
	   ...;s ^ztTmp("anmetOutId",j,m)=anmetOutId
	   ...f n=1:1:inNum d
	   ....s inId=$p(arcimIdStr,"#",n)
	   ....;s ^ztTmp("anmetInId",j,n)=anmetInId
	   ....s outId="^"_outId_"^",inId="^"_inId_"^"
	   ....i outId[inId s medFlag=medFlag+1
	   .q:(medFlag'=outNum)&(arMedStr'="")
	   
       .s inPatNo=$p($g(^PAADM(adm)),"^",29)
	   .s Stat=$P(^DHCANOPArrange(opaId),"^",27)
	   .q:(Stat="")&(userLocTyp'="E")
	   .q:(Stat'="")&(Stat'="F")&(Stat'="L")
	   .s papmiId=$p($g(^PAADM(admId)),"^",1)
       .s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
       .;s tMedicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
       .;s MedCareNo=$p(^PAADM(admId),"^",29) //PAADM_InPatNo,部分医院用
       .;q:(tMedicareNo'=MedCareNo)&(MedCareNo'="")
	   .s paadmtype=$p($g(^PAADM(adm)),"^",2)
	   .s tMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm,paadmtype,.ErrMsg)
       .s tPapmiName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
       .s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
       .s tPatAge=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
       .s ageFlag="Y" //test
       .s patAge=0  //当下面三个if语句都不执行时，没有这句话会报错
       .i ageFlag="Y" d
       ..s patAge=$p(tPatAge,"岁")
       .i ageFlag="M" d
       ..s patAge=$p(tPatAge,"月")
       .i ageFlag="D" d
       ..s patAge=$p(tPatAge,"天")
       .i patAge'=+patAge s patAge=-1 //当页面显示查询岁,而病人年龄只记录了多少个月的年龄，这种情况下及不满足查询条件。使下面判断年龄范围时不满足
       .;s flag=0
       .;f age=+fromAge:1:+toAge d
       ..;i +patAge=age s flag=1
       .s flag=1
       .i (patAge<fromAge)||(patAge>toAge) s flag=0
       .q:flag=0    
       .s tPatSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
       .q:(tPatSex'=sex)&(sex'="")
       .s tPatWeight=$p(^DHCANOPArrange(opaId),"^",24)
       .s flag=1
       .;f weight=+fromPatWeight:1:+toPatWeight d
       ..;i weight=+tPatWeight s flag=1
       .i (tPatWeight<fromPatWeight)||(tPatWeight>toPatWeight) s flag=0
       .q:flag=0
       .s tPatHeight=$p(^DHCANOPArrange(opaId),"^",22)
       .;s flag=0
       .;f height=+fromPatHeight:1:+toPatHeight d
       ..;i height=+tPatHeight s flag=1
       .s flag=1
       .i (tPatHeight<fromPatHeight)||(tPatHeight>toPatHeight) s flag=0
       .q:flag=0
       .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
       .;begain
       .s tOpDuration=0
	   .s oldStDate=$P(^DHCANOPArrange(opaId),"^",14) 	//OPA_StartDate 开始日期
	   .s oldStTime=$P(^DHCANOPArrange(opaId),"^",15) 	//OPA_StartTime 开始时间
	   .s oldEnDate=$P(^DHCANOPArrange(opaId),"^",16) 	//OPA_EndDate   结束日期
	   .s oldEnTime=$P(^DHCANOPArrange(opaId),"^",17) 	//OPA_EndTime	结束时间
	   .//新的取OR_Anaesthesia表中手术登记时间,如为空则取排班表时间
	   .s opstDate=$P(^OR(admId,"ANA",chl),"^",39) 	//ANA_TheatreInDate  	开始日期
	   .i opstDate="" d
	   ..s $P(^OR(admId,"ANA",chl),"^",39)=oldStDate	
	   ..s opstDate=oldStDate
	   .s opstTime=$P(^OR(admId,"ANA",chl),"^",40) 	//ANA_TheatreInTime  	开始时间
	   .i opstTime="" d
	   ..s $P(^OR(admId,"ANA",chl),"^",40)=oldStTime
	   ..s opstTime=oldStTime
	   .s openDate=$P(^OR(admId,"ANA",chl),"^",41) 	//ANA_TheatreOutDate  	结束日期
	   .i openDate="" d
	   ..s $P(^OR(admId,"ANA",chl),"^",41)=oldEnDate
	   ..s openDate=oldEnDate
	   .s openTime=$P(^OR(admId,"ANA",chl),"^",42) 	//ANA_TheatreOutTime	结束时间		
	   .i openTime="" d
	   ..s $P(^OR(admId,"ANA",chl),"^",42)=oldEnTime
	   ..s openTime=oldEnTime
	   .;s opTimeFlag="H",anTimeFlag="H"  //test
	   .s flag=1
	   .s opDurTime=0  //
	   .s opDurTime=(openDate-opstDate)*24*3600+(openTime-opstTime)
	   .;i opTimeFlag="H" d
	   ..;s opDurTime=(openDate-opstDate)*24+(openTime-opstTime)\3600
	   ..;i (openTime-opstTime)#3600\60'=0 s opDurTime=opDurTime+1,fromOperTime=+fromOperTime+1
	   .i (opDurTime<fromOperTime)||(opDurTime>toOperTime) s flag=0 
	   .;i opTimeFlag="N" d
	   ..;s opDurTime=(openDate-opstDate)*24*60+(openTime-opstTime)\60
	   ..;s fromOperTime=fromOperTime*60,toOperTime=toOperTime*60
	   ..;i (opDurTime<fromOperTime)||(opDurTime>toOperTime) s flag=0
	   .i opstDate'="",opstTime'="",openDate'="",openTime'=""  d
	   ..;f operTime=+fromOperTime:1:+toOperTime d
	   ...;i operTime=opDurTime s flag=1
	   ..s opDurHour= (openDate-opstDate)*24+(openTime-opstTime)\3600_"小时"
	   ..s opDurMinute=(openTime-opstTime)#3600\60_"分钟"
	   ..s opDurSec=(openTime-opstTime)#3600#60_"秒"
	   ..i opTimeFlag="H" s tOpDuration=opDurHour_opDurMinute
	   ..i opTimeFlag="N" s tOpDuration=(openDate-opstDate)*24*60+(openTime-opstTime)\60_"分钟"
	   ..s tOperDate=$ZD(opstDate)
	   .q:tOperDate=""
	   .q:(flag=0)&(opstDate'="")&(opstTime'="")&(openDate'="")&(openTime'="")
       .;final
       .s anastTime=$p(^OR(admId,"ANA",chl),"^",3) //ANA_AnaStartTime
       .s anaenTime=$p(^OR(admId,"ANA",chl),"^",4) //ANA_AnaFinishTime
       .s flag=1,anDurTime=0
       .;i anTimeFlag="H" d
       .s anDurTime=anaenTime-anastTime
       .i (anDurTime<fromAnaTime)||(anDurTime>toAnaTime) s flag=0
       ..;i (anaenTime-anastTime)#3600\60'=0 s anDurTime=anDurTime+1
       .;i anTimeFlag="N" s anDurTime=(anaenTime-anastTime)\60
       .i anastTime'="",anaenTime'="" d
       ..;f anaTime=+fromAnaTime:1:toAnaTime d
       ...;i anaTime=anDurTime s flag=1
       ..s anDurHour=(anaenTime-anastTime)\3600_"小时"
       ..s anDurMinute=(anaenTime-anastTime)#3600\60_"分钟"
       ..i anTimeFlag="H" s tAnaDuration=anDurHour_anDurMinute
       ..i anTimeFlag="N" s tAnaDuration=(anaenTime-anastTime)\60_"分钟"
       .q:(flag=0)&(fromAnaTime'="")&(toAnaTime'="")
	   .s locDr=$P(^PAADM(adm),"^",4)
	   .s locCheckDr="^"_locDr_"^"
	   .s locCheckId="^"_locId_"^"
	   .q:(locCheckId'[locCheckDr)&(locId'="") // 16包含6
	   .s tLocDesc=$P(^CTLOC(locDr),"^",2)
	   .i $l(tLocDesc,"-")>1 s tLocDesc=$p(tLocDesc,"-",2)
	   .s admType=$p(^PAADM(adm),"^",2)
	   .i admType="I" s tPaadmType="住院"
	   .i admType="O" s tPaadmType="门诊"
	   .i admType="E" s tPaadmType="急诊"
	   .i admType="N" s tPaadmType="新生"
	   .i admType="H" s tPaadmType="保健"
	   .q:(admType'=paadmType)&(paadmType'="")
	   .s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
	   .if jz="E" s tAnaSourceType="急诊"
	   .else  s tAnaSourceType="择期"
	   .q:(jz'=anaSourceTypeCode)&(jz'="")
	   .s ASADr=$P(^OR(adm,"ANA",chl),"^",26)
	   .q:(ASADr'=ASARowId)&(ASARowId'="")
	   .i ASADr'="" s tASA=$P(^ORC("ASA",ASADr),"^",2)
	   .e  s tASA=""
	   .; ttaa
	   .s theatreTransToDr=""
	   .s aniChildSub=""  f  s aniChildSub=$o(^DHCANOPArrange(opaId,"ANI",aniChildSub)) q:(aniChildSub="")||(aniChildSub'=1)  d
	   ..s theatreTransToDr=$p(^DHCANOPArrange(opaId,"ANI",aniChildSub),"^",101)
	   ..q:theatreTransToDr=""
	   ..s tTheatreTransToDesc=$p(^DHCANC("TheatreTransTo",theatreTransToDr),"^",2)
	   .q:(theatreTransToDr'=theatreTransToId)&(theatreTransToId'="")
	   .s intAnTypeDr=""
	   .s aniChildSub=""  f  s aniChildSub=$o(^DHCANOPArrange(opaId,"ANI",aniChildSub)) q:(aniChildSub="")||(aniChildSub'=1)  d
	   ..s intAnTypeDr=$p(^DHCANOPArrange(opaId,"ANI",aniChildSub),"^",73)
	   ..q:intAnTypeDr=""
	   ..s tIntAnTypeDesc=$p(^DHCANC("IntAnType",intAnTypeDr),"^",2)
	   .q:(intAnTypeDr'=intAnTypeId)&(intAnTypeId'="")
	   .s intRouteDr=""
	   .s aniChildSub=""  f  s aniChildSub=$o(^DHCANOPArrange(opaId,"ANI",aniChildSub)) q:(aniChildSub="")||(aniChildSub'=1)  d
	   ..s intRouteDr=$p(^DHCANOPArrange(opaId,"ANI",aniChildSub),"^",80)
	   ..q:intRouteDr=""
	   ..s tIntRouteDesc=$p(^DHCANC("IntRoute",intRouteDr),"^",2)
	   .q:(intRouteDr'=intRouteId)&(intRouteId'="")
	   .s intTermDr=""
	   .s aniChildSub=""  f  s aniChildSub=$o(^DHCANOPArrange(opaId,"ANI",aniChildSub)) q:(aniChildSub="")||(aniChildSub'=1)  d
	   ..s intTermDr=$p(^DHCANOPArrange(opaId,"ANI",aniChildSub),"^",78)
	   ..q:intTermDr=""
	   ..s tIntTermDesc=$p(^DHCANC("IntTerm",intTermDr),"^",2)
	   .q:(intTermDr'=intTermId)&(intTermId'="")
	   .s intVisionDr=""
	   .s aniChildSub=""  f  s aniChildSub=$o(^DHCANOPArrange(opaId,"ANI",aniChildSub)) q:(aniChildSub="")||(aniChildSub'=1)  d
	   ..s intVisionDr=$p(^DHCANOPArrange(opaId,"ANI",aniChildSub),"^",75)
	   ..q:intVisionDr=""
	   ..s tIntVisionDesc=$p(^DHCANC("IntVision",intVisionDr),"^",2)
	   .q:(intVisionDr'=intVisionId)&(intVisionId'="")
	   .s recoveryId=""
	   .s aniChildSub=""  f  s aniChildSub=$o(^DHCANOPArrange(opaId,"ANI",aniChildSub)) q:(aniChildSub="")||(aniChildSub'=1)  d
	   ..s recoveryId=$p(^DHCANOPArrange(opaId,"ANI",aniChildSub),"^",95)
	   .s recoveryFlag=0,outNum=1
	   .;i (postOpConditionId'="")&(postOpCondIdStr'="") d
	   .i recoveryId'="" d
	   ..s outNum=$l(recoveryIdStr,"|")
	   ..s inNum=$l(recoveryId,"|")
	   ..f m=1:1:outNum d
	   ...s outId=$p(recoveryIdStr,"|",m)
	   ...f n=1:1:inNum d
	   ....s inId=$p(recoveryId,"|",n)
	   ....q:inId=""
	   ....s recoveryDesc=$p(^DHCANC("Recovery",inId),"^",2) //
	   ....i tRecoveryDesc="" s tRecoveryDesc=recoveryDesc
	   ....e  s tRecoveryDesc=tRecoveryDesc_","_recoveryDesc
	   ....s outId="^"_outId_"^",inId="^"_inId_"^"
	   ....i outId[inId s recoveryFlag=recoveryFlag+1
	   .q:(recoveryFlag'=outNum)&(recoveryIdStr'="")
	   
	   .s intExtId=""
	   .s aniChildSub=""  f  s aniChildSub=$o(^DHCANOPArrange(opaId,"ANI",aniChildSub)) q:(aniChildSub="")||(aniChildSub'=1)  d
	   ..s intExtId=$p(^DHCANOPArrange(opaId,"ANI",aniChildSub),"^",86)
	   .s intExtFlag=0,outNum=1
	   .;i (postOpConditionId'="")&(postOpCondIdStr'="") d
	   .i intExtId'="" d
	   ..s outNum=$l(intExtIdStr,"|")
	   ..s inNum=$l(intExtId,"|")
	   ..f m=1:1:outNum d
	   ...s outId=$p(intExtIdStr,"|",m)
	   ...f n=1:1:inNum d
	   ....s inId=$p(intExtId,"|",n)
	   ....q:inId=""
	   ....s intExtDesc=$p(^DHCANC("IntExt",inId),"^",2) //
	   ....i tIntExtDesc="" s tIntExtDesc=intExtDesc
	   ....e  s tIntExtDesc=tIntExtDesc_","_intExtDesc
	   ....s outId="^"_outId_"^",inId="^"_inId_"^"
	   ....i outId[inId s intExtFlag=intExtFlag+1
	   .q:(intExtFlag'=outNum)&(intExtIdStr'="") 
	    
	   .s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					;ANA_Anaesthetist_Dr
	   .q:(mzdr'=anaesthetistId)&(anaesthetistId'="")
	   .s allAnaDocIdStr=""     //将麻醉医师，麻醉指导医师，麻醉助手结合成一个字符串 
	   .i mzdr'="" d
	   ..s allAnaDocIdStr=mzdr
	   ..s tAnaesthetist=$TR($P($G(^CTPCP(mzdr,1)),"^",2)," ","") 			;麻醉医师
	   .e  s tAnaesthetist=""
	   .s mzsupdr=$P(^OR(adm,"ANA",chl),"^",7)        				;ANA_Supervisor_DR ///ck091203 
	   .;q:(mzsupdr'=anaSupervisorId)&(anaSupervisorId'="") 
	   .i mzsupdr'="" d
	   ..i allAnaDocIdStr="" s allAnaDocIdStr=mzsupdr
	   ..e  d
	   ...i allAnaDocIdStr'[mzsupdr s allAnaDocIdStr=allAnaDocIdStr_"|"_mzsupdr
	   ..s tAnaSupervisor=$TR($P(^CTPCP(mzsupdr,1),"^",2)," ","") 		;麻醉指导医师
	   .e  s tAnaSupervisor=""
	   .;s flag=0
	   .s tAnaAssist=""
	   .s ass=0
	   .f  s ass=$o(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)) q:ass=""  d    //麻醉医师
	   ..s mzzsdr=$p($g(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)),"^",1)
	   ..;i (mzzsdr=anaAssistId)&(anaAssistId'="") s flag=1
	   ..q:mzzsdr=""
	   ..i allAnaDocIdStr="" s allAnaDocIdStr=mzzsdr
	   ..e  d
	   ...i allAnaDocIdStr'[mzzsdr s allAnaDocIdStr=allAnaDocIdStr_"|"_mzzsdr
	   ..i tAnaAssist="" d
	   ...s tAnaAssist=$TR($P($G(^CTPCP(mzzsdr,1)),"^",2)," ","")
	   ..e  d
	   ...s tAnaAssist=tAnaAssist_" "_$TR($P($G(^CTPCP(mzzsdr,1)),"^",2)," ","")
	   .s anastFlag=0,outNum=1
	   .i (allAnaDocIdStr'="")&(anaDocIdStr'="") d
	   ..s outNum=$l(anaDocIdStr,"|")
	   ..s inNum=$l(allAnaDocIdStr,"|")
	   ..f m=1:1:outNum d
	   ...s outId=$p(anaDocIdStr,"|",m)
	   ...q:outId=""
	   ...f n=1:1:inNum d
	   ....s inId=$p(allAnaDocIdStr,"|",n)
	   ....q:inId=""
	   ....s outId="^"_outId_"^",inId="^"_inId_"^"
	   ....i outId[inId s anastFlag=anastFlag+1
	   .q:(anastFlag'=outNum)&(anaDocIdStr'="")
	   .;q:(flag=0)&(anaAssistId'="")
	   .s mzNurseId=$P(^OR(adm,"ANA",chl),"^",8) 
	   .i mzNurseId'="" d
	   ..s anNurse=$TR($P($G(^CTPCP(mzNurseId,1)),"^",2)," ","") 	;麻醉护士
	   .e  s anNurse=""
	   .s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)						;ANA_Method	 麻醉方法
	   .s anFlag=0,anmetOutNum=1
	   .i (anmthdr'="")&(anaMethodId'="") d
	   ..s anmetOutNum=$l(anaMethodId,"|")
	   ..s anmetInNum=$l(anmthdr,"|")
	   ..f m=1:1:anmetOutNum d
	   ...s anmetOutId=$p(anaMethodId,"|",m)
	   ...q:anmetOutId=""
	   ...f n=1:1:anmetInNum d
	   ....s anmetInId=$p(anmthdr,"|",n)
	   ....q:anmetInId=""
	   ....s anmetOutId="^"_anmetOutId_"^",anmetInId="^"_anmetInId_"^"
	   ....i anmetOutId[anmetInId s anFlag=anFlag+1
	   .q:(anFlag'=(anmetOutNum-1))&(anaMethodId'="")  
	   .s tAnMethod=""
	   .i anmthdr'="" d
	   ..s anmetNum=$l(anmthdr,"|")
	   ..f i=1:1:anmetNum d
	   ...s anmetId=$p(anmthdr,"|",i)
	   ...q:anmetId=""
	   ...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
	   ...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	   ...i tAnMethod="" s tAnMethod=anmetDesc
	   ...e  s tAnMethod=tAnMethod_","_anmetDesc
	   .s anLevelDr=$P(^DHCANOPArrange(opaId),"^",28) //OPA_OPLevel_Dr 原手术规模,现为麻醉规模
	   .q:(anLevelDr'=anaLevelId)&(anaLevelId'="")
	   .s tAnLevel=""
	   .i anLevelDr'="" s tAnLevel=$P($g(^DHCANC("OPLevel",anLevelDr)),"^",2)  			//DHC_ANC_OPLevel->ANCOPL_Code 手术规模代 
	   .s op=0
	   .s flag=0
	   .s allDocIdStr=""
	   .s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d ///ck091117
	   ..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
	   ..i (opdr=opId)&(opId'="") s flag=1
	   ..i opdr'=""  d   //ck091210
	   ...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     ///ck091117
	   ....i tOperName'="" s tOperName=tOperName_";"     ///ck091117
	   ....s tOperName=tOperName_$P($g(^ORC("OPER",+opdr)),"^",2)     ///ck091117
	   ..e  d
	   ...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",1))'="" d
	   ....i tOperName'="" s tOperName=tOperName_";"
	   ....s tOperName=tOperName_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",1))    ///ck091210
	   ..s op=op+1
	   ..q:op>1
	   ..s sub=subchl
	   ..s opDoc=0
	   ..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
	   ..q:(docdr'=surgeonId)&(surgeonId'="")
	   ..s opDoc=opDoc+1
	   ..if docdr'="" s tSurgeon=$TR($P(^CTPCP(docdr,1),"^",2)," ",""),allDocIdStr=docdr
	   ..e  s tSurgeon=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //CK 091210 手术医生备注(外来手术医生)	   
	   ..s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) 		;ANAOP_CTLOC_DR
	   .s admLocId=$p($g(^PAADM(adm)),"^",4)
	   .;q:(("^"_userLocIdStr_"^")'[("^"_+operLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))  //ypz 070318
	   .q:sub=""
	   .q:(flag=0)&(opId'="")
	   .q:opDoc=0
	   .s tAssistant=""
	   .s assDocNum=2 //最多显示的助手人数
	   .i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)'="" s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
	   .s p=0
	   .;s flag=0
	   .s list=0,asName=""
	   .s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42) //手动填写OPA_OpDocNote（实习医生1;实习医生2...|主刀|一助|二助|三助|四助|五助...）
	   .s len=$l(opaDocNote,"|")
	   .s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",sub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
	   ..s asdr=$P(^OR(adm,"ANA",chl,"OP",sub,"ASS",as),"^",1)
	   ..;i (asdr=assistantId)&(assistantId'="") s flag=1  
	   ..s p=p+1
	   ..q:asdr=""
	   ..i allDocIdStr="" s allDocIdStr=asdr
	   ..e  d
	   ...i allDocIdStr'[asdr s allDocIdStr=allDocIdStr_"|"_asdr
	   ..s asName=asName_"^"_$P(^CTPCP(asdr,1),"^",2)
	   .s opDocFlag=0,outNum=1
	   .i (allDocIdStr'="")&(operDocIdStr'="") d
	   ..s outNum=$l(operDocIdStr,"|")
	   ..s inNum=$l(allDocIdStr,"|")
	   ..f m=1:1:outNum d
	   ...s outId=$p(operDocIdStr,"|",m)
	   ...q:outId=""
	   ...f n=1:1:inNum d
	   ....s inId=$p(allDocIdStr,"|",n)
	   ....q:inId=""
	   ....s outId="^"_outId_"^",inId="^"_inId_"^"
	   ....i outId[inId s opDocFlag=opDocFlag+1
	   .q:(opDocFlag'=outNum)&(operDocIdStr'="")
	   .;q:(flag=0)&(assistantId'="")
	   .i len>assDocNum+2 s len=assDocNum+2
	   .f getLen=3:1:len  d
	   ..i $p(opaDocNote,"|",getLen)'=""  d
	   ...s getName=$p(opaDocNote,"|",getLen)
	   ..e  d
	   ...s list=list+1
	   ...s getName=$p(asName,"^",list+1)
	   ..s tAssistant=tAssistant_" "_getName
	   .s p=0  ;洗手
	   .s flag=0
	   .s xs=0 f  s xs=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs)) q:(xs="")!(p=3)  d
	   ..q:xs>20
	   ..s xsdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs),"^",1)
	   ..i (xsdr=scrubNurseId)&(scrubNurseId'="") s flag=1
	   ..q:xsdr=""
	   ..s p=p+1
	   ..s tScrubNurse=tScrubNurse_" "_$TR($P(^CTPCP(xsdr,1),"^",2)," ","")  ;
	   .q:(flag=0)&(scrubNurseId'="")
	   .s p=0  ;巡回
	   .s flag=0
	   .s xc=0 f  s xc=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc)) q:(xc="")!(p=3)   d
	   ..q:xc>20
	   ..s xchdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc),"^",1)
	   ..i (xchdr=circulNurseId)&(circulNurseId'="") s flag=1
	   ..q:xchdr=""
	   ..s p=p+1
	   ..s tCirculNurse=$G(tCirculNurse)_" "_$TR($P($G(^CTPCP(xchdr,1)),"^",2)," ","")
	   .q:(flag=0)&(circulNurseId'="")  
	   .s tColloid=+$p($g(^DHCANOPArrange(opaId,"Sum","I")),"^",1)
       .s tCrystalloid=+$p($g(^DHCANOPArrange(opaId,"Sum","I")),"^",2)
       .s tNormalSaline=+$p($g(^DHCANOPArrange(opaId,"Sum","I")),"^",3)
       .s tTotalBloodTransfuse=+$p($g(^DHCANOPArrange(opaId,"Sum","I")),"^",4)
       .s tOtherFluid=+$p($g(^DHCANOPArrange(opaId,"Sum","I")),"^",5)
       .s tOtherWholeBlood=+$p($g(^DHCANOPArrange(opaId,"Sum","IB")),"^",1)
       .s tRBCSuspension=+$p($g(^DHCANOPArrange(opaId,"Sum","IB")),"^",2)
       .s tPlasma=+$p($g(^DHCANOPArrange(opaId,"Sum","IB")),"^",3)
       .s tSelfWholeBlood=+$p($g(^DHCANOPArrange(opaId,"Sum","IB")),"^",4)
       .s tOperCollect=+$p($g(^DHCANOPArrange(opaId,"Sum","IB")),"^",5)
       .s tBloodPlatelet=+$p($g(^DHCANOPArrange(opaId,"Sum","IB")),"^",6)
       .s tCoagulationFactor=+$p($g(^DHCANOPArrange(opaId,"Sum","IB")),"^",7)
       .s tUrineAmt=+$p($g(^DHCANOPArrange(opaId,"Sum","O")),"^",1)
       .s tBloodLoss=+$p($g(^DHCANOPArrange(opaId,"Sum","O")),"^",2)
       .s tOtherLoss=+$p($g(^DHCANOPArrange(opaId,"Sum","O")),"^",3)
       .q:(fluidInfuseCatCode="Co")&(+tColloid=0)
       .q:(fluidInfuseCatCode="Cr")&(+tCrystalloid=0)
       .q:(fluidInfuseCatCode="NS")&(+tNormalSaline=0)
       .q:(fluidInfuseCatCode="TB")&(+tTotalBloodTransfuse=0)
       .q:(fluidInfuseCatCode="O")&(+tOtherFluid=0)
       .q:(bloodTransCatCode["OWB")&(+tOtherWholeBlood=0)
       .q:(bloodTransCatCode["RBC")&(+tRBCSuspension=0)
       .q:(bloodTransCatCode["P")&(+tPlasma=0)
       .q:(bloodTransCatCode["SWB")&(+tSelfWholeBlood=0)
       .q:(bloodTransCatCode["OC")&(+tOperCollect=0)
       .q:(bloodTransCatCode["BP")&(+tBloodPlatelet=0)
       .q:(bloodTransCatCode["CF")&(+tCoagulationFactor=0)
       .;s flag=0
       .;i toUrineAmount'="" d
       ..;f urineAmt=+fromUrineAmount:1:+toUrineAmount d
       ...;i urineAmt=+tUrineAmt s flag=1
       .s flag=1
       .i (+tUrineAmt<fromUrineAmount)||(+tUrineAmt>toUrineAmount) s flag=0
       .;q:(flag=0)&(toUrineAmount'="")
       .q:flag=0
       .;s flag=0
       .;i toBloodLoss'="" d 
       ..;f bloodLoss=+fromBloodLoss:1:+toBloodLoss d
       ...;i bloodLoss=+tBloodLoss s flag=1
       .;q:(flag=0)&(toBloodLoss'="")
       .s flag=1
       .i (+tBloodLoss<fromBloodLoss)||(+tBloodLoss>toBloodLoss) s flag=0
       .q:flag=0
       .s tOpaId=opaId
       .s tInput=+tColloid+tCrystalloid+tNormalSaline+tTotalBloodTransfuse+tOtherFluid
       .s tOutput=+tUrineAmt+tBloodLoss+tOtherLoss
       .s tIODispersion=tOutput-tInput
       .s tColloidAmt=tColloidAmt+tColloid,tCrystalloidAmt=tCrystalloidAmt+tCrystalloid,tNormalSalineAmt=tNormalSalineAmt+tNormalSaline,tTotalBloodTransfuseAmt=tTotalBloodTransfuseAmt+tTotalBloodTransfuse,tOtherFluidAmt=tOtherFluidAmt+tOtherFluid
       .s tOtherWholeBloodAmt=tOtherWholeBloodAmt+tOtherWholeBlood,tRBCSuspensionAmt=tRBCSuspensionAmt+tRBCSuspension,tPlasmaAmt=tPlasmaAmt+tPlasma,tSelfWholeBloodAmt=tSelfWholeBloodAmt+tSelfWholeBlood,tOperCollectAmt=tOperCollectAmt+tOperCollect,tBloodPlateletAmt=tBloodPlateletAmt+tBloodPlatelet,tCoagulationFactorAmt=tCoagulationFactorAmt+tCoagulationFactor
       .s tUrineAmtAmounts=tUrineAmtAmounts+tUrineAmt,tBloodLossAmt=tBloodLossAmt+tBloodLoss,tOtherLossAmt=tOtherLossAmt+tOtherLoss
       .s tInputAmounts=tInputAmounts+tInput,tOutputAmounts=tOutputAmounts+tOutput,tIODispersionAmt=tIODispersionAmt+tIODispersion
       .s j=j+1
       .s tOther=""
       .;s ^Tmpzt("Data")=tLocDesc_"^"_tSurgeon_"^"_tAssistant_"^"_tAnaesthetist_"^"_tAnaSupervisor_"^"_tAnaAssist_"^"_tScrubNurse_"^"_tCirculNurse_"^"_tASA_"^"_tAnLevel_"^"_tAnMethod_"^"_tAnaDuration_"^"_tOpDuration_"^"_tAnaSourceType_"^"_tPapmiName_"^"_tPatSex_"^"_tPatAge_"^"_tMedicareNo_"^"_tOperName_"^"_tOperDate_"^"_tOtherWholeBlood_"^"_tRBCSuspension_"^"_tPlasma_"^"_tSelfWholeBlood_"^"_tOperCollect_"^"_tBloodPlatelet_"^"_tCoagulationFactor_"^"_tColloid_"^"_tCrystalloid_"^"_tNormalSaline_"^"_tTotalBloodTransfuse_"^"_tOtherFluid_"^"_tUrineAmt_"^"_tBloodLoss
	   .s ^TMPAN("App",$j,tOperDate,j)=$lb(tOther,tLocDesc,tSurgeon,tAssistant,tAnaesthetist,tAnaSupervisor,tAnaAssist,tScrubNurse,tCirculNurse,tASA,tAnLevel,tAnMethod,tAnaDuration,tOpDuration,tAnaSourceType,tPapmiName,tPatSex,tPatAge,tMedicareNo,tOperName,tOperDate,tOtherWholeBlood,tRBCSuspension,tPlasma,tSelfWholeBlood,tOperCollect,tBloodPlatelet,tCoagulationFactor,tColloid,tCrystalloid,tNormalSaline,tTotalBloodTransfuse,tOtherFluid,tUrineAmt,tBloodLoss,tOtherLoss,tInput,tOutput,tIODispersion,tOpaId,tGuardianshipItemDesc,tIndraftDesc,tVenoAnaDesc,tPartAnaDesc,tPaadmType,tPatWeight,tPatHeight,tTheatreTransToDesc,tRecoveryDesc,tIntExtDesc,tIntAnTypeDesc,tIntRouteDesc,tIntTermDesc,tIntVisionDesc)
	}
	do OutRow1
	s tOperDate=""  f  s tOperDate=$O(^TMPAN("App",$j,tOperDate)) q:tOperDate=""  d
	.s j="" f  s j=$O(^TMPAN("App",$j,tOperDate,j)) q:j=""  d
	..do OutRow2
	do OutRow3         
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow1
    set tOther="查询结果数："
    set Data=$lb(tOther,j-1,"例")
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
OutRow2
	;set Data=$lb(ind,tLocDesc,tSurgeon,tAssistant,tAnaesthetist,tAnaSupervisor,tAnaAssist,tScrubNurse,tCirculNurse,tASA,tAnLevel,tAnMethod,tAnaDuration,tOpDuration,tAnaSourceType,tPapmiName,tPatSex,tPatAge,tMedicareNo,tOperName,tOperDate,tOtherWholeBlood,tRBCSuspension,tPlasma,tSelfWholeBlood,tOperCollect,tBloodPlatelet,tCoagulationFactor,tColloid,tCrystalloid,tNormalSaline,tTotalBloodTransfuse,tOtherFluid,tUrineAmt,tBloodLoss)
 	Set ^CacheTemp(repid,ind)=^TMPAN("App",$j,tOperDate,j)
 	Set ind=ind+1
	quit
OutRow3
    set tOther="总量汇总："
    set Data=$lb(tOther,"","","","","","","","","","","","","","","","","","","","",tOtherWholeBloodAmt,tRBCSuspensionAmt,tPlasmaAmt,tSelfWholeBloodAmt,tOperCollectAmt,tBloodPlateletAmt,tCoagulationFactorAmt,tColloidAmt,tCrystalloidAmt,tNormalSalineAmt,tTotalBloodTransfuseAmt,tOtherFluidAmt,tUrineAmtAmounts,tBloodLossAmt,tOtherLossAmt,tInputAmounts,tOutputAmounts,tIODispersionAmt)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod FindAnOpStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnOpStatisticsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAnOpStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnOpStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnOpCostDetails","63487","63487","311","","")
/// 费用明细统计
Query GetAnOpCostDetails(stratdate As %Library.String, enddate As %Library.String, ctlocId As %String, patCtlocDr As %String = "", type As %String = "") As %Query(ROWSPEC = "opaId,arcimRowId,arcimDesc,SumNum,Price,SumPrice,OrdCatId,ordCatDesc,ordCatCode,stratdate,enddate")
{
}

ClassMethod GetAnOpCostDetailsExecute(ByRef qHandle As %Binary, stratdate As %Library.String, enddate As %Library.String, ctlocId As %String, patCtlocDr As %String = "", type As %String = "") As %Status
{
	s ^TMPwull("926")=stratdate_"^"_enddate_"^"_ctlocId_"^"_patCtlocDr_"^"_type
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=stratdate,edate=enddate
	s allSumPrice=0
	s allCost=0,allACost=0,allBCost=0,allCCost=0,allDCost=0,allECost=0,allFCost=0,allGCost=0,allHCost=0,allICost=0,allJCost=0,allKCost=0,allLCost=0,allZCost=0
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s sumCost=0,ACost=0,BCost=0,CCost=0,DCost=0,ECost=0,FCost=0,GCost=0,HCost=0,ICost=0,JCost=0,KCost=0,LCost=0,ZCost=0
		.s patLocId="",patLocDesc="",opLevelCode=""
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.;q:opLocId'=ctlocId
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
    	.q:(patCtlocDr'="")&(patCtlocDr'=patLocId)
		.s oeordRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
		.q:oeordRowId=""
		.s childOEORDRowId="" f  s childOEORDRowId=$O(^OEORD(oeordRowId,"I",childOEORDRowId)) q:childOEORDRowId=""  d
		..s anaDr=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,4)),"^",9)
		..q:anaDr'=anaId
		..s oeordItemStat=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",13)
		..q:oeordItemStat=4
		..s relocId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,3)),"^",6)   //执行科室
		..;w !,relocId
		..q:relocId'=ctlocId
		..s applocId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,7)),"^",2)   //接收科室
		..q:applocId=""
		..s arcItmRowId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",2)  //医嘱RowId
		..s arcItmDesc=$p(^ARCIM($p(arcItmRowId,"||",1),$p(arcItmRowId,"||",2),1),"^",2) //医嘱名
		..s arcItmCode=$p(^ARCIM($p(arcItmRowId,"||",1),$p(arcItmRowId,"||",2),1),"^",1) //医嘱code
		..s admReason=$P($G(^PAADM(EpisodeID),1),"^",7)
		..s exPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("",admReason,arcItmRowId,"","","","","") 
		..s exPrice=$P(exPrice,"^",1)
		..s exPrice=$j(exPrice,3,2)  //单价
  		..s uomId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,2)),"^",3)
  		..i uomId'="" s uomDesc=$p(^CT("UOM",uomId),"^",2)  //单位
  		..e  s uomDesc=""
  		..s exAmount=$P($G(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",12)  //数量
		..s exCosts=exAmount*exPrice
		..s exCosts=$j(exCosts,3,2)  //总价
		..s allSumPrice=allSumPrice+exCosts
		..s allSumPrice=$j(allSumPrice,3,2)
		..s exOeoriDr=oeordRowId_"||"_childOEORDRowId
		..;s exRowId=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr,-1))
		..;q:exRowId=""
		..;s priceStatus=$p($g(^DHCEXDE(exRowId)),"^",17)
		..;q:priceStatus'="1"   //不是已收费状态的除外
		..;s exStatus=$p($g(^DHCEXDE(exRowId)),"^",18)
		..;q:exStatus'="A"
		..;s exAmount=$p($g(^DHCEXDE(exRowId)),"^",8)  //数量
		..;s exPrice=$p($g(^DHCEXDE(exRowId)),"^",9)   //单价
		..;s exCosts=$p($g(^DHCEXDE(exRowId)),"^",10)  //费用
		..s ordCatId=##class(web.DHCCLCom).GetOrdCatId(exOeoriDr)
  		..s ^TMPAN("Stat",$j,ordCatId,arcItmRowId,opaId,exOeoriDr)=exAmount_"^"_exPrice_"^"_exCosts
    }
    
    s ordcatdr="" f  s ordcatdr=$o(^TMPAN("Stat",$j,ordcatdr)) q:ordcatdr=""  d
    .s allNum=0,allCost=0
    .s ordCatCode=$p(^OEC("ORCAT",ordcatdr),"^",1)
  	.s ordCatDesc=$p(^OEC("ORCAT",ordcatdr),"^",2)
  	.i type'="" q:ordcatdr'=type
    .s arcimRowId="" f  s arcimRowId=$o(^TMPAN("Stat",$j,ordcatdr,arcimRowId)) q:arcimRowId=""  d
    ..s SumNum=0,Price=0,SumPrice=0,FirstNum=0,FirstCost=0,SecNum=0,SecCost=0
    ..s opaRowId="" f  s opaRowId=$o(^TMPAN("Stat",$j,ordcatdr,arcimRowId,opaRowId)) q:opaRowId=""  d
    ...s exdr="" f  s exdr=$o(^TMPAN("Stat",$j,ordcatdr,arcimRowId,opaRowId,exdr)) q:exdr=""  d
    ....s FirstNum=$p(^TMPAN("Stat",$j,ordcatdr,arcimRowId,opaRowId,exdr),"^",1)
    ....s Price=$p(^TMPAN("Stat",$j,ordcatdr,arcimRowId,opaRowId,exdr),"^",2)
    ....s FirstCost=$p(^TMPAN("Stat",$j,ordcatdr,arcimRowId,opaRowId,exdr),"^",3)
    ...s SecNum=SecNum+FirstNum
    ...s SecCost=SecCost+FirstCost
    ..s arcimDesc=$p(^ARCIM($p(arcimRowId,"||",1),$p(arcimRowId,"||",2),1),"^",2) //医嘱名
	..;s arcimCode=$p(^ARCIM($p(arcimRowId,"||",1),$p(arcimRowId,"||",2),1),"^",1) //医嘱code
    ..s SumNum=SumNum+SecNum
    ..s SumPrice=SumPrice+SecCost
    ..s allNum=allNum+SumNum
    ..s allCost=allCost+SumPrice
    ..do OutRowAnOpCostDetails
    .s arcimRowId="",arcimDesc="合计",SumNum=allNum,Price="",SumPrice=allCost,OrdCatId=""
    .do OutRowAnOpCostDetails
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowAnOpCostDetails
	set Data=$lb(opaRowId,arcimRowId,arcimDesc,SumNum,Price,SumPrice,OrdCatId,ordCatDesc,ordCatCode,stratdate,enddate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpCostDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpCostDetailsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpCostDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpCostDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnOpWorkingTime","62294","62294","311","","")
/// 工作时间统计
Query GetAnOpWorkingTime(stratdate As %Library.String, enddate As %Library.String, ctlocId As %String) As %Query(ROWSPEC = "arcimRowId,arcimDesc,SumNum,Price,SumPrice,OrdCatId,ordCatDesc,ordCatCode,stratdate,enddate")
{
}

ClassMethod GetAnOpWorkingTimeExecute(ByRef qHandle As %Binary, stratdate As %Library.String, enddate As %Library.String, ctlocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=stratdate,edate=enddate
	s allCost=0,allACost=0,allBCost=0,allCCost=0,allDCost=0,allECost=0,allFCost=0,allGCost=0,allHCost=0,allICost=0,allJCost=0,allKCost=0,allLCost=0,allZCost=0
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s sumCost=0,ACost=0,BCost=0,CCost=0,DCost=0,ECost=0,FCost=0,GCost=0,HCost=0,ICost=0,JCost=0,KCost=0,LCost=0,ZCost=0,opd=""
		.s patLocId="",patLocDesc="",opLevelCode=""
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.q:opLocId'=ctlocId
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
    	.q:(patCtlocDr'="")&(patCtlocDr'=patLocId)
	
		.s oeordRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
		.q:oeordRowId=""
		.s childOEORDRowId="" f  s childOEORDRowId=$O(^OEORD(oeordRowId,"I",childOEORDRowId)) q:childOEORDRowId=""  d
		..s anaDr=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,4)),"^",9)
		..q:anaDr'=anaId
		..s oeordItemStat=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",13)
		..q:oeordItemStat=4
		..s relocId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,3)),"^",6)   //执行科室
		..q:relocId'=ctlocId
		..s applocId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,7)),"^",2)   //接收科室
		..q:applocId=""
		..s arcItmRowId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",2)  //医嘱RowId
		..;s arcItmDesc=$p(^ARCIM($p(arcItmRowId,"||",1),$p(arcItmRowId,"||",2),1),"^",2) //医嘱名
		..;s arcItmCode=$p(^ARCIM($p(arcItmRowId,"||",1),$p(arcItmRowId,"||",2),1),"^",1) //医嘱code
		..s exOeoriDr=oeordRowId_"||"_childOEORDRowId
		..s exRowId=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr,-1))
		..q:exRowId=""
		..s priceStatus=$p($g(^DHCEXDE(exRowId)),"^",17)
		..q:priceStatus'="1"   //不是已收费状态的除外
		..s exStatus=$p($g(^DHCEXDE(exRowId)),"^",18)
		..q:exStatus'="A"
		..s exAmount=$p($g(^DHCEXDE(exRowId)),"^",8)  //数量
		..s exPrice=$p($g(^DHCEXDE(exRowId)),"^",9)   //单价
		..s exCosts=$p($g(^DHCEXDE(exRowId)),"^",10)  //费用
		..s ordCatId=##class(web.DHCCLCom).GetOrdCatId(exOeoriDr)
  		..s ^TMPAN("Stat",$j,ordCatId,arcItmRowId,opaId,exRowId)=exAmount_"^"_exPrice_"^"_exCosts
    }
    
    s ordcatdr="" f  s ordcatdr=$o(^TMPAN("Stat",$j,ordcatdr)) q:ordcatdr=""  d
    .s allNum=0,allCost=0
    .s ordCatCode=$p(^OEC("ORCAT",ordcatdr),"^",1)
  	.s ordCatDesc=$p(^OEC("ORCAT",ordcatdr),"^",2)
    .s arcimRowId="" f  s arcimRowId=$o(^TMPAN("Stat",$j,ordcatdr,arcimRowId)) q:arcimRowId=""  d
    ..s SumNum=0,Price=0,SumPrice=0,FirstNum=0,FirstCost=0,SecNum=0,SecCost=0
    ..s opaRowId="" f  s opaRowId=$o(^TMPAN("Stat",$j,ordcatdr,arcimRowId,opaRowId)) q:opaRowId=""  d
    ...s exdr="" f  s exdr=$o(^TMPAN("Stat",$j,ordcatdr,arcimRowId,opaRowId,exdr)) q:exdr=""  d
    ....s FirstNum=$p(^TMPAN("Stat",$j,ordcatdr,arcimRowId,opaRowId,exdr),"^",1)
    ....s Price=$p(^TMPAN("Stat",$j,ordcatdr,arcimRowId,opaRowId,exdr),"^",2)
    ....s FirstCost=$p(^TMPAN("Stat",$j,ordcatdr,arcimRowId,opaRowId,exdr),"^",3)
    ...s SecNum=SecNum+FirstNum
    ...s SecCost=SecCost+FirstCost
    ..s arcimDesc=$p(^ARCIM($p(arcimRowId,"||",1),$p(arcimRowId,"||",2),1),"^",2) //医嘱名
	..;s arcimCode=$p(^ARCIM($p(arcimRowId,"||",1),$p(arcimRowId,"||",2),1),"^",1) //医嘱code
    ..s SumNum=SumNum+SecNum
    ..s SumPrice=SumPrice+SecCost
    ..s allNum=allNum+SumNum
    ..s allCost=allCost+SumPrice
    ..do OutRowAnOpWorkingTime
    .s arcimRowId="",arcimDesc="合计",SumNum=allNum,Price="",SumPrice=allCost,OrdCatId=""
    .do OutRowAnOpWorkingTime
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowAnOpWorkingTime
	set Data=$lb(arcimRowId,arcimDesc,SumNum,Price,SumPrice,OrdCatId,ordCatDesc,ordCatCode,stratdate,enddate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpWorkingTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpWorkingTimeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpWorkingTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpWorkingTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 麻醉医生工作量明细统计
/// w d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnDocWorkload","62888","62888","116")
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnDocWorkload","62294","62294","52")
Query GetAnDocWorkload(stratdate As %Library.String, enddate As %Library.String, andocId As %String, ctlocId As %String) As %Query(ROWSPEC = "ctctpdr,ctctpdesc,ACount,DCount,ECount,FCount,GCount,HCount,ICount,JCount,KCount,LCount,OCount,PCount,QCount,RCount,SCount,TCount,UCount,WCount,YCount,IASA,IIASA,IIIASA,IVASA,VASA,IClass,IIClass,IIIClass,IVClass,stratdate,enddate,anCountTime")
{
}

ClassMethod GetAnDocWorkloadExecute(ByRef qHandle As %Binary, stratdate As %Library.String, enddate As %Library.String, andocId As %String, ctlocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=stratdate,edate=enddate
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s result=##class(web.DHCANCom).JudgeANStatus(opaId)
		.q:result="N"
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.;s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.;q:opLocId'=ctlocId
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
		.s andocdesc="",ansupdocdesc="",andocassdesc="",annurdesc="",anmethoddesc="",andocassdr="",anTime=0
		.s anmethoddrStr=$p(^OR(EpisodeID,"ANA",anaSub),"^",5)   //麻醉方法
		.q:anmethoddrStr=""
		.s anASADR=$p(^OR(EpisodeID,"ANA",anaSub),"^",26)  //ASA分级
		.q:anASADR=""
		.s opaPAAnaClass=$p(^DHCANOPArrange(opaId,"PA"),"^",88)  //麻醉分级
		.;q:opaPAAnaClass=""
	    .;s inAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
	    .;s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
	    .s anaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",3)
	    .;s opaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",19)
	    .;s opaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",20)
	    .;k ^TEMPwf
	    .;s ^TEMPwf("0307")=opaEndTime
	    .;s anaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",4)
	    .s anaStrDate=$p(^OR(+anaId,"ANA",anaSub),"^",2)
	    .;s anaEndDate=$p(^OR(+anaId,"ANA",anaSub),"^",29)
	    .s anaTheatreInDate=$p(^OR(+anaId,"ANA",anaSub),"^",39)
	    .s anaTheatreOutDate=$p(^OR(+anaId,"ANA",anaSub),"^",41)
		.s anaTheatreOutTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
	    .i anaTheatreOutDate-anaTheatreInDate>5 s anTime=anaTheatreOutTime-anaStartTime
	    .e  s anTime=86400*(anaTheatreOutDate-anaTheatreInDate)+anaTheatreOutTime-anaStartTime
	   	.i anTime<0 s anTime=$p(anTime,"-",2)
	   	.;s ^abc("Date",opaId)=anaStrDate_"*"_anaTheatreOutDate_"*"_anTime
	   	.;s anTime=anaTheatreOutTime-anaStartTime
	    .;s leaveRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
		.s andocdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",6)  //麻醉医师
		.s ansupdocdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",7)  //麻醉指导医师
		.;s annurdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",8)  //麻醉护士
		.s ass="" f  s ass=$o(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass)) q:ass=""  d
		..s andocassdr=andocassdr_$p(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass),"^",1)_"^"  //麻醉助手
		
		.i andocdr'="" d
		..i $l(andocdr,"~")=1 d
		...s andocRowId=$o(^RB("RES",0,"CTPCP",andocdr,ctlocId,""))
		...q:andocRowId=""
		...q:ctlocId'=$p(^RB("RES",andocRowId),"^",1)
		...s ^TMPAN("Stat",$j,andocdr,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,andocdr,"ASA",anASADR))+1
		...;s ^TMPAN("Stat",$j,andocdr,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,andocdr,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,andocdr,"anTime")=+$g(^TMPAN("Stat",$j,andocdr,"anTime"))+anTime
		..e  d
		...s ^TMPAN("Stat",$j,andocdr,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,andocdr,"ASA",anASADR))+1
		...;s ^TMPAN("Stat",$j,andocdr,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,andocdr,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,andocdr,"anTime")=+$g(^TMPAN("Stat",$j,andocdr,"anTime"))+anTime
		.i ansupdocdr'="" d
		..i $l(ansupdocdr,"~")=1 d
		...s supdocId=$o(^RB("RES",0,"CTPCP",ansupdocdr,ctlocId,""))
		...q:supdocId=""
		...q:ctlocId'=$p(^RB("RES",supdocId),"^",1)
		...s ^TMPAN("Stat",$j,ansupdocdr,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,ansupdocdr,"ASA",anASADR))+1
		...;s ^TMPAN("Stat",$j,ansupdocdr,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,ansupdocdr,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,ansupdocdr,"anTime")=+$g(^TMPAN("Stat",$j,ansupdocdr,"anTime"))+anTime
		..e  d
		...s ^TMPAN("Stat",$j,ansupdocdr,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,ansupdocdr,"ASA",anASADR))+1
		...;s ^TMPAN("Stat",$j,ansupdocdr,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,ansupdocdr,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,ansupdocdr,"anTime")=+$g(^TMPAN("Stat",$j,ansupdocdr,"anTime"))+anTime
		.f j=1:1:$l(andocassdr,"^") d
		..s assId=$p(andocassdr,"^",j)
		..q:assId=""
		..i $l(assId,"~")=1 d
		...s assdocdr=$o(^RB("RES",0,"CTPCP",assId,ctlocId,""))
		...q:(assdocdr="")&($l(assId,"~")=1)
		...q:ctlocId'=$p(^RB("RES",assdocdr),"^",1)
		...s ^TMPAN("Stat",$j,assId,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,assId,"ASA",anASADR))+1
		...;s ^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,assId,"anTime")=+$g(^TMPAN("Stat",$j,assId,"anTime"))+anTime
		..e  d
		...s ^TMPAN("Stat",$j,assId,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,assId,"ASA",anASADR))+1
		...;s ^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,assId,"anTime")=+$g(^TMPAN("Stat",$j,assId,"anTime"))+anTime

		.f i=1:1:$l(anmethoddrStr,"|") d
		..s anmethoddr=$p(anmethoddrStr,"|",i)
		..q:anmethoddr=""
		..i andocdr'="" d
		...i $l(andocdr,"~")=1 d
		....s andocRowId=$o(^RB("RES",0,"CTPCP",andocdr,ctlocId,""))
		....q:andocRowId=""
		....q:ctlocId'=$p(^RB("RES",andocRowId),"^",1)
		....s ^TMPAN("Stat",$j,andocdr,"ANMethod",anmethoddr)=+$g(^TMPAN("Stat",$j,andocdr,"ANMethod",anmethoddr))+1
		...e  d
		....s ^TMPAN("Stat",$j,andocdr,"ANMethod",anmethoddr)=+$g(^TMPAN("Stat",$j,andocdr,"ANMethod",anmethoddr))+1
		..i ansupdocdr'="" d
		...i $l(ansupdocdr,"~")=1 d
		....s supdocId=$o(^RB("RES",0,"CTPCP",ansupdocdr,ctlocId,""))
		....q:supdocId=""
		....q:ctlocId'=$p(^RB("RES",supdocId),"^",1)
		....s ^TMPAN("Stat",$j,ansupdocdr,"ANMethod",anmethoddr)=+$g(^TMPAN("Stat",$j,ansupdocdr,"ANMethod",anmethoddr))+1
		...e  d
		....s ^TMPAN("Stat",$j,ansupdocdr,"ANMethod",anmethoddr)=+$g(^TMPAN("Stat",$j,ansupdocdr,"ANMethod",anmethoddr))+1
		..f j=1:1:$l(andocassdr,"^") d
		...s assId=$p(andocassdr,"^",j)
		...q:assId=""
		...i $l(assId,"~")=1 d
		....s assdocdr=$o(^RB("RES",0,"CTPCP",assId,ctlocId,""))
		....q:(assdocdr="")&($l(assId,"~")=1)
		....q:ctlocId'=$p(^RB("RES",assdocdr),"^",1)
		....s ^TMPAN("Stat",$j,assId,"ANMethod",anmethoddr)=+$g(^TMPAN("Stat",$j,assId,"ANMethod",anmethoddr))+1
		....s ^TMPAN("Stat",$j,assId,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,assId,"ASA",anASADR))+1
		....;s ^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass))+1
		....s ^TMPAN("Stat",$j,assId,"anTime")=+$g(^TMPAN("Stat",$j,assId,"anTime"))+anTime
		...e  d
		....s ^TMPAN("Stat",$j,assId,"ANMethod",anmethoddr)=+$g(^TMPAN("Stat",$j,assId,"ANMethod",anmethoddr))+1
		....s ^TMPAN("Stat",$j,assId,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,assId,"ASA",anASADR))+1
		....;s ^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass))+1
		....s ^TMPAN("Stat",$j,assId,"anTime")=+$g(^TMPAN("Stat",$j,assId,"anTime"))+anTime
    }
    s SumACount=0,SumDCount=0,SumECount=0,SumFCount=0,SumGCount=0,SumHCount=0,SumICount=0,SumJCount=0,SumKCount=0,SumLCount=0
    s SumOCount=0,SumPCount=0,SumQCount=0,SumRCount=0,SumSCount=0,SumTCount=0,SumUCount=0,SumWCount=0,SumYCount=0
	s SumIASA=0,SumIIASA=0,SumIIIASA=0,SumIVASA=0,SumVASA=0
	s SumIClass=0,SumIIClass=0,SumIIIClass=0,SumIVClass=0,anCountTime=0
    s ctctpdr="" f  s ctctpdr=$o(^TMPAN("Stat",$j,ctctpdr)) q:ctctpdr=""  d
    .q:(andocId'="")&(ctctpdr'=andocId)
    .s ctctpdesc=##class(web.DHCANOPCom).GetNameById(ctctpdr)
    .s ACount=0,DCount=0,ECount=0,FCount=0,GCount=0,HCount=0,ICount=0,JCount=0,KCount=0,LCount=0
    .s OCount=0,PCount=0,QCount=0,RCount=0,SCount=0,TCount=0,UCount=0,WCount=0,YCount=0
    .s anmethodId="" f  s anmethodId=$o(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId)) q:anmethodId=""  d
    ..s anmethodcode=$p(^ORC("ANMET",anmethodId),"^",1)
    ..i anmethodcode="A" s ACount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="D" s DCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="E" s ECount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="F" s FCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="G" s GCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="H" s HCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="I" s ICount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="J" s JCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="K" s KCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="L" s LCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="O" s OCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="P" s PCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="Q" s QCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="R" s RCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="S" s SCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="T" s TCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="U" s UCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="W" s WCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    ..i anmethodcode="Y" s YCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANMethod",anmethodId))
    .s SumACount=SumACount+ACount
    .s SumDCount=SumDCount+DCount
    .s SumECount=SumECount+ECount
    .s SumFCount=SumFCount+FCount
    .s SumGCount=SumGCount+GCount
    .s SumHCount=SumHCount+HCount
    .s SumICount=SumICount+ICount
    .s SumJCount=SumJCount+JCount
    .s SumKCount=SumKCount+KCount
    .s SumLCount=SumLCount+LCount
    .s SumOCount=SumOCount+OCount
    .s SumPCount=SumPCount+PCount
    .s SumQCount=SumQCount+QCount
    .s SumRCount=SumRCount+RCount
    .s SumSCount=SumSCount+SCount
    .s SumTCount=SumTCount+TCount
    .s SumUCount=SumUCount+UCount
    .s SumWCount=SumWCount+WCount
    .s SumYCount=SumYCount+YCount
    .s IASA=0,IIASA=0,IIIASA=0,IVASA=0,VASA=0
    .s asaId="" f  s asaId=$o(^TMPAN("Stat",$j,ctctpdr,"ASA",asaId)) q:asaId=""  d
    ..s IASA=+$g(^TMPAN("Stat",$j,ctctpdr,"ASA",1))
    ..s IIASA=+$g(^TMPAN("Stat",$j,ctctpdr,"ASA",2))
    ..s IIIASA=+$g(^TMPAN("Stat",$j,ctctpdr,"ASA",3))
    ..s IVASA=+$g(^TMPAN("Stat",$j,ctctpdr,"ASA",4))
    ..s VASA=+$g(^TMPAN("Stat",$j,ctctpdr,"ASA",5))
    .s SumIASA=SumIASA+IASA
    .s SumIIASA=SumIIASA+IIASA
    .s SumIIIASA=SumIIIASA+IIIASA
    .s SumIVASA=SumIVASA+IVASA
    .s SumVASA=SumVASA+VASA       
    .s IClass=0,IIClass=0,IIIClass=0,IVClass=0
    .s anaClass="" f  s anaClass=$o(^TMPAN("Stat",$j,ctctpdr,"PA",anaClass)) q:anaClass=""  d
    ..s IClass=+$g(^TMPAN("Stat",$j,ctctpdr,"PA",1))
    ..s IIClass=+$g(^TMPAN("Stat",$j,ctctpdr,"PA",2))
    ..s IIIClass=+$g(^TMPAN("Stat",$j,ctctpdr,"PA",3))
    ..s IVClass=+$g(^TMPAN("Stat",$j,ctctpdr,"PA",4))
    .s SumIClass=SumIClass+IClass
    .s SumIIClass=SumIIClass+IIClass
    .s SumIIIClass=SumIIIClass+IIIClass
    .s SumIVClass=SumIVClass+IVClass
    .s anCountTime=+$g(^TMPAN("Stat",$j,ctctpdr,"anTime"))
    .s anCountTime=(+anCountTime\3600)_"时"_((+anCountTime-((+anCountTime\3600)*3600))\60)_"分"
    .do OutRowAnDocWorkload
    i andocId="" d
    .s ctctpdr="",ctctpdesc="合计"
    .s ACount=SumACount,DCount=SumDCount,ECount=SumECount,FCount=SumFCount,GCount=SumGCount
    .s HCount=SumHCount,ICount=SumICount,JCount=SumJCount,KCount=SumKCount,LCount=SumLCount
    .s OCount=SumOCount,PCount=SumPCount,QCount=SumQCount,RCount=SumRCount,SCount=SumSCount,TCount=SumTCount
    .s UCount=SumUCount,WCount=SumWCount,YCount=SumYCount
    .s IASA=SumIASA,IIASA=SumIIASA,IIIASA=SumIIIASA,IVASA=SumIVASA,VASA=SumVASA
    .s IClass=SumIClass,IIClass=SumIIClass,IIIClass=SumIIIClass,IVClass=SumIVClass,anCountTime=""
    .do OutRowAnDocWorkload
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowAnDocWorkload
	set Data=$lb(ctctpdr,ctctpdesc,ACount,DCount,ECount,FCount,GCount,HCount,ICount,JCount,KCount,LCount,OCount,PCount,QCount,RCount,SCount,TCount,UCount,WCount,YCount,IASA,IIASA,IIIASA,IVASA,VASA,IClass,IIClass,IIIClass,IVClass,stratdate,enddate,anCountTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnDocWorkloadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnDocWorkloadExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnDocWorkloadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnDocWorkloadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 麻醉医生工作量明细统计
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnDocWorkloadDetails","63453","63453","1434","52")
Query GetAnDocWorkloadDetails(stratdate As %Library.String, enddate As %Library.String, andocId As %String, ctlocId As %String) As %Query(ROWSPEC = "opdate,opaId,oproomdes,opordno,patName,ansupdocdesc,andocdesc,andocassdesc,xshdesc,xchdesc,anTime,andocId,docname,TrainTime,InternsTime,GraduteTime,inPatNo,EpisodeID,hisRegno,patType")
{
}

ClassMethod GetAnDocWorkloadDetailsExecute(ByRef qHandle As %Binary, stratdate As %Library.String, enddate As %Library.String, andocId As %String, ctlocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TMPAN("Stat",$j)
 	k ^TMPAN("anTime",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    ;s ctlocId="52"
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=stratdate,edate=enddate
	s allGraduteTime=0,allInternsTime=0,allTrainTime=0
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s result=##class(web.DHCANCom).JudgeANStatus(opaId)
		.q:result="N"
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.;q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")
		.q:(opaStatus'="F")&(opaStatus'="P")
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s patType=$p(^PAADM(EpisodeID),"^",2)
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.s oproomdes=$p($g(^DHCANC("OPRoom",roomId)),"^",2)
		.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
	    .;i (opordno'="")&(opordno=1) s opdate="8:30"   				//ck  091016
	    .;i (opordno'="")&(opordno'=1) s opdate="接台"_(opordno-1)  	//ck  091016
	    .i opordno'="" d   //20100720 CK湘雅急诊插台用
	    ..i $l(opordno,".")=2 d
	    ...s opordno=(opordno+0.5)_"+"
		.q:opordno=""
		.;s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.;q:opLocId'=ctlocId
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
    	.s inPatNo=$p($g(^PAADM(EpisodeID)),"^",29)
    	.s bedCode="",inPatNo="",admreason=""
		.s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
		.s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
		.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
		.i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
		.s inPatNo=$p($g(^PAADM(EpisodeID)),"^",29)
    	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	    .s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	    .s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
		.s oaRowId=$o(^DHCENSOA("0","PapmiDr",papmiId,""))
		.s hisRegno=$p(^DHCENSOA(oaRowId),"^",4)
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    	
    	.s andocassdr="",careprovdrStr=""
		.s andocdesc="",ansupdocdesc="",andocassdesc="",annurdesc="",anmethoddesc="",xshdesc="",xchdesc="",anTime=0,GraduteTime=0,InternsTime=0,TrainTime=0
		.s anmethoddrStr=$p(^OR(EpisodeID,"ANA",anaSub),"^",5)   //麻醉方法
		.q:anmethoddrStr=""
		.s anASADR=$p(^OR(EpisodeID,"ANA",anaSub),"^",26)  //ASA分级
		.q:anASADR=""
		.s opaPAAnaClass=$p(^DHCANOPArrange(opaId,"PA"),"^",88)  //麻醉分级
		.;q:opaPAAnaClass=""
	    .;s inAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
	    .;s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
	    .s anaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",3)
	    .;s opaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",19)
	    .;s opaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",20)
	    .;s anaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",4)
	    .s anaStrDate=$p(^OR(+anaId,"ANA",anaSub),"^",2)
	    .;s anaEndDate=$p(^OR(+anaId,"ANA",anaSub),"^",29)
	    .s anaTheatreInDate=$p(^OR(+anaId,"ANA",anaSub),"^",39)
	    .s anaTheatreOutDate=$p(^OR(+anaId,"ANA",anaSub),"^",41)
		.s anaTheatreOutTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
		.q:anaTheatreOutTime=""
	    .i anaTheatreOutDate-anaTheatreInDate>5 s anTime=anaTheatreOutTime-anaStartTime
	    .e  s anTime=86400*(anaTheatreOutDate-anaTheatreInDate)+anaTheatreOutTime-anaStartTime
	   	.i anTime<0 s anTime=$p(anTime,"-",2)
	   	.;s ^abc("Date",opaId)=anaStrDate_"*"_anaTheatreOutDate_"*"_anTime
	   	.;s anTime=anaTheatreOutTime-anaStartTime
	    .;s leaveRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
	    
	    .k ^TMPAN("anaTime",$j)
	    .s docname=##class(web.DHCANOPCom).GetNameById(andocId)
		.s andocdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",6)  //麻醉医师
		.i andocdr'="" d
		..s careprovdrStr=careprovdrStr_"^"_andocdr
		..s groupId=##class(web.DHCANArrange).GetGroupIdByUserId(andocdr)
		..s andocdesc=##class(web.DHCANOPCom).GetNameById(andocdr)_"/"_groupId
		..s ^TMPAN("anaTime",$j,andocdr,1)=anTime
		.s ansupdocdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",7)  //麻醉指导医师
		.i ansupdocdr'="" d
		..s careprovdrStr=careprovdrStr_"^"_ansupdocdr
		..s groupId=##class(web.DHCANArrange).GetGroupIdByUserId(ansupdocdr)
		..s ansupdocdesc=##class(web.DHCANOPCom).GetNameById(ansupdocdr)_"/"_groupId		
		..s ^TMPAN("anaTime",$j,ansupdocdr,2)=anTime
		.;s annurdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",8)  //麻醉护士
		.s careprovdrStr=andocdr_"^"_ansupdocdr
		.s ass=0 f  s ass=$o(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass)) q:ass=""  d
		..s andocassdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass),"^",1)  //麻醉助手
		..q:andocassdr=""
		..s careprovdrStr=careprovdrStr_"^"_andocassdr
		..s groupId=##class(web.DHCANArrange).GetGroupIdByUserId(andocassdr)
		..s andocassdesc=andocassdesc_##class(web.DHCANOPCom).GetNameById(andocassdr)_"/"_groupId_" "
		..s ^TMPAN("anaTime",$j,andocassdr,3)=anTime
		
		.s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d
		..s p=0  ;洗手
		..s xs=0 f  s xs=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",xs)) q:(xs="")!(p=3)  d
		...q:xs>20
		...s xsdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",xs),"^",1)
		...q:xsdr=""
		...s careprovdrStr=careprovdrStr_"^"_xsdr
		...s xshdesc=xshdesc_##class(web.DHCANOPCom).GetNameById(xsdr)_" "
		...s p=p+1
		..s p=0  ;巡回
		..s xc=0 f  s xc=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",xc)) q:(xc="")!(p=3)   d
		...q:xc>20
		...s xchdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",xc),"^",1)
		...q:xchdr=""
		...s careprovdrStr=careprovdrStr_"^"_xchdr
		...s xchdesc=xchdesc_##class(web.DHCANOPCom).GetNameById(xchdr)_" "
		...s p=p+1
		
		.q:(andocId'="")&(("^"_careprovdrStr_"^")'[("^"_andocId_"^"))
		.s ^temp12345(1,opaId)=careprovdrStr_"*"_andocId
		.f i=1:1:$l(anmethoddrStr,"|") d
		..s anmethoddr=$p(anmethoddrStr,"|",i)
		..q:anmethoddr=""
		..s anmethoddesc=anmethoddesc_$p($g(^ORC("ANMET",anmethoddr)),"^",2)_" "
		.s opdate=$zd(date,3)
		.i $l(anTime,"-")=2 s anTime=$p(anTime,"-",2)
		.s ^TMPAN("anTime",$j,date,roomId,opordno)=anTime
		.s anTime=(+anTime\3600)_"时"_((+anTime-((+anTime\3600)*3600))\60)_"分"
		
		.i andocId'="" d
		..s TrainTime=$g(^TMPAN("anaTime",$j,andocId,2))   //指导时间
		..s InternsTime=$g(^TMPAN("anaTime",$j,andocId,1))  //主麻时间
		..s GraduteTime=$g(^TMPAN("anaTime",$j,andocId,3))  //助手时间
		..s allGraduteTime=allGraduteTime+GraduteTime
		..s allInternsTime=allInternsTime+InternsTime
		..s allTrainTime=allTrainTime+TrainTime
		..s TrainTime=(+TrainTime\3600)_"时"_((+TrainTime-((+TrainTime\3600)*3600))\60)_"分"
		..s InternsTime=(+InternsTime\3600)_"时"_((+InternsTime-((+InternsTime\3600)*3600))\60)_"分"
    	..s GraduteTime=(+GraduteTime\3600)_"时"_((+GraduteTime-((+GraduteTime\3600)*3600))\60)_"分"
		.s ^TMPAN("Stat",$j,date,roomId,opordno)=$lb(opdate,opaId,oproomdes,opordno,patName,ansupdocdesc,andocdesc,andocassdesc,xshdesc,xchdesc,anTime,andocId,docname,TrainTime,InternsTime,GraduteTime,inPatNo,EpisodeID,hisRegno,patType)
    }
    
    s allTime=0
    s opadate="" f  s opadate=$o(^TMPAN("Stat",$j,opadate)) q:opadate=""  d
    .s roomdr="" f  s roomdr=$o(^TMPAN("Stat",$j,opadate,roomdr)) q:roomdr=""  d
    ..s ord="" f  s ord=$o(^TMPAN("Stat",$j,opadate,roomdr,ord)) q:ord=""  d
    ...s allTime=allTime+^TMPAN("anTime",$j,opadate,roomdr,ord)
    ...do OutRowAnDocWorkloadDetails
    s anTime=(+allTime\3600)_"时"_((+allTime-((+allTime\3600)*3600))\60)_"分"
    s allTrainTime=(+allTrainTime\3600)_"时"_((+allTrainTime-((+allTrainTime\3600)*3600))\60)_"分"
    s allInternsTime=(+allInternsTime\3600)_"时"_((+allInternsTime-((+allInternsTime\3600)*3600))\60)_"分"
    s allGraduteTime=(+allGraduteTime\3600)_"时"_((+allGraduteTime-((+allGraduteTime\3600)*3600))\60)_"分"
    s opadate=+$h,roomdr=10000,ord=100
    s ^TMPAN("Stat",$j,opadate,roomdr,ord)=$lb("合计","","","","","","","","","",anTime,"","",allTrainTime,allInternsTime,allGraduteTime,"","","","")
    do OutRowAnDocWorkloadDetails
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowAnDocWorkloadDetails
	set Data=^TMPAN("Stat",$j,opadate,roomdr,ord)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnDocWorkloadDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnDocWorkloadDetailsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnDocWorkloadDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnDocWorkloadDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnOpTimeDestails","62311","62311","1","anaStartTime","31200","before","311")
/// 手术时间明细
Query GetAnOpTimeDestails(stratdate As %Library.String, enddate As %Library.String, opordno As %Library.String, colCode As %Library.String, time As %Library.String, typeCode As %Library.String, ctlocId As %String) As %Query(ROWSPEC = "patLocDesc,bedNo,patName,roomDesc,ordno,inAreaTime,inRoomTime,anaStartTime,opaStartTime,opaEndTime,anaEndTime,leaveRoomTime,roomId,patLocId,stratdate,enddate,opdocStr,topdate,anMethod,interval")
{
}

ClassMethod GetAnOpTimeDestailsExecute(ByRef qHandle As %Binary, stratdate As %Library.String, enddate As %Library.String, opordno As %Library.String, colCode As %Library.String, time As %Library.String, typeCode As %Library.String, ctlocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TMPAN("Stat",$j)
	k ^TMPAN("Date",$j)
	k ^TMPAN("opaStartTime",$j)
 	i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H-1,edate=+$H-1
	e  s sdate=stratdate,edate=enddate
    f date=sdate:1:edate
    {
	    s allOrdno=0,flag=1,showOrdno=0
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s patLocId="",patLocDesc="",bedNo="",patName="",roomId="",roomDesc="",ordno="",inAreaTime="",inRoomTime="",anaStartTime="",opaStartTime="",opaEndTime="",anaEndTime="",leaveRoomTime="",opdocStr="",ash=""
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.;q:opLocId'=ctlocId
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus="A")!(opaStatus="")!(opaStatus="D")!(opaStatus="N")
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.i roomId'="" s roomDesc=$p($g(^DHCANC("OPRoom",roomId)),"^",2)
		.s ordno=$P(^DHCANOPArrange(opaId),"^",26)
		.q:ordno=""
		
		.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	    .s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
	    .i (bedSub'="")&(curWardId'="") s bedNo=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	    .s patLocId=$P(^PAADM(EpisodeID),"^",4)
	    .q:patLocId=""
	    .s patLocDesc=$P(^CTLOC(patLocId),"^",2)
	    .i $l(patLocDesc,"-")>1 s patLocDesc=$p(patLocDesc,"-",2)
	    .s inAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
	    .s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
	    .s anaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",3)
	    .s opaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",19)
	    .s opaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",20)
	    .s anaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",4)
	    .s leaveRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
	    
	   	.s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)
		.s anmethoddesc=""
		.i anmthdr'="" d
		..s anmetNum=$l(anmthdr,"|")
		..f i=1:1:anmetNum d
		...s anmetId=$p(anmthdr,"|",i)
		...q:anmetId=""
		...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
		...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
		...i anmethoddesc="" s anmethoddesc=anmetDesc
		...e  s anmethoddesc=anmethoddesc_","_anmetDesc
	    
	    .s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42)
	    .s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d 
		..s sub=subchl
		..s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",8)
		..i +docdr=docdr s opd=##class(web.DHCANOPCom).GetNameById(docdr)
		..e  s opd=$TR($p(opaDocNote,"|",2)," ","")
		.q:sub=""
		.s list=0,asName=""
		.s assDocNum=3
		.s p=0
		.s len=$l(opaDocNote,"|")
		.s as=0 f  s as=$O(^OR(EpisodeID,"ANA",anaSub,"OP",sub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
		..s asdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",sub,"ASS",as),"^",1)
		..q:asdr=""
		..s p=p+1
		..i asName="" s asName=##class(web.DHCANOPCom).GetNameById(asdr)
		..e  s asName=asName_"^"_##class(web.DHCANOPCom).GetNameById(asdr)
		.i len>assDocNum+2 s len=assDocNum+2
		.f getLen=3:1:len  d
		..i $p(opaDocNote,"|",getLen)'=""  d
		...s getName=$p(opaDocNote,"|",getLen)
		..e  d
		...s list=list+1
		...s getName=$p(asName,"^",list)
		..i ash="" s ash=getName
		..e  s ash=ash_" "_getName
		.s opdocStr=opd_","_$G(ash)
		.q:(opordno'="")&(ordno'=opordno)
	    .s allOrdno=allOrdno+1  //第几台台次
	    .i ((time'="")&(typeCode'="")) d
	    ..i colCode="inAreaTime" d
	    ...i typeCode="before" d
	    ....i inAreaTime>time s flag=0
	    ....e  s flag=1
	    ...e  d
	    ....i inAreaTime>time s flag=1
	    ....e  s flag=0
	    ..i colCode="inRoomTime" d
	    ...i typeCode="before" d
	    ....i inRoomTime>time s flag=0
	    ....e  s flag=1
	    ...e  d
	    ....i inRoomTime>time s flag=1
	    ....e  s flag=0
	   	..i colCode="anaStartTime" d
	    ...i typeCode="before" d
	    ....i anaStartTime>time s flag=0
	    ....e  s flag=1
	    ...e  d
	    ....i anaStartTime>time s flag=1
	    ....e  s flag=0
	    ..i colCode="opaStartTime" d
	    ...i typeCode="before" d
	    ....i opaStartTime>time s flag=0
	    ....e  s flag=1
	    ...e  d
	    ....i opaStartTime>time s flag=1
	    ....e  s flag=0
	    ..i colCode="opaEndTime" d
	    ...i typeCode="before" d
	    ....i opaEndTime>time s flag=0
	    ....e  s flag=1
	    ...e  d
	    ....i opaEndTime>time s flag=1
	    ....e  s flag=0	    
	    ..i colCode="anaEndTime" d
	    ...i typeCode="before" d
	    ....i anaEndTime>time s flag=0
	    ....e  s flag=1
	    ...e  d
	    ....i anaEndTime>time s flag=1
	    ....e  s flag=0	 
	    ..i colCode="leaveRoomTime" d
	    ...i typeCode="before" d
	    ....i leaveRoomTime>time s flag=0
	    ....e  s flag=1
	    ...e  d
	    ....i leaveRoomTime>time s flag=1
	    ....e  s flag=0	 
	    .q:flag=0
	    .s showOrdno=showOrdno+1
	    .s ^TMPAN("Date",$j,date)=allOrdno_"^"_showOrdno
	    .s ^TMPAN("opaStartTime",$j,date,roomId,ordno)=opaStartTime
	    .i inAreaTime'="" s inAreaTime=$zt(inAreaTime)
	    .i inRoomTime'="" s inRoomTime=$zt(inRoomTime)
	    .i anaStartTime'="" s anaStartTime=$zt(anaStartTime)
	    .i opaStartTime'="" s opaStartTime=$zt(opaStartTime)
	    .i opaEndTime'="" s opaEndTime=$zt(opaEndTime)
	    .i anaEndTime'="" s anaEndTime=$zt(anaEndTime)
	    .i leaveRoomTime'="" s leaveRoomTime=$zt(leaveRoomTime)
		.;s ^TMPAN("Stat",$j,patLocId,roomId,ordno)=patLocDesc_"^"_bedNo_"^"_patName_"^"_roomDesc_"^"_ordno_"^"_inAreaTime_"^"_inRoomTime_"^"_anaStartTime_"^"_opaStartTime_"^"_opaEndTime_"^"_anaEndTime_"^"_leaveRoomTime_"^"_roomId_"^"_patLocId
		.s ^TMPAN("Stat",$j,date,roomId,ordno)=$lb(patLocDesc,bedNo,patName,roomDesc,ordno,inAreaTime,inRoomTime,anaStartTime,opaStartTime,opaEndTime,anaEndTime,leaveRoomTime,roomId,patLocId,stratdate,enddate,opdocStr,anmethoddesc)
		.;s ^TMPAN("Stat",$j,date,roomId,ordno,patLocId)=$lb(patLocDesc,bedNo,patName,roomDesc,ordno,inAreaTime,inRoomTime,anaStartTime,opaStartTime,opaEndTime,anaEndTime,leaveRoomTime,roomId,patLocId,stratdate,enddate,opdocStr,anmethoddesc)
    }
    s colName="",typeName=""
	s ColRowId="" f  s ColRowId=$o(^DHCCLSet("AnOp","TimeDestails","ColName",ColRowId)) q:ColRowId=""  d
	.q:colCode'=$p(^DHCCLSet("AnOp","TimeDestails","ColName",ColRowId),"^",1)
 	.s colName=$p(^DHCCLSet("AnOp","TimeDestails","ColName",ColRowId),"^",2)
 	s TypeRowId="" f  s TypeRowId=$o(^DHCCLSet("AnOp","TimeDestails","Type",TypeRowId)) q:TypeRowId=""  d
	.q:typeCode'=$p(^DHCCLSet("AnOp","TimeDestails","Type",TypeRowId),"^",1)
 	.s typeName=$p(^DHCCLSet("AnOp","TimeDestails","Type",TypeRowId),"^",2) q

    s opaDate="" f  s opaDate=$o(^TMPAN("Stat",$j,opaDate)) q:opaDate=""  d
	.s roomDr="" f  s roomDr=$o(^TMPAN("Stat",$j,opaDate,roomDr)) q:roomDr=""  d
	..s maxOrd=$o(^TMPAN("Stat",$j,opaDate,roomDr,""),-1)
	..s ord="" f  s ord=$o(^TMPAN("Stat",$j,opaDate,roomDr,ord)) q:ord=""  d
	...s nextOrd=""
	...i ord<maxOrd s nextOrd=$o(^TMPAN("Stat",$j,opaDate,roomDr,ord))
	...e  s nextOrd=maxOrd
	...;s locId="" f  s locId=$o(^TMPAN("Stat",$j,opaDate,roomDr,ord,locId)) q:locId=""  d
	...s nextOpaStartTime="",opaEndTime=""
	...s patLocDesc=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),1)
	...s bedNo=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),2)
	...s patName=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),3)
	...s roomDesc=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),4)
	...s ordno=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),5)
	...s inAreaTime=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),6)
	...s inRoomTime=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),7)
	...s anaStartTime=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),8)
	...s opaStartTime=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),9)
	...s opaEndTime=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),10)
	...s anaEndTime=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),11)
	...s leaveRoomTime=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),12)
	...s roomId=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),13)
	...s patLocId=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),14)
	...s stratdate=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),15)
	...s enddate=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),16)
	...s opdocStr=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),17)
	...s topdate=$zd(opaDate,3)
	...s anMethod=$li(^TMPAN("Stat",$j,opaDate,roomDr,ord),18)
	...s interval=""
	...i nextOrd'="" s nextOpaStartTime=$p(^TMPAN("opaStartTime",$j,opaDate,roomDr,nextOrd),"^",1)
	...e  s nextOpaStartTime=""
	...i (nextOpaStartTime="")!(leaveRoomTime="") s interval=""
	...e  d
	....i nextOpaStartTime>$zth(leaveRoomTime) s interval=$zt(nextOpaStartTime-$zth(leaveRoomTime))
	....e  s interval=$zt($zth(leaveRoomTime)-nextOpaStartTime)
	...do OutRowTimeDestails
	.s patLocDesc="",bedNo="",patName="",roomDesc="",ordno="",inAreaTime="",inRoomTime=""
	.s anaStartTime="",opaStartTime="",opaEndTime="",anaEndTime="",leaveRoomTime=""
	.s roomId="",patLocId="",stratdate="",enddate="",anMethod="",interval=""
	.s topdate=$zd(opaDate,3)
	.s allcount=$p(^TMPAN("Date",$j,opaDate),"^",1)
	.s showcount=$p(^TMPAN("Date",$j,opaDate),"^",2)
	.s percentage=$e(showcount/allcount,1,5)*100_"%"
	.s opdocStr=$zd(opaDate,3)_"第"_opordno_"台共"_allcount_"台,"_$zt(time)_typeName_colName_showcount_"台,占"_percentage
	.do OutRowTimeDestails
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowTimeDestails
 	Set ^CacheTemp(repid,ind)=$lb(patLocDesc,bedNo,patName,roomDesc,ordno,inAreaTime,inRoomTime,anaStartTime,opaStartTime,opaEndTime,anaEndTime,leaveRoomTime,roomId,patLocId,stratdate,enddate,opdocStr,topdate,anMethod,interval)
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpTimeDestailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpTimeDestailsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpTimeDestailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpTimeDestailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetColName","ColName")
Query GetColName(type As %String) As %Query(ROWSPEC = "typeCode,typeName")
{
}

ClassMethod GetColNameExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	q:type="" ""
 	s rowId="" f  s rowId=$o(^DHCCLSet("AnOp","TimeDestails",type,rowId)) q:rowId=""  d
 	.s typeCode=$p(^DHCCLSet("AnOp","TimeDestails",type,rowId),"^",1)
 	.s typeName=$p(^DHCCLSet("AnOp","TimeDestails",type,rowId),"^",2)
	.do OutRowColName
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowColName
 	Set ^CacheTemp(repid,ind)=$lb(typeCode,typeName)
 	Set ind=ind+1
	quit
}

ClassMethod GetColNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetColNameExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetColNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetColNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 麻醉医生工作量
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnOpDocWork","62294","62294","52")
Query GetAnOpDocWork(stratdate As %Library.String, enddate As %Library.String, andocId As %String, ctlocId As %String) As %Query(ROWSPEC = "ctctpdr,ctctpdesc,FirstCount,SecondCount,ThrirdCount,FourCount,FiveCount,SixCount,IASA,IIASA,IIIASA,IVASA,VASA,IClass,IIClass,IIIClass,IVClass,stratdate,enddate,anCountTime,SumOrd,andocOrd,superdocOrd,assdocOrd")
{
}

ClassMethod GetAnOpDocWorkExecute(ByRef qHandle As %Binary, stratdate As %Library.String, enddate As %Library.String, andocId As %String, ctlocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=stratdate,edate=enddate
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.;s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.;q:opLocId'=ctlocId
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
		.s andocdesc="",ansupdocdesc="",andocassdesc="",annurdesc="",anmethoddesc="",andocassdr="",anTime=0
		.s anmethoddrStr=$p(^OR(EpisodeID,"ANA",anaSub),"^",5)   //麻醉方法
		.q:anmethoddrStr=""
		.s anASADR=$p(^OR(EpisodeID,"ANA",anaSub),"^",26)  //ASA分级
		.q:anASADR=""
		.s opaPAAnaClass=$p(^DHCANOPArrange(opaId,"PA"),"^",88)  //麻醉分级
		.q:opaPAAnaClass=""
	    .;s inAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
	    .;s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
	    .s anaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",3)
	    .;s opaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",19)
	    .;s opaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",20)
	    .;s anaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",4)
	    .s anaStrDate=$p(^OR(+anaId,"ANA",anaSub),"^",2)
	    .;s anaEndDate=$p(^OR(+anaId,"ANA",anaSub),"^",29)
	    .s anaTheatreInDate=$p(^OR(+anaId,"ANA",anaSub),"^",39)
	    .s anaTheatreOutDate=$p(^OR(+anaId,"ANA",anaSub),"^",41)
		.s anaTheatreOutTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
	    .i anaTheatreOutDate-anaTheatreInDate>5 s anTime=anaTheatreOutTime-anaStartTime
	    .e  s anTime=86400*(anaTheatreOutDate-anaTheatreInDate)+anaTheatreOutTime-anaStartTime
	   	.i anTime<0 s anTime=$p(anTime,"-",2)
	   	.;s anTime=anaTheatreOutTime-anaStartTime
	    .;s leaveRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
		.s andocdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",6)  //麻醉医师
		.s ansupdocdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",7)  //麻醉指导医师
		.;s annurdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",8)  //麻醉护士
		.s ass="" f  s ass=$o(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass)) q:ass=""  d
		..s andocassdr=andocassdr_$p(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass),"^",1)_"^"  //麻醉助手
				
		.i andocdr'="" d
		..i $l(andocdr,"~")=1 d
		...s andocRowId=$o(^RB("RES",0,"CTPCP",andocdr,ctlocId,""))
		...q:andocRowId=""
		...q:ctlocId'=$p(^RB("RES",andocRowId),"^",1)
		...s ^TMPAN("Stat",$j,andocdr,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,andocdr,"ASA",anASADR))+1
		...s ^TMPAN("Stat",$j,andocdr,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,andocdr,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,andocdr,"anTime")=+$g(^TMPAN("Stat",$j,andocdr,"anTime"))+anTime
		...s ^TMPAN("Stat",$j,andocdr,"andoc")=+$g(^TMPAN("Stat",$j,andocdr,"andoc"))+1
		..e  d
		...s ^TMPAN("Stat",$j,andocdr,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,andocdr,"ASA",anASADR))+1
		...s ^TMPAN("Stat",$j,andocdr,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,andocdr,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,andocdr,"anTime")=+$g(^TMPAN("Stat",$j,andocdr,"anTime"))+anTime
		...s ^TMPAN("Stat",$j,andocdr,"andoc")=+$g(^TMPAN("Stat",$j,andocdr,"andoc"))+1
		.i ansupdocdr'="" d
		..i $l(ansupdocdr,"~")=1 d
		...s supdocId=$o(^RB("RES",0,"CTPCP",ansupdocdr,ctlocId,""))
		...q:supdocId=""
		...q:ctlocId'=$p(^RB("RES",supdocId),"^",1)
		...s ^TMPAN("Stat",$j,ansupdocdr,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,ansupdocdr,"ASA",anASADR))+1
		...s ^TMPAN("Stat",$j,ansupdocdr,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,ansupdocdr,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,ansupdocdr,"anTime")=+$g(^TMPAN("Stat",$j,ansupdocdr,"anTime"))+anTime
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc"))+1
		..e  d
		...s ^TMPAN("Stat",$j,ansupdocdr,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,ansupdocdr,"ASA",anASADR))+1
		...s ^TMPAN("Stat",$j,ansupdocdr,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,ansupdocdr,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,ansupdocdr,"anTime")=+$g(^TMPAN("Stat",$j,ansupdocdr,"anTime"))+anTime
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc"))+1
		.f j=1:1:$l(andocassdr,"^") d
		..s assId=$p(andocassdr,"^",j)
		..q:assId=""
		..i $l(assId,"~")=1 d
		...s assdocdr=$o(^RB("RES",0,"CTPCP",assId,ctlocId,""))
		...q:(assdocdr="")&($l(assId,"~")=1)
		...q:ctlocId'=$p(^RB("RES",assdocdr),"^",1)
		...s ^TMPAN("Stat",$j,assId,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,assId,"ASA",anASADR))+1
		...s ^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,assId,"anTime")=+$g(^TMPAN("Stat",$j,assId,"anTime"))+anTime
		...s ^TMPAN("Stat",$j,assId,"assdoc")=+$g(^TMPAN("Stat",$j,assId,"assdoc"))+1
		..e  d
		...s ^TMPAN("Stat",$j,assId,"ASA",anASADR)=+$g(^TMPAN("Stat",$j,assId,"ASA",anASADR))+1
		...s ^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass)=+$g(^TMPAN("Stat",$j,assId,"PA",opaPAAnaClass))+1
		...s ^TMPAN("Stat",$j,assId,"anTime")=+$g(^TMPAN("Stat",$j,assId,"anTime"))+anTime
    	...s ^TMPAN("Stat",$j,assId,"assdoc")=+$g(^TMPAN("Stat",$j,assId,"assdoc"))+1
		
		.f i=1:1:$l(anmethoddrStr,"|") d
		..s anmethoddr=$p(anmethoddrStr,"|",i)
		..q:anmethoddr=""
		..s anaTypeDR=$p(^ORC("ANMET",anmethoddr),"^",3)
		..i andocdr'="" d
		...i $l(andocdr,"~")=1 d
		....s andocRowId=$o(^RB("RES",0,"CTPCP",andocdr,ctlocId,""))
		....q:andocRowId=""
		....q:ctlocId'=$p(^RB("RES",andocRowId),"^",1)
		....s ^TMPAN("Stat",$j,andocdr,"ANAType",anaTypeDR)=+$g(^TMPAN("Stat",$j,andocdr,"ANAType",anaTypeDR))+1
		...e  d
		....s ^TMPAN("Stat",$j,andocdr,"ANAType",anaTypeDR)=+$g(^TMPAN("Stat",$j,andocdr,"ANAType",anaTypeDR))+1
		..i ansupdocdr'="" d
		...i $l(ansupdocdr,"~")=1 d
		....s supdocId=$o(^RB("RES",0,"CTPCP",ansupdocdr,ctlocId,""))
		....q:supdocId=""
		....q:ctlocId'=$p(^RB("RES",supdocId),"^",1)
		....s ^TMPAN("Stat",$j,ansupdocdr,"ANAType",anaTypeDR)=+$g(^TMPAN("Stat",$j,ansupdocdr,"ANAType",anaTypeDR))+1
		...e  d
		....s ^TMPAN("Stat",$j,ansupdocdr,"ANAType",anaTypeDR)=+$g(^TMPAN("Stat",$j,ansupdocdr,"ANAType",anaTypeDR))+1
		..f j=1:1:$l(andocassdr,"^") d
		...s assId=$p(andocassdr,"^",j)
		...q:assId=""
		...i $l(assId,"~")=1 d
		....s assdocdr=$o(^RB("RES",0,"CTPCP",assId,ctlocId,""))
		....q:(assdocdr="")&($l(assId,"~")=1)
		....q:ctlocId'=$p(^RB("RES",assdocdr),"^",1)
		....s ^TMPAN("Stat",$j,assId,"ANAType",anaTypeDR)=+$g(^TMPAN("Stat",$j,assId,"ANAType",anaTypeDR))+1
		...e  d
		....s ^TMPAN("Stat",$j,assId,"ANAType",anaTypeDR)=+$g(^TMPAN("Stat",$j,assId,"ANAType",anaTypeDR))+1
    }
    s SumFirstCount=0,SumSecondCount=0,SumThrirdCount=0,SumFourCount=0,SumFiveCount=0,SumSixCount=0
	s SumIASA=0,SumIIASA=0,SumIIIASA=0,SumIVASA=0,SumVASA=0
	s SumIClass=0,SumIIClass=0,SumIIIClass=0,SumIVClass=0,anCountTime=0
	s SumOrd=0,andocOrd=0,superdocOrd=0,assdocOrd=0,SumandocOrd=0,SumsuperdocOrd=0,SumassdocOrd=0
    s ctctpdr="" f  s ctctpdr=$o(^TMPAN("Stat",$j,ctctpdr)) q:ctctpdr=""  d
    .q:(andocId'="")&(ctctpdr'=andocId)
    .s ctctpdesc=##class(web.DHCANOPCom).GetNameById(ctctpdr)
    .s FirstCount=0,SecondCount=0,ThrirdCount=0,FourCount=0,FiveCount=0,SixCount=0
    .s anaTypeId="" f  s anaTypeId=$o(^TMPAN("Stat",$j,ctctpdr,"ANAType",anaTypeId)) q:anaTypeId=""  d
    ..s anaTypeCode=$p(^ORC("ANTYPE",anaTypeId),"^",1)
    ..s anaTypeDesc=$p(^ORC("ANTYPE",anaTypeId),"^",2)
    ..i anaTypeCode="01" s FirstCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANAType",anaTypeId))
    ..i anaTypeCode="02" s SecondCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANAType",anaTypeId))
    ..i anaTypeCode="03" s ThrirdCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANAType",anaTypeId))
    ..i anaTypeCode="04" s FourCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANAType",anaTypeId))
    ..i anaTypeCode="05" s FiveCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANAType",anaTypeId))
    ..i anaTypeCode="06" s SixCount=+$g(^TMPAN("Stat",$j,ctctpdr,"ANAType",anaTypeId))
    .s SumFirstCount=SumFirstCount+FirstCount
    .s SumSecondCount=SumSecondCount+SecondCount
    .s SumThrirdCount=SumThrirdCount+ThrirdCount
    .s SumFourCount=SumFourCount+FourCount
    .s SumFiveCount=SumFiveCount+FiveCount
    .s SumSixCount=SumSixCount+SixCount
    .s IASA=0,IIASA=0,IIIASA=0,IVASA=0,VASA=0
    .s asaId="" f  s asaId=$o(^TMPAN("Stat",$j,ctctpdr,"ASA",asaId)) q:asaId=""  d
    ..s IASA=+$g(^TMPAN("Stat",$j,ctctpdr,"ASA",1))
    ..s IIASA=+$g(^TMPAN("Stat",$j,ctctpdr,"ASA",2))
    ..s IIIASA=+$g(^TMPAN("Stat",$j,ctctpdr,"ASA",3))
    ..s IVASA=+$g(^TMPAN("Stat",$j,ctctpdr,"ASA",4))
    ..s VASA=+$g(^TMPAN("Stat",$j,ctctpdr,"ASA",5))
    .s SumIASA=SumIASA+IASA
    .s SumIIASA=SumIIASA+IIASA
    .s SumIIIASA=SumIIIASA+IIIASA
    .s SumIVASA=SumIVASA+IVASA
    .s SumVASA=SumVASA+VASA       
    .s SumOrd=IASA+IIASA+IIIASA+IVASA+VASA
    .s IClass=0,IIClass=0,IIIClass=0,IVClass=0
    .s anaClass="" f  s anaClass=$o(^TMPAN("Stat",$j,ctctpdr,"PA",anaClass)) q:anaClass=""  d
    ..s IClass=+$g(^TMPAN("Stat",$j,ctctpdr,"PA",1))
    ..s IIClass=+$g(^TMPAN("Stat",$j,ctctpdr,"PA",2))
    ..s IIIClass=+$g(^TMPAN("Stat",$j,ctctpdr,"PA",3))
    ..s IVClass=+$g(^TMPAN("Stat",$j,ctctpdr,"PA",4))
    .s SumIClass=SumIClass+IClass
    .s SumIIClass=SumIIClass+IIClass
    .s SumIIIClass=SumIIIClass+IIIClass
    .s SumIVClass=SumIVClass+IVClass
    .s anCountTime=+$g(^TMPAN("Stat",$j,ctctpdr,"anTime"))
    .s anCountTime=(+anCountTime\3600)_"时"_((+anCountTime-((+anCountTime\3600)*3600))\60)_"分"
    .s andocOrd=+$g(^TMPAN("Stat",$j,ctctpdr,"andoc"))
    .s superdocOrd=+$g(^TMPAN("Stat",$j,ctctpdr,"superdoc"))
    .s assdocOrd=+$g(^TMPAN("Stat",$j,ctctpdr,"assdoc"))
    .s SumandocOrd=SumandocOrd+andocOrd
    .s SumsuperdocOrd=SumsuperdocOrd+superdocOrd
    .s SumassdocOrd=SumassdocOrd+assdocOrd
    .do OutRowAnOpDocWork
    i andocId="" d
    .s ctctpdr="",ctctpdesc="合计"
    .s FirstCount=SumFirstCount,SecondCount=SumSecondCount,ThrirdCount=SumThrirdCount,FourCount=SumFourCount,FiveCount=SumFiveCount,SixCount=SumSixCount
    .s IASA=SumIASA,IIASA=SumIIASA,IIIASA=SumIIIASA,IVASA=SumIVASA,VASA=SumVASA
    .s IClass=SumIClass,IIClass=SumIIClass,IIIClass=SumIIIClass,IVClass=SumIVClass,anCountTime=""
    .s SumOrd=SumIASA+SumIIASA+SumIIIASA+SumIVASA+SumVASA
    .s andocOrd=SumandocOrd,superdocOrd=SumsuperdocOrd,assdocOrd=SumassdocOrd
    .do OutRowAnOpDocWork
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowAnOpDocWork
	set Data=$lb(ctctpdr,ctctpdesc,FirstCount,SecondCount,ThrirdCount,FourCount,FiveCount,SixCount,IASA,IIASA,IIIASA,IVASA,VASA,IClass,IIClass,IIIClass,IVClass,stratdate,enddate,anCountTime,SumOrd)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpDocWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpDocWorkExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpDocWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpDocWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetAnDocDailyReport(stratdate As %Library.String, enddate As %Library.String, ctlocId As %String)
{
	;n (stratdate,enddate,ctlocId)
	s ^abcd(1)=stratdate_"*"_enddate_"*"_ctlocId
 	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  d
	.s sdate=##Class(web.DHCCLCom).ConvertToDateH(stratdate)
	.s edate=##Class(web.DHCCLCom).ConvertToDateH(enddate)
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")&(opaStatus'="L")&(opaStatus'="R")&(opaStatus'="I")
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
		.s jz=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)  //"E="急诊" B="择期"
		.s andrStr=$p(^OR(EpisodeID,"ANA",anaSub),"^",5)   //麻醉方法
		.q:andrStr=""
		.s anPaClass=$p(^DHCANOPArrange(opaId,"PA"),"^",88)  //麻醉分级
		.q:anPaClass=""
		.f i=1:1:$l(andrStr,"|") d
		..s andr=$p(andrStr,"|",i)
		..q:andr=""
		..s antypedr=$p(^ORC("ANMET",andr),"^",3)  //麻醉分类ID		
		..s ^TMPAN("Stat",$j,"Reprot",antypedr,anPaClass,jz)=+$g(^TMPAN("Stat",$j,"Reprot",antypedr,anPaClass,jz))+1
    }
    
    s SIB=0,SIE=0,SIIB=0,SIIE=0,SIIIB=0,SIIIE=0,SIVB=0,SIVE=0,STB=0,STE=0
    s antypeId="" f  s antypeId=$o(^TMPAN("Stat",$j,"Reprot",antypeId)) q:antypeId=""  d
    .s retStr="",antypedesc="",IB=0,IE=0,IIB=0,IIE=0,IIIB=0,IIIE=0,IVB=0,IVE=0,TB=0,TE=0
    .s antypedesc=$p(^ORC("ANTYPE",antypeId),"^",2)
    .s IB=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"1","B"))
    .s IE=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"1","E"))
    .s IIB=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"2","B"))
    .s IIE=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"2","E"))
    .s IIIB=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"3","B"))
    .s IIIE=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"3","E"))
    .s IVB=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"4","B"))
    .s IVE=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"4","E"))
    .s TB=IB+IIB+IIIB+IVB
    .s TE=IE+IIE+IIIE+IVE
    .s SIB=SIB+IB
    .s SIE=SIE+IE
    .s SIIB=SIIB+IIB
    .s SIIE=SIIE+IIE
    .s SIIIB=SIIIB+IIIB
    .s SIIIE=SIIIE+IIIE
    .s SIVB=SIVB+IVB
    .s SIVE=SIVE+IVE
    .s STB=SIB+SIIB+SIIIB+SIVB
    .s STE=SIE+SIIE+SIIIE+SIVE
    .s retStr=antypedesc_"^"_IB_"^"_IE_"^"_IIB_"^"_IIE_"^"_IIIB_"^"_IIIE_"^"_IVB_"^"_IVE_"^"_TB_"^"_TE
    .s retval="LoadReport"_"('"_$ZCVT(retStr,"O","JS")_"');"
    .&javascript<#(retval)#>
    s retStr="合计"_"^"_SIB_"^"_SIE_"^"_SIIB_"^"_SIIE_"^"_SIIIB_"^"_SIIIE_"^"_SIVB_"^"_SIVE_"^"_STB_"^"_STE
    s retval="LoadReport"_"('"_$ZCVT(retStr,"O","JS")_"');"
  	&javascript<#(retval)#>
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnDocDailyReport1","62294","62294","52")
Query GetAnDocDailyReport1(stratdate As %Library.String, enddate As %Library.String, ctlocId As %String) As %Query(ROWSPEC = "antypeId,antypedesc,IB,IE,IIB,IIE,IIIB,IIIE,IVB,IVE,TB,TE")
{
}

ClassMethod GetAnDocDailyReport1Execute(ByRef qHandle As %Binary, stratdate As %Library.String, enddate As %Library.String, ctlocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  d
	.s sdate=##Class(web.DHCCLCom).ConvertToDateH(stratdate)
	.s edate=##Class(web.DHCCLCom).ConvertToDateH(enddate)
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")&(opaStatus'="L")&(opaStatus'="R")&(opaStatus'="I")
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
		.s jz=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)  //"E="急诊" B="择期"
		.s andrStr=$p(^OR(EpisodeID,"ANA",anaSub),"^",5)   //麻醉方法
		.q:andrStr=""
		.s anPaClass=$p(^DHCANOPArrange(opaId,"PA"),"^",88)  //麻醉分级
		.q:anPaClass=""
		.f i=1:1:$l(andrStr,"|") d
		..s andr=$p(andrStr,"|",i)
		..q:andr=""
		..s antypedr=$p(^ORC("ANMET",andr),"^",3)  //麻醉分类ID		
		..s ^TMPAN("Stat",$j,"Reprot",antypedr,anPaClass,jz)=+$g(^TMPAN("Stat",$j,"Reprot",antypedr,anPaClass,jz))+1
    }
    
    s j=0
    s SIB=0,SIE=0,SIIB=0,SIIE=0,SIIIB=0,SIIIE=0,SIVB=0,SIVE=0,STB=0,STE=0
    s antypeId="" f  s antypeId=$o(^TMPAN("Stat",$j,"Reprot",antypeId)) q:antypeId=""  d
    .s retStr="",antypedesc="",IB=0,IE=0,IIB=0,IIE=0,IIIB=0,IIIE=0,IVB=0,IVE=0,TB=0,TE=0
    .s antypedesc=$p(^ORC("ANTYPE",antypeId),"^",2)
    .s IB=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"1","B"))
    .s IE=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"1","E"))
    .s IIB=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"2","B"))
    .s IIE=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"2","E"))
    .s IIIB=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"3","B"))
    .s IIIE=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"3","E"))
    .s IVB=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"4","B"))
    .s IVE=+$g(^TMPAN("Stat",$j,"Reprot",antypeId,"4","E"))
    .s TB=IB+IIB+IIIB+IVB
    .s TE=IE+IIE+IIIE+IVE
    .s SIB=SIB+IB
    .s SIE=SIE+IE
    .s SIIB=SIIB+IIB
    .s SIIE=SIIE+IIE
    .s SIIIB=SIIIB+IIIB
    .s SIIIE=SIIIE+IIIE
    .s SIVB=SIVB+IVB
    .s SIVE=SIVE+IVE
    .s STB=SIB+SIIB+SIIIB+SIVB
    .s STE=SIE+SIIE+SIIIE+SIVE
    .s j=j+1
    .s ^TMPAN("Stat",$j,"Output",j)=$lb(antypeId,antypedesc,IB,IE,IIB,IIE,IIIB,IIIE,IVB,IVE,TB,TE)
    s j=j+1
    s ^TMPAN("Stat",$j,"Output",j)=$lb("","合计",SIB,SIE,SIIB,SIIE,SIIIB,SIIIE,SIVB,SIVE,STB,STE)
    s j=j+1
    s ^TMPAN("Stat",$j,"Output",j)=$lb("","急救插管","","","","","","","","","","")
    s j=j+1
    s ^TMPAN("Stat",$j,"Output",j)=$lb("","深静脉置管","","","","","","","","","","")
    s j=j+1
    s ^TMPAN("Stat",$j,"Output",j)=$lb("","日间手术麻醉","","","","","","","","","","")
    s j=j+1
    s ^TMPAN("Stat",$j,"Output",j)=$lb("","满意",SIB,SIE,SIIB,SIIE,SIIIB,SIIIE,SIVB,SIVE,STB,STE)
    s j=j+1
    s ^TMPAN("Stat",$j,"Output",j)=$lb("","不满意",0,0,0,0,0,0,0,0,0,0)
    s j=j+1
    s ^TMPAN("Stat",$j,"Output",j)=$lb("","失败",0,0,0,0,0,0,0,0,0,0)
    
    s j="" f  s j=$o(^TMPAN("Stat",$j,"Output",j)) q:j=""  d
    .do OutRowAnOpDocWork
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowAnOpDocWork
	Set ^CacheTemp(repid,ind)=^TMPAN("Stat",$j,"Output",j)
	//set Data=$lb(ctctpdr,ctctpdesc,FirstCount,SecondCount,ThrirdCount,FourCount,FiveCount,SixCount,IASA,IIASA,IIIASA,IVASA,VASA,IClass,IIClass,IIIClass,IVClass,stratdate,enddate,anCountTime,SumOrd)
 	//Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnDocDailyReport1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnDocDailyReport1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnDocDailyReport1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnDocDailyReport1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 麻醉医生收费统计
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnDocChargeStatistics","62294","62294","","52")
Query GetAnDocChargeStatistics(stratdate As %Library.String, enddate As %Library.String, userId As %String, ctlocId As %String) As %Query(ROWSPEC = "docname,allOrd,allAmount,allGCost,allABCost,allICost,allOtherCost,supdocOrd,supdocAmount,IIASA,andocOrd,andocAmount,singleOrd,singleAmount")
{
}

ClassMethod GetAnDocChargeStatisticsExecute(ByRef qHandle As %Binary, stratdate As %Library.String, enddate As %Library.String, userId As %String, ctlocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=stratdate,edate=enddate
	s i=1
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")
		.s Amount=0,GCost=0,ABCost=0,ICost=0,OtherCost=0
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
		.s careprovdrStr="",andocdesc="",ansupdocdesc="",andocassdesc="",annurdesc="",anmethoddesc="",andocassdr="",anTime=0
		.s anmethoddrStr=$p(^OR(EpisodeID,"ANA",anaSub),"^",5)   //麻醉方法
		.q:anmethoddrStr=""
		.s anASADR=$p(^OR(EpisodeID,"ANA",anaSub),"^",26)  //ASA分级
		.q:anASADR=""
		.s opaPAAnaClass=$p(^DHCANOPArrange(opaId,"PA"),"^",88)  //麻醉分级
		.q:opaPAAnaClass=""
	    .;s inAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
	    .;s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
	    .s anaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",3)
	    .;s opaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",19)
	    .;s opaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",20)
	    .;s anaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",4)
	    .s anaStrDate=$p(^OR(+anaId,"ANA",anaSub),"^",2)
	    .;s anaEndDate=$p(^OR(+anaId,"ANA",anaSub),"^",29)
	    .s anaTheatreInDate=$p(^OR(+anaId,"ANA",anaSub),"^",39)
	    .s anaTheatreOutDate=$p(^OR(+anaId,"ANA",anaSub),"^",41)
		.s anaTheatreOutTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
	    .i anaTheatreOutDate-anaTheatreInDate>5 s anTime=anaTheatreOutTime-anaStartTime
	    .e  s anTime=86400*(anaTheatreOutDate-anaTheatreInDate)+anaTheatreOutTime-anaStartTime
	   	.i anTime<0 s anTime=$p(anTime,"-",2)
	   	.;s anTime=anaTheatreOutTime-anaStartTime
	    .;s leaveRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
		.//1sumCost_"^"_2ACost_"^"_3BCost_"^"_4CCost_"^"_5DCost_"^"_6ECost_"^"_7FCost_"^"_
		.//8GCost_"^"_9HCost_"^"_10ICost_"^"_11JCost_"^"_12KCost_"^"_13LCost_"^"_14ZCost
		.s anopCost=##class(web.DHCANOPStatistics).GetAnOpCostByOpaId(opaId,ctlocId)
    	.s Amount=$p(anopCost,"^",1)
		.s GCost=$p(anopCost,"^",8)
		.s ABCost=$p(anopCost,"^",2)+$p(anopCost,"^",3)
		.s ICost=$p(anopCost,"^",10)
		.s OtherCost=$p(anopCost,"^",4)+$p(anopCost,"^",5)+$p(anopCost,"^",6)+$p(anopCost,"^",7)+$p(anopCost,"^",9)+$p(anopCost,"^",11)+$p(anopCost,"^",12)+$p(anopCost,"^",13)+$p(anopCost,"^",14)
		.s andocdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",6)  //麻醉医师
		.i andocdr'="" s careprovdrStr=careprovdrStr_"^"_andocdr
		.s ansupdocdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",7)  //麻醉指导医师
		.i ansupdocdr'="" s careprovdrStr=careprovdrStr_"^"_ansupdocdr
		.;s annurdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",8)  //麻醉护士
		.s ass=0 f  s ass=$o(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass)) q:ass=""  d
		..s andocassdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass),"^",1)  //麻醉助手
		..q:andocassdr=""
		..s careprovdrStr=careprovdrStr_"^"_andocassdr
		..;s groupId=##class(web.DHCANArrange).GetGroupIdByUserId(andocassdr)
		..;s andocassdesc=andocassdesc_##class(web.DHCANOPCom).GetNameById(andocassdr)_"/"_groupId_" "
		.;s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d
		..;s p=0  ;洗手
		..;s xs=0 f  s xs=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",xs)) q:(xs="")!(p=3)  d
		...;q:xs>20
		...;s xsdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",xs),"^",1)
		...;q:xsdr=""
		...;s careprovdrStr=careprovdrStr_"^"_xsdr
		...;s xshdesc=xshdesc_##class(web.DHCANOPCom).GetNameById(xsdr)_" "
		...;s p=p+1
		..;s p=0  ;巡回
		..;s xc=0 f  s xc=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",xc)) q:(xc="")!(p=3)   d
		...;q:xc>20
		...;s xchdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",xc),"^",1)
		...;q:xchdr=""
		...;s careprovdrStr=careprovdrStr_"^"_xchdr
		...;s xchdesc=xchdesc_##class(web.DHCANOPCom).GetNameById(xchdr)_" "
		...;s p=p+1
		.i andocdr'="" d
		..i $l(andocdr,"~")=1 d
		...s andocRowId=$o(^RB("RES",0,"CTPCP",andocdr,ctlocId,""))
		...q:andocRowId=""
		...q:ctlocId'=$p(^RB("RES",andocRowId),"^",1)
		...s ^TMPAN("Stat",$j,andocdr,"andoc","anTime")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","anTime"))+anTime
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ord")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","ord"))+1
		...s ^TMPAN("Stat",$j,andocdr,"andoc","amount")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","amount"))+Amount
		...s ^TMPAN("Stat",$j,andocdr,"andoc","GCost")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","GCost"))+GCost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ABCost")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","ABCost"))+ABCost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ICost")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","ICost"))+ICost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","OtherCost")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","OtherCost"))+OtherCost
		..e  d
		...s ^TMPAN("Stat",$j,andocdr,"andoc","anTime")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","anTime"))+anTime
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ord")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","ord"))+1
		...s ^TMPAN("Stat",$j,andocdr,"andoc","amount")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","amount"))+Amount
		...s ^TMPAN("Stat",$j,andocdr,"andoc","GCost")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","GCost"))+GCost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ABCost")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","ABCost"))+ABCost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ICost")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","ICost"))+ICost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","OtherCost")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","OtherCost"))+OtherCost
		.i ansupdocdr'="" d
		..i $l(ansupdocdr,"~")=1 d
		...s supdocId=$o(^RB("RES",0,"CTPCP",ansupdocdr,ctlocId,""))
		...q:supdocId=""
		...q:ctlocId'=$p(^RB("RES",supdocId),"^",1)
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","anTime")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","anTime"))+anTime
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ord")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","ord"))+1
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","amount")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","amount"))+Amount
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","GCost")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","GCost"))+GCost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ABCost")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","ABCost"))+ABCost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ICost")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","ICost"))+ICost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","OtherCost")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","OtherCost"))+OtherCost
		..e  d
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","anTime")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","anTime"))+anTime
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ord")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","ord"))+1
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","amount")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","amount"))+Amount
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","GCost")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","GCost"))+GCost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ABCost")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","ABCost"))+ABCost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ICost")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","ICost"))+ICost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","OtherCost")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","OtherCost"))+OtherCost
		.f j=1:1:$l(andocassdr,"^") d
		..s assId=$p(andocassdr,"^",j)
		..q:assId=""
		..i $l(assId,"~")=1 d
		...s assdocdr=$o(^RB("RES",0,"CTPCP",assId,ctlocId,""))
		...q:(assdocdr="")&($l(assId,"~")=1)
		...q:ctlocId'=$p(^RB("RES",assdocdr),"^",1)
		...s ^TMPAN("Stat",$j,assId,"assdoc","anTime")=+$g(^TMPAN("Stat",$j,assId,"assdoc","anTime"))+anTime
		...s ^TMPAN("Stat",$j,assId,"assdoc","ord")=+$g(^TMPAN("Stat",$j,assId,"assdoc","ord"))+1
		...s ^TMPAN("Stat",$j,assId,"assdoc","amount")=+$g(^TMPAN("Stat",$j,assId,"assdoc","amount"))+Amount
		...s ^TMPAN("Stat",$j,assId,"assdoc","GCost")=+$g(^TMPAN("Stat",$j,assId,"assdoc","GCost"))+GCost
		...s ^TMPAN("Stat",$j,assId,"assdoc","ABCost")=+$g(^TMPAN("Stat",$j,assId,"assdoc","ABCost"))+ABCost
		...s ^TMPAN("Stat",$j,assId,"assdoc","ICost")=+$g(^TMPAN("Stat",$j,assId,"assdoc","ICost"))+ICost
		...s ^TMPAN("Stat",$j,assId,"assdoc","OtherCost")=+$g(^TMPAN("Stat",$j,assId,"assdoc","OtherCost"))+OtherCost
		..e  d
		...s ^TMPAN("Stat",$j,assId,"assdoc","anTime")=+$g(^TMPAN("Stat",$j,assId,"assdoc","anTime"))+anTime
    	...s ^TMPAN("Stat",$j,assId,"assdoc","ord")=+$g(^TMPAN("Stat",$j,assId,"assdoc","ord"))+1
		...s ^TMPAN("Stat",$j,assId,"assdoc","amount")=+$g(^TMPAN("Stat",$j,assId,"assdoc","amount"))+Amount
		...s ^TMPAN("Stat",$j,assId,"assdoc","GCost")=+$g(^TMPAN("Stat",$j,assId,"assdoc","GCost"))+GCost
		...s ^TMPAN("Stat",$j,assId,"assdoc","ABCost")=+$g(^TMPAN("Stat",$j,assId,"assdoc","ABCost"))+ABCost
		...s ^TMPAN("Stat",$j,assId,"assdoc","ICost")=+$g(^TMPAN("Stat",$j,assId,"assdoc","ICost"))+ICost
		...s ^TMPAN("Stat",$j,assId,"assdoc","OtherCost")=+$g(^TMPAN("Stat",$j,assId,"andoc","OtherCost"))+OtherCost
		.i $l(careprovdrStr,"^")=2 d
		..s ^TMPAN("Stat",$j,$p(careprovdrStr,"^",2),"single","ord",i)=1 //独立
		..s ^TMPAN("Stat",$j,$p(careprovdrStr,"^",2),"single","amount",i)=Amount
    	.s i=i+1
    }
    s retstr=""
    s docname="",allOrd=0,allAmount=0,allGCost=0,allABCost=0,allICost=0,allOtherCost=0
    s supdocOrd=0,supdocAmount=0,andocOrd=0,andocAmount=0
    s andocId=0 f  s andocId=$o(^TMPAN("Stat",$j,andocId)) q:andocId=""  d
    .q:(userId'="")&(andocId'=userId)
    .s docname=##class(web.DHCANOPCom).GetNameById(andocId)
    .s allOrd=+$g(^TMPAN("Stat",$j,andocId,"andoc","ord"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","ord")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","ord")))
    .s allAmount=+$g(^TMPAN("Stat",$j,andocId,"andoc","amount"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","amount")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","amount")))
    .s allGCost=+$g(^TMPAN("Stat",$j,andocId,"andoc","GCost"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","GCost")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","GCost")))
    .s allABCost=+$g(^TMPAN("Stat",$j,andocId,"andoc","ABCost"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","ABCost")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","ABCost")))
    .s allICost=+$g(^TMPAN("Stat",$j,andocId,"andoc","ICost"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","ICost")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","ICost")))
    .s allOtherCost=+$g(^TMPAN("Stat",$j,andocId,"andoc","OtherCost"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","OtherCost")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","OtherCost")))
    .s supdocOrd=+$g(^TMPAN("Stat",$j,andocId,"superdoc","ord"))
    .s supdocAmount=+$g(^TMPAN("Stat",$j,andocId,"superdoc","amount"))
    .s andocOrd=+$g(^TMPAN("Stat",$j,andocId,"andoc","ord"))
    .s andocAmount=+$g(^TMPAN("Stat",$j,andocId,"andoc","amount"))
    .s singleOrd=0,singleAmount=0
    .s k=0 f  s k=$o(^TMPAN("Stat",$j,andocId,"single","ord",k)) q:k=""  d
    ..s singleOrd=singleOrd+(+$g(^TMPAN("Stat",$j,andocId,"single","ord",k)))
    ..s singleAmount=singleAmount+(+$g(^TMPAN("Stat",$j,andocId,"single","amount",k)))
    ..;s retstr=docname_"^"_allOrd_"^"_allAmount_"^"_allGCost_"^"_allABCost_"^"_allICost_"^"_allOtherCost_"^"_supdocOrd_"^"_supdocAmount_"^"_andocOrd_"^"_andocAmount_"^"_singleOrd_"^"_singleAmount
    .do OutRowAnDocChargeStatistics
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowAnDocChargeStatistics
	set Data=$lb(docname,allOrd,allAmount,allGCost,allABCost,allICost,allOtherCost,supdocOrd,supdocAmount,IIASA,andocOrd,andocAmount,singleOrd,singleAmount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnDocChargeStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnDocChargeStatisticsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnDocChargeStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnDocChargeStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据用户ID获取用户一段时间内的工作信息，包括总台次金额，各项分类费用，指导台次金额，主麻台次金额，独立台次金额
ClassMethod GetUserWorkInfo(stratdate As %Library.String, enddate As %Library.String, userId As %String) As %String
{
	q:userId="" "用户ID不能为空!"
	k ^TMPAN("Stat",$j)
    i ctlocId=""  s ctlocId=%session.Data("LOGON.CTLOCID")
    i (stratdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=stratdate,edate=enddate
	s i=1

    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")
		.s Amount=0,GCost=0,ABCost=0,ICost=0,OtherCost=0
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    	.q:patLocId=""
		.s careprovdrStr="",andocdesc="",ansupdocdesc="",andocassdesc="",annurdesc="",anmethoddesc="",andocassdr="",anTime=0
		.s anmethoddrStr=$p(^OR(EpisodeID,"ANA",anaSub),"^",5)   //麻醉方法
		.q:anmethoddrStr=""
		.s anASADR=$p(^OR(EpisodeID,"ANA",anaSub),"^",26)  //ASA分级
		.q:anASADR=""
		.s opaPAAnaClass=$p(^DHCANOPArrange(opaId,"PA"),"^",88)  //麻醉分级
		.q:opaPAAnaClass=""
	    .;s inAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
	    .;s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
	    .s anaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",3)
	    .;s opaStartTime=$p(^OR(+anaId,"ANA",anaSub),"^",19)
	    .;s opaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",20)
	    .;s anaEndTime=$p(^OR(+anaId,"ANA",anaSub),"^",4)
	    .s anaStrDate=$p(^OR(+anaId,"ANA",anaSub),"^",2)
	    .;s anaEndDate=$p(^OR(+anaId,"ANA",anaSub),"^",29)
	    .s anaTheatreInDate=$p(^OR(+anaId,"ANA",anaSub),"^",39)
	    .s anaTheatreOutDate=$p(^OR(+anaId,"ANA",anaSub),"^",41)
		.s anaTheatreOutTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
	    .i anaTheatreOutDate-anaTheatreInDate>5 s anTime=anaTheatreOutTime-anaStartTime
	    .e  s anTime=86400*(anaTheatreOutDate-anaTheatreInDate)+anaTheatreOutTime-anaStartTime
	   	.i anTime<0 s anTime=$p(anTime,"-",2)
	   	.;s anTime=anaTheatreOutTime-anaStartTime
	    .;s leaveRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
		.//1sumCost_"^"_2ACost_"^"_3BCost_"^"_4CCost_"^"_5DCost_"^"_6ECost_"^"_7FCost_"^"_
		.//8GCost_"^"_9HCost_"^"_10ICost_"^"_11JCost_"^"_12KCost_"^"_13LCost_"^"_14ZCost
		.s anopCost=##class(web.DHCANOPStatistics).GetAnOpCostByOpaId(opaId,ctlocId)
    	.s Amount=$p(anopCost,"^",1)
		.s GCost=$p(anopCost,"^",8)
		.s ABCost=$p(anopCost,"^",2)+$p(anopCost,"^",3)
		.s ICost=$p(anopCost,"^",10)
		.s OtherCost=$p(anopCost,"^",4)+$p(anopCost,"^",5)+$p(anopCost,"^",6)+$p(anopCost,"^",7)+$p(anopCost,"^",9)+$p(anopCost,"^",11)+$p(anopCost,"^",12)+$p(anopCost,"^",13)+$p(anopCost,"^",14)
		.s andocdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",6)  //麻醉医师
		.i andocdr'="" d
		..s careprovdrStr=careprovdrStr_"^"_andocdr
		..s groupId=##class(web.DHCANArrange).GetGroupIdByUserId(andocdr)
		..s andocdesc=##class(web.DHCANOPCom).GetNameById(andocdr)_"/"_groupId
		.s ansupdocdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",7)  //麻醉指导医师
		.i ansupdocdr'="" d
		..s careprovdrStr=careprovdrStr_"^"_ansupdocdr
		..s groupId=##class(web.DHCANArrange).GetGroupIdByUserId(ansupdocdr)
		..s ansupdocdesc=##class(web.DHCANOPCom).GetNameById(ansupdocdr)_"/"_groupId		
		.;s annurdr=$p(^OR(EpisodeID,"ANA",anaSub),"^",8)  //麻醉护士
		.s ass=0 f  s ass=$o(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass)) q:ass=""  d
		..s andocassdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",1,"ANASS",ass),"^",1)  //麻醉助手
		..q:andocassdr=""
		..s careprovdrStr=careprovdrStr_"^"_andocassdr
		..s groupId=##class(web.DHCANArrange).GetGroupIdByUserId(andocassdr)
		..s andocassdesc=andocassdesc_##class(web.DHCANOPCom).GetNameById(andocassdr)_"/"_groupId_" "
		.;s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d
		..;s p=0  ;洗手
		..;s xs=0 f  s xs=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",xs)) q:(xs="")!(p=3)  d
		...;q:xs>20
		...;s xsdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",xs),"^",1)
		...;q:xsdr=""
		...;s careprovdrStr=careprovdrStr_"^"_xsdr
		...;s xshdesc=xshdesc_##class(web.DHCANOPCom).GetNameById(xsdr)_" "
		...;s p=p+1
		..;s p=0  ;巡回
		..;s xc=0 f  s xc=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",xc)) q:(xc="")!(p=3)   d
		...;q:xc>20
		...;s xchdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",xc),"^",1)
		...;q:xchdr=""
		...;s careprovdrStr=careprovdrStr_"^"_xchdr
		...;s xchdesc=xchdesc_##class(web.DHCANOPCom).GetNameById(xchdr)_" "
		...;s p=p+1
		.;q:(userId'="")&(("^"_careprovdrStr_"^")'[("^"_userId_"^"))			
		.i andocdr'="" d
		..i $l(andocdr,"~")=1 d
		...s andocRowId=$o(^RB("RES",0,"CTPCP",andocdr,ctlocId,""))
		...q:andocRowId=""
		...q:ctlocId'=$p(^RB("RES",andocRowId),"^",1)
		...s ^TMPAN("Stat",$j,andocdr,"andoc","anTime")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","anTime"))+anTime
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ord")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","ord"))+1
		...s ^TMPAN("Stat",$j,andocdr,"andoc","amount")=^TMPAN("Stat",$j,andocdr,"andoc","amount")+Amount
		...s ^TMPAN("Stat",$j,andocdr,"andoc","GCost")=^TMPAN("Stat",$j,andocdr,"andoc","GCost")+GCost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ABCost")=^TMPAN("Stat",$j,andocdr,"andoc","ABCost")+ABCost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ICost")=^TMPAN("Stat",$j,andocdr,"andoc","ICost")+ICost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","OtherCost")=^TMPAN("Stat",$j,andocdr,"andoc","OtherCost")+OtherCost
		..e  d
		...s ^TMPAN("Stat",$j,andocdr,"andoc","anTime")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","anTime"))+anTime
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ord")=+$g(^TMPAN("Stat",$j,andocdr,"andoc","ord"))+1
		...s ^TMPAN("Stat",$j,andocdr,"andoc","amount")=^TMPAN("Stat",$j,andocdr,"andoc","amount")+Amount
		...s ^TMPAN("Stat",$j,andocdr,"andoc","GCost")=^TMPAN("Stat",$j,andocdr,"andoc","GCost")+GCost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ABCost")=^TMPAN("Stat",$j,andocdr,"andoc","ABCost")+ABCost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","ICost")=^TMPAN("Stat",$j,andocdr,"andoc","ICost")+ICost
		...s ^TMPAN("Stat",$j,andocdr,"andoc","OtherCost")=^TMPAN("Stat",$j,andocdr,"andoc","OtherCost")+OtherCost
		.i ansupdocdr'="" d
		..i $l(ansupdocdr,"~")=1 d
		...s supdocId=$o(^RB("RES",0,"CTPCP",ansupdocdr,ctlocId,""))
		...q:supdocId=""
		...q:ctlocId'=$p(^RB("RES",supdocId),"^",1)
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","anTime")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","anTime"))+anTime
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ord")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","ord"))+1
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","amount")=^TMPAN("Stat",$j,ansupdocdr,"superdoc","amount")+Amount
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","GCost")=^TMPAN("Stat",$j,ansupdocdr,"superdoc","GCost")+GCost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ABCost")=^TMPAN("Stat",$j,ansupdocdr,"superdoc","ABCost")+ABCost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ICost")=^TMPAN("Stat",$j,ansupdocdr,"superdoc","ICost")+ICost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","OtherCost")=^TMPAN("Stat",$j,ansupdocdr,"superdoc","OtherCost")+OtherCost
		..e  d
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","anTime")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","anTime"))+anTime
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ord")=+$g(^TMPAN("Stat",$j,ansupdocdr,"superdoc","ord"))+1
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","amount")=^TMPAN("Stat",$j,ansupdocdr,"superdoc","amount")+Amount
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","GCost")=^TMPAN("Stat",$j,ansupdocdr,"superdoc","GCost")+GCost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ABCost")=^TMPAN("Stat",$j,ansupdocdr,"superdoc","ABCost")+ABCost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","ICost")=^TMPAN("Stat",$j,ansupdocdr,"superdoc","ICost")+ICost
		...s ^TMPAN("Stat",$j,ansupdocdr,"superdoc","OtherCost")=^TMPAN("Stat",$j,ansupdocdr,"superdoc","OtherCost")+OtherCost
		.f j=1:1:$l(andocassdr,"^") d
		..s assId=$p(andocassdr,"^",j)
		..q:assId=""
		..i $l(assId,"~")=1 d
		...s assdocdr=$o(^RB("RES",0,"CTPCP",assId,ctlocId,""))
		...q:(assdocdr="")&($l(assId,"~")=1)
		...q:ctlocId'=$p(^RB("RES",assdocdr),"^",1)
		...s ^TMPAN("Stat",$j,assId,"assdoc","anTime")=+$g(^TMPAN("Stat",$j,assId,"assdoc","anTime"))+anTime
		...s ^TMPAN("Stat",$j,assId,"assdoc","ord")=+$g(^TMPAN("Stat",$j,assId,"assdoc","ord"))+1
		...s ^TMPAN("Stat",$j,assId,"assdoc","amount")=^TMPAN("Stat",$j,assId,"assdoc","amount")+Amount
		...s ^TMPAN("Stat",$j,assId,"assdoc","GCost")=^TMPAN("Stat",$j,assId,"assdoc","GCost")+GCost
		...s ^TMPAN("Stat",$j,assId,"assdoc","ABCost")=^TMPAN("Stat",$j,assId,"assdoc","ABCost")+ABCost
		...s ^TMPAN("Stat",$j,assId,"assdoc","ICost")=^TMPAN("Stat",$j,assId,"assdoc","ICost")+ICost
		...s ^TMPAN("Stat",$j,assId,"assdoc","OtherCost")=^TMPAN("Stat",$j,assId,"assdoc","OtherCost")+OtherCost
		..e  d
		...s ^TMPAN("Stat",$j,assId,"assdoc","anTime")=+$g(^TMPAN("Stat",$j,assId,"assdoc","anTime"))+anTime
    	...s ^TMPAN("Stat",$j,assId,"assdoc","ord")=+$g(^TMPAN("Stat",$j,assId,"assdoc","ord"))+1
		...s ^TMPAN("Stat",$j,assId,"assdoc","amount")=^TMPAN("Stat",$j,assId,"assdoc","amount")+Amount
		...s ^TMPAN("Stat",$j,assId,"assdoc","GCost")=^TMPAN("Stat",$j,assId,"assdoc","GCost")+GCost
		...s ^TMPAN("Stat",$j,assId,"assdoc","ABCost")=^TMPAN("Stat",$j,assId,"assdoc","ABCost")+ABCost
		...s ^TMPAN("Stat",$j,assId,"assdoc","ICost")=^TMPAN("Stat",$j,assId,"assdoc","ICost")+ICost
		...s ^TMPAN("Stat",$j,assId,"assdoc","OtherCost")=^TMPAN("Stat",$j,assId,"andoc","OtherCost")+OtherCost
		.i $l(careprovdrStr,"^")=2 d
		..s ^TMPAN("Stat",$j,$p(careprovdrStr,"^",2),"single","ord",i)=1 //独立
		..s ^TMPAN("Stat",$j,$p(careprovdrStr,"^",2),"single","amount",i)=Amount
    	.s i=i+1
    }
    s retstr=""
    s docname="",allOrd=0,allAmount=0,allGCost=0,allABCost=0,allICost=0,allOtherCost=0
    s supdocOrd=0,supdocAmount=0,andocOrd=0,andocAmount=0
    s andocId=0 f  s andocId=$o(^TMPAN("Stat",$j,andocId)) q:andocId=""  d
    .q:(userId'="")&(andocId'=userId)
    .s docname=##class(web.DHCANOPCom).GetNameById(andocId)
    .s allOrd=+$g(^TMPAN("Stat",$j,andocId,"andoc","ord"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","ord")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","ord")))
    .s allAmount=+$g(^TMPAN("Stat",$j,andocId,"andoc","amount"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","amount")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","amount")))
    .s allGCost=+$g(^TMPAN("Stat",$j,andocId,"andoc","GCost"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","GCost")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","GCost")))
    .s allABCost=+$g(^TMPAN("Stat",$j,andocId,"andoc","ABCost"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","ABCost")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","ABCost")))
    .s allICost=+$g(^TMPAN("Stat",$j,andocId,"andoc","ICost"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","ICost")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","ICost")))
    .s allOtherCost=+$g(^TMPAN("Stat",$j,andocId,"andoc","OtherCost"))+(+$g(^TMPAN("Stat",$j,andocId,"superdoc","OtherCost")))+(+$g(^TMPAN("Stat",$j,andocId,"assdoc","OtherCost")))
    .s supdocOrd=+$g(^TMPAN("Stat",$j,andocId,"superdoc","ord"))
    .s supdocAmount=+$g(^TMPAN("Stat",$j,andocId,"superdoc","amount"))
    .s andocOrd=+$g(^TMPAN("Stat",$j,andocId,"andoc","ord"))
    .s andocAmount=+$g(^TMPAN("Stat",$j,andocId,"andoc","amount"))
    .s singleOrd=0,singleAmount=0
    .s k=0 f  s k=$o(^TMPAN("Stat",$j,andocId,"single","ord",k)) q:k=""  d
    ..s singleOrd=singleOrd+(+$g(^TMPAN("Stat",$j,andocId,"single","ord",k)))
    ..s singleAmount=singleAmount+(+$g(^TMPAN("Stat",$j,andocId,"single","amount",k)))
    .s retstr=docname_"^"_allOrd_"^"_allAmount_"^"_allGCost_"^"_allABCost_"^"_allICost_"^"_allOtherCost_"^"_supdocOrd_"^"_supdocAmount_"^"_andocOrd_"^"_andocAmount_"^"_singleOrd_"^"_singleAmount
	q retstr
}

ClassMethod GetAnOpCostByOpaId(opaId As %String, ctlocId As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	q:ctlocId="" "ctlocId不能为空!"
	q:$d(^DHCANOPArrange(opaId))<1
	s sumCost=0,ACost=0,BCost=0,CCost=0,DCost=0,ECost=0,FCost=0,GCost=0,HCost=0,ICost=0,JCost=0,KCost=0,LCost=0,ZCost=0
	s patLocId="",patLocDesc="",opLevelCode=""
	s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
	q:(opaStatus'="F")&(opaStatus'="D")&(opaStatus'="P")
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	q:EpisodeID=""
	s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
	s anaSub=$p(anaId,"||",2)
	q:anaSub=""
	s roomId=$P(^DHCANOPArrange(opaId),"^",20)
	q:roomId=""
	s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
	;q:opLocId'=ctlocId
	s patLocId=$P(^PAADM(EpisodeID),"^",4)  //病人科室
    q:patLocId=""
		
	s oeordRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
	q:oeordRowId=""
	s childOEORDRowId="" f  s childOEORDRowId=$O(^OEORD(oeordRowId,"I",childOEORDRowId)) q:childOEORDRowId=""  d
	.s anaDr=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,4)),"^",9)
	.q:anaDr'=anaId
	.s oeordItemStat=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",13)
	.q:oeordItemStat=4
	.s relocId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,3)),"^",6)   //执行科室
	.q:relocId'=ctlocId
	.s applocId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,7)),"^",2)   //接收科室
	.q:applocId=""
	.s arcItmRowId=$p($g(^OEORD(oeordRowId,"I",childOEORDRowId,1)),"^",2)  //医嘱RowId
	.s exOeoriDr=oeordRowId_"||"_childOEORDRowId
	.s exRowId=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr,-1))
	.q:exRowId=""
	.s priceStatus=$p($g(^DHCEXDE(exRowId)),"^",17)
	.q:priceStatus'="1"   //不是已收费状态的除外
	.s exStatus=$p($g(^DHCEXDE(exRowId)),"^",18)
	.q:exStatus'="A"
	.s exCosts=$p($g(^DHCEXDE(exRowId)),"^",10)
	.s ordCatId=##class(web.DHCCLCom).GetOrdCatId(exOeoriDr)
  	.s ordCatCode=$p(^OEC("ORCAT",ordCatId),"^",1)
  	.i ordCatCode="A" s ACost=ACost+exCosts
  	.i ordCatCode="B" s BCost=BCost+exCosts
  	.i ordCatCode="C" s CCost=CCost+exCosts
  	.i ordCatCode="D" s DCost=DCost+exCosts
  	.i ordCatCode="E" s ECost=ECost+exCosts
  	.i ordCatCode="F" s FCost=FCost+exCosts
  	.i ordCatCode="G" s GCost=GCost+exCosts
  	.i ordCatCode="H" s HCost=HCost+exCosts
  	.i ordCatCode="I" s ICost=ICost+exCosts
  	.i ordCatCode="J" s JCost=JCost+exCosts
  	.i ordCatCode="K" s KCost=KCost+exCosts
  	.i ordCatCode="L" s LCost=LCost+exCosts
  	.i ordCatCode="Z" s ZCost=ZCost+exCosts
	.s sumCost=sumCost+exCosts
    s retStr=sumCost_"^"_ACost_"^"_BCost_"^"_CCost_"^"_DCost_"^"_ECost_"^"_FCost_"^"_GCost_"^"_HCost_"^"_ICost_"^"_JCost_"^"_KCost_"^"_LCost_"^"_ZCost
	q retStr
}

/// 
/// 查询条件：手术申请时间(选择时间段),病人所在科室，手术名称，住院号。
/// 查询内容：1.根据条件，查询内容包括病人住院号，姓名，性别，年龄，就诊科室，手术申请时间，手术名称，麻醉方法，手术完成状态。
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnOpInfo","62338","62338","","","")
Query GetAnOpInfo(StartDate As %String, EndDate As %String, PatWardId As %String, OpNameOrId As %String, MedCareNo As %String) As %Query(ROWSPEC = "opaId,admId,inPatNo,medCareNo,regNo,PatWardtDr,patWardDesc,patName,sex,age,ctlocId,ctlocCode,ctlocDesc,opdatestr,opAppDateStr,opStat,opStatus,anmethod,opnameStr,StartDate,EndDate,opdoc")
{
}

ClassMethod GetAnOpInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, PatWardId As %String, OpNameOrId As %String, MedCareNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^tempck(1)=StartDate_"^"_EndDate_"^"_PatWardId_"^"_OpNameOrId_"^"_MedCareNo
    k ^TMPAN("Stat",$j)
    i (StartDate="")!(EndDate="") s sdate=+$H,edate=+$H
	e  s sdate=StartDate,edate=EndDate
    f date=sdate:1:edate
    {  
		s opaId="" 
        f  s opaId=$O(^DHCANOPArrange(0,"AppDate",date,opaId)) q:opaId=""  d 
	    .q:$d(^DHCANOPArrange(opaId))<1
	    .s opstdate="",opsttime="",openddate="",opendtime="",opAppdate="",opApptime="",ctlocCode="",ctlocDesc="",patWardDesc="",opStatus="",anmethod="",opnameStr="",opname=""
	    .s admId=$P(^DHCANOPArrange(opaId),"^",1)
	    .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	    .;s PatWardtDr=$P(^DHCANOPArrange(opaId),"^",21)
	    .s patWardDesc=""
	    .s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
		.s PatWardtDr=$p($g(^PAADM(admId)),"^",70)  
		.i PatWardtDr'="" s patWardDesc=$P(^PAWARD(PatWardtDr),"^",1)
	    .q:(PatWardId'="")&(PatWardId'=PatWardtDr)
	    .;s patWardDesc=$P($G(^PAWARD(PatWardtDr)),"^",2)
	    .s papmiId=$p($g(^PAADM(admId)),"^",1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)   //登记号
		.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)   //病案号
	    .s paadmtype=$p($g(^PAADM(admId)),"^",2)
	    .s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
		.s inPatNo=$p($g(^PAADM(admId)),"^",29)   //住院号
		.q:(MedCareNo'="")&(inPatNo'=MedCareNo)
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		.s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
		.s ctlocId=$P(^PAADM(admId),"^",4)
		.s ctlocCode=$p($g(^CTLOC(ctlocId)),"^",1)
		.s ctlocDesc=$P($g(^CTLOC(ctlocId)),"^",2)
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		.s openddate=$P(^DHCANOPArrange(opaId),"^",16)
		.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		.i openddate<=opstdate s openddate=""
		.i opstdate'=""  s opstdate=$ZD(opstdate,4)
		.i openddate'=""  s openddate=$ZD(openddate,4)
		.i opsttime'=""  s opsttime=$ZT(opsttime,2)
		.i opendtime'=""  s opendtime=$ZT(opendtime,2)
		.s opdatestr=opstdate_" "_opsttime_"~"_openddate_" "_opendtime   	//手术日期
		.s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)
		.s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
		.q:opAppdate=""
		.i opAppdate'=""  s opAppdate=$ZD(opAppdate,4)
		.i opApptime'=""  s opApptime=$ZT(opApptime,2)
		.s opAppDateStr=$G(opAppdate)_" "_$G(opApptime)  	 //手术申请时间
		.s opStat=$P(^DHCANOPArrange(opaId),"^",27)     //手术状态
		.q:opStat=""
		.i opStat="A" s opStatus="申请"
		.i opStat="D" s opStatus="取消"
		.i opStat="R" s opStatus="安排"
		.i opStat="N" s opStatus="非预约"
		.i opStat="I" s opStatus="术中"
		.i opStat="P" s opStatus="恢复室"
		.i opStat="L" s opStatus="术毕"
		.i opStat="F" s opStatus="完成"
		.s anmthdr=$P(^OR(admId,"ANA",chl),"^",5)
		.i anmthdr'="" d
			..s anmetNum=$l(anmthdr,"|")
			..f i=1:1:anmetNum d
			...s anmetId=$p(anmthdr,"|",i)
			...q:anmetId=""
			...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
			...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
			...q:(anmethod'="")&((","_anmethod_",")[(","_anmetDesc_","))
			...i anmethod="" s anmethod=anmetDesc	//麻醉方法
			...e  s anmethod=anmethod_","_anmetDesc
		.s opdrStr=""
		.s subchl=0 f  s subchl=$O(^OR(admId,"ANA",chl,"OP",subchl)) q:(subchl="")  d
			..s opdr=$P(^OR(admId,"ANA",chl,"OP",subchl),"^",6)      //手术名称
			..i opdrStr="" s opdrStr=opdr
			..e  s opdrStr=opdrStr_";"_opdr
			..i +opdr=opdr d
			...s opname=$P($g(^ORC("OPER",+opdr)),"^",2)
			...i opnameStr'="" s opnameStr=opname
			...s opnameStr=opnameStr_";"_opname
			..e  d
				...s opname=$g(^OR(admId,"ANA",chl,"OP",subchl,"REM",2))
				...i opnameStr'="" s opnameStr=opname
				...s opnameStr=opnameStr_";"_opname
			..s docdr=$P(^OR(admId,"ANA",chl,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
			..s opd=""
			..i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
		.q:(OpNameOrId'="")&(OpNameOrId=+OpNameOrId)&((";"_opdrStr_";")'[(";"_OpNameOrId_";"))
	    .q:(OpNameOrId'="")&(OpNameOrId'=+OpNameOrId)&(opnameStr'[OpNameOrId)
	    .s ^TMPAN("Stat",$j,opAppdate,ctlocId,opaId)=$lb(opaId,admId,inPatNo,medCareNo,regNo,PatWardtDr,patWardDesc,patName,sex,age,ctlocId,ctlocCode,ctlocDesc,opdatestr,opAppDateStr,opStat,opStatus,anmethod,opnameStr,StartDate,EndDate,opd)
	}
	
	s opappdate="" f  s opappdate=$o(^TMPAN("Stat",$j,opappdate)) q:opappdate=""  d
	.s ctlocdr="" f  s ctlocdr=$o(^TMPAN("Stat",$j,opappdate,ctlocdr)) q:ctlocdr=""  d
	..s opaRowId="" f  s opaRowId=$o(^TMPAN("Stat",$j,opappdate,ctlocdr,opaRowId)) q:opaRowId=""  d
	...do OutPutAnOpInfo
	
	k ^TMPAN("Stat",$j)  //清除临时Global
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutAnOpInfo
 	Set ^CacheTemp(repid,ind)=^TMPAN("Stat",$j,opappdate,ctlocdr,opaRowId)
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 项目代码_"^"_项目名称_"^"_规格_"^"_单位_"^"_单价_"^"_数量_"^"_金额
/// w ##class(web.DHCANOPStatistics).GetPatOPChargeInfo("42651","2775151","311")
ClassMethod GetPatOPChargeInfo(opaId As %String, EpisodeID As %String, ctlocId As %String)
{
	q:opaId="" "opaId不能为空!"
	s retStr="",format="",allSumPrice=0
	k ^TMPAN("Stat",$j)
	s oeordRowId=$o(^OEORD(0,"Adm",EpisodeID,-1))
	q:oeordRowId="" "-1"
	s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	q:anaId="" "-1"
	s chl=0 f  s chl=$o(^OEORD(oeordRowId,"I",chl)) q:chl=""  d
	.s anaDr=$p($g(^OEORD(oeordRowId,"I",chl,4)),"^",9)
	.q:anaDr'=anaId
	.s itmMast=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",2)
	.s oeoriItemStat=$p($G(^OEORD(oeordRowId,"I",chl,1)),"^",13)
	.q:oeoriItemStat="4"
	.s itmCode=$P(^ARCIM($P(itmMast,"||",1),$P(itmMast,"||",2),1),"^",1)  //项目代码
	.s itmDesc=$P(^ARCIM($P(itmMast,"||",1),$P(itmMast,"||",2),1),"^",2)  //项目名称
	.;s appointmentDate=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",9)
	.;s sttdate=appointmentDate
	.;i appointmentDate'="" s appointmentDate=$ZD(appointmentDate,3)
	.;s appointmentTime=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",10)
	.;i appointmentTime'="" s appointmentTime=$ZT(appointmentTime,3)
	.;s tDate=$P($G(^OEORD(oeordRowId,"I",chl,3)),"^",7)
	.;i tDate'="" s tDate=$ZD(tDate,3)
	.;s tTime=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",17)
	.;i tTime'="" s tTime=$ZT(tTime,3)
	.;s admType=$P(^PAADM(EpisodeID),"^",2)
  	.;i admType="O" s admType="门诊"
  	.;i admType="I" s admType="住院"
  	.;i admType="E" s admType="急诊"
  	.s admReason=$P($G(^PAADM(EpisodeID),1),"^",7)
	.s price=##class(web.DHCDocOrderEntry).GetOrderPrice("",admReason,itmMast,"","","","","") 
	.s price=$P(price,"^",1)
	.s price=$j(price,3,2)  //单价
  	.s uomId=$p($g(^OEORD(oeordRowId,"I",chl,2)),"^",3)
  	.i uomId'="" s uomDesc=$p(^CT("UOM",uomId),"^",2)  //单位
  	.e  s uomDesc=""
  	.s qtyNum=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",12)  //数量
	.s sumPrice=qtyNum*price
	.s sumPrice=$j(sumPrice,3,2)  //总价
	.s allSumPrice=allSumPrice+sumPrice
	.s allSumPrice=$j(allSumPrice,3,2)
	.s reLocRowId=$p($g(^OEORD(oeordRowId,"I",chl,3)),"^",6)
	.q:reLocRowId'=ctlocId
	.s reLocDesc=$p($g(^CTLOC(reLocRowId)),"^",2)
	.s oeordDate=$p($G(^OEORD(oeordRowId,"I",chl,11)),"^",4)
	.s oeordTime=$p($G(^OEORD(oeordRowId,"I",chl,11)),"^",5)
	.s oeordDate=$zd(oeordDate,3)
	.s oeordTime=$zt(oeordTime,1)
	.s oeordUserId=$p($g(^OEORD(oeordRowId,"I",chl,7)),"^",1)
	.s appLocRowId=$p($g(^OEORD(oeordRowId,"I",chl,7)),"^",2)
	.q:appLocRowId=""
	.s appLocDesc=$p($g(^CTLOC(appLocRowId)),"^",2)
	.s oeoerUserDesc=$P(^SSU("SSUSR",oeordUserId),"^",2)
	.s oeordDr=oeordRowId_"||"_chl
	.s ordCatId=##class(web.DHCCLCom).GetOrdCatId(oeordDr)
	.s ordCatDesc=$p(^OEC("ORCAT",ordCatId),"^",2)
	.s ^TMPAN("Stat",$j,chl)=itmCode_"^"_itmDesc_"^"_format_"^"_uomDesc_"^"_price_"^"_qtyNum_"^"_sumPrice  //缺规格
	.;s retStr=retStr_itmCode_"^"_itmDesc_"^^"_uomDesc_"^"_price_"^"_qtyNum_"^"_sumPrice_$c(1)
	
	s i=0 f  s i=$o(^TMPAN("Stat",$j,i)) q:i=""  d
	.s retStr=^TMPAN("Stat",$j,i)
	.s retval="ChargeInfoList"_"('"_$ZCVT(retStr,"O","JS")_"');"
	.&javascript<#(retval)#>
	s itmCode="",itmDesc="合计",format="",uomDesc="",price="",qtyNum="",sumPrice=allSumPrice
	s retStr=itmCode_"^"_itmDesc_"^"_format_"^"_uomDesc_"^"_price_"^"_qtyNum_"^"_sumPrice
	s retval="ChargeInfoList"_"('"_$ZCVT(retStr,"O","JS")_"');"
	&javascript<#(retval)#>
}

ClassMethod Test()
{
	//d ##class(web.DHCANOPStatistics).Test()
	s ^DHCCLSet("AnOp","TimeDestails","ColName",1)="inAreaTime^入等候区"
	s ^DHCCLSet("AnOp","TimeDestails","ColName",2)="inRoomTime^入室"
	s ^DHCCLSet("AnOp","TimeDestails","ColName",3)="anaStartTime^麻醉开始"
	s ^DHCCLSet("AnOp","TimeDestails","ColName",4)="opaStartTime^手术开始"
	s ^DHCCLSet("AnOp","TimeDestails","ColName",5)="opaEndTime^手术结束"
	s ^DHCCLSet("AnOp","TimeDestails","ColName",6)="anaEndTime^麻醉结束"
	s ^DHCCLSet("AnOp","TimeDestails","ColName",7)="leaveRoomTime^离室"
	s ^DHCCLSet("AnOp","TimeDestails","Type",1)="before^前"
	s ^DHCCLSet("AnOp","TimeDestails","Type",2)="after^后"
}

/// 获取镇痛泵事件的明细  入参(医嘱开始日期,结束日期,第几天,PatNoStr=regNo^medCareNo^inPatNo)
/// OutType如果输出结果是js中的内容，传入ForJS
/// w ##class(web.DHCANOPStatistics).GetAnalgesiaPumpDetails("2012-06-29","","0001171770^915930^915930","")
ClassMethod GetAnalgesiaPumpDetails(OPDate As %String, NDay As %String, PatNoStr As %String, OutType As %String) As %String
{
	k ^TMPAN("Stat",$j)
    i OPDate="" s opdate=+$H
	e  s opdate=##Class(web.DHCCLCom).ConvertToDateH(OPDate)
	s retStr="",retStr1=""
	s eventId=$o(^DHCANC("ComOrd",0,"TypeCode","E","AnalgesiaPump",""))
	q:eventId="" ""

	    s opaId="" f  s opaId=$o(^DHCANOrder(0,"CommOrd",eventId,opaId)) q:opaId=""  d
	    .q:$d(^DHCANOPArrange(opaId))<1
	    .s opstdate="",opsttime="",openddate="",opendtime="",ctlocDesc="",patWardDesc="",bedCode="",inPatNo="",DayNum="",DayStr="",floorId=""
	    .s admId=$P(^DHCANOPArrange(opaId),"^",1)
	    .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	    .s PatWardtDr=$P(^DHCANOPArrange(opaId),"^",21)
	    .s patWardDesc=$P($G(^PAWARD(PatWardtDr)),"^",2)
	    .i $l(patWardDesc,"-")>1 s patWardDesc=$p(patWardDesc,"-",2)
	    .s papmiId=$p($g(^PAADM(admId)),"^",1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)   //登记号
		.q:($p(PatNoStr,"^",1)'="")&($p(PatNoStr,"^",1)'=regNo)
		.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)   //病案号
	    .s paadmtype=$p($g(^PAADM(admId)),"^",2)
	    .s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
		.q:($p(PatNoStr,"^",2)'="")&($p(PatNoStr,"^",2)'=medCareNo)
		.s inPatNo=$p($g(^PAADM(admId)),"^",29)   //住院号
		.q:($p(PatNoStr,"^",3)'="")&($p(PatNoStr,"^",3)'=inPatNo)
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		.s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
		.s ctlocId=$P(^PAADM(admId),"^",4)
		.s ctlocDesc=$P($g(^CTLOC(ctlocId)),"^",2)
		.i $l(ctlocDesc,"-")>1 s ctlocDesc=$p(ctlocDesc,"-",2)
		.s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
		.s curWardId=$p($g(^PAADM(admId)),"^",70)  
		.i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
		.
		.
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
		.e  s floorId=""
		.i floorId'="" s oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
		.e  s oprFloor=""
		.i floorId="" s floorId=100
		.	
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		.s openddate=$P(^DHCANOPArrange(opaId),"^",16)
		.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		.i openddate<=opstdate s openddate=""
		.i opstdate'=""  s opstdate=$ZD(opstdate,3)
		.i openddate'=""  s openddate=$ZD(openddate,3)
		.i opsttime'=""  s opsttime=$ZT(opsttime,2)
		.i opendtime'=""  s opendtime=$ZT(opendtime,2)
		.s opdatestr=opstdate_" "_opsttime_" ~ "_openddate_" "_opendtime   	//手术日期
		
		.s ANORowId=""  f  s ANORowId=$o(^DHCANOrder(0,"CommOrd",eventId,opaId,ANORowId)) q:ANORowId=""  d
		..s ANOSDate=$p(^DHCANOrder(ANORowId),"^",5)
		..q:opdate<ANOSDate
		..s DayNum=opdate-ANOSDate
		..q:(DayNum>3)&((($p(PatNoStr,"^",1)="")&($p(PatNoStr,"^",2)="")&($p(PatNoStr,"^",3)="")))
		..q:(NDay'="")&(NDay'=DayNum)
		..s DayStr="第"_DayNum_"天"
		..s ^TMPAN("Stat",$j,floorId,opaId,DayNum)=opaId_"^"_admId_"^"_regNo_"^"_medCareNo_"^"_inPatNo_"^"_patName_"^"_sex_"^"_age_"^"_ctlocDesc_"^"_patWardDesc_"^"_bedCode_"^"_opdatestr_"^"_DayStr_"^"_oprFloor
		..;s ^TMPAN("Stat",$j,opaId,DayNum)=opaId_"^"_admId_"^"_regNo_"^"_medCareNo_"^"_inPatNo_"^"_patName_"^"_sex_"^"_age_"^"_ctlocDesc_"^"_patWardDesc_"^"_bedCode_"^"_opdatestr_"^"_DayStr
		..i retStr1="" s retStr=opaId_"^"_admId_"^"_regNo_"^"_medCareNo_"^"_inPatNo_"^"_patName_"^"_sex_"^"_age_"^"_ctlocDesc_"^"_patWardDesc_"^"_bedCode_"^"_opdatestr_"^"_DayStr
		..e  s retStr1=retStr_"*"_opaId_"^"_admId_"^"_regNo_"^"_medCareNo_"^"_inPatNo_"^"_patName_"^"_sex_"^"_age_"^"_ctlocDesc_"^"_patWardDesc_"^"_bedCode_"^"_opdatestr_"^"_DayStr

	q:OutType'="ForJS" retStr1
	
	i OutType="ForJS" d
	.s opfloordr="" f  s opfloordr=$o(^TMPAN("Stat",$j,opfloordr)) q:opfloordr=""  d
	..s opdr="" f  s opdr=$o(^TMPAN("Stat",$j,opfloordr,opdr)) q:opdr=""  d
	...s i="" f  s i=$o(^TMPAN("Stat",$j,opfloordr,opdr,i)) q:i=""  d
	....s retStr=^TMPAN("Stat",$j,opfloordr,opdr,i)
	....s retval="GetAnalgesiaPumpDetails"_"('"_$ZCVT(retStr,"O","JS")_"');"
	....&javascript<#(retval)#>
	
	;i OutType="ForJS" d
	.;s opdr="" f  s opdr=$o(^TMPAN("Stat",$j,opdr)) q:opdr=""  d
	..;s i="" f  s i=$o(^TMPAN("Stat",$j,opdr,i)) q:i=""  d
	...;s retStr=^TMPAN("Stat",$j,opdr,i)
	...;s retval="GetAnalgesiaPumpDetails"_"('"_$ZCVT(retStr,"O","JS")_"');"
	...;&javascript<#(retval)#>
}

/// w ##class(web.DHCANOPStatistics).GetAnOpWorkDetails("20/09/2011","20/09/2011","311","")
ClassMethod GetAnOpWorkDetails(SDate As %Library.String, EDate As %Library.String, ctlocId As %Library.String, OutType As %String) As %String
{
	i SDate="" s sdate=+$H
	e  s sdate=##Class(web.DHCCLCom).ConvertToDateH(SDate)
	i EDate="" s edate=+$H
	e  s edate=##Class(web.DHCCLCom).ConvertToDateH(EDate)
	s retStr=""
	;s ctlocId=%session.Data("LOGON.CTLOCID")
	s linkLocId=##Class(web.DHCCLCom).GetLinkLocId(ctlocId)
    s userLocIdStr=linkLocId_"^"_ctlocId
    k ^TMPAN("AnOpWorkDetails",$j)
    f date=sdate:1:edate
    {
	    s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
		.q:$d(^DHCANOPArrange(opaId))<1
		.s jzstat="",opdatestr="",inPatNo="",patName="",patWardDesc="",bedNo="",opdes="",opd="",asName1="",asName2="",anmethoddesc="",anaSTime="",anaETime="",anaTime="",opaSumCharge="",anaCharge="",opSupplyRoomCharge="",opadrugCharge=""
		.s isNavigation="",docgroup=""
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.;q:opLocId'=ctlocId
		.s admLocId=$p($g(^PAADM(EpisodeID)),"^",4)
		.q:(("^"_userLocIdStr_"^")'[("^"_+opLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))
		.s opLocDesc=$p($g(^CTLOC(opLocId)),"^",2)
		.i $l(opLocDesc,"-")>1 s opLocDesc=$p(opLocDesc,"-",2)
		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
		.q:(opaStatus="A")!(opaStatus="")!(opaStatus="D")!(opaStatus="N")
		.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
		.q:roomId=""
		.i roomId'="" s roomDesc=$p($g(^DHCANC("OPRoom",roomId)),"^",2)
		.s ordno=$P(^DHCANOPArrange(opaId),"^",26)
		.q:ordno=""
		.s jz=$p(^OR(EpisodeID,"ANA",anaSub),"^",32)   	//ANA_SourceType 急诊(E)/择期(B)
		.i jz="E" s jzstat="是"
		.e  s jzstat=""
		.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.;s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)   //登记号
		.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)   //病案号
		.s inPatNo=$p($g(^PAADM(EpisodeID)),"^",29)   //住院号
		.;s PatWardDr=$P(^DHCANOPArrange(opaId),"^",21)
		.;q:PatWardDr=""
		.s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
       	.if curWardId'="" s patWardDesc=$P(^PAWARD(curWardId),"^",2)
	    .;s patWardDesc=$P($G(^PAWARD(PatWardDr)),"^",2)
	    .i $l(patWardDesc,"-")>1 s patWardDesc=$p(patWardDesc,"-",2)
		.s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	    .s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
	    .i (bedSub'="")&(curWardId'="") s bedNo=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	    .s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42)
		.s subchl=0
		.f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d
		..s sub=subchl
		..;s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)      //手术名称
		..;i +opdr=opdr d
		...;i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d
		....;i opdes'="" s opdes=opdes_";"
		....;s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)
		..;e  d
		...;i $g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))'="" d
		....;i opdes'="" s opdes=opdes_";"_^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2)
		....;e  s opdes=^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2)
		..s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",8)		//手术医师
		..i +docdr=docdr s opd=##class(web.DHCANOPCom).GetNameById(docdr)
		..e  s opd=$TR($p(opaDocNote,"|",2)," ","")
		
		.s retAnOpInfoStr=##Class(web.DHCANOPStatistics).GetAnOpChargeInfo(opaId,EpisodeID,"","")
		.f k=1:1:$l(retAnOpInfoStr,"*") d
		..s retAnOpInfo=$p(retAnOpInfoStr,"*",k)
		..s opSubCatCode=$g(^DHCANOPSet("Statistics","HS","opSubCatCode"))
		..q:(opSubCatCode'="")&(opSubCatCode'=$p(retAnOpInfo,"^",19))&(opSubCatCode'=$p(retAnOpInfo,"^",20))
		..i opdes'="" s opdes=opdes_";"
		..s opdes=opdes_$P(retAnOpInfo,"^",2)

		.s list=0,asName="",assDocNum=3,p=0,ash=""   	//手术助手
		.s len=$l(opaDocNote,"|")
		.s as=0 f  s as=$O(^OR(EpisodeID,"ANA",anaSub,"OP",sub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
		..s asdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",sub,"ASS",as),"^",1)
		..q:asdr=""
		..s p=p+1
		..i asName="" s asName=##class(web.DHCANOPCom).GetNameById(asdr)
		..e  s asName=asName_"^"_##class(web.DHCANOPCom).GetNameById(asdr)
		.i len>assDocNum+2 s len=assDocNum+2
		.f getLen=3:1:len  d
		..i $p(opaDocNote,"|",getLen)'=""  d
		...s getName=$p(opaDocNote,"|",getLen)
		..e  d
		...s list=list+1
		...s getName=$p(asName,"^",list)
		..i ash="" s ash=getName
		..e  s ash=ash_" "_getName
		.s asName1=$p(ash," ",1),asName2=$p(ash," ",2)
		.s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)      // 麻醉方法
		.i anmthdr'="" d
		..s anmetNum=$l(anmthdr,"|")
		..f i=1:1:anmetNum d
		...s anmetId=$p(anmthdr,"|",i)
		...q:anmetId=""
		...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
		...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
		...i anmethoddesc="" s anmethoddesc=anmetDesc
		...e  s anmethoddesc=anmethoddesc_","_anmetDesc
		
		.s mzdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)        	//麻醉医师
		.i mzdr'="" s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)			
		.e  s mzdoc=""
		.s anmethoddesc=mzdoc
		
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s openddate=$P(^DHCANOPArrange(opaId),"^",16)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		.s anaSDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",2)
		.s anaEDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",29)
		.s anaSTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",3)
	    .s anaETime=$p(^OR(EpisodeID,"ANA",anaSub),"^",4)
	    .i anaSDate="" s anaSDate=opstdate
		.i anaEDate="" s anaEDate=openddate
		.i anaSTime="" s anaSTime=opsttime
		.i anaETime="" s anaETime=opendtime
		.s anaTime=(anaEDate-anaSDate)*86400+anaETime-anaSTime
		.i anaTime<0 s anaTime=""
		.i anaTime'="" s anaTime=(+anaTime\3600)_"时"_((+anaTime-((+anaTime\3600)*3600))\60)_"分"
		.i openddate<=opstdate s openddate=opstdate
		.i anaSTime'="" s anaSTime=$zt(anaSTime,2)
		.i anaETime'="" s anaETime=$zt(anaETime,2)
		.i opstdate'=""  s opstdate=$ZD(opstdate,3)
		.i openddate'=""  s openddate=$ZD(openddate,3)
		.i opsttime'=""  s opsttime=$ZT(opsttime,2)
		.i opendtime'=""  s opendtime=$ZT(opendtime,2)
		.s opdatestr=opstdate_" "_opsttime_"--"_openddate_" "_opendtime   	//手术日期
		
		.;s ^DHCANOPSet("Statistics","HS","OPCode")="F"  //手术对应医嘱分类代码
		.;s ^DHCANOPSet("Statistics","HS","DrugCode")="A"  //药品对应医嘱分类代码
		.;s ^DHCANOPSet("Statistics","HS","MaterialCode")="I"  //材料对应医嘱分类代码
		.;s ^DHCANOPSet("Statistics","HS","AppLoc","AN")="52"  //麻醉科室ID
		.;s ^DHCANOPSet("Statistics","HS","AppLoc","OP")="311"  //手术中心供应室ID
		.;s ^DHCANOPSet("Statistics","HS","UserCode")=""  //录入人code或者ID
		.s opcode=$g(^DHCANOPSet("Statistics","HS","OPCode"))
		.s drugcode=$G(^DHCANOPSet("Statistics","HS","DrugCode"))
		.s materialcode=$G(^DHCANOPSet("Statistics","HS","MaterialCode"))
		.s anctlocId=$g(^DHCANOPSet("Statistics","HS","AppLoc","AN"))
		.s opctlocId=$G(^DHCANOPSet("Statistics","HS","AppLoc","OP"))
		.s logctlocId=%session.Data("LOGON.CTLOCID")
		.i ($l(opctlocId,"^")>1)&(("^"_opctlocId_"^")[("^"_logctlocId_"^")) s opctlocId=logctlocId
		.s opaSumCharge=##Class(web.DHCANOPStatistics).GetAnOpSpecificCharge(opaId,"","","",opcode)
		.s anaCharge=##Class(web.DHCANOPStatistics).GetAnOpSpecificCharge(opaId,"",anctlocId,"","")
		.s opSupplyRoomCharge=##Class(web.DHCANOPStatistics).GetAnOpSpecificCharge(opaId,"",opctlocId,"",materialcode)
		.s opadrugCharge=##Class(web.DHCANOPStatistics).GetAnOpSpecificCharge(opaId,"","","",drugcode)
		.s ^TMPAN("AnOpWorkDetails",$j,opLocId,date,opaId)=jzstat_"^"_opdatestr_"^"_inPatNo_"^"_patName_"^"_patWardDesc_"^"_bedNo_"^"_opdes_"^"_isNavigation_"^"_opaSumCharge_"^"_opd_"^"_asName1_"^"_asName2_"^"_docgroup_"^"_anmethoddesc_"^"_anaSTime_"^"_anaETime_"^"_anaTime_"^"_$G(anaCharge)_"^"_$G(opSupplyRoomCharge)_"^"_$G(opadrugCharge)_"^"_opLocDesc
		.i retStr="" s retStr=jzstat_"^"_opdatestr_"^"_inPatNo_"^"_patName_"^"_patWardDesc_"^"_bedNo_"^"_opdes_"^"_isNavigation_"^"_opaSumCharge_"^"_opd_"^"_asName1_"^"_asName2_"^"_docgroup_"^"_anmethoddesc_"^"_anaSTime_"^"_anaETime_"^"_anaTime_"^"_$G(anaCharge)_"^"_$G(opSupplyRoomCharge)_"^"_$G(opadrugCharge)_"^"_opLocDesc
		.e  s retStr=retStr_"*"_jzstat_"^"_opdatestr_"^"_inPatNo_"^"_patName_"^"_patWardDesc_"^"_bedNo_"^"_opdes_"^"_isNavigation_"^"_opaSumCharge_"^"_opd_"^"_asName1_"^"_asName2_"^"_docgroup_"^"_anmethoddesc_"^"_anaSTime_"^"_anaETime_"^"_anaTime_"^"_$G(anaCharge)_"^"_$G(opSupplyRoomCharge)_"^"_$G(opadrugCharge)_"^"_opLocDesc
    }
	q:OutType'="ForJS" retStr

	i OutType="ForJS" d
	.s oplocdr="" f  s oplocdr=$o(^TMPAN("AnOpWorkDetails",$j,oplocdr)) q:oplocdr=""  d
	..s opdate="" f  s opdate=$o(^TMPAN("AnOpWorkDetails",$j,oplocdr,opdate)) q:opdate=""  d
	...s opadr="" f  s opadr=$o(^TMPAN("AnOpWorkDetails",$j,oplocdr,opdate,opadr)) q:opadr=""  d
	....s retJSStr=^TMPAN("AnOpWorkDetails",$j,oplocdr,opdate,opadr)
	....s retval="GetAnOpWorkDetails"_"('"_$ZCVT(retJSStr,"O","JS")_"');"
	....&javascript<#(retval)#>
}

/// 获取指定方式的手术费用
/// w ##class(web.DHCANOPStatistics).GetAnOpSpecificCharge("42651","311","311","","A")
ClassMethod GetAnOpSpecificCharge(opaId As %String, relocId As %String, applocId As %String, userCodeOrId As %String, ordCatCode As %String) As %String
{
	q:opaId="" ""
	s allPrice=0
	s EpisodeID=$p(^DHCANOPArrange(opaId),"^",1)
	s retInfoStr=##Class(web.DHCANOPStatistics).GetAnOpChargeInfo(opaId,EpisodeID,relocId,userCodeOrId)
	f i=1:1:$l(retInfoStr,"*") d
	.s retInfo=$p(retInfoStr,"*",i)
	.q:(relocId'="")&(("^"_relocId_"^")'[("^"_$p(retInfo,"^",8)_"^"))
	.q:(applocId'="")&(("^"_applocId_"^")'[("^"_$p(retInfo,"^",10)_"^"))
	.q:(userCodeOrId'="")&(("^"_userCodeOrId_"^")'[("^"_$p(retInfo,"^",12)_"^"))&(("^"_userCodeOrId_"^")'[("^"_$p(retInfo,"^",13)_"^"))
	.q:(ordCatCode'="")&(ordCatCode'=$p(retInfo,"^",16))&(ordCatCode'=$p(retInfo,"^",17))
	.s sumPrice=$p(retInfo,"^",7)
	.s allPrice=allPrice+sumPrice
	q allPrice
}

ClassMethod GetAnOpChargeInfo(opaId As %String, EpisodeID As %String, ctlocId As %String, userCodeOrId As %String) As %String
{
	/// w ##class(web.DHCANOPStatistics).GetAnOpChargeInfo("42651","2775151","311")
	q:opaId="" "opaId不能为空!"
	s retStrInfo="",allSumPrice=0
	;k ^TMPAN("AnOpChargeInfo",$j)
	q:EpisodeID'=$p(^DHCANOPArrange(opaId),"^",1) ""
	s oeordRowId=$o(^OEORD(0,"Adm",EpisodeID,-1))
	q:oeordRowId="" "-1"
	s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	q:anaId="" "-1"
	s chl=0 f  s chl=$o(^OEORD(oeordRowId,"I",chl)) q:chl=""  d
	.s anaDr=$p($g(^OEORD(oeordRowId,"I",chl,4)),"^",9)
	.q:anaDr'=anaId
	.s itmMast=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",2)
	.s oeoriItemStat=$p($G(^OEORD(oeordRowId,"I",chl,1)),"^",13)
	.q:oeoriItemStat="4"
	.s itmCode=$P(^ARCIM($P(itmMast,"||",1),$P(itmMast,"||",2),1),"^",1)  //项目代码
	.s itmDesc=$P(^ARCIM($P(itmMast,"||",1),$P(itmMast,"||",2),1),"^",2)  //项目名称
	.;s appointmentDate=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",9)
	.;s sttdate=appointmentDate
	.;i appointmentDate'="" s appointmentDate=$ZD(appointmentDate,3)
	.;s appointmentTime=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",10)
	.;i appointmentTime'="" s appointmentTime=$ZT(appointmentTime,3)
	.;s tDate=$P($G(^OEORD(oeordRowId,"I",chl,3)),"^",7)
	.;i tDate'="" s tDate=$ZD(tDate,3)
	.;s tTime=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",17)
	.;i tTime'="" s tTime=$ZT(tTime,3)
	.;s admType=$P(^PAADM(EpisodeID),"^",2)
  	.;i admType="O" s admType="门诊"
  	.;i admType="I" s admType="住院"
  	.;i admType="E" s admType="急诊"
  	.s admReason=$P($G(^PAADM(EpisodeID),1),"^",7)
	.s price=##class(web.DHCDocOrderEntry).GetOrderPrice("",admReason,itmMast,"","","","","") 
	.s price=$P(price,"^",1)
	.s price=$j(price,3,2)  //单价
  	.s uomId=$p($g(^OEORD(oeordRowId,"I",chl,2)),"^",3)
  	.i uomId'="" s uomDesc=$p(^CT("UOM",uomId),"^",2)  //单位
  	.e  s uomDesc=""
  	.s qtyNum=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",12)  //数量
	.s sumPrice=qtyNum*price
	.s sumPrice=$j(sumPrice,3,2)  //总价
	.s reLocRowId=$p($g(^OEORD(oeordRowId,"I",chl,3)),"^",6)
	.q:(reLocRowId'=ctlocId)&(ctlocId'="")
	.s reLocDesc=$p($g(^CTLOC(reLocRowId)),"^",2)
	.s oeordDate=$p($G(^OEORD(oeordRowId,"I",chl,11)),"^",4)
	.s oeordTime=$p($G(^OEORD(oeordRowId,"I",chl,11)),"^",5)
	.s oeordDate=$zd(oeordDate,3)
	.s oeordTime=$zt(oeordTime,1)
	.s oeordUserId=$p($g(^OEORD(oeordRowId,"I",chl,7)),"^",1)
	.s appLocRowId=$p($g(^OEORD(oeordRowId,"I",chl,7)),"^",2)
	.q:appLocRowId=""
	.s appLocDesc=$p($g(^CTLOC(appLocRowId)),"^",2)
	.s oeoerUserCode=$P(^SSU("SSUSR",oeordUserId),"^",1)
	.s oeoerUserDesc=$P(^SSU("SSUSR",oeordUserId),"^",2)
	.q:(userCodeOrId'="")&(("^"_userCodeOrId_"^")'[("^"_oeordUserId_"^"))&(("^"_userCodeOrId_"^")'[("^"_oeoerUserCode_"^"))
	.s oeordDr=oeordRowId_"||"_chl
	.s ordCatId=##class(web.DHCCLCom).GetOrdCatId(oeordDr)
	.s ordSubCatId=##class(web.DHCCLCom).GetOrdSubCatId(oeordDr)
	.s ordCatCode=$p(^OEC("ORCAT",ordCatId),"^",1)
	.s ordCatDesc=$p(^OEC("ORCAT",ordCatId),"^",2)
	.s ordSubCatCode=$p(^ARC("IC",ordSubCatId),"^",1)
	.s ordSubCatDesc=$p(^ARC("IC",ordSubCatId),"^",2)
	.s allSumPrice=allSumPrice+sumPrice
	.s allSumPrice=$j(allSumPrice,3,2)
	.//                       代码1      名称2       单位id3   单位4       价格5     数量6      总价7        开单科室8        9           接受科室10         11          录入人12           13             录入日期14    录入时间15    医嘱分类16   17              18                   医嘱分类19      20                 21
	.;s ^TMPAN("AnOpChargeInfo",$j,chl)=itmCode_"^"_itmDesc_"^"_uomId_"^"_uomDesc_"^"_price_"^"_qtyNum_"^"_sumPrice_"^"_reLocRowId_"^"_reLocDesc_"^"_appLocRowId_"^"_appLocDesc_"^"_oeordUserId_"^"_oeoerUserCode_"^"_oeordDate_"^"_oeordTime_"^"_ordCatId_"^"_ordCatCode_"^"_ordCatDesc
	.i retStrInfo="" s retStrInfo=itmCode_"^"_itmDesc_"^"_uomId_"^"_uomDesc_"^"_price_"^"_qtyNum_"^"_sumPrice_"^"_reLocRowId_"^"_reLocDesc_"^"_appLocRowId_"^"_appLocDesc_"^"_oeordUserId_"^"_oeoerUserCode_"^"_oeordDate_"^"_oeordTime_"^"_ordCatId_"^"_ordCatCode_"^"_ordCatDesc_"^"_ordSubCatId_"^"_ordSubCatCode_"^"_ordSubCatDesc
	.e  s retStrInfo=retStrInfo_"*"_itmCode_"^"_itmDesc_"^"_uomId_"^"_uomDesc_"^"_price_"^"_qtyNum_"^"_sumPrice_"^"_reLocRowId_"^"_reLocDesc_"^"_appLocRowId_"^"_appLocDesc_"^"_oeordUserId_"^"_oeoerUserCode_"^"_oeordDate_"^"_oeordTime_"^"_ordCatId_"^"_ordCatCode_"^"_ordCatDesc_"^"_ordSubCatId_"^"_ordSubCatCode_"^"_ordSubCatDesc
	q retStrInfo
}

/// 开始日期和结束日期为公用查询条件，入参为StatCode模板代码SchValueStr界面入参串,顺序与InquiryCodeStr一致
/// 查询条件可以从输出结果中选择
/// 查询返回结果用代码拼串，查询姓名写成临时global形式存值，再循环返回结果拼串输出（不用写成QUERY）
/// 统计大致分为5类：1、按病区/科室 2、按医生/护士 3、按病人 4、按ASA分级/手术级别 5、按手术间
/// w ##class(web.DHCANOPStatistics).GetAllAnOpInfo("62000","62007","ANReport","")
ClassMethod GetAllAnOpInfo(StrDate As %String, EndDate As %String, StatCode As %String, SchValueStr As %String) As %String
{
	//分权限？  维护权限group
	//^DHCANOPStat("Statistics",StatType,StatCode,"Inquiry","Code")="rownum^code^desc^retutnType"
	//^DHCANOPStat("Statistics",StatType,StatCode,"Return","Code")="rownum^code^desc^retutnType"
	k ^TempAnOp("Statistics",$j)
	k ^TempAnOpTotal
	k ^vallist
	s ^ttt(121)=StrDate_"^"_EndDate_"^"_StatCode_"^"_SchValueStr
	//^TempAnOp("Statistics",$j,StatType,statId,jztype,ReturnCode)="value^count"  区分不同类型统计
	s ctlocId=%session.Data("LOGON.CTLOCID")
	s linkLocId=##Class(web.DHCCLCom).GetLinkLocId(ctlocId)
    s userLocIdStr=linkLocId_"^"_ctlocId
	//^DHCANOPStat("Statistics","StatType",typecode,modulecode)=名称^手术状态
	s InquiryCodeStr="RegNo"   //通过statcode获取
	s ReturnCodeStr="RegNo^Sex^PatName^CtlocDesc^BedCode"   //通过statcode获取  ""登记号^性别^姓名^科室^床号"
	s StatType="ByPat"   //通过statcode获取     "ByLoc"  "ByCareProv"  "ByPat"  "ByASA"
	;q:$p(schValueStr,"^",1)'=^TempAnOp("Statistics",$j,opaId,$p(schCodeStr,"^",1))  //过滤条件
	s StrDate=##class(web.DHCCLCom).ConvertToDateH(StrDate)
	s EndDate=##class(web.DHCCLCom).ConvertToDateH(EndDate)

	//病人、排班、麻醉、手术、术毕、附加手术、交班、麻醉记录信息
	s StatType=##class(web.DHCANOPStatistics).GetReportTypeByCode(StatCode)
	q:StatType="" ""
	s ReturnCodeStr=##class(web.DHCANOPStatistics).GetReturnStr(StatCode,"Return","Code")
	q:ReturnCodeStr="" ""
	;s ReturnTypeStr=##class(web.DHCANOPStatistics).GetReturnStr(StatCode,"Return","Type")
	;q:ReturnTypeStr="" ""
	s repStatCode=""
	s bytype="" f  s bytype=$o(^DHCANOPStat("Statistics","StatType",bytype)) q:bytype=""  d
	.s Stat="" f  s Stat=$o(^DHCANOPStat("Statistics","StatType",bytype,Stat)) q:Stat=""  d
	..i (Stat=StatCode) d
	...s repStatCode=$p(^DHCANOPStat("Statistics","StatType",bytype,Stat),"^",3)

	;i StatType="ByLoc" s ReturnCodeStr="RegNo^Sex^PatName^CtlocDesc^BedCode"

	f date=StrDate:1:EndDate
    {  
		s opaId="" 
        f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d 
	    .q:$d(^DHCANOPArrange(opaId))<1
	    .s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	    .;q:opaStatus'=repStatCode
	    .
	    .s EpisodeID=$p($g(^DHCANOPArrange(opaId)),"^",1)
	    .s anaId=$p($g(^DHCANOPArrange(opaId)),"^",2)
	    .q:anaId=""
	    .s anaSub=$p(anaId,"||",2)
	    .s anaInfoStr=##class(web.DHCANCom).GetAnaInfo(opaId)
	    .s ansingle=##class(web.UDHCANOPArrange).GetAnSingle("","",opaId,EpisodeID,"")
		.s patInfo=$p(anaInfoStr,"^",1)
		.s arrInfo=$p(anaInfoStr,"^",2)
		.s anaInfo=$p(anaInfoStr,"^",3)
		.s opaInfo=$p(anaInfoStr,"^",4)
		.s opendInfo=$p(anaInfoStr,"^",5)
		.s chlopInfo=$p(anaInfoStr,"^",6)
		.s ansInfo=$p(anaInfoStr,"^",7)
		.s aniInfo=$p(anaInfoStr,"^",8)
		.s ^ttt(444)=anaInfoStr
		.s ^ttt(555)=$p(anaInfo,$c(3),2)
		.i StatType="ByPat" s statId=opaId
		.i StatType="ByASA" s statId=opaId
		.i StatType="ByLoc" s statId=$p(^PAADM(+EpisodeID),"^",4)

		.s jztype=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)
		.q:jztype=""
		.s opLevelDr=$P(^DHCANOPArrange(opaId),"^",28)
		.s chl=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
		.
		.s opLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
		.s admLocId=$p($g(^PAADM(EpisodeID)),"^",4)
		.q:(("^"_userLocIdStr_"^")'[("^"_+opLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))
		.
		.s opLevelDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",chl,"DHC"),"^",1)
		.s opLevelCode=""
		.i opLevelDr'="" s opLevelCode=$P($g(^DHCANC("OPLevel",opLevelDr)),"^",2)
		.s ANAOPBladeDR=$P($o(^OR(EpisodeID,"ANA",anaSub,"OP",0)),"^",9)  //取主手术的手术切口ID
		.s ANAOPBladeDesc="",ANAOPBladeCode=""
		.i ANAOPBladeDR'="" d
		..s ANAOPBladeCode=$p(^ORC("BLDTP",ANAOPBladeDR),"^",1)
		..s ANAOPBladeDesc=$p(^ORC("BLDTP",ANAOPBladeDR),"^",2)
		.s ANACOMPDR=$P(^OR(EpisodeID,"ANA",anaSub),"^",27)   //麻醉并发症ID
		.s ANACOMPDesc=""
		.s compchl="" f  s compchl=$o(^OR(EpisodeID,"ANA",anaSub,"COMP",compchl)) q:compchl=""  d
		..s COMPComplicDR=$p(^OR(EpisodeID,"ANA",anaSub,"COMP",compchl),"^",1)
		..q:COMPComplicDR=""
		..i ANACOMPDesc="" s ANACOMPDesc=$p(^ORC("COMP",COMPComplicDR),"^",2)
		..e  s ANACOMPDesc=ANACOMPDesc_";"_$p(^ORC("COMP",COMPComplicDR),"^",2)
		.s ANITheatreTransferTo="",ANINerveBlockEffect=""  //病人去向  取最后一次?   麻醉效果评价?
		.s anichl="" s anichl=$o(^DHCANOPArrange(opaId,"ANI",anichl),-1)
		.i anichl'="" d
		..s ANITheatreTransferTo=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",101)
		..s ANINerveBlockEffect=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",60)
		..s ANACOMPDesc=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",44)
		.s retBloodTransStr=##class(web.DHCANOPStatistics).GetBloodTrans(opaId)
		.i retBloodTransStr'="" d
		..f retCount=1:1:$l(retBloodTransStr,$c(3)) d
		...s retBloodStr=$p(retBloodTransStr,$c(3),retCount)
		...s ^TempAnOp("Statistics",$j,StatType,statId,$p(retBloodStr,$c(1),1))=$p(retBloodStr,$c(1),2)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,$p(retBloodStr,$c(1),1))),"^",2)+$p(retBloodStr,$c(1),3))   //输血
		
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAOpLevelDr")=opLevelDr_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAOpLevelDr")),"^",2)+1)   //手术规模ID
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAOpLevelCode")=opLevelCode_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAOpLevelCode")),"^",2)+1)   //手术规模代码
		
		.i $p(opaInfo,$c(3),11)="" d
		..s OperStartStr=##class(web.DHCANCom).GetAncoByCode(opaId,"OperStart","E","AN")
		..s OperEndStr=##class(web.DHCANCom).GetAncoByCode(opaId,"OperEnd","E","AN")
		..s OperStartDate=$p(OperStartStr,"^",5)
		..s OperStartTime=$p(OperStartStr,"^",6)
		..s OperEndDate=$p(OperEndStr,"^",5)
		..s OperEndTime=$p(OperEndStr,"^",6)
		..s OPDuration=##Class(web.DHCANCom).FormatDuration(((OperEndDate-OperStartDate)*86400+OperEndTime-OperStartTime),"")
		.e  s OPDuration=""
		.i $p(anaInfo,$c(3),13)="" d
		..s AnaStartStr=##class(web.DHCANCom).GetAncoByCode(opaId,"AnaStart","E","AN")
		..s AnaEndStr=##class(web.DHCANCom).GetAncoByCode(opaId,"AnaEnd","E","AN")
		..s AnaStartDate=$p(AnaStartStr,"^",5)
		..s AnaStartTime=$p(AnaStartStr,"^",6)
		..s AnaEndDate=$p(AnaEndStr,"^",5)
		..s AnaEndTime=$p(AnaEndStr,"^",6)
		..s ANADuration=##Class(web.DHCANCom).FormatDuration(((AnaEndDate-AnaStartDate)*86400+AnaEndTime-AnaStartTime),"")
		.e  s ANADuration=""
		.//patInfo
		.s ^TempAnOp("Statistics",$j,StatType,statId,"RegNo")=$p(patInfo,$c(3),1)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"RegNo")),"^",2)+1)   //登记号
		.s ^TempAnOp("Statistics",$j,StatType,statId,"CtlocDesc")=$p(patInfo,$c(3),2)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"CtlocDesc")),"^",2)+1)   //科室
		.s ^TempAnOp("Statistics",$j,StatType,statId,"PatRoomDesc")=$p(patInfo,$c(3),3)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"PatRoomDesc")),"^",2)+1)   //病人房间 不是手术间
		.s ^TempAnOp("Statistics",$j,StatType,statId,"Sex")=$p(patInfo,$c(3),4)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"Sex")),"^",2)+1)   //性别
		.s ^TempAnOp("Statistics",$j,StatType,statId,"PatName")=$p(patInfo,$c(3),5)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"PatName")),"^",2)+1)   //姓名
		.s ^TempAnOp("Statistics",$j,StatType,statId,"SafetyNetCardNo")=$p(patInfo,$c(3),6)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"SafetyNetCardNo")),"^",2)+1)   //安全号码
		.s ^TempAnOp("Statistics",$j,StatType,statId,"BedCode")=$p(patInfo,$c(3),7)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"BedCode")),"^",2)+1)   //床号
		.s ^TempAnOp("Statistics",$j,StatType,statId,"Age")=$p(patInfo,$c(3),8)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"Age")),"^",2)+1)   //年龄
		.s ^TempAnOp("Statistics",$j,StatType,statId,"WardDesc")=$p(patInfo,$c(3),9)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"WardDesc")),"^",2)+1)   //病区
		.s ^TempAnOp("Statistics",$j,StatType,statId,"HomeAddres")=$p(patInfo,$c(3),10)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"HomeAddres")),"^",2)+1)  //住址
		.s ^TempAnOp("Statistics",$j,StatType,statId,"HomeTel")=$p($p(patInfo,$c(3),11),"  ",1)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"HomeTel")),"^",2)+1)  //家庭电话
		.s ^TempAnOp("Statistics",$j,StatType,statId,"WorkTel")=$p($p(patInfo,$c(3),11),"  ",2)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"WorkTel")),"^",2)+1)  //工作电话
		.s ^TempAnOp("Statistics",$j,StatType,statId,"Handtel")=$p($p(patInfo,$c(3),11),"  ",3)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"Handtel")),"^",2)+1)  //手机
		.s ^TempAnOp("Statistics",$j,StatType,statId,"DocDes")=$p(patInfo,$c(3),12)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"DocDes")),"^",2)+1)  //主管医生?
		.s ^TempAnOp("Statistics",$j,StatType,statId,"MedicareNo")=$p(patInfo,$c(3),13)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"MedicareNo")),"^",2)+1)  //病案号
		.s ^TempAnOp("Statistics",$j,StatType,statId,"MRDiagnos")=$p(patInfo,$c(3),14)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"MRDiagnos")),"^",2)+1)  //诊断
		.s ^TempAnOp("Statistics",$j,StatType,statId,"Nation")=$p(patInfo,$c(3),15)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"Nation")),"^",2)+1)  //民族
		.s ^TempAnOp("Statistics",$j,StatType,statId,"PaersonLX")=$p(patInfo,$c(3),16)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"PaersonLX")),"^",2)+1)  //联系人
		.s ^TempAnOp("Statistics",$j,StatType,statId,"DrugCell")=$p(patInfo,$c(3),17)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"DrugCell")),"^",2)+1)  //药柜号
		.s ^TempAnOp("Statistics",$j,StatType,statId,"BirthDate")=$p(patInfo,$c(3),18)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"BirthDate")),"^",2)+1)  //出生日期
		.s ^TempAnOp("Statistics",$j,StatType,statId,"PatWordUnit")=$p(patInfo,$c(3),19)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"PatWordUnit")),"^",2)+1)  //工作单位
		.s ^TempAnOp("Statistics",$j,StatType,statId,"PersonID")=$p(patInfo,$c(3),20)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"PersonID")),"^",2)+1)  //身份证
		.s ^TempAnOp("Statistics",$j,StatType,statId,"BloodType")=$p(patInfo,$c(3),21)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"BloodType")),"^",2)+1)  //血型
		.s ^TempAnOp("Statistics",$j,StatType,statId,"AdmReasonDesc")=$p(patInfo,$c(3),22)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"AdmReasonDesc")),"^",2)+1)  //病人身份
		.s ^TempAnOp("Statistics",$j,StatType,statId,"AdmDoc")=$p(patInfo,$c(3),23)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"AdmDoc")),"^",2)+1)  //办理出院医生
		.s ^TempAnOp("Statistics",$j,StatType,statId,"MainNurse")=$p(patInfo,$c(3),24)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"MainNurse")),"^",2)+1)  //主管护士
		.s ^TempAnOp("Statistics",$j,StatType,statId,"AdmStayDay")=$p(patInfo,$c(3),25)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"AdmStayDay")),"^",2)+1)  //住院天数
		.//arrInfo
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAPatHeight")=$p(arrInfo,$c(3),1)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAPatHeight")),"^",2)+1)   //身高
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAPatWeight")=$p(arrInfo,$c(3),2)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAPatWeight")),"^",2)+1)   //体重
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAPreAnDrug")=$p(arrInfo,$c(3),3)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAPreAnDrug")),"^",2)+1)   //术前用药
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAAnaEffect")=$p(arrInfo,$c(3),4)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAAnaEffect")),"^",2)+1)   //麻醉效果ID
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAAnaEffectDesc")=$p(arrInfo,$c(3),5)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAAnaEffectDesc")),"^",2)+1)   //麻醉效果
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAOpDocNote")=$p(arrInfo,$c(3),6)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAOpDocNote")),"^",2)+1)   //手术医生备注
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAAnDocNote")=$p(arrInfo,$c(3),7)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAAnDocNote")),"^",2)+1)   //麻醉医生备注
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAPAAnaestType")=$p(arrInfo,$c(3),8)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAPAAnaestType")),"^",2)+1)   //拟施麻醉Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAPAAnaestTypeDesc")=$p(arrInfo,$c(3),9)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAPAAnaestTypeDesc")),"^",2)+1)   //拟施麻醉
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAStartDate")=$p(arrInfo,$c(3),10)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAStartDate")),"^",2)+1)  //手术开始日期
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAStartTime")=$p(arrInfo,$c(3),11)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAStartTime")),"^",2)+1)  //手术开始时间
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAEndDate")=$p(arrInfo,$c(3),12)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAEndDate")),"^",2)+1)  //手术结束日期
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAEndTime")=$p(arrInfo,$c(3),13)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAEndTime")),"^",2)+1)  //手术结束时间
		.//anaInfo
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAAnaesthetistDR")=$p(anaInfo,$c(3),1)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAAnaesthetistDR")),"^",2)+1)   //麻醉医师Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAAndocDesc")=$p(anaInfo,$c(3),2)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAAndocDesc")),"^",2)+1)   //麻醉医师
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAMethod")=$p(anaInfo,$c(3),3)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAMethod")),"^",2)+1)   //麻醉方法Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAMethodDesc")=$p(anaInfo,$c(3),4)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAMethodDesc")),"^",2)+1)   //麻醉方法
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAASADR")=$p(anaInfo,$c(3),5)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAASADR")),"^",2)+1)   //ASAId
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAASADesc")=$p(anaInfo,$c(3),6)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAASADesc")),"^",2)+1)   //ASA分级
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAIntubGradeDR")=$p(anaInfo,$c(3),7)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAIntubGradeDR")),"^",2)+1)   //插管通道Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAIntubGradeDesc")=$p(anaInfo,$c(3),8)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAIntubGradeDesc")),"^",2)+1)   //插管通道
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANACuffIntubTube")=$p(anaInfo,$c(3),9)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANACuffIntubTube")),"^",2)+1)   //
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANACuffIntubTubeDesc")=$p(anaInfo,$c(3),10)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANACuffIntubTubeDesc")),"^",2)+1)  //
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAIntSizeDR")=$p(anaInfo,$c(3),11)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAIntSizeDR")),"^",2)+1)  //插管尺寸Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAIntSizeDesc")=$p(anaInfo,$c(3),12)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAIntSizeDesc")),"^",2)+1)  //插管尺寸
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANADuration")=ANADuration_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANADuration")),"^",2)+1)  //
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAAssIdStr")=$p(anaInfo,$c(3),14)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAAssIdStr")),"^",2)+1)  //麻醉助手Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAAssDescStr")=$p(anaInfo,$c(3),15)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAAssDescStr")),"^",2)+1)  //麻醉助手
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANASupervisorDR")=$p(anaInfo,$c(3),16)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANASupervisorDR")),"^",2)+1)  //麻醉指导Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANASupervisorDesc")=$p(anaInfo,$c(3),17)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANASupervisorDesc")),"^",2)+1)  //麻醉指导
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANATheatreInDate")=$p(anaInfo,$c(3),18)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANATheatreInDate")),"^",2)+1)  //入手术间日期
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANATheatreInTime")=$p(anaInfo,$c(3),19)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANATheatreInTime")),"^",2)+1)  //入手术间时间
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANATheatreOutDate")=$p(anaInfo,$c(3),20)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANATheatreOutDate")),"^",2)+1)  //出手术间日期
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANATheatreOutTime")=$p(anaInfo,$c(3),21)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANATheatreOutTime")),"^",2)+1)  //出手术间时间
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANASourceType")=$p(anaInfo,$c(3),22)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANASourceType")),"^",2)+1)  //手术类型		
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAORAnaNurseDR")=$p(anaInfo,$c(3),23)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAORAnaNurseDR")),"^",2)+1)  //麻醉护士Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAORAnaNurseDesc")=$p(anaInfo,$c(3),24)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAORAnaNurseDesc")),"^",2)+1)  //麻醉护士
		.//opaInfo
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPSurgeonDR")=$p(opaInfo,$c(3),1)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPSurgeonDR")),"^",2)+1)   //主刀医生Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPSurgeonDesc")=$p(opaInfo,$c(3),2)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPSurgeonDesc")),"^",2)+1)   //主刀医生
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPTypeDR")=$p(opaInfo,$c(3),3)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPTypeDR")),"^",2)+1)   //手术名称Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPTypeDesc")=$p(opaInfo,$c(3),4)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPTypeDesc")),"^",2)+1)   //手术名称
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPPreopDiagDR")=$p(opaInfo,$c(3),5)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPPreopDiagDR")),"^",2)+1)   //术前诊断ID
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPPreopDiagDesc")=$p(opaInfo,$c(3),6)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPPreopDiagDesc")),"^",2)+1)   //术前诊断
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPPostDiagDR")=$p(opaInfo,$c(3),7)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPPostDiagDR")),"^",2)+1)   //术后诊断ID
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPPostDiagDesc")=$p(opaInfo,$c(3),8)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPPostDiagDesc")),"^",2)+1)   //术后诊断

		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPBladeDR")=ANAOPBladeDR_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPBladeDR")),"^",2)+1)  //取主手术的手术切口
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPBladeDesc")=ANAOPBladeDesc_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPBladeDesc")),"^",2)+1)  //取主手术的手术切口
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANAOPBladeCode")=ANAOPBladeCode_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANAOPBladeCode")),"^",2)+1)  //取主手术的手术切口


		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPPOSPositionDR")=$p(opaInfo,$c(3),9)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPPOSPositionDR")),"^",2)+1)   //手术部位ID
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPPOSPositionDesc")=$p(opaInfo,$c(3),10)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPPOSPositionDesc")),"^",2)+1)  //手术部位
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPDuration")=OPDuration_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPDuration")),"^",2)+1)  //
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPDocAssIdStr")=$p(opaInfo,$c(3),12)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPDocAssIdStr")),"^",2)+1)  //手术助手ID
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPDocAssDescStr")=$p(opaInfo,$c(3),13)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPDocAssDescStr")),"^",2)+1)  //手术助手
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPScnIdStr")=$p(opaInfo,$c(3),16)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPScnIdStr")),"^",2)+1)  //器械护士ID
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPScnDescStr")=$p(opaInfo,$c(3),17)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPScnDescStr")),"^",2)+1)  //器械护士
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPCirnIdStr")=$p(opaInfo,$c(3),18)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPCirnIdStr")),"^",2)+1)  //巡回护士ID
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPCirnDescStr")=$p(opaInfo,$c(3),19)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPCirnDescStr")),"^",2)+1)  //巡回护士
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPPlanOperId")=$p(opaInfo,$c(3),20)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPPlanOperId")),"^",2)+1)  //拟施手术ID
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPPlanOperDesc")=$p(opaInfo,$c(3),21)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPPlanOperDesc")),"^",2)+1)  //拟施手术

		.s ^TempAnOp("Statistics",$j,StatType,statId,"AppLocDesc")=$p(arrInfo,$c(3),14)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"AppLocDesc")),"^",2)+1)  //手术申请科室
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAAnalgesia")=$p(^DHCANOPArrange(opaId),"^",66)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAAnalgesia")),"^",2)+1)  //术后镇痛
		.//opendInfo
		.//chlopInfo
		.//ansInfo
		.//aniInfo
		.//ansingle		
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAEstiOperDuration")=$p($p(ansingle,"^",1)," ",7)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAEstiOperDuration")),"^",2)+1)   //预计手术持续时间
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAPreDiscussDate")=$p($p(ansingle,"^",1)," ",6)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAPreDiscussDate")),"^",2)+1)   //术前讨论日期
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPARoom")=$p($p(ansingle,"^",2)," ",1)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPARoom")),"^",2)+1)   //手术间
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPARoomDr")=$p($p(ansingle,"^",2)," ",2)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPARoomDr")),"^",2)+1)   //手术间Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPASeq")=$p($p(ansingle,"^",2)," ",3)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPASeq")),"^",2)+1)   //手术台次
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAIsAddInstrument")=$p($p(ansingle,"^",2)," ",5)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAIsAddInstrument")),"^",2)+1)   //是否需要器械
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAInstrumentDr")=$p($p(ansingle,"^",2)," ",6)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAInstrumentDr")),"^",2)+1)   //器械Id
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAInstrument")=$p($p(ansingle,"^",2)," ",7)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAInstrument")),"^",2)+1)   //器械
		.//other
		.////不同手术类型的手术规模
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPL"_opLevelCode_jztype)=opLevelCode_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPL"_opLevelCode_jztype)),"^",2)+1)   
		.//不同手术类型的麻醉规模
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ASA"_$p(anaInfo,$c(3),6)_jztype)=$p(anaInfo,$c(3),6)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ASA"_$p(anaInfo,$c(3),6)_jztype)),"^",2)+1)   
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAAnalgesia")=$p(^DHCANOPArrange(opaId),"^",66)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAAnalgesia")),"^",2)+1)   //术后镇痛
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANACOMP")=ANACOMPDesc_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANACOMP")),"^",2)+1)   //麻醉并发症
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANITheatreTransferTo")=ANITheatreTransferTo_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANITheatreTransferTo")),"^",2)+1)   //病人去向
		.s ^TempAnOp("Statistics",$j,StatType,statId,"ANINerveBlockEffect")=ANINerveBlockEffect_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANINerveBlockEffect")),"^",2)+1)   //麻醉效果评价
		.
		.s anaASAIndex=0,opBladeIndex=0,durationIndex=0,opRiskIndex=0
		.i +OPDuration>2 s durationIndex=1    //潍坊，手术时间超过3小时，风险评分加1
		.;i +$p(opaInfo,$c(3),11)>2 s durationIndex=1
		.e  s durationIndex=0
		.i ($p(anaInfo,$c(3),6)="I")!($p(anaInfo,$c(3),6)="II")!($p(anaInfo,$c(3),6)="IE")!($p(anaInfo,$c(3),6)="IIE") S anaASAIndex=0
		.;i ($p(anaInfo,$c(3),6)="I")!($p(anaInfo,$c(3),6)="II") S anaASAIndex=0
		.e  s anaASAIndex=1
		.i (ANAOPBladeDesc="")!(ANAOPBladeDesc="I")!(ANAOPBladeDesc="II") s opBladeIndex=0
		.;i (ANAOPBladeDesc="I")!(ANAOPBladeDesc="II") s opBladeIndex=0
		.e  s opBladeIndex=1
		.q:(anaASAIndex="")&(opBladeIndex="")&(durationIndex="")
		.s opRiskIndex=anaASAIndex+opBladeIndex+durationIndex
		.
		.
		.;s ^tempck(opaId)=OPDuration_"*"_durationIndex_"*"_$p(anaInfo,$c(3),6)_"*"_anaASAIndex_"*"_ANAOPBladeDesc_"*"_opBladeIndex_"*"_opRiskIndex
		.;s ^tempck(opaId,"opaInfo")=opaInfo
		.;s ^tempck(opaId,"anaInfo")=anaInfo
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPRiskIndex"_opRiskIndex)=opRiskIndex_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPRiskIndex"_opRiskIndex)),"^",2)+1)   //感染手术风险指数
		.s ^TempAnOp("Statistics",$j,StatType,statId,"OPAPACUScoreDetail")=$p($G(^DHCANOPArrange(opaId,"PACU")),"^",2)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OPAPACUScoreDetail")),"^",2)+1)
		.s anichl=$o(^DHCANOPArrange(opaId,"ANI",0))
		.;s anichl=1
		.i anichl'="" d
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneral")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",62)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneral")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralType")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",63)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralType")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInduce")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",64)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInduce")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInduceType")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",65)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInduceType")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInduceEffect")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",66)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInduceEffect")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInduceOther")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",67)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInduceOther")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInhalation")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",68)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInhalation")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInhalType")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",69)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralInhalType")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralIntraven")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",70)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralIntraven")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralIntravenType")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",71)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralIntravenType")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralRecovery")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",95)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralRecovery ")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralRecovTech")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",96)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralRecovTech")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralRecoveryOther")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",99)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralRecoveryOther")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralRecovLocation")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",98)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralRecovLocation")),"^",2)+1)
		..s ^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralOther")=$p(^DHCANOPArrange(opaId,"ANI",anichl),"^",100)_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"ANIGeneralOther")),"^",2)+1)
    	
    	.s ^TempAnOp("Statistics",$j,StatType,statId,"PostAnalgesic")=##class(web.DHCANOPStatistics).GetEventDetails(opaId,"PostAnalgesic")_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"PostAnalgesic")),"^",2)+1)
    	.s ^TempAnOp("Statistics",$j,StatType,statId,"CPR")=##class(web.DHCANOPStatistics).GetEventDetails(opaId,"CPR")_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"CPR")),"^",2)+1)
    	.s ^TempAnOp("Statistics",$j,StatType,statId,"DisturbanceConsciousness")=##class(web.DHCANOPStatistics).GetEventDetails(opaId,"DisturbanceConsciousness")_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"DisturbanceConsciousness")),"^",2)+1)
    	.s ^TempAnOp("Statistics",$j,StatType,statId,"Desaturation")=##class(web.DHCANOPStatistics).GetEventDetails(opaId,"Desaturation")_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"Desaturation")),"^",2)+1)
    	.s ^TempAnOp("Statistics",$j,StatType,statId,"AnalepticDrugs")=##class(web.DHCANOPStatistics).GetEventDetails(opaId,"AnalepticDrugs")_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"AnalepticDrugs")),"^",2)+1)
    	.s ^TempAnOp("Statistics",$j,StatType,statId,"AirwayObstruction")=##class(web.DHCANOPStatistics).GetEventDetails(opaId,"AirwayObstruction")_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"AirwayObstruction")),"^",2)+1)
    	.s ^TempAnOp("Statistics",$j,StatType,statId,"AnAccidentalDeath")=##class(web.DHCANOPStatistics).GetEventDetails(opaId,"AnAccidentalDeath")_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"AnAccidentalDeath")),"^",2)+1)
    	.s ^TempAnOp("Statistics",$j,StatType,statId,"OtherUnexpected")=##class(web.DHCANOPStatistics).GetEventDetails(opaId,"OtherUnexpected")_"^"_(+$p($g(^TempAnOp("Statistics",$j,StatType,statId,"OtherUnexpected")),"^",2)+1)

    
    }
    s TCount=1,retStr="",retPatTotal=""
	s statdr="" f  s statdr=$o(^TempAnOp("Statistics",$j,StatType,statdr)) q:statdr=""  d
	.s retPat=""
	.f RCount=1:1:$l(ReturnCodeStr,"^") d
	..m ^TempAnOpTotal($p(ReturnCodeStr,"^",RCount),statdr)=^TempAnOp("Statistics",$j,StatType,statdr,$p(ReturnCodeStr,"^",RCount))
	..s returnType=$p($g(^DHCANOPStat("Statistics","StatType",StatType,StatCode,"Return",$p(ReturnCodeStr,"^",RCount))),"^",4)
	..i returnType="String" s TCount=1
	..e  i returnType="Number" s TCount=2
	..e  s TCount=1
	..s patstr=$p($g(^TempAnOp("Statistics",$j,StatType,statdr,$p(ReturnCodeStr,"^",RCount))),"^",TCount)
	..i patstr="" s patstr=" "
	..i retPat="" s retPat=patstr
	..e  s retPat=retPat_$c(1)_patstr
	.i retStr="" s retStr=retPat
	.e  s retStr=retStr_$C(3)_retPat

	s IType="" f  s IType=$o(^TempAnOpTotal(IType)) q:IType=""  d
	.s stId="" f  s stId=$o(^TempAnOpTotal(IType,stId)) q:stId=""  d
	..s type=$p($g(^DHCANOPStat("Statistics","StatType",StatType,StatCode,"Return",IType)),"^",4)
	..i type="Number" s ^vallist(IType)=+$g(^vallist(IType))+$p(^TempAnOpTotal(IType,stId),"^",2)
	
	s tatolVisible=""
	f ARCount=1:1:$l(ReturnCodeStr,"^") d
	.s type=$p($g(^DHCANOPStat("Statistics","StatType",StatType,StatCode,"Return",$p(ReturnCodeStr,"^",ARCount))),"^",4)
	.i type="Number" d
	..s tatolVisible=1
	..i retPatTotal="" s retPatTotal=$g(^vallist($p(ReturnCodeStr,"^",ARCount)))
	..e  s retPatTotal=retPatTotal_$c(1)_$g(^vallist($p(ReturnCodeStr,"^",ARCount)))
	.e  d
	..i retPatTotal="" s retPatTotal="合计"
	..e  s retPatTotal=retPatTotal_$c(1)_"合计"
	i tatolVisible'="" s retStr=retStr_$C(3)_retPatTotal
	s retStr=$tr(retStr," ","")
	k ^TempAnOp("Statistics",$j)
	k ^TempAnOpTotal

	q retStr    //可能出现超长现象
}

/// 设置名称和代码
/// w ##class(web.DHCANOPStatistics).DHCANOPStatSet()
ClassMethod DHCANOPStatSet() As %String
{
	//w ##class(web.DHCANOPStatistics).DHCANOPStatSet()
	s ^DHCANOPStat("Statistics","Report","Var",0)="148"
	s ^DHCANOPStat("Statistics","Report","Var",1)="登记号^RegNo"
	s ^DHCANOPStat("Statistics","Report","Var",2)="手术规模ID^OPAOpLevelDr"
	s ^DHCANOPStat("Statistics","Report","Var",3)="手术规模^OPAOpLevelCode"
	s ^DHCANOPStat("Statistics","Report","Var",4)="科室^CtlocDesc"
	s ^DHCANOPStat("Statistics","Report","Var",5)="病人房间^PatRoomDesc"
	s ^DHCANOPStat("Statistics","Report","Var",6)="性别^Sex"
	s ^DHCANOPStat("Statistics","Report","Var",7)="姓名^PatName"
	s ^DHCANOPStat("Statistics","Report","Var",8)="安全号码^SafetyNetCardNo"
	s ^DHCANOPStat("Statistics","Report","Var",9)="床号^BedCode"
	s ^DHCANOPStat("Statistics","Report","Var",10)="年龄^Age"
	s ^DHCANOPStat("Statistics","Report","Var",11)="病区^WardDesc"
	s ^DHCANOPStat("Statistics","Report","Var",12)="住址^HomeAddres"
	s ^DHCANOPStat("Statistics","Report","Var",13)="家庭电话^HomeTel"
	s ^DHCANOPStat("Statistics","Report","Var",14)="工作电话^WorkTel"
	s ^DHCANOPStat("Statistics","Report","Var",15)="手机^Handtel"
	s ^DHCANOPStat("Statistics","Report","Var",16)="医生^DocDes"
	s ^DHCANOPStat("Statistics","Report","Var",17)="病案号^MedicareNo"
	s ^DHCANOPStat("Statistics","Report","Var",18)="诊断^MRDiagnos"
	s ^DHCANOPStat("Statistics","Report","Var",19)="民族^Nation"
	s ^DHCANOPStat("Statistics","Report","Var",20)="联系人^PaersonLX"
	s ^DHCANOPStat("Statistics","Report","Var",21)="药柜号^DrugCell"
	s ^DHCANOPStat("Statistics","Report","Var",22)="出生日期^BirthDate"
	s ^DHCANOPStat("Statistics","Report","Var",23)="工作单位^PatWordUnit"
	s ^DHCANOPStat("Statistics","Report","Var",24)="身份证^PersonID"
	s ^DHCANOPStat("Statistics","Report","Var",25)="血型^BloodType"
	s ^DHCANOPStat("Statistics","Report","Var",26)="病人身份^AdmReasonDesc"
	s ^DHCANOPStat("Statistics","Report","Var",27)="办理出院医生^AdmDoc"
	s ^DHCANOPStat("Statistics","Report","Var",28)="主管护士^MainNurse"
	s ^DHCANOPStat("Statistics","Report","Var",29)="住院天数^AdmStayDay"
	
	s ^DHCANOPStat("Statistics","Report","Var",30)="身高^OPAPatHeight"
	s ^DHCANOPStat("Statistics","Report","Var",31)="体重^OPAPatWeight"
	s ^DHCANOPStat("Statistics","Report","Var",32)="术前用药^OPAPreAnDrug"
	s ^DHCANOPStat("Statistics","Report","Var",33)="麻醉效果ID^OPAAnaEffect"
	s ^DHCANOPStat("Statistics","Report","Var",34)="麻醉效果^OPAAnaEffectDesc"
	s ^DHCANOPStat("Statistics","Report","Var",35)="手术医生备注^OPAOpDocNote"
	s ^DHCANOPStat("Statistics","Report","Var",36)="麻醉医生备注^OPAAnDocNote"
	s ^DHCANOPStat("Statistics","Report","Var",37)="拟施麻醉Id^OPAPAAnaestType"
	s ^DHCANOPStat("Statistics","Report","Var",38)="拟施麻醉^OPAPAAnaestTypeDesc"
	s ^DHCANOPStat("Statistics","Report","Var",39)="手术开始日期^OPAStartDate"
	s ^DHCANOPStat("Statistics","Report","Var",40)="手术开始时间^OPAStartTime"
	s ^DHCANOPStat("Statistics","Report","Var",41)="手术结束日期^OPAEndDate"
	s ^DHCANOPStat("Statistics","Report","Var",42)="手术结束时间^OPAEndTime"
	
	s ^DHCANOPStat("Statistics","Report","Var",43)="麻醉医师Id^ANAAnaesthetistDR"
	s ^DHCANOPStat("Statistics","Report","Var",44)="麻醉医师^ANAAndocDesc"
	s ^DHCANOPStat("Statistics","Report","Var",45)="麻醉方法Id^ANAMethod"
	s ^DHCANOPStat("Statistics","Report","Var",46)="麻醉方法^ANAMethodDesc"
	s ^DHCANOPStat("Statistics","Report","Var",47)="ASAId^ANAASADR"
	s ^DHCANOPStat("Statistics","Report","Var",48)="ASA分级^ANAASADesc"
	s ^DHCANOPStat("Statistics","Report","Var",49)="插管通道Id^ANAIntubGradeDR"
	s ^DHCANOPStat("Statistics","Report","Var",50)="插管通道^ANAIntubGradeDesc"
	s ^DHCANOPStat("Statistics","Report","Var",51)="^ANACuffIntubTube"
	s ^DHCANOPStat("Statistics","Report","Var",52)="^ANACuffIntubTubeDesc"
	s ^DHCANOPStat("Statistics","Report","Var",53)="插管尺寸Id^ANAIntSizeDR"
	s ^DHCANOPStat("Statistics","Report","Var",54)="插管尺寸^ANAIntSizeDesc"
	s ^DHCANOPStat("Statistics","Report","Var",55)="麻醉持续时间^ANADuration"
	s ^DHCANOPStat("Statistics","Report","Var",56)="麻醉助手Id^ANAAssIdStr"
	s ^DHCANOPStat("Statistics","Report","Var",57)="麻醉助手^ANAAssDescStr"
	s ^DHCANOPStat("Statistics","Report","Var",58)="麻醉指导Id^ANASupervisorDR"
	s ^DHCANOPStat("Statistics","Report","Var",59)="麻醉指导^ANASupervisorDesc"
	s ^DHCANOPStat("Statistics","Report","Var",60)="入手术间日期^ANATheatreInDate"
	s ^DHCANOPStat("Statistics","Report","Var",61)="入手术间时间^ANATheatreInTime"
	s ^DHCANOPStat("Statistics","Report","Var",62)="出手术间日期^ANATheatreOutDate"
	s ^DHCANOPStat("Statistics","Report","Var",63)="出手术间时间^ANATheatreOutTime"
	s ^DHCANOPStat("Statistics","Report","Var",64)="手术类型^ANASourceType"
	s ^DHCANOPStat("Statistics","Report","Var",65)="麻醉护士Id^ANAORAnaNurseDR"
	s ^DHCANOPStat("Statistics","Report","Var",66)="麻醉护士^ANAORAnaNurseDesc"
	
	s ^DHCANOPStat("Statistics","Report","Var",67)="主刀医生Id^ANAOPSurgeonDR"
	s ^DHCANOPStat("Statistics","Report","Var",68)="主刀医生^ANAOPSurgeonDesc"
	s ^DHCANOPStat("Statistics","Report","Var",69)="手术名称Id^ANAOPTypeDR"
	s ^DHCANOPStat("Statistics","Report","Var",70)="手术名称^ANAOPTypeDesc"
	s ^DHCANOPStat("Statistics","Report","Var",71)="术前诊断ID^ANAOPPreopDiagDR"
	s ^DHCANOPStat("Statistics","Report","Var",72)="术前诊断^ANAOPPreopDiagDesc"
	s ^DHCANOPStat("Statistics","Report","Var",73)="术后诊断ID^ANAOPPostDiagDR"
	s ^DHCANOPStat("Statistics","Report","Var",74)="术后诊断^ANAOPPostDiagDesc"
	s ^DHCANOPStat("Statistics","Report","Var",75)="手术部位ID^OPPOSPositionDR"
	s ^DHCANOPStat("Statistics","Report","Var",76)="手术部位^OPPOSPositionDesc"
	s ^DHCANOPStat("Statistics","Report","Var",77)="手术持续时间^OPDuration"
	s ^DHCANOPStat("Statistics","Report","Var",78)="手术助手ID^OPDocAssIdStr"
	s ^DHCANOPStat("Statistics","Report","Var",79)="手术助手^OPDocAssDescStr"
	s ^DHCANOPStat("Statistics","Report","Var",80)="器械护士ID^OPScnIdStr"
	s ^DHCANOPStat("Statistics","Report","Var",81)="器械护士^OPScnDescStr"
	s ^DHCANOPStat("Statistics","Report","Var",82)="巡回护士ID^OPCirnIdStr"
	s ^DHCANOPStat("Statistics","Report","Var",83)="巡回护士^OPCirnDescStr"
	s ^DHCANOPStat("Statistics","Report","Var",84)="拟施手术ID^OPPlanOperId"
	s ^DHCANOPStat("Statistics","Report","Var",85)="拟施手术^OPPlanOperDesc"
	
	s ^DHCANOPStat("Statistics","Report","Var",86)="手术申请科室^AppLocDesc"
	
	s ^DHCANOPStat("Statistics","Report","Var",87)="预计手术持续时间^OPAEstiOperDuration"
	s ^DHCANOPStat("Statistics","Report","Var",88)="术前讨论日期^OPAPreDiscussDate"
	s ^DHCANOPStat("Statistics","Report","Var",89)="手术间^OPARoom"
	s ^DHCANOPStat("Statistics","Report","Var",90)="手术间Id^OPARoomDr"
	s ^DHCANOPStat("Statistics","Report","Var",91)="手术台次^OPASeq"
	s ^DHCANOPStat("Statistics","Report","Var",92)="是否需要器械^OPAIsAddInstrument"
	s ^DHCANOPStat("Statistics","Report","Var",93)="器械Id^OPAInstrumentDr"
	s ^DHCANOPStat("Statistics","Report","Var",94)="器械^OPAInstrument"
	

	s ^DHCANOPStat("Statistics","Report","Var",95)="ASAIE^ASAIE"  //ASA分级 目前见过最多的是6级 若与表中的代码不一致，需要修改
	s ^DHCANOPStat("Statistics","Report","Var",96)="ASAIB^ASAIB"
	s ^DHCANOPStat("Statistics","Report","Var",97)="ASAIIE^ASAIIE"
	s ^DHCANOPStat("Statistics","Report","Var",98)="ASAIIB^ASAIIB"
	s ^DHCANOPStat("Statistics","Report","Var",99)="ASAIIIE^ASAIIIE"
	s ^DHCANOPStat("Statistics","Report","Var",100)="ASAIIIB^ASAIIIB"
	s ^DHCANOPStat("Statistics","Report","Var",101)="ASAIVE^ASAIVE"
	s ^DHCANOPStat("Statistics","Report","Var",102)="ASAIVB^ASAIVB"
	s ^DHCANOPStat("Statistics","Report","Var",103)="ASAVE^ASAVE"
	s ^DHCANOPStat("Statistics","Report","Var",104)="ASAVB^ASAVB"
	s ^DHCANOPStat("Statistics","Report","Var",105)="ASAVIE^ASAVIE"
	s ^DHCANOPStat("Statistics","Report","Var",106)="ASAVIB^ASAVIB"
		
	s ^DHCANOPStat("Statistics","Report","Var",107)="OPLIE^OPLIE"   //手术级别 若与表中的代码不一致，需要修改
	s ^DHCANOPStat("Statistics","Report","Var",108)="OPLIB^OPLIB"
	s ^DHCANOPStat("Statistics","Report","Var",109)="OPLIIE^OPLIIE"
	s ^DHCANOPStat("Statistics","Report","Var",110)="OPLIIB^OPLIIB"
	s ^DHCANOPStat("Statistics","Report","Var",111)="OPLIIIE^OPLIIIE"
	s ^DHCANOPStat("Statistics","Report","Var",112)="OPLIIIB^OPLIIIB"
	s ^DHCANOPStat("Statistics","Report","Var",113)="OPLIVE^OPLIVE"
	s ^DHCANOPStat("Statistics","Report","Var",114)="OPLIVB^OPLIVB"
	s ^DHCANOPStat("Statistics","Report","Var",115)="OPLVE^OPLVE"
	s ^DHCANOPStat("Statistics","Report","Var",116)="OPLVB^OPLVB"
	
	s ^DHCANOPStat("Statistics","Report","Var",117)="术后镇痛^OPAAnalgesia"
	s ^DHCANOPStat("Statistics","Report","Var",118)="麻醉并发症^ANACOMP"
	s ^DHCANOPStat("Statistics","Report","Var",119)="病人去向^ANITheatreTransferTo"
	//必须与常用医嘱中维护的输血项目一致，如不一致则需要修改
	s ^DHCANOPStat("Statistics","Report","Var",120)="冰冻血浆^Plasma"
	s ^DHCANOPStat("Statistics","Report","Var",121)="浓缩血小板^BloodPlatelet"
	s ^DHCANOPStat("Statistics","Report","Var",122)="RBC^OtherRedCell"
	s ^DHCANOPStat("Statistics","Report","Var",123)="冷沉淀^CoagulationFactorⅦ"
	s ^DHCANOPStat("Statistics","Report","Var",124)="单采血小板^CoagulationFactorⅧ"
	s ^DHCANOPStat("Statistics","Report","Var",125)="自体全血^SelfWholeBlood"
	s ^DHCANOPStat("Statistics","Report","Var",126)="回收自体血^OperCollect"
	//手术刀口
	s ^DHCANOPStat("Statistics","Report","Var",127)="主手术刀口DR^ANAOPBladeDR"
	s ^DHCANOPStat("Statistics","Report","Var",128)="主手术刀口^ANAOPBladeDesc"
	s ^DHCANOPStat("Statistics","Report","Var",129)="主手术刀口Code^ANAOPBladeCode"
	//WF  手术风险评分
	s ^DHCANOPStat("Statistics","Report","Var",130)="手术风险评分0级^OPRiskIndex0"
	s ^DHCANOPStat("Statistics","Report","Var",131)="手术风险评分1级^OPRiskIndex1"
	s ^DHCANOPStat("Statistics","Report","Var",132)="手术风险评分2级^OPRiskIndex2"
	s ^DHCANOPStat("Statistics","Report","Var",133)="手术风险评分3级^OPRiskIndex3"
	//WF 术后访视  
	s ^DHCANOPStat("Statistics","Report","Var",134)="神智^ANIGeneral"
	s ^DHCANOPStat("Statistics","Report","Var",135)="呼吸系统^ANIGeneralType"
	s ^DHCANOPStat("Statistics","Report","Var",136)="循环系统^ANIGeneralInduce"
	s ^DHCANOPStat("Statistics","Report","Var",137)="声音嘶哑^ANIGeneralInduceType"
	s ^DHCANOPStat("Statistics","Report","Var",138)="恶心呕吐^ANIGeneralInduceEffect"
	s ^DHCANOPStat("Statistics","Report","Var",139)="脊麻后头痛^ANIGeneralInduceOther"
	s ^DHCANOPStat("Statistics","Report","Var",140)="下肢肌力(Bromage分级)^ANIGeneralInhalation"
	s ^DHCANOPStat("Statistics","Report","Var",141)="异感^ANIGeneralInhalType"
	s ^DHCANOPStat("Statistics","Report","Var",142)="患者对麻醉^ANIGeneralIntraven"
	s ^DHCANOPStat("Statistics","Report","Var",143)="继续随访^ANIGeneralIntravenType"
	s ^DHCANOPStat("Statistics","Report","Var",144)="是否实施术后镇痛^ANIGeneralRecovery"
	s ^DHCANOPStat("Statistics","Report","Var",145)="镇痛效果^ANIGeneralRecovTech"
	s ^DHCANOPStat("Statistics","Report","Var",146)="术后镇痛不良反应^ANIGeneralRecoveryOther"
	s ^DHCANOPStat("Statistics","Report","Var",147)="是否实施非手术镇痛^ANIGeneralRecovLocation"
	s ^DHCANOPStat("Statistics","Report","Var",148)="PACU内麻醉并发症^ANIGeneralOther"
	s ^DHCANOPStat("Statistics","Report","Var",149)="麻醉效果评价^ANINerveBlockEffect"
	s ^DHCANOPStat("Statistics","Report","Var",150)="steward苏醒评分^OPAPACUScoreDetail"

	s ^DHCANOPStat("Statistics","Report","Var",151)="术后镇痛^PostAnalgesic"
	s ^DHCANOPStat("Statistics","Report","Var",152)="心肺复苏治疗^CPR"
	s ^DHCANOPStat("Statistics","Report","Var",153)="未预期意识障碍^DisturbanceConsciousness"
	s ^DHCANOPStat("Statistics","Report","Var",154)="氧饱和度降低^Desaturation"
	s ^DHCANOPStat("Statistics","Report","Var",155)="药物催醒^AnalepticDrugs"
	s ^DHCANOPStat("Statistics","Report","Var",156)="呼吸道梗阻^AirwayObstruction"
	s ^DHCANOPStat("Statistics","Report","Var",157)="麻醉意外死亡^AnAccidentalDeath"
	s ^DHCANOPStat("Statistics","Report","Var",158)="其他非预期事件^OtherUnexpected"
	q 0
}

/// 通过事件代码获取事件详细信息
ClassMethod GetEventDetails(opaId As %String, EventCode As %String) As %String
{
	q:opaId="" "opaId is not null"
	s anoNote=""
	s anodr=""  f  s anodr=$o(^DHCANOrder(0,"OPApp",opaId,anodr)) q:anodr=""  d
	.s anoType=$p(^DHCANOrder(anodr),"^",30)
	.q:anoType'="E"
	.s anoEditFlag=$p(^DHCANOrder(anodr),"^",25)
	.q:(anoEditFlag'="N")&(anoEditFlag'="E")
	.s ancodr=$p(^DHCANOrder(anodr),"^",2)
	.q:ancodr=""
	.s ancoCode=$p(^DHCANC("ComOrd",ancodr),"^",1)
	.q:ancoCode'=EventCode
	.s anoNote=$p(^DHCANOrder(anodr),"^",10)
	q anoNote
}

/// 获取监控过程中的输血，返回种类以及剂量
/// w ##class(web.DHCANOPStatistics).GetBloodTrans(24226)
ClassMethod GetBloodTrans(opaId As %String) As %String
{
	q:opaId="" ""
	s ^DHANOPSet("AN","ANOViewCat")="7"	
	s retBloodTrans=""
	k TempANOQty
	s anoRowId="" f  s anoRowId=$o(^DHCANOrder(0,"OPApp",opaId,anoRowId)) q:anoRowId=""  d
	.s ANOViewCatDr=$p(^DHCANOrder(anoRowId),"^",16)
	.q:ANOViewCatDr'=$G(^DHANOPSet("AN","ANOViewCat"))
	.s ANOEditFlag=$p(^DHCANOrder(anoRowId),"^",25)
	.q:ANOEditFlag'="N"
	.s ANOFlag=$p(^DHCANOrder(anoRowId),"^",17)
	.q:ANOFlag'="N"
	.s ANCORowId=$p(^DHCANOrder(anoRowId),"^",2)
	.q:ANCORowId=""
	.s ANOQty=$p(^DHCANOrder(anoRowId),"^",11)
	.q:$p(^DHCANC("ComOrd",ANCORowId),"^",1)=""
	.s TempANOQty(ANCORowId)=$g(TempANOQty(ANCORowId))+ANOQty
	
	s ancoId="" f  s ancoId=$o(TempANOQty(ancoId)) q:ancoId=""  d
	.s ANCOCode=$p(^DHCANC("ComOrd",ancoId),"^",1)
	.s ANCODesc=$p(^DHCANC("ComOrd",ancoId),"^",2)
	.i retBloodTrans="" s retBloodTrans=ANCOCode_$c(1)_ANCODesc_$c(1)_TempANOQty(ancoId)
	.e  s retBloodTrans=retBloodTrans_$c(3)_ANCOCode_$c(1)_ANCODesc_$c(1)_TempANOQty(ancoId)
	q retBloodTrans
}

/// w ##class(web.DHCANOPStatistics).GetReportDetails()
ClassMethod GetReportDetails() As %String
{
	//s ^DHCANOPStat("Statistics","StatType","ByASA","BBB") = "B^安排^R^按分级" 
	//s ^DHCANOPStat("Statistics","StatType","ByASA","BBB","Return","PatName") = "姓名^关联名称^1^String" 
	//s ^DHCANOPStat("Statistics","StatType","ByASA","BBB","Return","CtlocDesc") = "科室^关联名称^2^String"
	//s ^DHCANOPStat("Statistics","StatType","ByASA","BBB","Return","RegNo") = "登记号^关联名称^3^String"
	//s ^DHCANOPStat("Statistics","StatType","ByLoc","AAA","Return","RegNo") = "登记号^关联名称^2^String" 
	s retDetails=""
	
	s rpType="" f  s rpType=$o(^DHCANOPStat("Statistics","StatType",rpType)) q:rpType=""  d
	.s rpCode="" f  s rpCode=$o(^DHCANOPStat("Statistics","StatType",rpType,rpCode)) q:rpCode=""  d
	..s rpDesc=$p(^DHCANOPStat("Statistics","StatType",rpType,rpCode),"^",1)
	..s rpStat=$p(^DHCANOPStat("Statistics","StatType",rpType,rpCode),"^",3)   //暂时不试用，改成多个？
	..i retDetails="" s retDetails=rpCode_$c(1)_rpDesc_$c(1)_rpType_$c(1)_rpStat
	..e  s retDetails=retDetails_$c(3)_rpCode_$c(1)_rpDesc_$c(1)_rpType_$c(1)_rpStat
	
	q retDetails
}

/// w ##class(web.DHCANOPStatistics).GetReportTypeByCode("BBB")
ClassMethod GetReportTypeByCode(Code As %String) As %String
{
	//s ^DHCANOPStat("Statistics","StatType","ByASA","BBB") = "麻醉日报表^安排^F^按分级" 
	//s ^DHCANOPStat("Statistics","StatType","ByLoc","AAA") = "手术日报表^安排^F^按分级" 
	q:Code="" ""
	s retType=""
	s rpType="" f  s rpType=$o(^DHCANOPStat("Statistics","StatType",rpType)) q:rpType=""  d
	.s rpCode="" f  s rpCode=$o(^DHCANOPStat("Statistics","StatType",rpType,rpCode)) q:rpCode=""  d
	..q:Code'=rpCode
	..s retType=rpType
	q retType
}

ClassMethod GetReturnStr(Code As %String, SchType As %String, Type As %String) As %String
{
	q:Code="" ""
	q:SchType="" ""
	q:Type="" ""
	
	s rpCodeStr="",rpDescStr="",rpTypeStr="",returnStr=""
    s rpType="" f  s rpType=$o(^DHCANOPStat("Statistics","StatType",rpType)) q:rpType=""  d
	.s rpCode="" f  s rpCode=$o(^DHCANOPStat("Statistics","StatType",rpType,rpCode)) q:rpCode=""  d
	..q:Code'=rpCode
	..s retRPCode="" f  s retRPCode=$o(^DHCANOPStat("Statistics","StatType",rpType,rpCode,SchType,retRPCode)) q:retRPCode=""  d
    ...s seqnum=+$p(^DHCANOPStat("Statistics","StatType",rpType,rpCode,SchType,retRPCode),"^",3)
    ...m ^Tempseqnum("Statistics","StatType",seqnum,retRPCode)=^DHCANOPStat("Statistics","StatType",rpType,rpCode,SchType,retRPCode)
    s seqno=0
    f  s seqno=$O(^Tempseqnum("Statistics","StatType",seqno)) q:seqno=""  d
    .s retCode=""
    .f  s retCode=$O(^Tempseqnum("Statistics","StatType",seqno,retCode)) q:retCode=""  d
    ..s retRPDesc=$p(^Tempseqnum("Statistics","StatType",seqno,retCode),"^",1)
	..s retRPType=$p(^Tempseqnum("Statistics","StatType",seqno,retCode),"^",4)
    ..i rpCodeStr="" s rpCodeStr=retCode
	..e  s rpCodeStr=rpCodeStr_"^"_retCode
	..i rpDescStr="" s rpDescStr=retRPDesc
	..e  s rpDescStr=rpDescStr_"^"_retRPDesc
	..i rpTypeStr="" s rpTypeStr=retRPType
	..e  s rpTypeStr=rpTypeStr_"^"_retRPType
	i Type="Code" s returnStr=rpCodeStr
	i Type="Desc" s returnStr=rpDescStr
	i Type="Type" s returnStr=rpTypeStr
	k ^Tempseqnum
	q returnStr
}

Query FindAllVarLink(ColName As %String) As %Query(ROWSPEC = "desc,ID")
{
}

ClassMethod FindAllVarLinkExecute(ByRef qHandle As %Binary, ColName As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
	s var=""
	f  s var=$o(^DHCANOPStat("Statistics","Report","Var",var)) q:var=""  d
	    .s varStr=$p(^DHCANOPStat("Statistics","Report","Var",var),"^",1)
	    .q:(ColName'="")&(ColName'=" ")&(varStr'[ColName)
	    .s varAlp=$p(^DHCANOPStat("Statistics","Report","Var",var),"^",2)
        .d Outvar
    s qHandle=$lb(0,repid,0)
	q $$$OK

Outvar
	s Data=$lb(varStr,varAlp)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAllVarLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllVarLinkExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindAllVarLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllVarLinkExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// 统计某条手术相关费用
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStatistics","GetAnOpInfoDetails","135","503","","")
Query GetAnOpInfoDetails(opaId As %String, EpisodeID As %String, ctlocId As %String = "", userCodeOrId As %String = "") As %Query(ROWSPEC = "itmCode,itmDesc,uomDesc,price,qtyNum,sumPrice,reLocDesc,appLocDesc,oeoerUserDesc,oeordDate,oeordTime,ordCatDesc,ordSubCatDesc")
{
}

ClassMethod GetAnOpInfoDetailsExecute(ByRef qHandle As %Binary, opaId As %String, EpisodeID As %String, ctlocId As %String = "", userCodeOrId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	if ((opaId="")&&(EpisodeID=""))
 	{
	 	s itmCode="",itmDesc="",uomDesc="",price="",qtyNum="",sumPrice="",reLocDesc="",appLocDesc="",oeoerUserDesc="",oeordDate="",oeordTime="",ordCatDesc="",ordSubCatDesc=""
 	}
	//q:opaId="" "opaId不能为空!"
	if ((opaId'="")&&(EpisodeID'=""))
	{
	s retStrInfo="",allSumPrice=0
	q:EpisodeID'=$p(^DHCANOPArrange(opaId),"^",1) ""
	s oeordRowId=$o(^OEORD(0,"Adm",EpisodeID,-1))
	q:oeordRowId="" "-1"
	s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	q:anaId="" "-1"
	s chl=0 f  s chl=$o(^OEORD(oeordRowId,"I",chl)) q:chl=""  d
	.s anaDr=$p($g(^OEORD(oeordRowId,"I",chl,4)),"^",9)
	.q:anaDr'=anaId
	.s itmMast=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",2)
	.s oeoriItemStat=$p($G(^OEORD(oeordRowId,"I",chl,1)),"^",13)
	.q:oeoriItemStat="4"
	.s itmCode=$P(^ARCIM($P(itmMast,"||",1),$P(itmMast,"||",2),1),"^",1)  //项目代码
	.s itmDesc=$P(^ARCIM($P(itmMast,"||",1),$P(itmMast,"||",2),1),"^",2)  //项目名称
  	.s admReason=$P($G(^PAADM(EpisodeID),1),"^",7)
	.s price=##class(web.DHCDocOrderEntry).GetOrderPrice("",admReason,itmMast,"","","","","") 
	.s price=$P(price,"^",1)
	.s price=$j(price,3,2)  //单价
  	.s uomId=$p($g(^OEORD(oeordRowId,"I",chl,2)),"^",3)
  	.i uomId'="" s uomDesc=$p(^CT("UOM",uomId),"^",2)  //单位
  	.e  s uomDesc=""
  	.s qtyNum=$P($G(^OEORD(oeordRowId,"I",chl,1)),"^",12)  //数量
	.s sumPrice=qtyNum*price
	.s sumPrice=$j(sumPrice,3,2)  //总价
	.s reLocRowId=$p($g(^OEORD(oeordRowId,"I",chl,3)),"^",6)
	.q:(reLocRowId'=ctlocId)&(ctlocId'="")
	.s reLocDesc=$p($g(^CTLOC(reLocRowId)),"^",2)
	.s oeordDate=$p($G(^OEORD(oeordRowId,"I",chl,11)),"^",4)
	.s oeordTime=$p($G(^OEORD(oeordRowId,"I",chl,11)),"^",5)
	.s oeordDate=$zd(oeordDate,3)
	.s oeordTime=$zt(oeordTime,1)
	.s oeordUserId=$p($g(^OEORD(oeordRowId,"I",chl,7)),"^",1)
	.s appLocRowId=$p($g(^OEORD(oeordRowId,"I",chl,7)),"^",2)
	.q:appLocRowId=""
	.s appLocDesc=$p($g(^CTLOC(appLocRowId)),"^",2)
	.s oeoerUserCode=$P(^SSU("SSUSR",oeordUserId),"^",1)
	.s oeoerUserDesc=$P(^SSU("SSUSR",oeordUserId),"^",2)
	.q:(userCodeOrId'="")&(("^"_userCodeOrId_"^")'[("^"_oeordUserId_"^"))&(("^"_userCodeOrId_"^")'[("^"_oeoerUserCode_"^"))
	.s oeordDr=oeordRowId_"||"_chl
	.s ordCatId=##class(web.DHCCLCom).GetOrdCatId(oeordDr)
	.s ordSubCatId=##class(web.DHCCLCom).GetOrdSubCatId(oeordDr)
	.s ordCatCode=$p(^OEC("ORCAT",ordCatId),"^",1)
	.s ordCatDesc=$p(^OEC("ORCAT",ordCatId),"^",2)
	.s ordSubCatCode=$p(^ARC("IC",ordSubCatId),"^",1)
	.s ordSubCatDesc=$p(^ARC("IC",ordSubCatId),"^",2)
	.s allSumPrice=allSumPrice+sumPrice
	.s allSumPrice=$j(allSumPrice,3,2)
	.do OutRowAnOpCost
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowAnOpCost
	set Data=$lb(itmCode,itmDesc,uomDesc,price,qtyNum,sumPrice,reLocDesc,appLocDesc,oeoerUserDesc,oeordDate,oeordTime,ordCatDesc,ordSubCatDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpInfoDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpInfoDetailsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpInfoDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpInfoDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
