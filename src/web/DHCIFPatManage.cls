Class web.DHCIFPatManage Extends %Persistent [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetOrdInfo(RegNo As %String, DefVarTyp As %String)
{
	;w ##class(web.DHCIFPatManage).GetOrdInfo("03858186","SYDO")
	//取病人三天内所有未执行，未配置医嘱数
	s OrdNum=..GetOrdNum(RegNo,DefVarTyp)
	s UnExecOrdNum=$P(OrdNum,"^",1)
	s UnExecDosAgeNum=$P(OrdNum,"^",2)
	s ret="剩余未执行:"_UnExecOrdNum_" 剩余未配制:"_UnExecDosAgeNum
	q ret
}

ClassMethod GetOrdNum(RegNo As %String, DefVarTyp As %String) As %String
{
	q:RegNo=""
	s papmiId=$O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),"")) 
 	q:papmiId=""
 	s UnExecOrdNum=0,UnExecDosAgeNum=0 //未执行医嘱,未配置医嘱
 	s Adm="" f  s Adm=$O(^PAPERdr(papmiId,"ADM","O",Adm),-1) q:Adm=""  d
    .s Oew=$O(^OEORD(0,"Adm",Adm,""))
 	.s fromDate=$h-2,toDate=$h
 	.f Date=fromDate:1:toDate d
 	..s Extim="" f  s Extim=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim)) q:Extim=""  d
    ...s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim,OrdSub)) q:OrdSub=""  d
    ....q:$P(^OEORD(Oew,"I",OrdSub,11),"^",39)'=""  //子医嘱退出
    ....s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8) 
    ....q:PriorDR="" 
    ....s PriorDes=$P(^OECPR(PriorDR),"^",2)
    ....q:PriorDes="取药医嘱"
    ....s MethDr=$p(^OEORD(Oew,"I",OrdSub,2),"^",7)
    ....s MethId="^"_^DHCCLNurseExec("VarDef",0,DefVarTyp,"PhcIn")_"^"
    ....q:MethId'[("^"_MethDr_"^")
    ....s Meth=$P(^PHCIN(MethDr),"^",2)
    ....s ordStatCode=##Class(web.DHCIFComm).GetOrdStatCode(Oew_"||"_OrdSub)
    ....q:ordStatCode="D" //跳过停止医嘱
    ....s ArcimDR=$P(^OEORD(Oew,"I",OrdSub,1),"^",2)
    ....s ARCIMRowid=$P(ArcimDR,"||",1)
	....s ARCIMSub=$P(ArcimDR,"||",2)
	....s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
    ....s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
    ....q:OrdTyp'="R" //非药品医嘱
    ....s ExceChl=""  f  s ExceChl=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim,OrdSub,ExceChl)) q:ExceChl=""  d  
    .....s UnExecOrdNum=UnExecOrdNum+1
    .....s OeoreId=Oew_"||"_OrdSub_"||"_ExceChl
    .....s DosRowId=$O(^User.DHCIFDosAgeI("Oeore"," "_OeoreId,""))
    .....i DosRowId="" s UnExecDosAgeNum=UnExecDosAgeNum+1
    s ret=UnExecOrdNum_"^"_UnExecDosAgeNum
    q ret
}

Query GetSYPatList(CTLocId As %String) As %Query(ROWSPEC = "SeatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,EpisodeID:%String,PatAllergy:%String,PatOrdInfo:%String,LeaveTime:%String")
{
}

ClassMethod GetSYPatListExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s CTLocId=$P(Parr,"^",1)
 	s DefVarTyp=$P(Parr,"^",2)
 	i CTLocId="" Quit $$$OK
 	s Seatid="" f  s Seatid=$O(^User.DHCNurSySeatI("loc"," "_CTLocId,Seatid)) q:Seatid=""  d
 	.s flag=$list(^User.DHCNurSySeatD(Seatid),7)
 	.q:flag="N"
 	.s SeatNo=$list(^User.DHCNurSySeatD(Seatid),3)
 	.s id="" f  s id=$O(^User.DHCNurSyPatRecI("seat"," "_CTLocId," "_Seatid," Y",id)) q:id=""  d
 	..s EpisodeID=$list(^User.DHCNurSyPatRecD(id),3)
 	..s PapmiDr=$P(^PAADM(EpisodeID),"^",1)
 	..s PatName=$P(^PAPER(PapmiDr,"ALL"),"^",1)
 	..s PatRegNo=$P(^PAPER(PapmiDr,"PAT",1),"^",2)
 	..s PatBirthDay=$P(^PAPER(PapmiDr,"ALL"),"^",6)
 	..s PatAge=##class(web.DHCIFComm).CalAge(PatBirthDay,$P($H,",",1))
 	..s SexDr=$P(^PAPER(PapmiDr,"ALL"),"^",7)
 	..s PatSex=$P(^CT("SEX",SexDr),"^",2)
 	..s Mradm=$P(^PAADM(EpisodeID),"^",61)
 	..s chl="" f  s chl=$O(^MR(Mradm,"DIA",chl)) q:chl=""  d
 	...s DiaTypDr=$P($G(^MR(Mradm,"DIA",chl,"TYP",1)),"^",1)
 	...q:DiaTypDr=""
 	...s DiaTypCode=$P(^MRC("DTYP",DiaTypDr),"^",1)
 	...q:DiaTypCode'["OUT"
 	...s DiaDr=$P(^MR(Mradm,"DIA",chl),"^",1)
 	...s DiaDesc=$P(^MRC("ID",DiaDr),"^",2)
 	..s PatAllergy=##class(web.DHCIFComm).GetPatAllergy(EpisodeID)
 	..s PatOrdInfo=..GetOrdInfo(PatRegNo,DefVarTyp)
 	..s LeaveTime=..LeaveTime(PatRegNo)
 	..do OutRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
OutRow
	set Data=$lb($G(SeatNo),$G(PatName),$G(PatSex),$G(PatAge),$G(EpisodeID),$G(PatAllergy),$G(PatOrdInfo),$G(LeaveTime))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSYPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSYPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSYPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSYPatListExecute ]
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

ClassMethod LeaveTime(RegNo As %String) As %String
{
	s time="",DistantDay=0
	s rw="" f  s rw=$O(^User.DHCIFTimeI("RegNo"," "_RegNo,rw)) q:rw=""  d
	.s Status=$list(^User.DHCIFTimeD(rw),13)
	.q:Status="Y" 
	.s PrefinalDate=$list(^User.DHCIFTimeD(rw),7)
	.s PrefinalTime=$list(^User.DHCIFTimeD(rw),8)
	.s WithTime=$list(^User.DHCIFTimeD(rw),14)
	.s NowDate=$P($h,",",1)
	.s NowTime=$P($h,",",2)
	.i PrefinalDate>NowDate d
	..i WithTime>86400 d
	..s DistantDay=PrefinalDate-NowDate
	..s time=PrefinalTime
	..e  s time=86400-NowTime+PrefinalTime
	.i PrefinalDate=NowDate d
	..i PrefinalTime>NowTime s time=PrefinalTime-NowTime
	..e  s time=0
	.i PrefinalDate< NowDate s time=0
	i time'="" s ret="剩余时间:"_" "_$ZT(time)
	i DistantDay>0 s ret="剩余时间:"_DistantDay_"天"_$ZT(time)
	q $G(ret)
}

}
