Import SQLUser

/// , websys.Abstract)
Class web.DHCRisOrditemStatics Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 135;

// 

/// d ##class(%ResultSet).RunQuery("web.DHCRisOrditemStatics","QueryArcImMast","64","61087","61087")
Query QueryArcImMast(LocID As %String, StDate As %String, EndDate As %String) As %Query(ROWSPEC = "TDesc:%String,TNum:%String,TInCome:%String,TPeopleNums:%String,TItemID:%String")
{
}

ClassMethod QueryArcImMastExecute(ByRef qHandle As %Binary, LocID As %String, StDate As %String, EndDate As %String) As %Status
{
	s ^t=LocID_""_StDate_""_EndDate
 	set repid=$I(^CacheTemp)
	s ind=1
 	k ^tempITMSta
    i StDate="" s StDate=+$h
    i EndDate="" s EndDate=+$h
    if LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    
 	s perTotalPrice=0
 	s ^tempITMSta=0
    f regdate=StDate:1:EndDate d 
	.Set RowId=0	f  s RowId=$o(^DHCPACRegInfoi("RegDate",regdate,RowId)) q:RowId=""  d
	..s reglocdr=$p(^DHCPACRegInfo(RowId),"^",13)
	..s Flag=$p(^DHCPACRegInfo(RowId),"^",21)  
	..q:Flag'=""                          ;不统计转诊病人，不统计住院再收费病人
	..i reglocdr=LocID d
	...s OeordDR=$p(^DHCPACRegInfo(RowId),"^",11)
	...q:OeordDR="" 
	...s Ordrowid=$p(OeordDR,"||",1)
	...s OrdItemrowid=$p(OeordDR,"||",2)
	...s arcimid=$p(^OEORD(Ordrowid,"I",OrdItemrowid,1),"^",2)
	...i $g(^tempITMSta(arcimid))=""  d  ; 医嘱项目不存在
	....s ^tempITMSta=^tempITMSta+1
	....s Index=^tempITMSta
	....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    ....s ^tempITMSta(Index,1)=strOrderName
    ....s ^tempITMSta(arcimid)=Index
    ....s ^tempITMSta(Index,5)=arcimid
	...else  d   ; 存在
	....s Index=^tempITMSta(arcimid)
	...i $g(^tempITMSta(Index,2))="" s ^tempITMSta(Index,2)=0
	...s ^tempITMSta(Index,2)=^tempITMSta(Index,2)+1
    ...s SttDate=$p(^OEORD(Ordrowid,"I",OrdItemrowid,3),"^",7)  
    ...;s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimid, SttDate, "", "", "", "")
	...;s price=$p(priceinfo,"^",1)
	...s price=##class(web.DHCRisCommFunction).GetItemPrice(OeordDR)
	...s Num=$p(^OEORD(Ordrowid,"I",OrdItemrowid,1),"^",12)
	...s perTotalPrice=price*Num
	...i $g(^tempITMSta(Index,3))="" s ^tempITMSta(Index,3)=0
	...s ^tempITMSta(Index,3)=^tempITMSta(Index,3)+perTotalPrice
	...; 计算人数
	...s paadmdr=$p(^DHCPACRegInfo(RowId),"^",10)
	...s StudyNo=$p(^DHCPACRegInfo(RowId),"^",2)
	...i $g(^tempITMSta(Index,4))="" s ^tempITMSta(Index,4)=0
	...i $g(^tempITMSta(Index,StudyNo))="" d 
	....s ^tempITMSta(Index,StudyNo)=1
	....s ^tempITMSta(Index,4)=^tempITMSta(Index,4)+1
	...d OutputRow1
 		
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	s Nums=0,InCome=0,PNums=0
    for i=1:1:^tempITMSta d
  	.set Data=$lb(^tempITMSta(i,1),^tempITMSta(i,2),^tempITMSta(i,3),^tempITMSta(i,4),^tempITMSta(i,5))
  	.Set Nums=Nums+^tempITMSta(i,2)
  	.Set InCome=InCome+^tempITMSta(i,3)
  	.Set PNums=PNums+^tempITMSta(i,4)
  	.Set ^CacheTemp(repid,i)=Data
  	.Set ^CacheTemp(repid,i+1)=$lb("合计",Nums,InCome,PNums)
  	.Set ind=ind+1
	quit
}

ClassMethod QueryArcImMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryArcImMastExecute ]
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

ClassMethod QueryArcImMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryArcImMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisOrditemStatics","QuerybyItmDate","83","62304","62557")
Query QuerybyItmDate(LocID As %String, StDate As %String, EndDate As %String) As %Query(ROWSPEC = "TDesc:%String,TNum:%String,TInCome:%String,TPeopleNums:%String,TItemID:%String")
{
}

ClassMethod QuerybyItmDateExecute(ByRef qHandle As %Binary, LocID As %String, StDate As %String, EndDate As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	s ind=1
 	k ^tempITMSta
    i StDate="" s StDate=+$h
    i EndDate="" s EndDate=+$h
    if LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    
 	s perTotalPrice=0
 	s ^tempITMSta=0
    
	f date=StDate:1:EndDate d 
	.s PriorityDR=0 f  s PriorityDR=$o(^OEORDi(0,"LocStDtPr",LocID,PriorityDR)) q:PriorityDR=""  d
    ..s OrderRowid=0 f  s OrderRowid=$o(^OEORDi(0,"LocStDtPr",LocID,PriorityDR,date,OrderRowid)) q:OrderRowid=""  d
    ...s itemsub=0 f  s itemsub=$o(^OEORDi(0,"LocStDtPr",LocID,PriorityDR,date,OrderRowid,itemsub)) q:itemsub=""  d
	....s reclocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	....i (reclocdr=LocID) d
	.....s ItemStatDR="",ItemStatusCode=""
	.....s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.....s ItemStatDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13) ; 医嘱状态
	.....i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.....;q:(ItemStatusCode'="E")
	.....s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
	.....q:(paadmdr="")
 	.....i $g(^tempITMSta(arcimid))=""  d  ; 医嘱项目不存在
 	......s ^tempITMSta=^tempITMSta+1
	......s Index=^tempITMSta
	......s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    ......s ^tempITMSta(Index,1)=strOrderName
    ......s ^tempITMSta(arcimid)=Index
    ......s ^tempITMSta(Index,5)=arcimid
 	.....else  d   ; 存在
	......s Index=^tempITMSta(arcimid)
 	.....i $g(^tempITMSta(Index,2))="" s ^tempITMSta(Index,2)=0
	.....s ^tempITMSta(Index,2)=^tempITMSta(Index,2)+1
    .....s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
    .....s OeordDR=OrderRowid_"||"_itemsub
	.....s price=##class(web.DHCRisCommFunction).GetItemPrice(OeordDR)
	.....s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
	.....s perTotalPrice=price*Num
	.....i $g(^tempITMSta(Index,3))="" s ^tempITMSta(Index,3)=0
	.....s ^tempITMSta(Index,3)=^tempITMSta(Index,3)+perTotalPrice
	.....; 计算人数
	.....i $g(^tempITMSta(Index,4))="" s ^tempITMSta(Index,4)=0
	.....i $g(^tempITMSta(Index,paadmdr))="" d
	......s ^tempITMSta(Index,paadmdr)=1
	......s ^tempITMSta(Index,4)=^tempITMSta(Index,4)+1
	.....d OutputRow11 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow11
	s Nums=0,InCome=0,PNums=0
    for i=1:1:^tempITMSta d
  	.set Data=$lb(^tempITMSta(i,1),^tempITMSta(i,2),^tempITMSta(i,3),^tempITMSta(i,4),^tempITMSta(i,5))
  	.Set Nums=Nums+^tempITMSta(i,2)
  	.Set InCome=InCome+^tempITMSta(i,3)
  	.Set PNums=PNums+^tempITMSta(i,4)
  	.Set ^CacheTemp(repid,i)=Data
  	.Set ^CacheTemp(repid,i+1)=$lb("合计",Nums,InCome,PNums)
  	.Set ind=ind+1
	quit
}

ClassMethod QuerybyItmDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerybyItmDateExecute ]
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

ClassMethod QuerybyItmDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerybyItmDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query ItemDetailStatics(LocID As %String, stdate As %String, eddate As %String, AppLoc As %String, TOptionDoc As %String, ReportDoc As %String, VeriedDoc As %String) As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TWardName:%String,TBedNo:%String,TTechian:%String,TReport:%String,TVeriedReport:%String")
{
}

ClassMethod ItemDetailStaticsExecute(ByRef qHandle As %Binary, LocID As %String, stdate As %String, eddate As %String, AppLoc As %String, TOptionDoc As %String, ReportDoc As %String, VeriedDoc As %String) As %Status
{
	s ^test=LocID_"^"_stdate_"^"_stdate_"^"_AppLoc_"^"_TOptionDoc_"^"_ReportDoc_"^"_VeriedDoc
	Set repid=$I(^CacheTemp)
	s ind=1
	k ^tmpDHCRisReport
   
  	f date=stdate:1:eddate d 
	.Set RowId=0	f  s RowId=$o(^DHCRBStudyi("ReportDate",date,RowId)) q:RowId=""  d
	..s getVeriedDoc="",getReportDoc=""
	..s StudyNo=$p(^DHCRBStudy("Report",RowId),"^",1)
	..i $g(^tmpDHCRisReport(StudyNo))="" d
	...s ^tmpDHCRisReport(StudyNo)=StudyNo
	...s regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,0))  
	...s reglocdr=$p(^DHCPACRegInfo(regrowid),"^",13)
	...i reglocdr=LocID d 
	....s OeordDR=$p(^DHCPACRegInfo(regrowid),"^",11)
	....s Paadmdr=$p(^DHCPACRegInfo(regrowid),"^",10)
	....s patmasdr=$p(^PAADM($g(Paadmdr)),"^",1)
	....s patname=$p(^PAPER(patmasdr,"ALL"),"^",1)
	....s RegNo=$p(^PAPER(patmasdr,"PAT",1),"^",1)  
    ....s DOB=$p(^PAPER(patmasdr,"ALL"),"^",6)
    ....s SexDr=$p(^PAPER(patmasdr,"ALL"),"^",7)
    ....s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    ....i DOB="" d
 	.....s strDOB=""
 	.....s strAge=""
 	....e  d
    .....s strDOB=$ZD(DOB,3)
    .....s strToday=$ZD(+$h,3)
    .....s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
    ....s WardDr=$p(^PAADM(Paadmdr),"^",70)
    ....i WardDr'=""  d
    .....s wardname=$p(^PAWARD(WardDr),"^",2)
    .....s wardname=$p(wardname,"-",2)
    ....s beddr=$p(^PAADM(Paadmdr),"^",73)
    ....i beddr'=""  d 
    .....s wardrowid=$p(beddr,"||",1)
    .....s bedchildsub=$p(beddr,"||",2)
    .....s bedname=$p(^PAWARD(wardrowid,"BED",bedchildsub),"^",1)
    ....s OptionDocDr=$p(^DHCPACRegInfo(regrowid),"^",7)  ;操作员
    ....i OptionDocDr'="" d
    .....s OptionCPDr=$p(^SSU("SSUSR",OptionDocDr),"^",14) 
    .....i OptionCPDr'="" d
    ......i ^DHCRisGetNameSet="ID" d
	.......s getOptionDoc=$p(^CTPCP(OptionCPDr,1),"^",3)
    ......else  d
	.......s getOptionDoc=$p($g(^CTPCP(OptionCPDr,1)),"^",2)
    ....s rptssdr=$p(^DHCRBStudy("Report",RowId),"^",8) ;报告医生
    ....i rptssdr'="" d
    .....s ReportCPDr=$p(^SSU("SSUSR",rptssdr),"^",14) 
    .....i ReportCPDr'="" d
    ......i ^DHCRisGetNameSet="ID" d
	.......s getReportDoc=$p(^CTPCP(ReportCPDr,1),"^",3)
    ......else  d
	.......s getReportDoc=$p($g(^CTPCP(ReportCPDr,1)),"^",2)
    ....s rptssdr=$p(^DHCRBStudy("Report",RowId),"^",11) ;审核医生
    ....i rptssdr'="" d
    .....s ReportCPDr=$p(^SSU("SSUSR",rptssdr),"^",14) 
    .....i ReportCPDr'="" d
    ......i ^DHCRisGetNameSet="ID" d
	.......s getVeriedDoc=$p(^CTPCP(ReportCPDr,1),"^",3)
    ......else  d
	.......s getVeriedDoc=$p($g(^CTPCP(ReportCPDr,1)),"^",2)
    ....i (((TOptionDoc="")!(TOptionDoc=getOptionDoc))&&((ReportDoc="")!(ReportDoc=getReportDoc))&&((VeriedDoc="")!(VeriedDoc=getVeriedDoc))) d
   	.....d IOutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
IOutputRow
    i $g(regdate)'="" d
     .s TotalFilmCount8=TotalFilmCount8+FilmCount8
     .s TotalFilmCount11=TotalFilmCount11+FilmCount11
     .s TotalFilmCount14=TotalFilmCount14+FilmCount14
     .s Data=$lb($zd(regdate,3),$g(getBodyDesc),$g(patname),$g(getTechician),$g(getReportDoc),$g(getVeriedDoc),$g(TotalAmount),$g(FilmCount8),$g(FilmCount11),$g(FilmCount14),$g(flag),$g(ordresultrowid))
     .Set ^CacheTemp(repid,ind)=Data
     .s ^PrintData(ind)=$zd(regdate,3)_"^"_$g(getBodyDesc)_"^"_$g(patname)_"^"_$g(getTechician)_"^"_$g(getReportDoc)_"^"_$g(getVeriedDoc)_"^"_$g(TotalAmount)_"^"_$g(FilmCount8)_"^"_$g(FilmCount11)_"^"_$g(FilmCount14)_"^"_$g(flag)
     .s yyl=$j(masculinecount/ind,3,2)
   	 .set ^CacheTemp(repid,ind+1)=$lb("合计","总人数["_ind_"]","","","","",$g(TotalInCome),$g(TotalFilmCount8),$g(TotalFilmCount11),$g(TotalFilmCount14),$g(yyl),"")
   	 .s ^PrintData(ind+1)="合计"_"^"_"总人数["_ind_"]"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_$g(TotalInCome)_"^"_$g(TotalFilmCount8)_"^"_$g(TotalFilmCount11)_"^"_$g(TotalFilmCount14)_"^"_$g(yyl)
   	 .s ^PrintData=ind+1
   	 .Set ind=ind+1
   quit
}

ClassMethod ItemDetailStaticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemDetailStaticsExecute ]
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

ClassMethod ItemDetailStaticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryArcImMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCRisOrditemStatics","QueryReportList","780","60964","60964","","on")

Query QueryReportList(LocID As %String, stdate As %String, eddate As %String, Status As %String, CkNotAppStatus As %String) As %Query(ROWSPEC = "TStudyNo:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TWardName:%String,TBedNo:%String,TPrint:%String,TStatusDesc:%String,TReportDate:%String,TReportTime:%String")
{
}

ClassMethod QueryReportListExecute(ByRef qHandle As %Binary, LocID As %String, stdate As %String, eddate As %String, Status As %String, CkNotAppStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^tmpgp=LocID_"^"_stdate_"^"_eddate_"^"_CkNotAppStatus_"^"_Status
	if (CkNotAppStatus="on")
	{
		s ret=..QueryNotAppPatientList(LocID,stdate,eddate,Status)
	}
	else 
	{  
	    s ret=..QueryPatientReportList(LocID,stdate,eddate,Status)
	}
	Quit $$$OK
}

ClassMethod QueryReportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportListExecute ]
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

ClassMethod QueryReportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryNotAppPatientList(LocID As %String, stdate As %String, eddate As %String, Status As %String)
{
	s CallStatus="",Number=""
	k ^tmpDHCRisReport
	for date=stdate:1:eddate
    {
	  s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("RegDate",date,Regrowid)) q:Regrowid=""  d    
      .s (StudyNo,RegNo,patname,SexDesc,strAge,wardname,bedname,Print,statusDesc,ReportDate,ReportTime)=""
      .s RegLocDR=$p(^DHCPACRegInfo(Regrowid),"^",13) 
      .q:LocID'=RegLocDR          ;不是本科室
      .s GetPatientStatusCode="I"
      .s bOut="N"  ;是否已经输出
      .s StudyNo1=$p(^DHCPACRegInfo(Regrowid),"^",2)
      .i $g(^tmpDHCRisReport(StudyNo1))="" d  //只显示一个人的一次记录
      ..s ^tmpDHCRisReport(StudyNo1)=StudyNo1
      ..s GetstrRegDate=$p(^DHCPACRegInfo(Regrowid),"^",8)
      ..s GetstrRegTime=$p(^DHCPACRegInfo(Regrowid),"^",9)
      ..s Oeorditemdr=$p(^DHCPACRegInfo(Regrowid),"^",11)
      ..s paadmdr=$p(^DHCPACRegInfo(Regrowid),"^",10)
      ..s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
	  ..q:patienttype'="I"
      ..s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
      ..s RegNo=$p(PatInfo,"^",1)
      ..s patname=$p(PatInfo,"^",2)
      ..s strAge=$p(PatInfo,"^",4)
      ..s strAge=$p(strAge," ")
 	  ..s SexDesc=$p(PatInfo,"^",5)
 	  ..s wardname=$p(PatInfo,"^",10)
      ..s bedname=$p(PatInfo,"^",11)
      ..q:StudyNo1=""
      ..s Print=##class(web.DHCRisOrditemStatics).GetReportSend(StudyNo1)
      ..s statusDesc=""
      ..s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo1,""),-1)
      ..i Rptrowid'="" d
      ...s StatusDr=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	  ...i StatusDr'="" s statusDesc=$p(^DHCRBCStatus("ReportStatus",StatusDr),"^",2) 
	  ...s ReportDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
      ...i ReportDate'="" s ReportDate=$zd(ReportDate,3)
      ...s ReportTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
      ...i ReportTime'="" s ReportTime=$zt(ReportTime,1)
      ..q:(Status'="")&&(Status'=statusDesc) 
      ..Do OutRowS4
    }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
   
OutRowS4
   	set Data=$lb(StudyNo1,RegNo,patname,SexDesc,strAge,wardname,bedname,Print,statusDesc,ReportDate,ReportTime)
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod QueryPatientReportList(LocID As %String, stdate As %String, eddate As %String, Status As %String)
{
	k ^tmpDHCRisReport
   	f date=stdate:1:eddate d 
	.Set RowId=0	f  s RowId=$o(^DHCRBStudyi("ReportDate",date,RowId)) q:RowId=""  d
	..s getVeriedDoc="",getReportDoc=""
	..s StudyNo=$p(^DHCRBStudy("Report",RowId),"^",1)
	..s StatusDr=$p(^DHCRBStudy("Report",RowId),"^",4)
	..s statusCode=""
	..i StatusDr'="" s statusDesc=$p(^DHCRBCStatus("ReportStatus",StatusDr),"^",2) 
	..q:(Status'="")&&(Status'=statusDesc) 
	..i $g(^tmpDHCRisReport(StudyNo))="" d  //只显示一个人的一次记录
	...s ^tmpDHCRisReport(StudyNo)=StudyNo
	...s Print=##class(web.DHCRisOrditemStatics).GetReportSend(StudyNo)
	...s regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,0))  
	...s reglocdr=$p(^DHCPACRegInfo(regrowid),"^",13)
	...i reglocdr=LocID d 
	....s OeordDR=$p(^DHCPACRegInfo(regrowid),"^",11)
	....s Paadmdr=$p(^DHCPACRegInfo(regrowid),"^",10)
	....s patmasdr=$p(^PAADM($g(Paadmdr)),"^",1)
	....s patienttype=$p(^PAADM(Paadmdr),"^",2) ;病人类型
	....q:patienttype'="I"
	....s patname=$p(^PAPER(patmasdr,"ALL"),"^",1)
	....s RegNo=$p(^PAPER(patmasdr,"PAT",1),"^",1)  
    ....s DOB=$p(^PAPER(patmasdr,"ALL"),"^",6)
    ....s SexDr=$p(^PAPER(patmasdr,"ALL"),"^",7)
    ....s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    ....i DOB="" d
 	.....s strDOB=""
 	.....s strAge=""
 	....e  d
    .....s strDOB=$ZD(DOB,3)
    .....s strToday=$ZD(+$h,3)
    .....s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
    ....s WardDr=$p(^PAADM(Paadmdr),"^",70)
    ....i WardDr'=""  d
    .....s wardname=$p(^PAWARD(WardDr),"^",2)
    .....s wardname=$p(wardname,"-",2)
    ....s beddr=$p(^PAADM(Paadmdr),"^",73)
    ....i beddr'=""  d 
    .....s wardrowid=$p(beddr,"||",1)
    .....s bedchildsub=$p(beddr,"||",2)
    .....s bedname=$p(^PAWARD(wardrowid,"BED",bedchildsub),"^",1)
    ....s ReportDate=$p(^DHCRBStudy("Report",RowId),"^",9)
    ....s ReportDate=$zd(ReportDate,3)
    ....s ReportTime=$p(^DHCRBStudy("Report",RowId),"^",10)
    ....s ReportTime=$zt(ReportTime)
    ....s rptssdr=$p(^DHCRBStudy("Report",RowId),"^",8) ;报告医生
    ....i rptssdr'="" d
    .....s ReportCPDr=$p(^SSU("SSUSR",rptssdr),"^",14) 
    .....i ReportCPDr'="" d
    ......i ^DHCRisGetNameSet="ID" d
	.......s getReportDoc=$p(^CTPCP(ReportCPDr,1),"^",3)
    ......else  d
	.......s getReportDoc=$p($g(^CTPCP(ReportCPDr,1)),"^",2)
    ....s rptssdr=$p(^DHCRBStudy("Report",RowId),"^",11) ;审核医生
    ....i rptssdr'="" d
    .....s ReportCPDr=$p(^SSU("SSUSR",rptssdr),"^",14) 
    .....i ReportCPDr'="" d
    ......i ^DHCRisGetNameSet="ID" d
	.......s getVeriedDoc=$p(^CTPCP(ReportCPDr,1),"^",3)
    ......else  d
	.......s getVeriedDoc=$p($g(^CTPCP(ReportCPDr,1)),"^",2)
   	....d OutputList
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputList
   set ^CacheTemp(repid,ind)=$lb(StudyNo,RegNo,patname,SexDesc,strAge,wardname,bedname,Print,statusDesc,ReportDate,ReportTime)
   ;set ^CacheTemp(repid,ind+1)=$lb("人数",ind)
   Set ind=ind+1
   quit
}

/// 函数名称：GetReportSend
/// 功能：获得报告列表的打印状态
/// 参数：检查号
/// 返回：状态
/// 作者：龚平
/// 日期：2007-03-09
/// ##class(web.DHCRisOrditemStatics).GetFilmSendDesc(StudyNo)
ClassMethod GetReportSend(StudyNo)
{
	s GetReportSend=""
	s studydescrowid=$o(^DHCRBStudyi("StudyDesc","StudyNo",StudyNo,0))
	i studydescrowid'="" d
	.s GetReportSend=$p(^DHCRBStudy("StudyDesc",studydescrowid),"^",14)
	q GetReportSend
}

ClassMethod PrintReport(StudyNo)
{
  q:StudyNo="" 0
  s studydescrowid=$o(^DHCRBStudyi("StudyDesc","StudyNo",StudyNo,0))
  i studydescrowid="" d
   .&sql(insert into DHCRB_StudyDesc(DRSD_StudyNo,DRSD_ReportPrint) values (:StudyNo,'Y'))
  else  d
   .&sql(update DHCRB_StudyDesc set DRSD_ReportPrint='Y' where DRSD_StudyNo=:StudyNo)
  q SQLCODE
}

/// /////////////////////                                     //////////////////////
Query ItemDetailByNameStatics(LocID As %String, StDate As %String, EndDate As %String, ArcItemID As %String) As %Query(ROWSPEC = "GetRegNo:%String,GetName:%String,GetSexDesc:%String,GetstrAge:%String,GetLocName:%String,GetWardName:%String,GetBedNo:%String,GetNum:%String,Getprice:%String,StudyNo:%String,GetstrOrderName:%String,GetstrDate:%String,GetstrTime:%String,GetTotalPrice:%String,Gettypedesc:%String")
{
}

ClassMethod ItemDetailByNameStaticsExecute(ByRef qHandle As %Binary, LocID As %String, StDate As %String, EndDate As %String, ArcItemID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	s ind=1
	s Num=0,PNums=0,TotalF=0
    if LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    i StDate="" s StDate=+$h
    i EndDate="" s EndDate=+$h
   	f regdate=StDate:1:EndDate d 
	.Set RowId=0	f  s RowId=$o(^DHCPACRegInfoi("RegDate",regdate,RowId)) q:RowId=""  d
	..s reglocdr=$p(^DHCPACRegInfo(RowId),"^",13)
	..s Flag=$p(^DHCPACRegInfo(RowId),"^",21)  
	..q:Flag'=""                          ;不统计转诊病人，不统计住院再收费病人
	..i reglocdr=LocID d
	...s OeordDR=$p(^DHCPACRegInfo(RowId),"^",11)
	...q:OeordDR="" 
	...s Ordrowid=$p(OeordDR,"||",1)
	...s OrdItemrowid=$p(OeordDR,"||",2)
	...s arcimid=$p(^OEORD(Ordrowid,"I",OrdItemrowid,1),"^",2)
	...q:arcimid'=ArcItemID
  	...s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(Ordrowid,OrdItemrowid)
    ...s GetstrOrderName=$p(ordInfo,"^",1)
    ...s GetstrDate=$p(ordInfo,"^",2)
    ...s GetstrTime=$p(ordInfo,"^",3)
    ...s Getprice=$p(ordInfo,"^",10)
    ...s GetNum=$p(ordInfo,"^",11)
    ...s GetTotalPrice=$p(ordInfo,"^",12)
 	...s paadmdr=$p(^DHCPACRegInfo(RowId),"^",10)
	...s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    ...s GetRegNo=$p(PatInfo,"^",1)
    ...s GetName=$p(PatInfo,"^",2)
    ...s GetstrDOB=$p(PatInfo,"^",3)
    ...s GetstrAge=$p(PatInfo,"^",4)
 	...s GetSexDesc=$p(PatInfo,"^",5)
    ...;s Getpatienttype=$p(PatInfo,"^",6)
    ...s Gettypedesc=$p(PatInfo,"^",7)
    ...s GetLocName=$p(PatInfo,"^",8)
    ...s GetWardName=$p(PatInfo,"^",10)
    ...s GetBedNo=$p(PatInfo,"^",11)
    ...s StudyNo=$p(^DHCPACRegInfo(RowId),"^",2)
    ...s Num=Num+GetNum
    ...s TotalF=TotalF+GetTotalPrice
	...d OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
 	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetLocName,GetWardName,GetBedNo,GetNum,Getprice,StudyNo,GetstrOrderName,GetstrDate,GetstrTime,GetTotalPrice,Gettypedesc)
 	set ^CacheTemp(repid,ind)=Data
  	Set ^CacheTemp(repid,ind+1)=$lb("合计","","","","","","",Num,"","","","","",TotalF)
  	Set ind=ind+1
	quit
}

ClassMethod ItemDetailByNameStaticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemDetailByNameStaticsExecute ]
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

ClassMethod ItemDetailByNameStaticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemDetailByNameStaticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
