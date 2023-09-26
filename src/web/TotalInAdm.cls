/// 医护人员统计
Class web.TotalInAdm Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod FindInAdmTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInAdmTotalExecute ]
{
	
    Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInAdmTotalExecute(ByRef qHandle As %Binary, DepRowID As %Text, flag As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.TotalInAdm","FindInAdmTotal","","1")
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
 	k ^temp("InAdmTotal")
 	if (DepRowID'=""){
	 	s len=$length(DepRowID,",")
	 	for i=1:1:len do
	 	.s rowid=$p(DepRowID,",",i)
	 	.d GetInfoByDep
 	}else {
	 	s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
    	.q:$p($g(^CTLOC(rowid)),"^",13)'="E"
    	.d GetInfoByDep
 	}
 	s (Locdesc,TotalDocNum,TotalAdmNum,Avg,CPTDesc,LocDPTNum,LocCptDocNum,READesc,AdmreasonDocNum,AdmreasonNum)=""
 	s locid="" f  s locid=$o(^temp("InAdmTotal","TotalLoc",locid)) q:locid=""  do
 	.s Locdesc=$p(^CTLOC(locid),"^",2)
 	.s TotalAdmNum=$G(^temp("InAdmTotal","TotalAdm",locid))
 	.s TotalDocNum=$G(^temp("InAdmTotal","TotalLoc",locid))
 	.s Avg=$j((TotalAdmNum/TotalDocNum),2,2)
 	
 	.if flag=1 do  //按费别
 	..s admreason="" f  s admreason=$o(^temp("InAdmTotal","TotalAdmReason",locid,admreason)) q:admreason=""  do
 	...s READesc=$p(^PAC("ADMREA",admreason),"^",2) 
 	...s AdmreasonNum=$G(^temp("InAdmTotal","TotalAdmReason",locid,admreason))
 	...s AdmreasonDocNum=""
 	...s doc="" f  s doc=$o(^temp("InAdmTotal","LocAdmresonDoc",locid,admreason,doc)) q:doc=""  do
 	....s AdmreasonDocNum=$G(AdmreasonDocNum)+1
 	...d OutputInfo1
 	
 	.if flag=2  do  //按职称
 	..s CPT="" f  s CPT=$O(^temp("InAdmTotal","LocCptDoc",locid,CPT)) q:CPT=""  do
 	...s LocDPTNum="",LocCptDocNum=""
 	...s docid="" f  s docid=$o(^temp("InAdmTotal","LocCptDoc",locid,CPT,docid)) q:docid=""  do
 	....s LocCptDocNum=$G(LocCptDocNum)+1
 	....s LocDPTNum=$G(LocDPTNum)+$G(^temp("InAdmTotal","LocCptDoc",locid,CPT,docid))
 	...if CPT=99999 s CPTDesc="未指定医生"
 	...else  s CPTDesc=$p(^CT("CPT",CPT),"^",2)
 	...d OutputInfo2
 	
 	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
	
OutputInfo1
	set Data=$lb(Locdesc,TotalDocNum,TotalAdmNum,Avg,READesc,AdmreasonDocNum,AdmreasonNum)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
	
OutputInfo2
	set Data=$lb(Locdesc,TotalDocNum,TotalAdmNum,Avg,CPTDesc,LocDPTNum,LocCptDocNum)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit

GetInfoByDep
	;q:rowid'=1
	s ctlocid=rowid
	s RESRowId="" f  s RESRowId=$o(^RB("RES",0,"CTLOC",ctlocid,RESRowId)) q:RESRowId=""  do
 	.s CTPCP=$p(^RB("RES",RESRowId),"^",2)
 	.q:CTPCP=""
 	.s CarPrvTpDR=$p(^CTPCP(CTPCP,1),"^",4)
 	.s ^temp("InAdmTotal","TotalLoc",ctlocid)=$G(^temp("InAdmTotal","TotalLoc",ctlocid))+1   //科室医生人数
 	.s ^temp("InAdmTotal","LocDocREA",ctlocid,CarPrvTpDR)=$G(^temp("TotalNum","LocDocREA",ctlocid,CarPrvTpDR))+1  //科室医生人数 按职称

	s date="" f  s date=$o(^PAADMi("AdmTypeCurrLoc","I",ctlocid,date)) q:date=""  do
	.s time="" f  s time=$o(^PAADMi("AdmTypeCurrLoc","I",ctlocid,date,time)) q:time=""  do
	..s AdmID="" f  s AdmID=$o(^PAADMi("AdmTypeCurrLoc","I",ctlocid,date,time,AdmID)) q:AdmID=""  do
	...Q:'$D(^PAADM(AdmID))
	...Set PatientID=$P(^PAADM(AdmID),"^",1)
	...Q:'$D(^PAPER(PatientID))
	...s ^temp("InAdmTotal","TotalAdm",ctlocid)=$g(^temp("InAdmTotal","TotalAdm",ctlocid))+1   //科室在院患者人数
	...s admreason=$p(^PAADM(AdmID,1),"^",7)
	...s ^temp("InAdmTotal","TotalAdmReason",ctlocid,admreason)=$G(^temp("InAdmTotal","TotalAdmReason",ctlocid,admreason))+1  //按费别
	...s docid=$P(^PAADM(AdmID),"^",9)
	...if docid="" s docid=99999,CarPrvTpDR=99999
	...else  s CarPrvTpDR=$p(^CTPCP(docid,1),"^",4)
	...s ^temp("InAdmTotal","LocCptDoc",ctlocid,CarPrvTpDR,docid)=$g(^temp("InAdmTotal","LocCptDoc",ctlocid,CarPrvTpDR,docid))+1
	...s ^temp("InAdmTotal","LocAdmresonDoc",ctlocid,admreason,docid)=$g(^temp("InAdmTotal","LocAdmresonDoc",ctlocid,admreason,docid))+1
 	quit
}

ClassMethod FindInAdmTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInAdmTotalExecute ]
{
	
    Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" // if there are no more rows, finish fetching
	{	Set AtEnd=1
		Set Row=""
	}
	Else 
	{Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindInAdmTotal(DepRowID As %Text, flag As %String) As %Query(ROWSPEC = "Locdesc:%String,TotalDocNum:%String,TotalAdmNum:%String,Avg:%String,CPTDesc:%String,LocDPTNum:%String,LocCptDocNum:%String") [ SqlProc ]
{
}

Query GetInsDep() As %Query(ROWSPEC = "rowid:%String,ctdesc:%String") [ SqlProc ]
{
}

ClassMethod GetInsDepExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.TotalInAdm","GetInsDep")
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
    .q:$p($g(^CTLOC(rowid)),"^",13)'="E"
    .s ctdesc=$p(^CTLOC(rowid),"^",2)
    .d outputct
    
    Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
	
outputct
    set Data=$lb(rowid,ctdesc)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod GetInsDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInsDepExecute ]
{
	    Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInsDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInsDepExecute ]
{
	   Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" // if there are no more rows, finish fetching
	{	Set AtEnd=1
		Set Row=""
	}
	Else 
	{Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOnAdmTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOnAdmTotalExecute ]
{
	
    Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOnAdmTotalExecute(ByRef qHandle As %Binary, DepRowID As %Text, stdate As %String, endate As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.TotalInAdm","FindOnAdmTotal","","2012-10-10","2012-10-10")
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
 	k ^temp("OnAdmTotal")
 	
 	i (stdate="")||(endate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	i $l(stdate,"-")=3	s stdate=$zdh(stdate,3)
   	i $l(endate,"-")=3  s endate=$zdh(endate,3)
   	i $l(stdate,"/")=4	s stdate=$zdh(stdate,4)
   	i $l(endate,"/")=4  s endate=$zdh(endate,4)
   	
	for date=stdate:1:endate {
		if DepRowID'="" {
			s len=$length(DepRowID,",")
			for i=1:1:len {
				s locid=$p(DepRowID,",",i)
				d GetInfoByONDep
			}
		}else {
			s locid=0 f  s locid=$O(^PAC("ADMLOC",0,"AdmType","O",locid)) Q:locid=""  d
			.Q:'$d(^RB("RES",0,"CTLOC",locid))
			.d GetInfoByONDep
		}				
	}
	
	s loc="" f  s loc=$o(^temp("OnAdmTotal","LocDoc",loc)) q:loc=""  do
	.s Locdesc=$p(^CTLOC(loc),"^",2)
	.s docnum=""
	.s doc="" f  s doc=$o(^temp("OnAdmTotal","LocDoc",loc,doc)) q:doc=""  do
	..s docnum=$G(docnum)+1	//科室医生总数
	..s StopNum=$G(StopNum)+$g(^temp("OnAdmTotal","LocDocRBAS",loc,doc,2))  //科室停诊总数
	..s TRNum=$g(TRNum)+$G(^temp("OnAdmTotal","LocDocRBAS",loc,doc,4)) //科室替诊总数
	
	.s admNum=$G(^temp("OnAdmTotal","LocAdmNum",loc))
	.s CPT="" f  s CPT=$o(^temp("OnAdmTotal","LocDocCPT",loc,CPT)) q:CPT=""  do
	..s docCPT=""
	..s CPTDesc=$p(^CT("CPT",CPT),"^",2),docCPTNum=""
	..s doc="" f  s doc=$o(^temp("OnAdmTotal","LocDocCPT",loc,CPT,doc)) q:doc=""  do
	...s docCPT=$G(docCPT)+1
	...s docCPTNum=$G(docCPTNum)+$G(^temp("OnAdmTotal","LocDocCPT",loc,CPT,doc))
 	..d OutputInfo3
 	
 	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
	
OutputInfo3
	set Data=$lb(Locdesc,docnum,admNum,CPTDesc,docCPT,docCPTNum,StopNum,TRNum)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
	
GetInfoByONDep
	//资源
	s RESRowId=0 f  s RESRowId=$o(^RB("RES",0,"CTLOC",locid,RESRowId)) q:RESRowId=""  do
 	.s CTPCP=$p(^RB("RES",RESRowId),"^",2)
 	.q:CTPCP=""
 	.s CarPrvTpDR=$p(^CTPCP(CTPCP,1),"^",4)
 	.s ^temp("OnAdmTotal","LocDoc",locid,CTPCP)=$g(^temp("OnAdmTotal","LocDoc",locid,CTPCP))+1
	.s time =0 f  s time=$o(^RBAS(RESRowId,0,"DateSTime",date,time)) q:time=""  d
   	..s ApptId="" f  s ApptId=$o(^RBAS(RESRowId,0,"DateSTime",date,time,ApptId)) q:ApptId=""  d   
   	...s status=$p($g(^RBAS(RESRowId,ApptId,"DHC")),"^",10) 
	...q:(status'=2)&&(status'=4)
	...s ^temp("OnAdmTotal","LocDocRBAS",locid,CTPCP,status)=$G(^temp("OnAdmTotal","LocDocRBAS",locid,CTPCP,status))+1
 	
	//就诊
	s time="" f  s time=$o(^PAADMi("CurrLoc",locid,date,time)) q:time=""  do
	.s admid="" f  s admid=$o(^PAADMi("CurrLoc",locid,date,time,admid)) q:admid=""  do
	..q:'$d(^PAADM(admid))
	..s PaType=$p($g(^PAADM(admid)),"^",2)
	..q:PaType'="O"
	..s VisitStatu=$p($g(^PAADM(admid)),"^",20)
	..q:VisitStatu'="A"
	..s DocDr=$p($g(^PAADM(admid)),"^",9)
	..s CarPrvTpDR=$p(^CTPCP(DocDr,1),"^",4)
	..s DepDr=$p($g(^PAADM(admid)),"^",4)
	..s ^temp("OnAdmTotal","LocAdmNum",DepDr)=$G(^temp("OnAdmTotal","LocAdmNum",DepDr))+1
	..s ^temp("OnAdmTotal","LocDocCPT",DepDr,CarPrvTpDR,DocDr)=$G(^temp("OnAdmTotal","LocDocCPT",DepDr,CarPrvTpDR,DocDr))+1

	quit
}

ClassMethod FindOnAdmTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOnAdmTotalExecute ]
{
	
    Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" // if there are no more rows, finish fetching
	{	Set AtEnd=1
		Set Row=""
	}
	Else 
	{Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindOnAdmTotal(DepRowID As %Text, stdate As %String, endate As %String) As %Query(ROWSPEC = "Locdesc:%String,docnum:%String,admNum:%String,CPTDesc:%String,docCPT:%String,docCPTNum:%String,StopNum:%String,TRNum:%String") [ SqlProc ]
{
}

}
