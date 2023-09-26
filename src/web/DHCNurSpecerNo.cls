Include Nur.DateFormat

Class web.DHCNurSpecerNo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query LookUpOrder(PlacerNo As %String = "") As %Query(ROWSPEC = "RegNo:%String,BedCode:%String,PatName:%String,ArcimDesc:%String,PlacerNo:%String,LabNo:%String,ReclocDesc:%String,ExecStat:%String,ExecDateTime:%String,ExecCtcpDesc:%String,SpecCollUser:%String,SpecCollDateTime:%String,oeoriId:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod LookUpOrderExecute(ByRef qHandle As %Binary, PlacerNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	i PlacerNo="" 	Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s $lb(RegNo,BedCode,PatName,ArcimDesc,PlacerNo,LabNo,ReclocDesc,ExecStat,ExecDateTime,ExecCtcpDesc,SpecCollUser,SpecCollDateTime,oeoriId)=""
	s LabEpisodeNo=PlacerNo
	s LabNo=LabEpisodeNo
	s OeordId=""
	f  s OeordId=$O(^OEORD(0,"EpisNo",LabEpisodeNo,OeordId))  q:OeordId=""  d
	.s OeordSub=""
	.f  s OeordSub=$O(^OEORD(0,"EpisNo",LabEpisodeNo,OeordId,OeordSub))  q:OeordSub=""  d
	..s oeoriId=OeordId_"||"_OeordSub
	..s PatStr=##class(web.DHCCLCom).PatInfo(oeoriId)
	..q:PatStr=""
	..s RegNo=$P($G(PatStr),"^",1)
	..s PatName=$P($G(PatStr),"^",5)
	..s BedCode=$P($G(PatStr),"^",7)
	..s ArcimDesc=..GetArcim(oeoriId)
	..s ReclocId=$p($g(^OEORD(OeordId,"I",OeordSub,3)),"^",6)
	..i ReclocId'="" s ReclocDesc=$p($g(^CTLOC(ReclocId)),"^",2)
	..&sql(select oeore_ctpcp_dr->ctpcp_desc,oeore_order_status_dr->stat_desc,oeore_dateexecuted,oeore_timeexecuted into :ExecCtcpDesc,:ExecStat,:ExecDate,:ExecTime from SQLUSER.oe_ordexec where oeore_oeori_parref=:oeoriId)
	..i ($g(ExecDate)'="")&($g(ExecTime)'="") d
	...s ExecDateTime=$$$ZD(ExecDate,3)_" "_$ZT(ExecTime)
	..e  s ExecDateTime=""
	..i ExecStat="撤销执行" s ExecDateTime=""
	..s oeoreSub=$o(^OEORD(OeordId,"I",OeordSub,"X",0))
	..q:oeoreSub=""
	..s oeoreId=oeoriId_"||"_oeoreSub
	..&sql(select OEORE_SpecCollUser_DR,OEORE_SpecCollDate,OEORE_SpecCollTime into :SpecCollUserId,:SpecCollDate,:SpecCollTime from SQLUSER.OE_OrdExecExt  where OEORE_RowId=:oeoreId)
	..i (SpecCollDate'="")&(SpecCollTime'="") s SpecCollDateTime=$$$ZD(SpecCollDate,3)_" "_$ZT(SpecCollTime)
	..e  s SpecCollDateTime=""
	..i SpecCollUserId'="" s SpecCollUser=$P($G(^SSU("SSUSR",SpecCollUserId)),"^",2)
	..e  s SpecCollUser=""
	..s EpisodeID=$p(^OEORD(OeordId),"^",1)
	..s PatientId=$P(^PAADM(EpisodeID),"^",1)
	..Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel(PatientId,"")
    ..Set EncryptLevel=$p(PatEncryptLevel,"^",1)
    ..Set PatLevel=$p(PatEncryptLevel,"^",2) 
	..Do OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(RegNo,BedCode,PatName,ArcimDesc,PlacerNo,LabNo,ReclocDesc,ExecStat,ExecDateTime,ExecCtcpDesc,SpecCollUser,SpecCollDateTime,oeoriId,EncryptLevel,PatLevel)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}
	Else {
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// /用于6.9老库
Query LookUpOrderOld(PlacerNo As %String = "") As %Query(ROWSPEC = "RegNo:%String,BedCode:%String,PatName:%String,ArcimDesc:%String,PlacerNo:%String,LabNo:%String,ReclocDesc:%String,ExecStat:%String,ExecDateTime:%String,ExecCtcpDesc:%String,SpecCollUser:%String,SpecCollDateTime:%String,oeoriId:%String")
{
}

ClassMethod LookUpOrderOldExecute(ByRef qHandle As %Binary, PlacerNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	i PlacerNo="" 	Set qHandle=$lb(0,repid,0)	Quit $$$OK
	i $d(^OEORDi(0,"PlacerNo",PlacerNo))<2 Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s $lb(RegNo,BedCode,PatName,ArcimDesc,PlacerNo,LabNo,ReclocDesc,ExecStat,ExecDateTime,ExecCtcpDesc,SpecCollUser,SpecCollDateTime,oeoriId)=""
	s LabEpisodeNo=""
	f  s LabEpisodeNo=$O(^OEORDi(0,"PlacerNo",PlacerNo,LabEpisodeNo)) q:LabEpisodeNo=""  d
	.s LabNo=LabEpisodeNo
	.s OeordId=""
	.f  s OeordId=$O(^OEORDi(0,"PlacerNo",PlacerNo,LabEpisodeNo,OeordId))  q:OeordId=""  d
	..s OeordSub=""
	..f  s OeordSub=$O(^OEORDi(0,"PlacerNo",PlacerNo,LabEpisodeNo,OeordId,OeordSub))  q:OeordSub=""  d
	...s oeoriId=OeordId_"||"_OeordSub
	...s PatStr=##class(web.DHCCLCom).PatInfo(oeoriId)
	...q:PatStr=""
	...s RegNo=$P($G(PatStr),"^",1)
	...s PatName=$P($G(PatStr),"^",5)
	...s BedCode=$P($G(PatStr),"^",7)
	...s ArcimDesc=..GetArcim(oeoriId)
	...s ReclocId=$p($g(^OEORD(OeordId,"I",OeordSub,3)),"^",6)
	...i ReclocId'="" s ReclocDesc=$p($p($g(^CTLOC(ReclocId)),"^",2),"-",2)
	...&sql(select oeore_ctpcp_dr->ctpcp_desc,oeore_order_status_dr->stat_desc,oeore_dateexecuted,oeore_timeexecuted into :ExecCtcpDesc,:ExecStat,:ExecDate,:ExecTime from SQLUSER.oe_ordexec where oeore_oeori_parref=:oeoriId)
	...i (ExecDate'="")&(ExecTime'="") d
	....s ExecDateTime=$ZD(ExecDate,3)_" "_$ZT(ExecTime)
	...e  s ExecDateTime=""
	...s oeoreSub=$o(^OEORD(OeordId,"I",OeordSub,"X",0))
	...q:oeoreSub=""
	...s oeoreId=oeoriId_"||"_oeoreSub
	...s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,0))
	...q:dhcoreId=""
	...&sql(select DHCORE_SpecCollUser,DHCORE_SpecCollDate,DHCORE_SpecCollTime into :SpecCollUserId,:SpecCollDate,:SpecCollTime from SQLUSER.DHC_OE_OrdExec  where DHCORE_RowId=:dhcoreId)
	...s SpecCollDateTime=$ZD(SpecCollDate,3)_" "_$ZT(SpecCollTime)
	...i SpecCollUserId'="" s SpecCollUser=$P($G(^SSU("SSUSR",SpecCollUserId)),"^",2)
	...e  s SpecCollUser=""
	...Do OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(RegNo,BedCode,PatName,ArcimDesc,PlacerNo,LabNo,ReclocDesc,ExecStat,ExecDateTime,ExecCtcpDesc,SpecCollUser,SpecCollDateTime,oeoriId)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpOrderOldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpOrderOldExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}
	Else {
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpOrderOldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpOrderOldExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UpdateSpacer(OrdRowIdStr As %String = "", UserId As %String = "") As %String
{
	s ret=1
	q:(OrdRowIdStr="")||(UserId="") ret
	s curDate=+$H
	s curTime=$P($H,",",2)
	s ret=0
	s len=$L(OrdRowIdStr,"^")
	s excutedFlag=0
	f i=1:1:len d
	.s oeoriId=$P(OrdRowIdStr,"^",i)
	.s oeordId=$P(oeoriId,"||",1)
	.s oeoriSub=$P(oeoriId,"||",2)
	.s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	.s ordStatDR=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	.s status=$P(^OEC("OSTAT",ordStatDR),"^",1)
	.i status="E" s excutedFlag=1
	.q:status="E"
	.q:oeoreSub=""
	.;s oeoreId=oeoriId_"||"_oeoreSub
	.s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	.TStart
	.&sql(update SQLUSER.OE_OrdExecExt set OEORE_SpecCollUser_DR=:UserId,OEORE_SpecCollDate=:curDate,OEORE_SpecCollTime=:curTime where OEORE_RowId=:oeoreId)
	.i SQLCODE'=0 d
	..i ret=0 s ret=oeoriId_" "_SQLCODE
	..e  s ret=ret_","_oeoriId_" "_SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	.job ##class(Nur.NIS.Service.Base.OrderHandle).sendToDHCHisInterface(oeoriId, "DB", "", UserId, "")
	.TCommit
	s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
	i $g(labNo)'="" d ##Class(DHCLIS.DHCReceiveProcess).SaveVisitNumber(labNo,UserId,"","","2")
	i excutedFlag=1 q ##class(websys.Translation).Get("web.DHCNurSpecerNo","标本已接收")_"!"
	q ret
}

/*
ClassMethod UpdateSpacer(OrdRowIdStr As %String = "", UserId As %String = "") As %String
{
	
	s ret=1
	q:(OrdRowIdStr="")||(UserId="") ret
	s curDate=+$H
	s curTime=$P($H,",",2)
	;s curDate=""
	;s curTime=""
	s ret=0
	s len=$L(OrdRowIdStr,"^")
	f i=1:1:len d
	.s oeoriId=$P(OrdRowIdStr,"^",i)
	.s oeordId=$P(oeoriId,"||",1)
	.s oeoriSub=$P(oeoriId,"||",2)
	.s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	.q:oeoreSub=""
	
	.s admId=$P($G(^OEORD(oeordId)),"^",1)
	.s admType=$p($G(^PAADM(admId)),"^",2) //类型
	.s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	.s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,0))
	.q:(dhcoreId="")&(admType="O")
	.TStart
	.i admType="I" d
	..b ;12
	..&sql(update SQLUSER.OE_OrdExecExt set OEORE_SpecCollUser_DR=:UserId,OEORE_SpecCollDate=:curDate,OEORE_SpecCollTime=:curTime where OEORE_RowId=:oeoreId)
	.e  d
	..b ;44
	..&sql(update SQLUSER.DHC_OE_OrdExec set DHCORE_SpecCollUser=:UserId,DHCORE_SpecCollDate=:curDate,DHCORE_SpecCollTime=:curTime where DHCORE_RowId=:dhcoreId)
	.i SQLCODE'=0 d
	..i ret=0 s ret=oeoriId_" "_SQLCODE
	..e  s ret=ret_","_oeoriId_" "_SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	.TCommit
	q ret
}
*/
ClassMethod GetOrderStr(LabEpisodeNo As %String) As %String
{
	s RetStr=""
	i LabEpisodeNo="" q RetStr
	s OeordId=""
	f  s OeordId=$O(^OEORD(0,"EpisNo",LabEpisodeNo,OeordId))  q:OeordId=""  d
	.s OeordSub=""
	.f  s OeordSub=$O(^OEORD(0,"EpisNo",LabEpisodeNo,OeordId,OeordSub))  q:OeordSub=""  d
	..s OeordRowID=OeordId_"||"_OeordSub
	..i RetStr="" d
	...s RetStr=OeordRowID
	..e  d
	...s RetStr=RetStr_"^"_OeordRowID
	q RetStr
}

ClassMethod GetOrderStrOld(PlacerNo As %String) As %String
{
	s RetStr=""
	i ($d(^OEORDi(0,"PlacerNo",PlacerNo))<2) q RetStr
	s LabEpisodeNo=""
	f  s LabEpisodeNo=$O(^OEORDi(0,"PlacerNo",PlacerNo,LabEpisodeNo)) q:LabEpisodeNo=""  d
	.s OeordId=""
	.f  s OeordId=$O(^OEORDi(0,"PlacerNo",PlacerNo,LabEpisodeNo,OeordId))  q:OeordId=""  d
	..s OeordSub=""
	..f  s OeordSub=$O(^OEORDi(0,"PlacerNo",PlacerNo,LabEpisodeNo,OeordId,OeordSub))  q:OeordSub=""  d
	...s OeordRowID=OeordId_"||"_OeordSub
	...i RetStr="" d
	....s RetStr=OeordRowID
	...e  d
	....s RetStr=RetStr_"^"_OeordRowID
	q RetStr
}

ClassMethod GetArcim(oeoriId As %String)
{
    q:oeoriId="" ""
    s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	s scrip=$p(arcimId,"||")
	s ver=$p(arcimId,"||",2)
	s arcimDesc=$p(^ARCIM(scrip,ver,1),"^",2)
    q arcimDesc
}

// 取采血时间

// oeoriId：医嘱id或执行记录id

ClassMethod GetspecCollDatetime(oeoriId As %String)
{
	 q:oeoriId="" ""
	 s (ret,specCollUser,specCollDate,specCollTime)=""
	 s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
	 i oeoreSub'="" d                            //7.0
	 .s specCollUser=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",10)
	 .s specCollDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",11)
	 .s specCollTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",12)
	 e  d
	 .s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	 .q:oeoreSub=""
	 .s specCollUser=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",10)
	 .s specCollDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",11)
	 .s specCollTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",12)
	 s:(specCollUser'="")&(specCollDate'="")&(specCollTime'="") ret=specCollUser_"^"_specCollDate_"^"_specCollTime
	 i ret="" d                ////6.9
	 .s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0)) 
	 .q:oeoreSub=""
	 .s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeordId_"||"_oeoriSub_"||"_oeoreSub,0))
     .q:dhcoreId=""
     .&sql(select DHCORE_SpecCollUser,DHCORE_SpecCollDate,DHCORE_SpecCollTime into :specCollUser,:specCollDate,:specCollTime from SQLUSER.DHC_OE_OrdExec  where DHCORE_RowId=:dhcoreId)
	 .s:(specCollUser'="")&(specCollDate'="")&(specCollTime'="") ret=specCollUser_"^"_specCollDate_"^"_specCollTime
	 
	q ret
}

}
