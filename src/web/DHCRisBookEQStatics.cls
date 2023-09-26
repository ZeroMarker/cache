Import SQLUser

Class web.DHCRisBookEQStatics Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCRisBookEQStatics","QueryBookEQ","83","62882","63260","")
Query QueryBookEQ(LocID As %String, Stdate As %String, EndDate As %String, PatType As %String) As %Query(ROWSPEC = "TDesc:%String,TNum:%String,TPNum:%String,EquimentID:%String,TDetail:%String")
{
}

ClassMethod QueryBookEQExecute(ByRef qHandle As %Binary, LocID As %String, Stdate As %String, EndDate As %String, PatType As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	s ind=1
	
 	k ^tempBookEQSta
 	
    if LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    i Stdate="" s Stdate=+$h
    i EndDate="" s EndDate=+$h
  
   	
 	s ^Inp=LocID_"^"_Stdate_"^"_EndDate_"^"_PatType
 	
	s resrowid=0
	f  s resrowid=$o(^RB("RES",0,"CTLOC",LocID,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s EQrowid=$p(ResInfo,"^",3)
	.i EQrowid'=""  d
	..s EQDesc=$p(^RBC("EQ",EQrowid),"^",2)
	..s ^tempBookEQSta(EQrowid)=ind
 	..s ^tempBookEQSta(ind,1)=EQDesc //名称
 	..s ^tempBookEQSta(ind,2)=0      //医嘱数量
 	..s ^tempBookEQSta(ind,3)=0      //人次
 	..s ^tempBookEQSta(ind,4)=$o(^RB("RES",0,"EQ",EQrowid,LocID,0)) //RB_Resource
 	..s ind=ind+1
    s ^tempBookEQSta=ind-1
    s ind=1
	
	f Bookdate=Stdate:1:EndDate d 
	.s ResRowId=0 f  s ResRowId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocID,Bookdate,ResRowId)) q:(ResRowId="")  d
	..s ResSchduleId=0 f  s ResSchduleId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocID,Bookdate,ResRowId,ResSchduleId)) q:(ResSchduleId="")  d
	...s ResourceID=$p(^DHCRBCResourceSchdule(ResSchduleId),"^",1)
	...s DetailRowid=0 f  s DetailRowid=$o(^DHCRBCResSchduleDetaili("SchudleId",ResSchduleId,DetailRowid)) q:(DetailRowid="")  d
	....s CAFlag="",paadmdr="",GetPatype="",StudyNo=""
	....s StudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",6)
	....q:StudyNo="" 
	....s CAFlag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
	....s paadmdr=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",3)
	....q:(paadmdr="")
	....s GetPatype=$p(^PAADM(paadmdr),"^",2)
	....q:(PatType'="")&(PatType'=GetPatype)
	....q:(CAFlag="Cancel")
	....i ResourceID'="" d
	.....s GetEQRowid=$p($g(^RB("RES",ResourceID)),"^",3)
	.....q:(GetEQRowid="")
	.....q:'$d(^RBC("EQ",GetEQRowid))
	.....s Index=$g(^tempBookEQSta(GetEQRowid))
	.....q:Index="" 
	.....s ^tempBookEQSta(Index,2)=^tempBookEQSta(Index,2)+1
	.....i $g(^tempBookEQSta(Index,StudyNo))="" d 
	......s ^tempBookEQSta(Index,StudyNo)=1
	......s ^tempBookEQSta(Index,3)=^tempBookEQSta(Index,3)+1
	....d OutputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
    s Num=0,PNum=0
    for i=1:1:^tempBookEQSta d
  	.set Data=$lb(^tempBookEQSta(i,1),^tempBookEQSta(i,2),^tempBookEQSta(i,3),^tempBookEQSta(i,4),"明细")
  	.Set ^CacheTemp(repid,i)=Data
  	.Set Num=Num+^tempBookEQSta(i,2)
  	.Set PNum=PNum+^tempBookEQSta(i,3)
  	.Set ^CacheTemp(repid,i+1)=$lb("合计",Num,PNum)
  	.Set ind=ind+1
	quit
}

ClassMethod QueryBookEQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookEQExecute ]
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

ClassMethod QueryBookEQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBookEQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询设备预约明细
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookEQStatics","QueryBookEQDetail","83","1383","62882","63260","")
Query QueryBookEQDetail(LocID As %String, ResRowId As %String, Stdate As %String, EndDate As %String, PatType As %String) As %Query(ROWSPEC = "TOeorditmDR:%String,TBookedDate:%String,TResource:%String,TimeDesc:%String,TStartTime:%String,TEndTime:%String,TServiceGroupDesc:%String,TPatName:%String,TSex:%String,TAge:%String,TItemName:%String,TRegNo:%String,TStudyNo:%String")
{
}

ClassMethod QueryBookEQDetailExecute(ByRef qHandle As %Binary, LocID As %String, ResRowId As %String, Stdate As %String, EndDate As %String, PatType As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	s ind=1
	
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    i Stdate="" s Stdate=+$h
    i EndDate="" s EndDate=+$h
    
    f Bookdate=Stdate:1:EndDate 
    {
	    ;s ResRowId=0 f  s ResRowId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocID,Bookdate,ResRowId)) q:(ResRowId="")  d
	    s ResSchduleId=0 f  s ResSchduleId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocID,Bookdate,ResRowId,ResSchduleId)) q:(ResSchduleId="")  d
	    .s ResourceID=$p($g(^DHCRBCResourceSchdule(ResSchduleId)),"^",1)
	    .q:(ResourceID="")
		.s DetailRowid=0 f  s DetailRowid=$o(^DHCRBCResSchduleDetaili("SchudleId",ResSchduleId,DetailRowid)) q:(DetailRowid="")  d
		..s (CAFlag,paadmdr,GetPatype,StudyNo)=""
		..s (OrdItemrowid,BookedDate,Resource,TimeDesc,StartTime,EndTime,ServiceGroupDesc,PatName,Sex,Age,ItemName,RegNo)=""
		..s OrdItemrowid=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",1)
		..q:(OrdItemrowid="")
		..s OrderRowid=$p(OrdItemrowid,"||",1)
	    ..s ItemRowid=$p(OrdItemrowid,"||",2) 
	    ..s ItemStatDR="",ItemStatusCode="",TimeDescCode=""
	    ..s ItemStatDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",13) ; 医嘱状态
	    ..i ItemStatDR'="" s ItemStatusCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
		..s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1) 
		..s GetPatype=$p(^PAADM(paadmdr),"^",2)
		..s StudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",6)
		..s CAFlag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
        ..q:(ItemStatusCode="D")
		..q:(StudyNo="")
		..q:(paadmdr="")
		..q:(CAFlag="Cancel")
		..q:(PatType'="")&(PatType'=GetPatype)
		..s BookedDate=$p($g(^DHCRBCResourceSchdule(ResSchduleId)),"^",2)
		..i BookedDate'="" s BookedDate=$zd(BookedDate,3)
		..s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleId),"^",3)
	    ..s TimeDesc=""
	    ..i TimeDescCode'="" s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	    ..i TimeDescRowid'="" s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
	    ..s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleId),"^",5)  
	    ..s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleId),"^",6)
	    ..s examStartTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)
	    ..s examEndTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",19)
	    ..i ( (examStartTime'="")&&(examEndTime'=""))  d
	    ...s StartTime=examStartTime
	    ...s EndTime=examEndTime
	    ..s BooketTime=$zt(StartTime)
	    ..s EndTime=$zt(EndTime)
	    ..s Resource=""
	    ..i ResourceID'="" d
	    ...s EqId=$p(^RB("RES",ResourceID),"^",3)
	    ...s CareProvId=$p($g(^RB("RES",ResourceID)),"^",2)
        ...i EqId'="" s Resource=$p($g(^RBC("EQ",EqId)),"^",2)
	    ...i CareProvId'="" s Resource=$p(^CTPCP(CareProvId,1),"^",2)
		..s ServiceGroupDR=$p($g(^DHCRBCResourceSchdule(ResSchduleId)),"^",4)
		..i ServiceGroupDR'="" s ServiceGroupDesc=$p($g(^RBC("SG",ServiceGroupDR)),"^",2)
		..s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
		..q:(papatmasmdr="")
        ..s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
        ..s Name="",ItemName="",SexDr="",ArcItemId="",DOB=""
        ..s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
	    ..s ArcItemId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)
	    ..s ItemName=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),1),"^",2)
	    ..s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
        ..i SexDr'="" s Sex=$p(^CT("SEX",SexDr),"^",2)
        ..s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
        ..i DOB="" d
        ...s strDOB="" s strAge=""
 	    ..e  d
        ...s strDOB=$ZD(DOB,3)
        ...s strToday=$ZD(+$h,3)
        ...s Age=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday) 
		..d OutputRowDetail
	}
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowDetail
    
  	set Data=$lb(OrdItemrowid,BookedDate,Resource,TimeDesc,BooketTime,EndTime,ServiceGroupDesc,Name,Sex,Age,ItemName,RegNo,StudyNo)
  	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
	quit
}

ClassMethod QueryBookEQDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookEQDetailExecute ]
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

ClassMethod QueryBookEQDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBookEQDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询设备预约明细
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookEQStatics","QueryBookEQDetailBySchId","1314")
Query QueryBookEQDetailBySchId(ResSchduleId As %String) As %Query(ROWSPEC = "TOeorditmDR:%String,TBookedDate:%String,TResource:%String,TimeDesc:%String,TStartTime:%String,TEndTime:%String,TServiceGroupDesc:%String,TPatName:%String,TSex:%String,TAge:%String,TItemName:%String,TRegNo:%String,TStudyNo:%String,TExamStatus:%String,TOrderStatus:%String,Ttypedesc:%String,TIPNO:%String,TLocName:%String")
{
}

ClassMethod QueryBookEQDetailBySchIdExecute(ByRef qHandle As %Binary, ResSchduleId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	s ind=1
	s ^DHCRisTemp("ResSchduleId")=ResSchduleId
	if (ResSchduleId="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
    s DetailRowid=""  f  s DetailRowid=$o(^DHCRBCResSchduleDetaili("SchudleId",ResSchduleId,DetailRowid)) q:(DetailRowid="")  d
    .;w !,DetailRowid
    .s (CAFlag,paadmdr,GetPatype,StudyNo)=""
	.s (OrdItemrowid,BookedDate,Resource,TimeDesc,StartTime,EndTime,ServiceGroupDesc,PatName,Sex,Age,ItemName,RegNo,LocName,IPNO,typedesc)=""
	.s OrdItemrowid=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",1)
	.q:(OrdItemrowid="")
	.s bodylist=""
	.s bodyDr="" f  s bodyDr=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",DetailRowid,bodyDr)) q:(bodyDr="")
	..if bodylist="" d
	...s bodylist=bodyDr
	..e  d
	...s bodylist=bodylist_","_bodyDr
	.;w !,OrdItemrowid
	.s orderDescList=""
	.if bodylist="" d
	..s orderDescList=##class(web.DHCRisCommFunctionEx).getOrderItemDesc(OrdItemrowid)
	.e  d
	..s orderDescList=##class(web.DHCRisCommFunctionEx).getOrderItemDesc(OrdItemrowid_"$"_bodylist)
	.s OrderRowid=$p(OrdItemrowid,"||",1)
    .s ItemRowid=$p(OrdItemrowid,"||",2) 
    .s ItemStatDR="",ItemStatusCode="",TimeDescCode="",examStatus="预约"
    .s ItemStatDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",13) ; 医嘱状态
    .i ItemStatDR'="" s ItemStatusCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
	.s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1) 
	.s GetPatype=$p(^PAADM(paadmdr),"^",2)
	.s Locdr=$p(^PAADM(paadmdr),"^",4)
	    .i $g(Locdr)'="" d
	      ..s LocName=$p(^CTLOC(Locdr),"^",2)
          ..i $f(LocName,"-")>0 d
          ...s LocName=$p(LocName,"-",2)
	.s typedesc=##class(web.DHCRisCommFunction).GetTypeDesc(GetPatype)
	.s StudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",6)
	.s CAFlag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
    .;q:(ItemStatusCode="D")
	.q:(StudyNo="")
	.q:(paadmdr="")
	.q:(CAFlag="Cancel")
	.s regRowid=""
    .s regRowid=$o(^DHCPACRegInfoi("OEORI",OrdItemrowid,regRowid))
    .i regRowid'="" s examStatus="登记"
    .s rptRowid=""
    .s rptRowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,rptRowid))
    .i rptRowid'="" s examStatus="检查完成"
	.s BookedDate=$p($g(^DHCRBCResourceSchdule(ResSchduleId)),"^",2)
	.i BookedDate'="" s BookedDate=##class(websys.Conversions).DateLogicalToHtml(BookedDate)  ;$zd(BookedDate,3)
	.s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleId),"^",3)
    .s TimeDesc="",TimeDescRowid="",TimeDesc=""
    .i TimeDescCode'="" s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
    .i TimeDescRowid'="" s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
    .s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleId),"^",5)  
    .s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleId),"^",6)
    .s examStartTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)
    .s examEndTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",19)
    .i ( (examStartTime'="")&&(examEndTime'=""))  d
    ..s StartTime=examStartTime
    ..s EndTime=examEndTime
    .s BooketTime=$zt(StartTime)
    .s EndTime=$zt(EndTime)
    .s Resource=""
    .s ResourceID=$p($g(^DHCRBCResourceSchdule(ResSchduleId)),"^",1)
    .i ResourceID'="" d
    ..s EqId=$p(^RB("RES",ResourceID),"^",3)
    ..s CareProvId=$p($g(^RB("RES",ResourceID)),"^",2)
    ..i EqId'="" s Resource=$p($g(^RBC("EQ",EqId)),"^",2)
    ..i CareProvId'="" s Resource=$p(^CTPCP(CareProvId,1),"^",2)
	.s ServiceGroupDR=$p($g(^DHCRBCResourceSchdule(ResSchduleId)),"^",4)
	.i ServiceGroupDR'="" s ServiceGroupDesc=$p($g(^RBC("SG",ServiceGroupDR)),"^",2)
	.s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
	.q:(papatmasmdr="")
    .s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
    .s Name="",ItemName="",SexDr="",ArcItemId="",DOB=""
    .s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
    .s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(papatmasmdr)   //获得住院号
    .s ArcItemId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)
    .s ItemName=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),1),"^",2)
    .s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
    .i SexDr'="" s Sex=$p(^CT("SEX",SexDr),"^",2)
    .s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
    .i DOB="" d
    ..s strDOB="" s strAge=""
    .e  d
    ..s strDOB=##class(websys.Conversions).DateLogicalToHtml(DOB)   ;$ZD(DOB,3)
    ..;s strToday=$ZD(+$h,3)
    ..s Age=##class(web.DHCBillInterface).GetPapmiAge(papatmasmdr,paadmdr) 
	.d OutputRowDetailByResId
    
    ;查住院预约信息
    //ResSchduleId
    s patientId=""
    for 
    {
	    s patientId=$o(^DHCRBCBookInfoExternali("ResSchedule",ResSchduleId,patientId))
	    q:(patientId="")
	    s bookInfoExtId=""
	    for
	    {
		    s bookInfoExtId=$o(^DHCRBCBookInfoExternali("ResSchedule",ResSchduleId,patientId,bookInfoExtId))
		    q:(bookInfoExtId="")
		    s bookDate=$p(^DHCRBCBookInfoExternal(bookInfoExtId),"^",6)
		    i bookDate'="" s bookDate=##class(websys.Conversions).DateLogicalToHtml(bookDate)  ;$zd(bookDate,3)
		    s resourceId=$p(^DHCRBCBookInfoExternal(bookInfoExtId),"^",2)
		    s resourceDesc=$p(^DHCRBCBookInfoExternal(bookInfoExtId),"^",3)
		    s patientId=$p(^DHCRBCBookInfoExternal(bookInfoExtId),"^",4)
		    s patientName=$p(^DHCRBCBookInfoExternal(bookInfoExtId),"^",5)
		    s startTime=$p(^DHCRBCBookInfoExternal(bookInfoExtId),"^",7)
		    i startTime'="" s startTime=$zt(startTime,2)
		    s endTime=$p(^DHCRBCBookInfoExternal(bookInfoExtId),"^",8)
		    i endTime'="" s endTime=$zt(endTime,2)
		    s bookNum=$p(^DHCRBCBookInfoExternal(bookInfoExtId),"^",9)
	    }
	    do outPutInpatient
    }

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowDetailByResId
    
  	set Data=$lb(OrdItemrowid,BookedDate,Resource,TimeDesc,BooketTime,EndTime,ServiceGroupDesc,Name,Sex,Age,orderDescList,RegNo,StudyNo,examStatus,ItemStatusCode,typedesc,IPNO,LocName)
  	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
	quit
	
outPutInpatient
	set Data=$lb("",BookedDate,resourceDesc,"",startTime,endTime,"",patientName,"","","",patientId,"","","","住院病人","","")
  	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
	quit
}

ClassMethod QueryBookEQDetailBySchIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookEQDetailBySchIdExecute ]
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

ClassMethod QueryBookEQDetailBySchIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBookEQDetailBySchIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
