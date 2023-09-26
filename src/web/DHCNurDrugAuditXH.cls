Import SQLUser

Class web.DHCNurDrugAuditXH Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query GetFaYao(userId As %String, locId As %String, StDate As %String, EDate As %String, typ As %String = "", dep As %String = "", tempOrdFlag As %String = "", Audittyp As %String = "", regNo As %String = "", RollOrd As %String = "", longOrdFlag = "", RecLocId = "", ArcimID = "", UnPayFlage As %String = "", AllFlage As %String = "", auditBatchId As %String = "") As %Query(ROWSPEC = "LocDes,Arcim,Qty,Uom,ArRow,Process,recLocId")
{
}

ClassMethod getEpisodeIdByOEORI1(oeoriId As %String) As %String
{
	q:oeoriId=""
	s EpisodeId=$P(^OEORD(+oeoriId),"^",1)
	q EpisodeId
}

ClassMethod getEpisodeIdByOEORI(oeoriId As %String) As %String
{
	q:oeoriId=""
	s EpisodeId=$P(^OEORD(+oeoriId),"^",1)
    s feeStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeId, "")
    s flag=$p(feeStr,"^",5)
    s ArcRow=$P(^OEORD(+oeoriId,"I",$p(oeoriId,"||",2),1),"^",2)
    s ItemCatDR=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1)),"^",10)
    s ItemCatDesc=$P(^ARC("IC",ItemCatDR),"^",2)
    s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
    s jfFlag=##class(web.DHCJFArrearsOrdItm).DHCJFArrearsOrdCheck(ArcRow)
    q:(flag="C")&(ItemCatDesc["贵重")&(jfFlag=-1) EpisodeId //(locId'=819)&
	q:(ItemCatDesc'["贵重") EpisodeId_"^非贵重药品!"
	q:((flag'="C")!(jfFlag'=-1)) EpisodeId_"^病人未欠费!"
}

ClassMethod Getpatinfobyadmno(admno)
{
	;w ##class(web.UDHCJFZYDB).Getpatinfobyadmno(272956)
	q:admno="" 0_"^"_0_"^"_0
	s money="",Admdate="",pbamount=""
	s deposit=##class(web.UDHCJFCASHIER).deposit(admno)   //预交金
	b
	s warrant="",warrantrowid=""
	i $d(^DHCWARRANT(0,"ADM",admno))=0 {
		f  s warrantrowid=$o(^DHCWARRANT(0,"ADM",admno,warrantrowid)) q:warrantrowid=""  d
		.s warrantamt=$p(^DHCWARRANT(warrantrowid),"^",2)
		.s money=money+warrantamt
		s money=money+deposit     //担保金加预交金
	}
	s Admdate=$p(^PAADM(admno),"^",6)  //入院日期
	s Admdate=$zd(Admdate,3)
	s Pbrowid=$O(^DHCPB(0,"ADM",admno,""))
	q:Pbrowid="" $j(deposit,1,2)_"^"_Admdate_"^"_$j(pbamount,1,2)
	s:$d(^DHCPB(Pbrowid)) pbamount=$p(^DHCPB(Pbrowid),"^",8)
	
	q $j(deposit,1,2)_"^"_Admdate_"^"_$j(pbamount,1,2)
}

ClassMethod GetFaYaoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaYaoExecute ]
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

ClassMethod GetFaYaoExecute(ByRef qHandle As %Binary, userId As %String, locId As %String, StDate As %String = "", EDate As %String = "", typ As %String = "", dep As %String = "", tempOrdFlag As %String = "", Audittyp As %String = "", regNo As %String = "", RollFl As %String, longOrdFlag = "", RecLocId = "", ArcimID = "", UnPayFlage As %String = "", AllFlage As %String = "on", auditBatchId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
 	s ind=1
 	//w !,RollFl_435
 	//ypz 061109 begin
 	s ^PanTmp("drug")=userId_","_locId_","_StDate_","_EDate_","_typ_","_dep_","_tempOrdFlag_","_Audittyp_","_regNo_","_RollFl_","_longOrdFlag_","_RecLocId_","_ArcimID_","_UnPayFlage_","_AllFlage_","_auditBatchId
 	 //s RecLocId=""
 	if %request.Get("RecLoc")="" s RecLocId=""  //pan
 	//s ArcimID=""
 	if %request.Get("ArcimDesc")="" s ArcimID=""  //pan
 	//s ^PanTmp("drug1")=RecLocId_"^"_ArcimID
 	//s StTime=""
 	s GZFl=%request.Get("GZFlag")
 	s DMFl=%request.Get("DMFlag")
 	s OutFlag=%request.Get("OutFlag")
 	s StTime=%request.Get("StTime")  //pan
 	i StTime'="" s StTime=$zth(StTime)
 	//e  s StTime=0 
 	//s ETime=""
 	s ETime=%request.Get("ETime")  //pan
 	i ETime'="" s ETime=$zth(ETime)
 	//e  s ETime=86400
 	//S CheckFlag="N"
 	s CheckFlag=%request.Get("CheckFlag")  //pan
 	s KfyFlag=%request.Get("KfyFlag")
    s NotKfyFlag=%request.Get("NotKfyFlag")
 	s ^panTmp("drugCheck1")=StTime_"|"_ETime_"|"_CheckFlag
 	s qHandle=$lb(0,repid,0)
 	i (userId="")!(locId="") Q $$$OK
 	s wardStr=..GetUserWardId(userId,locId)
 	i (wardStr="")&&(locId'=819)&&(locId'=822) Q $$$OK
 	i (regNo="")&&((locId=819)!(locId=822)) Q $$$OK
 	s ward=$p($p(wardStr,"|"),"^",2)
 	i locId=819 s ward=819
    i locId=822 s ward=822
 	s ctcpId=$P(^SSU("SSUSR",userId),"^",14)
    i ctcpId'="" s ctcptId=$P(^CTPCP(ctcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	i $G(ctcptId)'="" s ctcpType=$P(^CT("CPT",ctcptId),"^",4)  ;CT_CarPrvTp
    i ($G(ctcpType)'="NURSE")&&(locId'=819)&&(locId'=822)  Q $$$OK
    s dep=""
    s anStr="^"_^DHCANOPSET("anloc")
    i anStr[("^"_locId_"|") s dep=locId
	s opStr=^DHCANOPSET("oploc")
	i opStr[("^"_locId_"|") s dep=locId
 	//清除临时数据
 	k ^TMP(ward,$J,"RecLoc")   ///合计数据
 	k ^TMP("AuditMed",userId)  ///明细数据
 	;i auditBatchId'="" d
 	.;s fromTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",2)
 	.;s toTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",3)
 	.;i fromTime>toTime s fromTime="",toTime=""
 	s stdate=StDate,edate=EDate
 	//s stdate=60402,edate=60402,typ="on"
 	if $G(stdate)="" s stdate=+$h
 	if $G(edate)="" s edate=+$h
 	//s ^TT=typ
 	if typ="on"  s typ="C"
 	e  s typ="TC"
    if typ="C" s Audittyp="on"          //xuqy 070124
 	s ATyp=""
	// + wxl 090331

	i regNo'="" d
    .s papmiId=0 f  s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),papmiId)) q:papmiId=""  d 
    ..s admId=0 f  s admId=$o(^PAPERdr(papmiId,"ADM","I",admId)) q:admId=""  d
    ...b ;003
    ...//s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(admId, "")   //080103 S
    ...//s NurFeeCon=$p(feeRetStr,"^",5)
    ...//q:(AllFlage="")&(UnPayFlage="")&(NurFeeCon="C")
    ...//q:(NurFeeCon'="C")&(UnPayFlage="on")&(AllFlage="")                                   //080103 S
    ...s pavisit=$p($g(^PAADM(admId)),"^",20)
    ...i pavisit'="A" q
    ...d ..GetFaYaoList(ward,userId,locId,admId,stdate,edate,typ,dep,tempOrdFlag,Audittyp,RollFl,longOrdFlag,RecLocId,ArcimID,auditBatchId,StTime,ETime,CheckFlag,GZFl,DMFl,KfyFlag,NotKfyFlag,OutFlag)
	
	i regNo="" d 
	.s Room=""  f  s Room=$O(^PAADMi("CurrWard",ward,Room)) q:Room=""  d
    ..s admId=""  f  s admId=$O(^PAADMi("CurrWard",ward,Room,admId)) q:admId=""  d
    ...//s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(admId, "")   //080103 S
    ...//s NurFeeCon=$p(feeRetStr,"^",5)
    ...//q:(AllFlage="")&(UnPayFlage="")&(NurFeeCon="C")
    ...//q:(NurFeeCon'="C")&(UnPayFlage="on")&(AllFlage="")                                   //080103 S
    ...s curRegNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(admId)
    ...q:(regNo'="")&(regNo'=curRegNo)
    ...s pavisit=$p($g(^PAADM(admId)),"^",20)  //ypz 070312
    ...i (pavisit'="A") q   ;
    ...d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(admId)
    ...d ..GetFaYaoList(ward,userId,locId,admId,StDate,EDate,typ,dep,tempOrdFlag,Audittyp,RollFl,longOrdFlag,RecLocId,ArcimID,auditBatchId,StTime,ETime,CheckFlag,GZFl,DMFl,KfyFlag,NotKfyFlag,OutFlag)
    // + wxl 090331

    k ^TMP(ward,$J,"ward")
    s ^TMP(ward,"ward")=$J
    s i=0
    s loc=""  f  s loc=$O(^TMP(ward,$J,"RecLoc",loc)) q:loc=""  d
    .s LocDes=$P(^CTLOC(loc),"^",2)
    .s recLocId=loc
    .s Arc="" f  s Arc=$O(^TMP(ward,$J,"RecLoc",loc,Arc)) q:Arc=""  d
    ..s Arcim=$P(^ARCIM($P(Arc,"||",1),$P(Arc,"||",2),1),"^",2)
    ..s Qty=^TMP(ward,$J,"RecLoc",loc,Arc,"Qty") 
    ..s Uom=^TMP(ward,$J,"RecLoc",loc,Arc,"Uom")
    ..s i=i+1
    ..s ^TMP(ward,$J,"ward",i)=LocDes_"^"_Arcim_"^"_Qty_"^"_Uom_"^"_Arc_"^"_$j
    ..d OutPutArc
    //清除临时数据
    k ^TMP(ward,$J,"RecLoc")
    k ^TMP(ward,$J,"ward")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutArc  
	set Data=$lb(LocDes,Arcim,Qty,Uom,Arc,$j,recLocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFaYaoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaYaoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetFaYao1(userId As %String, locId As %String, StDate As %String, EDate As %String, typ As %String = "", dep As %String = "", tempOrdFlag As %String = "", Audittyp As %String = "", regNo As %String = "", RollOrd As %String = "", longOrdFlag = "", RecLocId = "", ArcimID = "", UnPayFlage As %String = "", AllFlage As %String = "", auditBatchId As %String = "") As %Query(ROWSPEC = "LocDes,Arcim,Qty,Uom,ArRow,Process,recLocId")
{
}

ClassMethod GetFaYao1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaYao1Execute ]
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

ClassMethod GetFaYao1Execute(ByRef qHandle As %Binary, userId As %String, locId As %String, StDate As %String = "", EDate As %String = "", typ As %String = "", dep As %String = "", tempOrdFlag As %String = "", Audittyp As %String = "", regNo As %String = "", RollFl As %String, longOrdFlag = "", RecLocId = "", ArcimID = "", UnPayFlage As %String = "", AllFlage As %String = "on", auditBatchId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
 	s ind=1
 	//w !,RollFl_435
 	//ypz 061109 begin
 	s ^ypzTmp("drug")=userId_","_locId_","_StDate_","_EDate_","_typ_","_dep_","_tempOrdFlag_","_Audittyp_","_regNo_","_RollFl_","_longOrdFlag_","_RecLocId_","_ArcimID_","_UnPayFlage_","_AllFlage
 	if %request.Get("RecLoc")="" s RecLocId=""
 	if %request.Get("ArcimDesc")="" s ArcimID=""
 	s qHandle=$lb(0,repid,0)
 	i (userId="")!(locId="") Q $$$OK
 	s wardStr=..GetUserWardId(userId,locId)
 	i wardStr="" Q $$$OK
 	s ward=$p($p(wardStr,"|"),"^",2)
 	s ctcpId=$P(^SSU("SSUSR",userId),"^",14)
    i ctcpId'="" s ctcptId=$P(^CTPCP(ctcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	i $G(ctcptId)'="" s ctcpType=$P(^CT("CPT",ctcptId),"^",4)  ;CT_CarPrvTp
    i ($G(ctcpType)'="NURSE")  Q $$$OK
    s dep=""
    s anStr="^"_^DHCANOPSET("anloc")
    i anStr[("^"_locId_"|") s dep=locId
	s opStr=^DHCANOPSET("oploc")
	i opStr[("^"_locId_"|") s dep=locId
 	//清除临时数据
 	k ^TMP(ward,$J,"RecLoc")   ///合计数据
 	k ^TMP("AuditMed",userId)  ///明细数据
 	;i auditBatchId'="" d
 	.;s fromTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",2)
 	.;s toTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",3)
 	.;i fromTime>toTime s fromTime="",toTime=""
 	s stdate=StDate,edate=EDate
 	//s stdate=60402,edate=60402,typ="on"
 	if $G(stdate)="" s stdate=+$h
 	if $G(edate)="" s edate=+$h
 	//s ^TT=typ
 	if typ="on"  s typ="C"
 	e  s typ="TC"
    if typ="C" s Audittyp="on"          //xuqy 070124
 	s ATyp=""
	// + wxl 090331
	i regNo'="" d
    .s papmiId=0 f  s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),papmiId)) q:papmiId=""  d 
    ..s admId=0 f  s admId=$o(^PAPERdr(papmiId,"ADM","I",admId)) q:admId=""  d
    ...s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(admId, "")   //080103 S
    ...s NurFeeCon=$p(feeRetStr,"^",5)
    ...q:(AllFlage="")&(UnPayFlage="")&(NurFeeCon="C")
    ...q:(NurFeeCon'="C")&(UnPayFlage="on")&(AllFlage="")                                   //080103 S
    ...s pavisit=$p($g(^PAADM(admId)),"^",20)
    ...i pavisit'="A" q
    ...d ..GetFaYaoList1(ward,userId,locId,admId,stdate,edate,typ,dep,tempOrdFlag,Audittyp,RollFl,longOrdFlag,RecLocId,ArcimID,auditBatchId)
	
	i regNo="" d 
	.s Room=""  f  s Room=$O(^PAADMi("CurrWard",ward,Room)) q:Room=""  d
    ..s admId=""  f  s admId=$O(^PAADMi("CurrWard",ward,Room,admId)) q:admId=""  d
    ...s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(admId, "")   //080103 S
    ...s NurFeeCon=$p(feeRetStr,"^",5)
    ...q:(AllFlage="")&(UnPayFlage="")&(NurFeeCon="C")
    ...q:(NurFeeCon'="C")&(UnPayFlage="on")&(AllFlage="")                                   //080103 S
    ...s curRegNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(admId)
    ...q:(regNo'="")&(regNo'=curRegNo)
    ...s pavisit=$p($g(^PAADM(admId)),"^",20)  //ypz 070312
    ...i pavisit'="A" q   ;
    ...d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(admId)
    ...d ..GetFaYaoList1(ward,userId,locId,admId,StDate,EDate,typ,dep,tempOrdFlag,Audittyp,RollFl,longOrdFlag,RecLocId,ArcimID,auditBatchId)
    // + wxl 090331

    k ^TMP(ward,$J,"ward")
    s ^TMP(ward,"ward")=$J
    s i=0
    s loc=""  f  s loc=$O(^TMP(ward,$J,"RecLoc",loc)) q:loc=""  d
    .s LocDes=$P(^CTLOC(loc),"^",2)
    .s recLocId=loc
    .s Arc="" f  s Arc=$O(^TMP(ward,$J,"RecLoc",loc,Arc)) q:Arc=""  d
    ..s Arcim=$P(^ARCIM($P(Arc,"||",1),$P(Arc,"||",2),1),"^",2)
    ..s Qty=^TMP(ward,$J,"RecLoc",loc,Arc,"Qty") 
    ..s Uom=^TMP(ward,$J,"RecLoc",loc,Arc,"Uom")
    ..s i=i+1
    ..s ^TMP(ward,$J,"ward",i)=LocDes_"^"_Arcim_"^"_Qty_"^"_Uom_"^"_Arc_"^"_$j
    ..d OutPutArc1
    //清除临时数据
    k ^TMP(ward,$J,"RecLoc")
    k ^TMP(ward,$J,"ward")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutArc1  
	set Data=$lb(LocDes,Arcim,Qty,Uom,Arc,$j,recLocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFaYao1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaYao1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetFaYaoDet(userId As %String, process As %String, ArRow As %String, recLocId As %String) As %Query(ROWSPEC = "Doctor,OrdDate,PatName,BedCode,Arcim,Qty,Uom,Orw,Prior,Audit,PackNum,dhcDspId,dspStat,doseQtyUnit,phcfrCode,batchTime,DispDateTime,AuditFlag,CheckInfo,CheckFlag,OrdStat")
{
}

ClassMethod GetFaYaoDetExecute(ByRef qHandle As %Binary, userId As %String, process As %String, ArRow As %String, recLocId As %String) As %Status
{
   Set repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	i (userId="")!(ArRow="") Q $$$OK
 	
 	s ^PanTmp("FaYaoDet")=userId_","_process_","_ArRow_","_recLocId
 	s Ord=""  f  s Ord=$O(^TMP("AuditMed",userId,process,ArRow,Ord)) q:Ord=""  d
 	.s OrdSub=""  f  s OrdSub=$O(^TMP("AuditMed",userId,process,ArRow,Ord,OrdSub)) q:OrdSub=""  d
    ..s LocId=$P(^OEORD(Ord,"I",OrdSub,3),"^",6)
    ..q:(recLocId'=LocId)
    ..s dhcDspId=""
    ..f  s dhcDspId=$O(^TMP("AuditMed",userId,process,ArRow,Ord,OrdSub,dhcDspId))  q:dhcDspId=""  d
    ...s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    ...s dispDate=""
    ...s dispDate=$P(^DHCOEDISQTY(dhcDspId),"^",8)
    ...s dispTime=""
    ...s dispTime=$P(^DHCOEDISQTY(dhcDspId),"^",9) 
    ...s dispUserID=""
    ...s dispUserID=$P(^DHCOEDISQTY(dhcDspId),"^",10) 
    ...s dispUser=""
    ...i $g(dispUserID) '="" d  s dispUser=$P(^SSU("SSUSR",dispUserID),"^",2)
    ...s DispDateTime=""
    ...i ($g(dispDate)'="")&&($g(dispTime)'="") d  s DispDateTime=dispUser_"|"_$ZD(dispDate,3)_" "_$ZT(dispTime)
    ...q:dhcDspStat="R"
    ...i dhcDspStat="C" s dspStat="已发"
    ...i dhcDspStat="TC" s dspStat="未发"
    ...s user=$P($G(^OEORD(Ord,"I",OrdSub,7)),"^",1)
    ...q:user=""
    ...s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
    ...i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",2) 
 	...s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期时间?加入基础数据表
	...s OrdDate=+OrdDate
	...s OrdTime=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",17)
	...s OrdDate1=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",9)  ;取得医嘱表医嘱日期时间?加入基础数据表
	...s OrdDate1=+OrdDate1
	...s OrdTime1=$P(^DHCOEDISQTY(dhcDspId),"^",20)
    ...s Patinfo=##class(web.DHCCLCom).PatInfo(Ord_"||"_OrdSub)
    ...s RegNo=$P(Patinfo,"^",1)
    ...s PatName=$P(Patinfo,"^",5)
    ...s BedCode=$P(Patinfo,"^",7)
    ...s Arcim=$P(^ARCIM($P(ArRow,"||",1),$P(ArRow,"||",2),1),"^",2)
    ...s StrQty=..GetQty(Ord,OrdSub)
    ...s Qty=$P(StrQty,"^"),Uom=$P(StrQty,"^",2)
    ...s PriorDR=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	...s Prior=$P(^OECPR(PriorDR),"^",2) 
    ...s drugAuditStr=..GetAuditDrug(""_"^"_dhcDspId)
    ...i ($p(drugAuditStr,"^")'="") d
    ....s auditDr=$P(drugAuditStr,"^",1)
    ....s AuditUsr=$P(^SSU("SSUSR",auditDr),"^",2)
    ....s AuditDate=$ZD($P(drugAuditStr,"^",2),3) //$ZD($P($P(str,"|",1),",",1),3)
    ....s AuditTime=$ZT($P(drugAuditStr,"^",3)) //$ZT($P($P(str,"|",1),",",2))
    ....s AuditFlag=$P(drugAuditStr,"^",4)
    ...e  d
    ....s AuditUsr="", AuditDate="",AuditTime="",AuditFlag=""
    ...s PackNum=..GetPackQty(Ord,OrdSub)
    ...//s DateTime=$ZD(OrdDate,3)_" "_$ZT(OrdTime)
    ...s DateTime=$ZD(OrdDate1,3)_" "_$ZT(OrdTime1)
    ...s Audit=$G(AuditUsr)_"|"_$G(AuditDate)_" "_$G(AuditTime)
    ...b ;001
    ...s drugCheckStr=..GetCheckDrug(""_"^"_dhcDspId) //pan
    ...i ($p(drugCheckStr,"^")'="") d
    ....s CheckDr=$P(drugCheckStr,"^",1)
    ....s CheckUsr=$P(^SSU("SSUSR",CheckDr),"^",2)
    ....s CheckDate=$ZD($P(drugCheckStr,"^",2),3) //$ZD($P($P(str,"|",1),",",1),3)
    ....s CheckTime=$ZT($P(drugCheckStr,"^",3)) //$ZT($P($P(str,"|",1),",",2))
    ....s CheckFlag=$P(drugCheckStr,"^",4)
    ...e  d
    ....s CheckUsr="", CheckDate="",CheckTime="",CheckFlag=""
    ...s CheckInfo=$G(CheckUsr)_"|"_$G(CheckDate)_" "_$G(CheckTime)
    ...s ordStatId=$p($g(^OEORD(Ord,"I",OrdSub,1)),"^",13)
    ...s OrdStat=""
    ...s OrdStat=$p($g(^OEC("OSTAT",+ordStatId)),"^",2)
    ...s ORow=Ord_"||"_OrdSub
    ...s doseQty=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",1)
    ...i doseQty'="" s unitUomId=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",3)
    ...i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    ...i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
    ...i (doseQty'="")&(unitDesc'="") s doseQtyUnit=doseQty_" "_unitDesc
    ...s phcfrId=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",4)
    ...i phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 
    ...s dhcDspTime=$P(^DHCOEDISQTY(dhcDspId),"^",20)
    ...i dhcDspTime'="" s batchTime=$ZT(dhcDspTime)
    ...e  s batchTime=""
    ...d OutPutArc1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutArc1
	set Data=$lb(Doctor,DateTime,PatName,BedCode,Arcim,Qty,Uom,ORow,Prior,Audit,PackNum,dhcDspId,dspStat,doseQtyUnit,phcfrCode,batchTime,DispDateTime,AuditFlag,CheckInfo,CheckFlag,OrdStat)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetFaYaoDet1(userId As %String, process As %String, ArRow As %String, recLocId As %String) As %Query(ROWSPEC = "Doctor,OrdDate,PatName,BedCode,Arcim,Qty,Uom,Orw,Prior,Audit,PackNum,dhcDspId,dspStat,doseQtyUnit,phcfrCode,batchTime,DispDateTime,AuditFlag")
{
}

ClassMethod GetFaYaoDet1Execute(ByRef qHandle As %Binary, userId As %String, process As %String, ArRow As %String, recLocId As %String) As %Status
{
   Set repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	i (userId="")!(ArRow="") Q $$$OK
 	
 	s Ord=""  f  s Ord=$O(^TMP("AuditMed",userId,process,ArRow,Ord)) q:Ord=""  d
 	.s OrdSub=""  f  s OrdSub=$O(^TMP("AuditMed",userId,process,ArRow,Ord,OrdSub)) q:OrdSub=""  d
    ..s LocId=$P(^OEORD(Ord,"I",OrdSub,3),"^",6)
    ..q:(recLocId'=LocId)
    ..s dhcDspId=""
    ..f  s dhcDspId=$O(^TMP("AuditMed",userId,process,ArRow,Ord,OrdSub,dhcDspId))  q:dhcDspId=""  d
    ...s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    ...s dispDate=""
    ...s dispDate=$P(^DHCOEDISQTY(dhcDspId),"^",8)
    ...s dispTime=""
    ...s dispTime=$P(^DHCOEDISQTY(dhcDspId),"^",9) 
    ...s dispUserID=""
    ...s dispUserID=$P(^DHCOEDISQTY(dhcDspId),"^",10) 
    ...s dispUser=""
    ...i $g(dispUserID) '="" d  s dispUser=$P(^SSU("SSUSR",dispUserID),"^",2)
    ...s DispDateTime=""
    ...i ($g(dispDate)'="")&&($g(dispTime)'="") d  s DispDateTime=dispUser_"|"_$ZD(dispDate,3)_" "_$ZT(dispTime)
    ...q:dhcDspStat="R"
    ...i dhcDspStat="C" s dspStat="已发"
    ...i dhcDspStat="TC" s dspStat="未发"
    ...s user=$P($G(^OEORD(Ord,"I",OrdSub,7)),"^",1)
    ...q:user=""
    ...s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
    ...i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",2) 
 	...s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期时间?加入基础数据表
	...s OrdDate=+OrdDate
	...s OrdTime=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",17)
    ...s Patinfo=##class(web.DHCCLCom).PatInfo(Ord_"||"_OrdSub)
    ...s RegNo=$P(Patinfo,"^",1)
    ...s PatName=$P(Patinfo,"^",5)
    ...s BedCode=$P(Patinfo,"^",7)
    ...s Arcim=$P(^ARCIM($P(ArRow,"||",1),$P(ArRow,"||",2),1),"^",2)
    ...s StrQty=..GetQty(Ord,OrdSub)
    ...s Qty=$P(StrQty,"^"),Uom=$P(StrQty,"^",2)
    ...s PriorDR=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	...s Prior=$P(^OECPR(PriorDR),"^",2) 
    ...s drugAuditStr=..GetAuditDrug(""_"^"_dhcDspId)
    ...i ($p(drugAuditStr,"^")'="") d
    ....s auditDr=$P(drugAuditStr,"^",1)
    ....s AuditUsr=$P(^SSU("SSUSR",auditDr),"^",2)
    ....s AuditDate=$ZD($P(drugAuditStr,"^",2),3) //$ZD($P($P(str,"|",1),",",1),3)
    ....s AuditTime=$ZT($P(drugAuditStr,"^",3)) //$ZT($P($P(str,"|",1),",",2))
    ....s AuditFlag=$P(drugAuditStr,"^",4)
    ...e  d
    ....s AuditUsr="", AuditDate="",AuditTime="",AuditFlag=""
    ...s PackNum=..GetPackQty(Ord,OrdSub)
    ...s DateTime=$ZD(OrdDate,3)_" "_$ZT(OrdTime)
    ...s Audit=$G(AuditUsr)_"|"_$G(AuditDate)_" "_$G(AuditTime)
    ...s ORow=Ord_"||"_OrdSub
    ...s doseQty=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",1)
    ...i doseQty'="" s unitUomId=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",3)
    ...i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    ...i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
    ...i (doseQty'="")&(unitDesc'="") s doseQtyUnit=doseQty_" "_unitDesc
    ...s phcfrId=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",4)
    ...i phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 
    ...s dhcDspTime=$P(^DHCOEDISQTY(dhcDspId),"^",20)
    ...i dhcDspTime'="" s batchTime=$ZT(dhcDspTime)
    ...e  s batchTime=""
    ...d OutPutArc2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutArc2
	set Data=$lb(Doctor,DateTime,PatName,BedCode,Arcim,Qty,Uom,ORow,Prior,Audit,PackNum,dhcDspId,dspStat,doseQtyUnit,phcfrCode,batchTime,DispDateTime,AuditFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFaYaoDet1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaYaoDet1Execute ]
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

ClassMethod GetFaYaoDet1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaYaoDet1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPackQty(oew, chl)
{
     s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
	 s scrip=$P(arcimdr,"||")
	 s ver=$P(arcimdr,"||",2)
	 s packUomId=$P(^ARCIM(scrip,ver,8),"^",14)
	 q:packUomId="" ""
	 s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
     s packUomQty=$p($g(^OEORD(oew,"I",chl,9)),"^",4)
     if packUomQty'="" s res=packUomQty_"|"_packUomDesc    
     else  s res=""
     q res
}

ClassMethod GetQty(Ord, OrdSub)
{
    //ypz 080411 begin
	s Qty="",PackUom=""
	s oeoriId=Ord_"||"_OrdSub
	s dhcDspId=0  
    f  s dhcDspId=$O(^DHCOEDISQTY(0,"OEORI",oeoriId,dhcDspId))  q:dhcDspId=""  d
    .s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    .q:dhcDspStat="R"
    .s Qty=$P(^DHCOEDISQTY(dhcDspId),"^",5)
    .s uomId=$P(^DHCOEDISQTY(dhcDspId),"^",6)
    .s PackUom=$p(^CT("UOM",uomId),"^",2) 
    q Qty_"^"_PackUom

    //ypz 080411 end
	s Qty="",PackUom=""
	s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:OrdEx=""  d
    .s OrdDsp=0  f  s OrdDsp=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp)) q:OrdDsp=""  d
    ..s Dsp=^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp) 
    ..s IncLb=$P(Dsp,"^",2)
    ..s Stat=$P(Dsp,"^",6)  
    ..s Qty=$P(Dsp,"^",1)
    ..s ItmBat=$P(^INCI($P(IncLb,"||",1),"IL",$P(IncLb,"||",2),"LB", $P(IncLb,"||",3)),"^",1)
    ..s Inci=$P(ItmBat,"||",1)
    ..s BatNo=$P(^INCI(Inci,"IB",$P(ItmBat,"||",2)),"^",1)
    ..s PackUom=$p(^CT("UOM",$p(^INCI(Inci,1),"^",10)),"^",2) 
    q Qty_"^"_PackUom
}

ClassMethod GetFaYaoDetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaYaoDetExecute ]
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

ClassMethod GetFaYaoDetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaYaoDetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod AuditDrug(oeoriId, userId, auditBatchId As %String = "", locId)
{
	//oeoriId   oeoriId^dhcDspId
	q:oeoriId="" ""
	q:userId="" ""
	s ret=""
    s dhcDspId=$P(oeoriId,"^",2)
    s oeoriId=$P(oeoriId,"^")
    s oeoriAudit=oeoriId
    i (oeoriAudit="")&&(dhcDspId'="") d
    .s oeoriAudit=$p($G(^DHCOEDISQTY(dhcDspId)),"^",1)
    s Ord=+oeoriAudit
    s OrdSub=$p(oeoriAudit,"||",2)
    s adm=+(^OEORD(Ord))
    i $g(^TMP("NurseCheckMoney",$j,adm))="" d
    .s ^TMP("NurseCheckMoney",$j,adm)=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(adm, "")
 	s feeStr=^TMP("NurseCheckMoney",$j,adm)
 	s flag=$p(feeStr,"^",5)
 	s ArcRow=$P(^OEORD(Ord,"I",OrdSub,1),"^",2)
    s ItemCatDR=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1)),"^",10)
    s ItemCatDesc=$P(^ARC("IC",ItemCatDR),"^",2)
    s oecprCode=##Class(web.DHCCLCom).GetOecprCode(Ord_"||"_OrdSub)
    s jfFlag=##class(web.DHCJFArrearsOrdItm).DHCJFArrearsOrdCheck(ArcRow)
    q:(locId'=822)&(locId'=819)&((oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT"))&(flag="C")&(ItemCatDesc["贵重")&(jfFlag=-1) "患者欠费不能审核长期贵重药物"
    i oeoriAudit'="" d
    .d ##class(DHCENS.NURSE.BS.WebNURSEService).NURSESendDrug(oeoriAudit)
    s curDate=+$h,curTime=$p($h,",",2)
    i auditBatchId'="" s auditBatchTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",4)
    e  s auditBatchTime=""
    i dhcDspId="" d
	.&sql(update DHC_OEDispensing set DSP_ConfirmUser=:userId,DSP_DateConfirm=:curDate,DSP_TimeConfirm=:curTime,DSP_ConfirmFlag='Y' where DSP_OEORI_DR=:oeoriId)
	.s ret=SQLCODE
	e  d
	.i auditBatchTime'="" d
	..&sql(update DHC_OEDispensing set DSP_ConfirmUser=:userId,DSP_DateConfirm=:curDate,DSP_TimeConfirm=:curTime,DSP_ConfirmFlag='Y',DSP_TimeDosing=:auditBatchTime where DSP_RowId=:dhcDspId)
	.e  d
	..&sql(update DHC_OEDispensing set DSP_ConfirmUser=:userId,DSP_DateConfirm=:curDate,DSP_TimeConfirm=:curTime,DSP_ConfirmFlag='Y' where DSP_RowId=:dhcDspId)
	.s ret=SQLCODE
	q ret
}

/// 审核药品(新)
ClassMethod CheckDrug(oeoriId, userId, auditBatchId As %String = "")
{
	//oeoriId   oeoriId^dhcDspId
	q:oeoriId="" ""
	q:userId="" ""
	s ret=""
    s dhcDspId=$P(oeoriId,"^",2)
    s oeoriId=$P(oeoriId,"^")
    s curDate=+$h,curTime=$p($h,",",2)
    i auditBatchId'="" s auditBatchTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",4)
    e  s auditBatchTime=""
    i dhcDspId="" d
	.&sql(update DHC_OEDispensing set DSP_CheckUser=:userId,DSP_DateCheck=:curDate,DSP_TimeCheck=:curTime,DSP_CheckFlag='Y' where DSP_OEORI_DR=:oeoriId)
	.s ret=SQLCODE
	e  d
	.i auditBatchTime'="" d
	..&sql(update DHC_OEDispensing set DSP_CheckUser=:userId,DSP_DateCheck=:curDate,DSP_TimeCheck=:curTime,DSP_CheckFlag='Y',DSP_TimeDosing=:auditBatchTime where DSP_RowId=:dhcDspId)
	.e  d
	..&sql(update DHC_OEDispensing set DSP_CheckUser=:userId,DSP_DateCheck=:curDate,DSP_TimeCheck=:curTime,DSP_CheckFlag='Y' where DSP_RowId=:dhcDspId)
	.s ret=SQLCODE
	q ret
}

ClassMethod UndoAuditDrug(dhcDspId)
{
	q:dhcDspId="" ""
	s userId="",curDate="",curTime=""
	&sql(update DHC_OEDispensing set DSP_ConfirmUser=:userId,DSP_DateConfirm=:curDate,DSP_TimeConfirm=:curTime,DSP_ConfirmFlag='N' where DSP_RowId=:dhcDspId)
	q SQLCODE
}

ClassMethod UndoCheckDrug(dhcDspId)
{
	q:dhcDspId="" ""
	s userId="",curDate="",curTime=""
	&sql(update DHC_OEDispensing set DSP_CheckUser=:userId,DSP_DateCheck=:curDate,DSP_TimeCheck=:curTime,DSP_CheckFlag='N' where DSP_RowId=:dhcDspId)
	q SQLCODE
}

ClassMethod GetAuditDrug(oeoriDspId)
{
	q:oeoriDspId="" ""
	s flagenum=0
	s num=0
	s dhcDspId=$P(oeoriDspId,"^",2)
	s oeoriId=$P(oeoriDspId,"^")
	i dhcDspId'="" d
    .s auditUserId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",12)
    .s auditDate=$p($G(^DHCOEDISQTY(dhcDspId)),"^",18)
    .s auditTime=$p($G(^DHCOEDISQTY(dhcDspId)),"^",19)
    .s auditFlag=$p($G(^DHCOEDISQTY(dhcDspId)),"^",17)
    s auditStr=$G(auditUserId)_"^"_$G(auditDate)_"^"_$G(auditTime)_"^"_$G(auditFlag)
	q:(dhcDspId'="") auditStr
	i oeoriId'="" d
	.s dhcDspId=""
	.f  s dhcDspId=$O(^DHCOEDISQTY(0,"OEORI",oeoriId,dhcDspId))  q:dhcDspId=""  d
    ..s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    ..q:dhcDspStat="R"
    ..s auditUserId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",12)
    ..i auditUserId'="" s flagenum=flagenum+1
    ..s num=num+1
    ..s auditDate=$p($G(^DHCOEDISQTY(dhcDspId)),"^",18)
    ..s auditTime=$p($G(^DHCOEDISQTY(dhcDspId)),"^",19)
    i (flagenum'=0)&(flagenum=num) s auditStr=$G(auditUserId)_"^"_$G(auditDate)_"^"_$G(auditTime)
    i flagenum=0 s auditStr=""
    q:(oeoriId'="") auditStr
    q ""
}

ClassMethod GetCheckDrug(oeoriDspId)
{
	q:oeoriDspId="" ""
	s flagenum=0
	s num=0
	s dhcDspId=$P(oeoriDspId,"^",2)
	s oeoriId=$P(oeoriDspId,"^")
	i dhcDspId'="" d
    .s CheckUserId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",24)
    .s CheckDate=$p($G(^DHCOEDISQTY(dhcDspId)),"^",22)
    .s CheckTime=$p($G(^DHCOEDISQTY(dhcDspId)),"^",23)
    .s CheckFlag=$p($G(^DHCOEDISQTY(dhcDspId)),"^",21)
    s CheckStr=$G(CheckUserId)_"^"_$G(CheckDate)_"^"_$G(CheckTime)_"^"_$G(CheckFlag)
	q:(dhcDspId'="") CheckStr
	i oeoriId'="" d
	.s dhcDspId=""
	.f  s dhcDspId=$O(^DHCOEDISQTY(0,"OEORI",oeoriId,dhcDspId))  q:dhcDspId=""  d
    ..s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    ..q:dhcDspStat="R"
    ..s CheckUserId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",24)
    ..i CheckUserId'="" s flagenum=flagenum+1
    ..s num=num+1
    ..s CheckDate=$p($G(^DHCOEDISQTY(dhcDspId)),"^",22)
    ..s CheckTime=$p($G(^DHCOEDISQTY(dhcDspId)),"^",23)
    i (flagenum'=0)&(flagenum=num) s CheckStr=$G(CheckUserId)_"^"_$G(CheckDate)_"^"_$G(CheckTime)
    i flagenum=0 s CheckStr=""
    q:(oeoriId'="") CheckStr
    q ""
}

ClassMethod GetUserWardId(usid, loc)
{
 ///获得用户病区dup??
  //n (usid,loc)
  //s loc=$P(^SSU("SSUSR",usid),"^",4)
  s warddes=$P(^CTLOC(loc),"^",2)
  s loctyp=$P(^CTLOC(loc),"^",13)
  q:loctyp'="W" ""  //ward
  s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
  s ctcpt=$P(^SSU("SSUSR",usid),"^",14)
  i $G(ctcpt)'="" s typid=$P(^CTPCP(ctcpt,1),"^",4)
  i $G(typid)'="" s typdes=$P(^CT("CPT",typid),"^",4)
  i ($G(typdes)="NURSE") s res=warddes_"^"_wardid
  //b ;001
  s paroom=0 f  s paroom=$o(^PAADMi("CurrWard",wardid,paroom)) q:(paroom="")!($G(ctloc)'="")  d
  .s admId=0 f  s admId=$o(^PAADMi("CurrWard",wardid,paroom,admId)) q:(admId="")!($G(ctloc)'="")  d
  ..s ctlocdr=$P(^PAADM(admId),"^",4)
  ..q:ctlocdr=loc
  ..i ctlocdr'="" s ctloc=$P(^CTLOC(ctlocdr),"^",2)
  i $G(res)'="" s res=res_"|"_$G(ctloc)_"^"_$G(ctlocdr) 
  q $G(res)
}

ClassMethod Getdocloc(admId, Oew, OrdSub)
{
	//dup??
         //n (admId,Oew,OrdSub)
         s res="Y"
   	     s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
         q:user="" "N"
	     s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
         if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	     e  q "N"
		        
	     if '$D(^CT("CPT",CpTypDR))
	     {
		  w !, DoctorDr
		  q "N"
		 }
	     i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	     q:($G(CpTyp)'="DOCTOR") "N"  //////////////2005-12-3 qse add
	     s truedoc=0
	     s DocLoc="" //2005-12-3 qse add///////////////////////////////////////
	     f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:DocLoc=""  d
	     .if $D(^TMP($J,"loc",admId,DocLoc))  s truedoc=1
         i truedoc'=1 s res="N" 
 q res
}

ClassMethod getDep(Dep, Oew, OrdSub) As %String
{
    //dup??
    //n (Dep,Oew,OrdSub)
	s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	q:user="" "N"
	q:'$D(^SSU("SSUSR",user)) "N"
	s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	q:DoctorDr="" "N"  
	s truedoc=0
	s Loc="" 
	f  s Loc=$O(^RB("RES",0,"CTPCP",DoctorDr,Loc)) q:Loc=""  d
	.if Dep=Loc  s truedoc=1
	q:truedoc=0 "N"
	q:truedoc=1 "Y"
}

ClassMethod GetDispCatCode(oeori As %String) As %String
{
	//dup??
 //n (oeori)
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 q:ord="" "" q:itm="" "" q:'$d(^OEORD(ord,"I",itm,1)) ""
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
 s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
 q:sub="" "" q:ver="" "" q:'$d(^ARCIM(sub,ver,1))
 s arcic=$p(^ARCIM(sub,ver,1),"^",10) q:arcic="" ""
 //s ^ypzTmp(101)=$g(^ypzTmp(101))_"/"_oeori_"/"_sub_"/"_arcic
 &sql(select sdgi_sdg_parref->sdg_code into :sdgcode 
	 From DHCStkDrugGrpitm where sdgi_ordercat_dr=:arcic)
 //s ^ypzTmp(101)=$g(^ypzTmp(101))_"/"_$g(sdgcode)
 q $g(sdgcode)
}

ClassMethod SendMsg(WardId, Ward, userId, Process) As %String
{
	s Date=$P($H,",")
	s Time=$P($H,",",2)
	s loc=""  f  s loc=$O(^TMP(WardId,Process,"RecLocMed",loc))  q:loc=""  d
    .s cat=""  f  s cat=$O(^TMP(WardId,Process,"RecLocMed",loc,cat)) q:cat=""  d
    ..s ^DHCCLNurseExec("SendMedic",loc,$P($H,","),WardId,cat)=Ward_"^"_userId_"^"_Date_"^"_Time
	q 0
}

ClassMethod sendMessage()
{
}

ClassMethod AuditMed(userId As %String, process As %String, ArRowStr As %String, locId) As %String
{
	//audit all
 	//n (locId , std, edd, typ,userId,Process,dep,tempOrdFlag,regNo)
  	//ypz 061109 begin
 	i (userId="")!(process="") Q $$$OK
    k ^TMP("NurseCheckMoney",$j)
 	s ArRow="" f  s ArRow=$O(^TMP("AuditMed",userId,process,ArRow)) q:ArRow=""  d
 	.q:$D(^TMP("NurExec",userId,"UnAudit",ArRow))
 	.q:(ArRowStr'="")&(ArRowStr'[ArRow) // + wxl 090331
 	.s Ord=""  f  s Ord=$O(^TMP("AuditMed",userId,process,ArRow,Ord)) q:Ord=""  d
 	..s OrdSub=""  f  s OrdSub=$O(^TMP("AuditMed",userId,process,ArRow,Ord,OrdSub)) q:OrdSub=""  d
 	...s DispenId=""  f  s DispenId=$O(^TMP("AuditMed",userId,process,ArRow,Ord,OrdSub,DispenId)) q:DispenId=""  d
    ....s retStr=..AuditDrug(Ord_"||"_OrdSub_"^"_DispenId,userId,"",locId)
    ....i retStr'=0 s error=retStr
   //删除标记
    if $D(^TMP("NurExec",userId,"UnAudit")) k ^TMP("NurExec",userId,"UnAudit")
   //s a=..SendMsg(ward,ward,userId,Process)  //发送消息  //ypz 070129
   q:$g(error)'="" error
   q 0
}

ClassMethod CheckMed(userId As %String, process As %String, ArRowStr As %String) As %String
{
	s ^PanTmp("CheckMed")=userId_","_process_","_ArRowStr
	//audit all
 	//n (locId , std, edd, typ,userId,Process,dep,tempOrdFlag,regNo)
  	//ypz 061109 begin
 	i (userId="")!(process="") Q $$$OK
 	s ArRow="" f  s ArRow=$O(^TMP("AuditMed",userId,process,ArRow)) q:ArRow=""  d
 	.q:$D(^TMP("NurExec",userId,"UnAudit",ArRow))
 	.q:(ArRowStr'="")&(ArRowStr'[ArRow) // + wxl 090331
 	.s Ord=""  f  s Ord=$O(^TMP("AuditMed",userId,process,ArRow,Ord)) q:Ord=""  d
 	..s adm=+(^OEORD(Ord))
 	..s feeStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(adm, "")
 	..s flag=$p(feeStr,"^",5)
 	..s OrdSub=""  f  s OrdSub=$O(^TMP("AuditMed",userId,process,ArRow,Ord,OrdSub)) q:OrdSub=""  d
    ...s retStr=..CheckDrug(Ord_"||"_OrdSub,userId,"")
   //删除标记
    if $D(^TMP("NurExec",userId,"UnAudit")) k ^TMP("NurExec",userId,"UnAudit")
   //s a=..SendMsg(ward,ward,userId,Process)  //发送消息  //ypz 070129
   q 0
}

ClassMethod PhAudit(dhcDspIdStr, userId, ArcRow = "", locId = "", auditBatchId = "") As %String
{
 //药品审核
  k ^TMP("NurseCheckMoney",$j)
  s dhcDspIdLen=$L(dhcDspIdStr,"^")
  if (dhcDspIdStr'="")
  {
    f i=1:1:dhcDspIdLen
    {
	  s dhcDspId=$P(dhcDspIdStr,"^",i)
	  s retStr=..AuditDrug(""_"^"_dhcDspId,userId,auditBatchId,locId)
	  s oeoriId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",1)
	  s oew=$P(oeoriId,"||")
	  s chl=$P(oeoriId,"||",2)
	  s RecLoc=$P(^OEORD(oew,"I",chl,3),"^",6)
	  s MedTyp=..GetDispCatCode(oeoriId)
	  //s wardId=$O(^PAWARD(0,"WARD_LocationDR",locId,""),-1)  //ypz 070430
	  //s ^DHCCLNurseExec("SendMedic",RecLoc,$P($H,","),wardId,MedTyp)=wardId_"^"_userId_"^"_$P($H,",")_"^"_$P($H,",",2)
    }
  }
	 if (ArcRow'="")
	 {
	  s ^TMP("NurExec",userId,"UnAudit",ArcRow)=""
	 }
  q "0"
}

ClassMethod PhCheck(dhcDspIdStr, userId, ArcRow = "", locId = "", auditBatchId = "") As %String
{
 //药品审核
  s dhcDspIdLen=$L(dhcDspIdStr,"^")
  if (dhcDspIdStr'="")
  {
    f i=1:1:dhcDspIdLen
    {
	  s dhcDspId=$P(dhcDspIdStr,"^",i)
	  s retStr=..CheckDrug(""_"^"_dhcDspId,userId,auditBatchId,locId)
	  s oeoriId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",1)
	  s oew=$P(oeoriId,"||")
	  s chl=$P(oeoriId,"||",2)
	  s RecLoc=$P(^OEORD(oew,"I",chl,3),"^",6)
	  s MedTyp=..GetDispCatCode(oeoriId)
	  //s wardId=$O(^PAWARD(0,"WARD_LocationDR",locId,""),-1)  //ypz 070430
	  //s ^DHCCLNurseExec("SendMedic",RecLoc,$P($H,","),wardId,MedTyp)=wardId_"^"_userId_"^"_$P($H,",")_"^"_$P($H,",",2)
    }
  }
	 if (ArcRow'="")
	 {
	  s ^TMP("NurExec",userId,"UnAudit",ArcRow)=""
	 }
  q "0"
}

ClassMethod UnAudit(dhcDspIdStr, userId) As %String
{
 //撤消药品审核
  s dhcDspIdLen=$L(dhcDspIdStr,"^")
  f i=1:1:dhcDspIdLen
  {
	  s dhcDspId=$P(dhcDspIdStr,"^",i)
	  //s oeoriId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",1)
	  //s collect=##class(web.DHCCLCom).GetDispensingStat(oeoriId)
	  s collect=$p($G(^DHCOEDISQTY(dhcDspId)),"^",7)
	  if collect="C" s ret=$G(ret)_i_"-已发"_"^" q
	  s drugAuditStr=..GetAuditDrug(""_"^"_dhcDspId)
	  s AuditUsr=$p(drugAuditStr,"^")
	  if (AuditUsr'=userId) s ret=$G(ret)_i_"非本人不能撤销"  q
	  s undoAuditStr=..UndoAuditDrug(dhcDspId)
  }
  if $G(ret)="" s ret="OK"
  q $G(ret)
}

ClassMethod UnCheck(dhcDspIdStr, userId) As %String
{
 //撤消药品审核
  s dhcDspIdLen=$L(dhcDspIdStr,"^")
  f i=1:1:dhcDspIdLen
  {
	  s dhcDspId=$P(dhcDspIdStr,"^",i)
	  //s oeoriId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",1)
	  //s collect=##class(web.DHCCLCom).GetDispensingStat(oeoriId)
	  s collect=$p($G(^DHCOEDISQTY(dhcDspId)),"^",7)
	  if collect="C" s ret=$G(ret)_i_"-已发"_"^" q
	  s drugCheckStr=..GetCheckDrug(""_"^"_dhcDspId)
	  s CheckUsr=$p(drugCheckStr,"^")
	  if (CheckUsr'=userId) s ret=$G(ret)_i_"非本人不能撤销"  q
	  s undoAuditStr=..UndoCheckDrug(dhcDspId)
  }
  if $G(ret)="" s ret="OK"
  q $G(ret)
}

ClassMethod IL(inci, loc, dd) As %String
{
 //查询库存
 //n (inci, loc, dd)
 ;ret value :
 ; <0 - error occurs
 q:inci="" 0
 q:loc="" 0
 q:dd="" 0
 s nextdate=dd+1
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,nextdate),-1)
 i rr="" q 0
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,rr,""),-1)
 i rr="" q 0
 s qty=+$P(^DHCLOCTOT(rr),"^",4)
 q qty
}

ClassMethod GetUnPackExecute(ByRef qHandle As %Binary, userId As %String, locId As %String, std As %String, edd As %String, ArRow As %String, typ = "", dep As %String = "") As %Status
{
   Set repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)

 	i (userId="")!(locId="") Q $$$OK
 	s wardStr=..GetUserWardId(userId,locId)
 	i wardStr="" Q $$$OK
 	s ward=$p($p(wardStr,"|"),"^",2)
 	s ctcpId=$P(^SSU("SSUSR",userId),"^",14)
    i ctcpId'="" s ctcptId=$P(^CTPCP(ctcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	i $G(ctcptId)'="" s ctcpType=$P(^CT("CPT",ctcptId),"^",4)  ;CT_CarPrvTp
    i ($G(ctcpType)'="NURSE")  Q $$$OK
    s dep=""
    s anStr="^"_^DHCANOPSET("anloc")
    i anStr[("^"_locId_"|") s dep=locId
	s opStr=^DHCANOPSET("oploc")
	i opStr[("^"_locId_"|") s dep=locId
 	
 	
 	if (ward="")&(std="")&(edd="")&(ArRow="") Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s std=$ZDH(std,4),edd=$ZDH(edd,4)
 	s ATyp=""
	s Room=""  f  s Room=$O(^PAADMi("CurrWard",ward,Room)) q:Room=""  d
    .s Adm=""  f  s Adm=$O(^PAADMi("CurrWard",ward,Room,Adm)) q:Adm=""  d
    ..s DischgDate=$P(^PAADM(Adm),"^",17)
    ..q:DischgDate'=""
    ..s Patinfo=##class(web.DHCCLCom).PatInfo("^"_Adm)
    ..d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(Adm)
    ..s RegNo=$P(Patinfo,"^",1)
    ..s PatName=$P(Patinfo,"^",5)
    ..s BedCode=$P(Patinfo,"^",7)
    ..s Ord="" f  s Ord=$O(^OEORD(0,"Adm",Adm,Ord)) q:Ord=""  d
    ...s OrdSub=0  f  s OrdSub=$O(^OEORD(Ord,"I",OrdSub)) q:OrdSub=""  d
    ....s PriorDR=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",8)     ;OEC_Priority OEORI_Priority_DR
	....i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2) 
	....s Prior="^"_PriorDR_"^" 
	....q:"^6^7^"[Prior
    ....s OrdStat=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",13)
    ....q:(OrdStat=11)
    ....q:(OrdStat=4)
 	....s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期时间?加入基础数据表
	....s OrdDate=+OrdDate
	....q:((OrdDate<std)!(OrdDate>edd))&((std'="")&(edd'=""))
	....s OrdTime=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",17)
	....s DateTime=$ZD(OrdDate,3)_" "_$ZT(OrdTime)
    ....s RecLoc=$P(^OEORD(Ord,"I",OrdSub,3),"^",6)
    ....s ArcRow=$P(^OEORD(Ord,"I",OrdSub,1),"^",2)
    ....s PresNo=$P(^OEORD(Ord,"I",OrdSub,1),"^",14)  //处方号
    ....q:'$D(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1))
    ....s Arcim=$P(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1),"^",2)
    ....s unitUomId=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",3)
    ....i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    ....s PacUnit=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),8)),"^",14)
    ....if PacUnit'="" s packUomDesc=$P(^CT("UOM",PacUnit),"^",2) 
    ....s packUomQty=$p($g(^OEORD(Ord,"I",OrdSub,9)),"^",4)
    ....s phOrdQty=$p($g(^OEORD(Ord,"I",OrdSub,1)),"^",12)
    ....i (phOrdQty'="") s phOrdQtyUnit=phOrdQty_" "_$G(unitDesc)
    ....i packUomQty'=""  s phOrdQtyUnit=packUomQty_" "_packUomDesc 
    ....s res="Y"
    ....s res=..Getdocloc(Adm,Ord,OrdSub)  //只要本科室
	....q:(res="N")&(dep="")
	....s user=$P($G(^OEORD(Ord,"I",OrdSub,7)),"^",1)
    ....q:user=""
	....s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
    ....i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",2) 
    ....s ret="N"
    ....if dep'=""  s ret=..getDep(dep,Ord,OrdSub)
    ....q:(dep'="")&($G(ret)="N")  //手术室审核
    ....s ItemCatDR=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1)),"^",10)
    ....s Cat="^"_ItemCatDR_"^"
    ....s PHStat=""
    ....s PHStat=##class(web.DHCCLCom).GetDispensingStat(Ord_"||"_OrdSub)
    ....q:(^DHCNURSEITEMCAT("FaYao")'[Cat)
    ....q:(PHStat'="")
    ....s IncItm=$O(^INCI(0,"ARCIM_DR",$p(ArcRow,"||",1),""))
    ....s StockQty=..IL($G(IncItm),RecLoc,$H)
    ....if StockQty=0 s Reason="没库存"
    ....if StockQty'=0 s Reason="库存不足"
    ....q:IncItm=""
    ....s UomDr=$P(^INCI(IncItm,1),"^",10)
    ....s Uom=$P(^CT("UOM",UomDr),"^",2)
    ....if StockQty'=0  s StockQtyUnit=StockQty_" "_Uom
    ....s PhBasQty=..PhItmBasQty(ArcRow)
    ....if PhBasQty=0 s Reason="药学项基本数量为0"
    ....s Audit=Reason
    ....s ORow=Ord_"|"_OrdSub 
    ....s reclocDesc=""
    ....if RecLoc'="" s reclocDesc=$P(^CTLOC(RecLoc),"^",2)
    ....d OutPutArc1

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutArc1
	set Data=$lb(Doctor,DateTime,PatName,BedCode,Arcim,$G(Qty),$G(Uom),ORow,PriorDes,Audit,PresNo,$G(phOrdQtyUnit),$G(StockQtyUnit),reclocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PhItmBasQty(Arc) As %String
{
 //求药学项基本数量
	//n (Arc)
	s PHItm=$P(^ARCIM($P(Arc,"||",1),$P(Arc,"||",2),1),"^",12)
	q:PHItm="" ""
	s PHBaseQty=$P(^PHCD($P(PHItm,"||",1),"DF",$P(PHItm,"||",2),2),"^",5)
    q $G(PHBaseQty)
}

ClassMethod GetUnPackFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnPackExecute ]
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

Query GetUnPack(userId As %String, locId As %String, std As %String, edd As %String, ArRow As %String, typ = "", dep As %String = "") As %Query(ROWSPEC = "Doctor,OrdDate,PatName,BedCode,Arcim,Qty,Uom,Orw,Prior,Audit,PresNo,phOrdQtyUnit,StockQtyUnit")
{
}

ClassMethod GetUnPackClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnPackExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod pack(PresNo)
{
 //药品打包
  	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set CurrentNS=$ZNSPACE
	ZN MEDDATA	
    s res= $$PackPresc^DHCPackPresc(PresNo)
    zn CurrentNS
  q res
}

Query Findpat(wardId As %String, unPayFlage As %String) As %Query(ROWSPEC = "regNo,patName,bedNo")
{
}

ClassMethod FindpatExecute(ByRef qHandle As %Binary, wardId As %String, unPayFlage As %String = "false") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i wardId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s wardId=+wardId
    s roomId=""
    f  s roomId=$O(^PAADMi("CurrWard",wardId,roomId)) q:roomId=""  d
    .s admId=""
    .f  s admId=$O(^PAADMi("CurrWard",wardId,roomId,admId)) q:admId=""  d
    ..s regNo="",patName="",bedNo=""
    ..q:'$d(^PAADM(admId))
	..s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(admId,"")   //是否允许发药
	..s flag=$p(feeRetStr,"^",9)
	..q:(flag'="Y")&&(unPayFlage="true")
    ..s visitStatus=$p(^PAADM(admId),"^",20)
    ..q:(visitStatus="")||(visitStatus="C")
    ..s regNo=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
    ..s patName=$p(^PAPER(+^PAADM(admId),"ALL"),"^",1)
    ..s bedRowId=$p(^PAADM(admId),"^",73)
    ..q:bedRowId=""
    ..i bedRowId'=""  d  
    ...s wardId=$p(bedRowId,"||",1),bedId=$p(bedRowId,"||",2)
    ...s bedNo=$p(^PAWARD(wardId,"BED",bedId),"^",1)
	..s BedOrder(bedNo)=regNo_"^"_patName
	
	s bedNo=""
	f  s bedNo=$O(BedOrder(bedNo)) q:bedNo=""  d
	.s regNo=$P(BedOrder(bedNo),"^",1)
	.s patName=$P(BedOrder(bedNo),"^",2)
	.Do OutputRowpat
     
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputRowpat
	set Data=$lb(regNo,patName,bedNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindpatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindpatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindpatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindpatExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocLinkDoc(Ord, OrdSub, locId)
{
	s retStr=0
	;q:(Ord="")!(OrdSub="") retStr
	q:(Ord="")!(OrdSub="")!(locId="") retStr
	;s admId=$p($g(^OEORD(Ord)),"^",1)
	;q:admId="" retStr
	;s admLocId=$p(^PAADM(admId),"^",4)
	;q:admLocId="" retStr
	s locIdStr=##Class(web.DHCCLCom).GetLinkLocId(locId)
	i locIdStr'="" s locIdStr="^"_locId_"^"_locIdStr_"^"
	e  s locIdStr="^"_locId_"^"
    s userId=$P($G(^OEORD(Ord,"I",OrdSub,7)),"^",1)
    q:userId="" retStr
    s doctorDr=$P(^SSU("SSUSR",userId),"^",14)
    q:doctorDr="" retStr
    s docLocId=""
    f  s docLocId=$o(^RB("RES",0,"CTPCP",doctorDr,docLocId)) q:docLocId=""  d
    .;i docLocId=admLocId s retStr=1
    .i locIdStr[docLocId s retStr=1
    q retStr
}

/// 护士审核时间
Query GetAuditTime() As %SQLQuery(CONTAINID = 1)
{
    select * from DHC_NurDispensingTime
}

/// 护士审核时间维护
ClassMethod InsertDispAudit(batch As %String = "", fromTime As %String = "", endTime As %String = "", auditTime As %String = "")
{
	q:(batch="")!(fromTime="")!(endTime="")!(auditTime="") "数据不全!"
	s fromTime=$ZTH(fromTime),endTime=$ZTH(endTime),auditTime=$ZTH(auditTime)
	//q:(fromTime=0)!(endTime=0)!(auditTime=0) "时间格式不对!"
	&SQL(Insert into DHC_NurDispensingTime (Batch,FromTime,EndTime,AuditTime) Values (:batch,:fromTime,:endTime,:auditTime))
	i SQLCODE=0 s ret="插入成功!"
	e  s ret="插入失败!"
	q ret
}

ClassMethod UpdateDispAudit(rowID As %String = "", batch As %String = "", fromTime As %String = "", endTime As %String = "", auditTime As %String = "")
{
	q:(rowID="")!(batch="")!(fromTime="")!(endTime="")!(auditTime="") "数据不全!"
	s rowID=+rowID,fromTime=$ZTH(fromTime),endTime=$ZTH(endTime),auditTime=$ZTH(auditTime)
	q:(rowID=0) "RowID不存在!"
	&SQL(Update DHC_NurDispensingTime set Batch=:batch,FromTime=:fromTime,EndTime=:endTime,AuditTime=:auditTime where RowID=:rowID)
	i SQLCODE=0 s ret="更新成功!"
	e  s ret="更新失败!"
	q ret
}

ClassMethod DeleteDispAudit(rowID As %String = "")
{
	s rowID=+rowID
	q:(rowID=0) "RowID不存在!"
	&SQL(Delete From DHC_NurDispensingTime where RowID=:rowID)
	i SQLCODE=0 s ret="删除成功!"
	e  s ret="删除失败!"
	q ret
}

/// w ##Class(web.DHCNurDrugAudit).GetAuditTimeList()
ClassMethod GetAuditTimeList() As %String
{
	///List 加载审核批次
	s retStr=""
    s rowId="" f  s rowId=$O(^DHCNurDisAud(rowId)) q:rowId=""  d
    .s batch=$P(^DHCNurDisAud(rowId),"^",1)
    .i retStr="" s retStr=rowId_"^"_batch
    .e  s retStr=retStr_"|"_rowId_"^"_batch
    q retStr
}

ClassMethod GetFaYaoList(ward, userId, locId, admId, stdate, edate, typ = "", dep = "", tempOrdFlag = "", Audittyp = "", RollFl = "", longOrdFlag = "", RecLocId = "", ArcimID = "", auditBatchId = "", StTime = "", ETime = "", CheckFlag = "Y", GZFl = "", DMFl = "", KfyFlag = "", NotKfyFlag = "", OutFlag = "") As %String
{
	s ^panTmp("drugCheck")=stdate_"|"_StTime_"|"_edate_"|"_ETime_"|"_CheckFlag
	q:(ward="")!(userId="")!(locId="")!(admId="")
    i auditBatchId'="" d
 	.s fromTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",2)
 	.s toTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",3)
 	.i fromTime>toTime s fromTime="",toTime=""
    s Ord="" f  s Ord=$O(^OEORD(0,"Adm",admId,Ord)) q:Ord=""  d
    .s OrdSub=0  f  s OrdSub=$O(^OEORD(Ord,"I",OrdSub)) q:OrdSub=""  d
    ..;w Ord_"||"_OrdSub,!
    ..s locLinkDoc=..GetLocLinkDoc(Ord,OrdSub,locId)
    ..q:(locLinkDoc=0)&(ward'=819)&(ward'=822)                //过滤非本科室医生开的医嘱
    ..s oeoriId=Ord_"||"_OrdSub
    ..s PriorDR=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
    ..q:PriorDR=""  //ypz 061001
    ..s PriorDes=$P(^OECPR(PriorDR),"^",2) 
    ..s Prior="^"_PriorDR_"^" 
    ..////q:"^6^7^"[Prior  //6 7 自备
    ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
    ..q:(OutFlag="on")&(oecprCode'="OUT")
    ..//长期嘱托和临时嘱托不领药
    ..q:(oecprCode="OM")!(oecprCode="OMST")!(oecprCode="OMCQZT")!(oecprCode="OMLSZT")
    ..i ((tempOrdFlag="")&((oecprCode="NORM")!(oecprCode="STAT"))) q
    ..i ((longOrdFlag="")&(oecprCode="S")) q
    ..s OrdStat=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",13)
    ..s ordItemStatCode=$p($g(^OEC("OSTAT",+OrdStat)),"^")
    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
    ..s xDate=$p($g(^OEORD(Ord,"I",OrdSub,3)),"^",34)
    ..s xTime=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",15)
    ..q:(OrdStat=11)||(OrdStat=10)||(OrdStat=2) //未激活和未核实医嘱
    ..//q:(OrdStat=4)
    ..//q:(OrdStat=4)&(typ'="C")
    ..;q:(ordStatCode="D")&(typ'="C")
    ..q:(OrdStat=4)&(typ'="C")&(Audittyp'="on")&((oecprCode="NORM")!(oecprCode="OUT")!(oecprCode="ONE"))
    ..//s drugAuditStr=..GetAuditDrug(oeoriId)
    ..s FillerNo=$P($G(^OEORD(Ord,"I",OrdSub,9)),"^",12) 
    ..if FillerNo'="" d
    ...s drugAuditF=..GetAuditDrug(oeoriId)
    ...//i $p(drugAuditF,"^")="" s res=..AuditDrug(oeoriId,userId)  //自动审核
    ..q:(FillerNo'="")&(RollFl'="on")
    ..q:(FillerNo'="")&(CheckFlag="Y")
    ..//q:(typ'="C")&(Audittyp="on")&($p(drugAuditStr,"^")="") //ypz 070317
    ..//q:(Audittyp="")&($D(^DHCCLNurseExec("Audit",Ord,OrdSub))'=0)  //xuqy 070124
    ..//q:(Audittyp="")&($p(drugAuditStr,"^")'="")  //ypz 070318
    ..s res=..Getdocloc(admId,Ord,OrdSub)  //转科科室
    ..//q:(res="N")&(dep="")
    ..s ret="N"
    ..i dep'=""  s ret=..getDep(dep,Ord,OrdSub)
    ..q:(dep'="")&($G(ret)="N")&(ward'=819)&(ward'=822)  //手术科室审核
    ..//s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期时间?加入基础数据表
    ..s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",9)
    ..s OrdDate=+OrdDate
    ..//w !,OrdDate,",",stdate,",",edate
    ..q:((OrdDate<stdate)!(OrdDate>edate))&((stdate'="")&(edate'=""))
    ..s RecLoc=$P(^OEORD(Ord,"I",OrdSub,3),"^",6)
    ..q:(RecLoc'=RecLocId)&(RecLocId'="") //药房
    ..s ArcRow=$P(^OEORD(Ord,"I",OrdSub,1),"^",2)
    ..q:(ArcRow'=ArcimID)&(ArcimID'="")
    ..s ItemCatDR=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1)),"^",10)
    ..s Cat="^"_ItemCatDR_"^"
    ..//s OrdCat=$P(^ARC("IC",ItemCatDR),"^",8)
    ..q:^DHCNURSEITEMCAT("FaYao")'[Cat
    ..s ItemCatDesc=$P(^ARC("IC",ItemCatDR),"^",2)
    ..q:(GZFl="on")&(ItemCatDesc'["贵重")
    ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(Ord_"||"_OrdSub)
    ..s jfFlag=##class(web.DHCJFArrearsOrdItm).DHCJFArrearsOrdCheck(ArcRow)
    ..q:((jfFlag=0)!(ItemCatDesc'["贵重")!((oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT")))&((ward=819)!(ward=822))
    ..i oeoriId="160590||1335" w jfFlag
    ..s IsDM=##class(web.DHCSTINTERFACE).GetPoisonByOrd(oeoriId)
    ..q:(DMFl="on")&(IsDM'=1)
    ..s CatCode=$p($G(^ARC("IC",ItemCatDR)),"^",1)
    ..s MedCode=##Class(web.DHCSTPCHCOLLS).GetCat(CatCode)
    ..q:(KfyFlag="on")&(NotKfyFlag'="on")&(MedCode'="KFBY")
    ..q:(NotKfyFlag="on")&(KfyFlag'="on")&(MedCode="KFBY")
    ..//q:(OrdCat=22)!(OrdCat=21) //宁波 消耗材料
    ..//ypz 080411 begin
    ..s MedTyp=..GetDispCatCode(oeoriId) //发药类型
    ..//q:MedTyp="" //ypz 060923
    ..//s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:OrdEx=""  d
    ..s dhcDspId=0  
    ..f  s dhcDspId=$O(^DHCOEDISQTY(0,"OEORI",oeoriId,dhcDspId))  q:dhcDspId=""  d
    ...s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    ...q:dhcDspStat="R"
    ...q:dhcDspStat'=typ
    ...s drugAuditStr=..GetAuditDrug(""_"^"_dhcDspId)
    ...q:(Audittyp="on")&($p(drugAuditStr,"^")="")
    ...q:(Audittyp="")&($p(drugAuditStr,"^")'="")
    ...s dosTime=$P(^DHCOEDISQTY(dhcDspId),"^",20)
    ...b ;001
    ...s dosDateTimval=(OrdDate*100000)+dosTime
    ...s xDateTimeval=(xDate*100000)+xTime
    ...q:(ordStatCode="PD")&(typ'="C")&(xDateTimeval<dosDateTimval)
    ...q:(ordItemStatCode="D")&(typ'="C")&(xDateTimeval<dosDateTimval)
    ...q:(OrdDate=edate)&(ETime'="")&(dosTime>ETime) //pan  (CheckFlag="N")&
    ...q:(OrdDate=stdate)&(StTime'="")&(dosTime<StTime) //(CheckFlag="N")&
    ...//q:($G(fromTime)'="")&($G(toTime)'="")&&((dosTime<fromTime)!(dosTime>toTime))
    ...s Qty=$P(^DHCOEDISQTY(dhcDspId),"^",5)
    ...s uomId=$P(^DHCOEDISQTY(dhcDspId),"^",6)
    ...s PackUom=$p(^CT("UOM",uomId),"^",2) 
    ...s ^TMP(ward,$J,"RecLoc",RecLoc,ArcRow,"Qty")=$G(^TMP(ward,$J,"RecLoc",RecLoc,ArcRow,"Qty"))+Qty
    ...s ^TMP(ward,$J,"RecLoc",RecLoc,ArcRow,"Uom")=PackUom
    ...s ^TMP("AuditMed",userId,$J,ArcRow,Ord,OrdSub,dhcDspId)=""
}

ClassMethod GetFaYaoList1(ward, userId, locId, admId, stdate, edate, typ = "", dep = "", tempOrdFlag = "", Audittyp = "", RollFl = "", longOrdFlag = "", RecLocId = "", ArcimID = "", auditBatchId = "") As %String
{
	q:(ward="")!(userId="")!(locId="")!(admId="")
    i auditBatchId'="" d
 	.s fromTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",2)
 	.s toTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",3)
 	.i fromTime>toTime s fromTime="",toTime=""
    s Ord="" f  s Ord=$O(^OEORD(0,"Adm",admId,Ord)) q:Ord=""  d
    .s OrdSub=0  f  s OrdSub=$O(^OEORD(Ord,"I",OrdSub)) q:OrdSub=""  d
    ..s locLinkDoc=..GetLocLinkDoc(Ord,OrdSub,locId)
    ..q:locLinkDoc=0                 //过滤非本科室医生开的医嘱
    ..s oeoriId=Ord_"||"_OrdSub
    ..s PriorDR=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
    ..q:PriorDR=""  //ypz 061001
    ..s PriorDes=$P(^OECPR(PriorDR),"^",2) 
    ..s Prior="^"_PriorDR_"^" 
    ..////q:"^6^7^"[Prior  //6 7 自备
    ..s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
    ..q:(oecprCode="OM")!(oecprCode="OMST")
    ..i ((tempOrdFlag="")&((oecprCode="NORM")!(oecprCode="STAT"))) q
    ..i ((longOrdFlag="")&(oecprCode="S")) q
    ..s OrdStat=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",13)
    ..q:(OrdStat=11)
    ..//q:(OrdStat=4)
    ..q:(OrdStat=4)&(typ'="C")
    ..//s drugAuditStr=..GetAuditDrug(oeoriId)
    ..s FillerNo=$P($G(^OEORD(Ord,"I",OrdSub,9)),"^",12) 
    ..if FillerNo'="" d
    ...s drugAuditF=..GetAuditDrug(oeoriId)
    ...//i $p(drugAuditF,"^")="" s res=..AuditDrug(oeoriId,userId)  //自动审核
    ..q:(FillerNo'="")&(RollFl'="on")
    ..//q:(typ'="C")&(Audittyp="on")&($p(drugAuditStr,"^")="") //ypz 070317
    ..//q:(Audittyp="")&($D(^DHCCLNurseExec("Audit",Ord,OrdSub))'=0)  //xuqy 070124
    ..//q:(Audittyp="")&($p(drugAuditStr,"^")'="")  //ypz 070318
    ..s res=..Getdocloc(admId,Ord,OrdSub)  //转科科室
    ..//q:(res="N")&(dep="")
    ..s ret="N"
    ..i dep'=""  s ret=..getDep(dep,Ord,OrdSub)
    ..q:(dep'="")&($G(ret)="N")  //手术科室审核
    ..//w !,Ord,"dep ,ret ",$g(OrdSub)
    ..//s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期时间?加入基础数据表
    ..s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",9)
    ..s OrdDate=+OrdDate
    ..//w !,OrdDate,",",stdate,",",edate
    ..q:((OrdDate<stdate)!(OrdDate>edate))&((stdate'="")&(edate'=""))
    ..s RecLoc=$P(^OEORD(Ord,"I",OrdSub,3),"^",6)
    ..q:(RecLoc'=RecLocId)&(RecLocId'="") //药房
    ..s ArcRow=$P(^OEORD(Ord,"I",OrdSub,1),"^",2)
    ..q:(ArcRow'=ArcimID)&(ArcimID'="")
    ..s ItemCatDR=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1)),"^",10)
    ..s Cat="^"_ItemCatDR_"^"
    ..//s OrdCat=$P(^ARC("IC",ItemCatDR),"^",8)
    ..q:^DHCNURSEITEMCAT("FaYao")'[Cat
    ..//q:(OrdCat=22)!(OrdCat=21) //宁波 消耗材料
    ..//ypz 080411 begin
    ..s MedTyp=..GetDispCatCode(oeoriId) //发药类型
    ..//q:MedTyp="" //ypz 060923
    ..//s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:OrdEx=""  d
    ..s dhcDspId=0  
    ..f  s dhcDspId=$O(^DHCOEDISQTY(0,"OEORI",oeoriId,dhcDspId))  q:dhcDspId=""  d
    ...s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    ...q:dhcDspStat="R"
    ...q:dhcDspStat'=typ
    ...s drugAuditStr=..GetAuditDrug(""_"^"_dhcDspId)
    ...q:(Audittyp="on")&($p(drugAuditStr,"^")="")
    ...q:(Audittyp="")&($p(drugAuditStr,"^")'="")
    ...s dosTime=$P(^DHCOEDISQTY(dhcDspId),"^",20)
    ...//q:($G(fromTime)'="")&($G(toTime)'="")&&((dosTime<fromTime)!(dosTime>toTime))
    ...s Qty=$P(^DHCOEDISQTY(dhcDspId),"^",5)
    ...s uomId=$P(^DHCOEDISQTY(dhcDspId),"^",6)
    ...s PackUom=$p(^CT("UOM",uomId),"^",2) 
    ...s ^TMP(ward,$J,"RecLoc",RecLoc,ArcRow,"Qty")=$G(^TMP(ward,$J,"RecLoc",RecLoc,ArcRow,"Qty"))+Qty
    ...s ^TMP(ward,$J,"RecLoc",RecLoc,ArcRow,"Uom")=PackUom
    ...s ^TMP("AuditMed",userId,$J,ArcRow,Ord,OrdSub,dhcDspId)=""
}

/// Creator: wangxinlei
/// CreatDate: 2009-10-10
/// Description: 对于药品明细审核,点"部分审核"时未打勾的医嘱只填入审核人不置审核标志为"Y"
/// Table：DHC_OEDispensing
/// Input：dhcDspIdStr: 医嘱ID^发药ID(oeoriId^dhcDspId), userId: 操作用户, ArcRow: 药品医嘱ID, locId: 登陆科室ID
/// Return：审核成功返回0,失败返回非0
ClassMethod PartAudit(dhcDspIdStr, userId, ArcRow = "", locId = "") As %String
{
  s dhcDspIdLen=$L(dhcDspIdStr,"^")
  s curDate=+$h,curTime=$p($h,",",2)
  s ret=0
  if (dhcDspIdStr'="")
  {
    f i=1:1:dhcDspIdLen d  q:ret'=0
	  .s tmpDspIdStr=$P(dhcDspIdStr,"^",i)
	  .s selFlag=$P(tmpDspIdStr,"!",1)
	  .s dhcDspId=$P(tmpDspIdStr,"!",2)
	  .q:dhcDspId=""
	  .&sql(update DHC_OEDispensing set DSP_ConfirmUser=:userId,DSP_DateConfirm=:curDate,DSP_TimeConfirm=:curTime,DSP_ConfirmFlag=:selFlag where DSP_RowId=:dhcDspId)
	  .s ret=SQLCODE
  }
  if (ArcRow'="")
  {
	  s ^TMP("NurExec",userId,"UnAudit",ArcRow)=""
  }
  q ret
}

}
