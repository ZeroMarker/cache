Class web.DHCNurOPTransfusion Extends %RegisteredObject
{

Query FindTransfusionList(StartDate As %String, EndDate As %String, CTLOCID As %String, OrdDep As %String, OPChekc As %String, EMChekc As %String, StartTime As %String, EndTime As %String) As %Query(ROWSPEC = "admType,patCardNo,execDate,execTime,patName,execNur,patSeatNo,seqNo,tOrdDep,EncryptLevel,PatLevel,execDateTime")
{
}

ClassMethod FindTransfusionListExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, CTLOCID As %String, OrdDep As %String, OPChekc As %String, EMChekc As %String, StartTime As %String, EndTime As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
	if (OPChekc'="on")&(EMChekc'="on") Set qHandle=$lb(0,repid,0) Quit $$$OK
	i StartDate="" s fDate=+$h
	e  s fDate=StartDate
	i EndDate="" s tDate=+$h
	e  s tDate=EndDate
	i StartTime="" s StartTime="0"
	i EndTime=""  s EndTime="86340"
    s seqNo=0
    f ordSttDate=fDate:1:tDate  d
    .s oeordId=0 f  s oeordId=$o(^OEORDi(0,"StDt",ordSttDate,oeordId)) q:oeordId=""  d
    ..Q:'$d(^OEORD(oeordId))
    ..s EpisodeID=$p(^OEORD(oeordId),"^",1)
    ..s admType=$p($g(^PAADM(EpisodeID)),"^",2)
    ..q:(admType'="E")&(admType'="O")							//非门急诊病人退出
    ..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
    ..s patRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    ..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    ..s cardDr=$O(^DHCCARDi("CF",0,"PAPMIDR",papmiId,""))
    ..s patSeatNo=##class(web.DHCNurSyComm).getPatSeat(EpisodeID)
	..q:cardDr=""
	..s patCardNo=$p($g(^DHCCARD("CF",cardDr)),"^",2)
	..s flag=0,execDateTime="",execNur="",patSeatNo="",tOrdDep=""
    ..s execDate=""
    ..s execTime=""
    ..s execDateTime=""
    ..
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"StDt",ordSttDate,oeordId,oeoriSub)) q:(oeoriSub="")!(flag=1)  d
    ...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
    ...q:ordStatCode'="V"		
    ...s curOrdDepDesc=""									//非核实状态医嘱退出
    ...s curOrdDepId=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)	//开医嘱科室
    ...i curOrdDepId'="" s curOrdDepDesc=$P(^CTLOC(curOrdDepId),"^",2)
    ...e  s curOrdDepDesc=""
    ...q:(OrdDep'="")&(OrdDep'=curOrdDepDesc)	
    ...s tOrdDep=curOrdDepDesc
    ...s ArcimDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	...s ARCIMRowid=$P(ArcimDR,"||",1)
	...s ARCIMSub=$P(ArcimDR,"||",2)  
	...s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) //oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	...s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
	...q:OrdTyp'="R"											//非药物退出
	...s SubCatFlag=$g(^DHCCLSet("Exec","OrderSubCat"))			//设置大类或子类过滤
	...s oecatIdStr="^"_$g(^DHCCLNurseExec("VarDef",0,"SYDO","OrCat"))_"^"	//执行设置输液单医嘱分类
	...s orcatId=$p($g(^ARC("IC",ItemCatDR)),"^",8)				//医嘱大类 
    ...q:(SubCatFlag'="Y")&(oecatIdStr'[("^"_orcatId_"^"))&(orcatId'="") 
    ...q:(SubCatFlag="Y")&(oecatIdStr'[("^"_ItemCatDR_"^"))&(ItemCatDR'="")
    ...s phcinIdStr="^"_$g(^DHCCLNurseExec("VarDef",0,"SYDO","PhcIn"))_"^"
	...s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) 	//OEORI_Instr_DR
	...q:(phcinIdStr'[("^"_phcinId_"^"))&(phcinId'="")			//用药途径 
    ...q:($d(^OEORD(oeordId,"I",oeoriSub,"X"))<10)				//无执行医嘱
   	...s oeoreSub=0
    ...f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")!(flag=1)  d
    ....s execDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",19)		//执行日期	
    ....s execTime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",20)		//执行时间	
    ....q:(execTime<StartTime)||(execTime>EndTime)
    ....q:(execDate="")!(execTime="")
    ....s exeDate=##Class(web.DHCCLCom).FormatDate(execDate)
    ....s exeTime=##Class(web.DHCCLCom).FormatTime(execTime)
    ....s execDateTime=exeDate_" "_exeTime
	....s execNurId=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)	//执行人
	....i execNurId'="" s execNur=$P($g(^CTPCP(execNurId,1)),"^",2)
	....e  s execNur=""
	....q:execNur=""
	....s patSeatNo=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",22)	//座位号
	....//q:patSeatNo=""  //暂不判断有无座位
	....i admType="E" d
    .....s loc=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",2) ;$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",5)
    .....s:loc'="" patSeatNo = ##class(web.DHCEMPatientSeat).GetBedDescByEpisodeID(loc,EpisodeID)
	....s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	....s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
	....i dhcoreId'="" d
	....s execLocId=$p($g(^DHCOrdExec(dhcoreId)),"^",4)						//执行科室
	....q:(CTLOCID'="")&(CTLOCID'=execLocId)
	....s flag=1
	..//q:(execDateTime=" ")!(execNur="")!(patSeatNo="")
	..q:(execDateTime=" ")!(execNur="")
	..s seqNo=seqNo+1
	..q:(OPChekc="on")&(EMChekc'="on")&(admType'="O")
	..q:(OPChekc'="on")&(EMChekc="on")&(admType'="E")	
	..i admType="E"	s admType="急诊"
	..i admType="O"	s admType="门诊"
	..q:tOrdDep=""
	..Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)  ///病人密级、级别
    ..Set EncryptLevel=$p(PatEncryptLevel,"^",1)  
    ..Set PatLevel=$p(PatEncryptLevel,"^",2)     
	..Do OutRow
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$lb(admType,patCardNo,exeDate,exeTime,patName,execNur,patSeatNo,seqNo,tOrdDep,EncryptLevel,PatLevel,execDateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTransfusionListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransfusionListExecute ]
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

ClassMethod FindTransfusionListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransfusionListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
