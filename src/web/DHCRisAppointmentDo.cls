Import SQLUser

Class web.DHCRisAppointmentDo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 67;

//根据设备的ROWID获得登记打印格式

Query QueryResource(LocID As %String) As %Query(ROWSPEC = "TResDesc:%String,TRowid:%String")
{
}

ClassMethod QueryResourceExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
	s ^LXSRB("RB")=LocID
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
   
	Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
	.s CTCPDR=$p(^RB("RES",RowId),"^",2)
	.i CTCPDR'="" d
	..s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	.else  d
	..s EQDR=$p(^RB("RES",RowId),"^",3) q:EQDR=""
	..s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	.s scdrowid=$o(^RBAS(RowId,0))
	.;w !,scdrowid
	.i scdrowid '=""  d    ;有排版计划
    ..Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutputRow
	set Data=$lb($g(ResDesc),RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^CacheTemp(repid,ind+1)=$lb("所有","")
 	
 	Set ind=ind+1
	quit
}

ClassMethod QueryResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourceExecute ]
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

ClassMethod QueryResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryResApptSchedule(ResourceID, OEOrdItemID, LocID, AppStDate) As %Query(ROWSPEC = "TResDesc:%String,TitmName:%String,TSessDate:%String,TSessStTime:%String,TSessEdTime:%String,TSessNoAppt:%String,TBookedNum:%String,TSessNoLoad:%String,Tlength:%String,TApptschDr:%String,TSelect:%Library.Boolean,TEQDr:%String")
{
}

ClassMethod QueryResApptScheduleExecute(ByRef qHandle As %Binary, ResourceID As %String, OEOrdItemID As %String, LocID As %String, AppStDate As %String) As %Status
{
 	
 	s ^test=ResourceID_"^"_OEOrdItemID_"^"_LocID_"^"_AppStDate
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 
    //--------------------------------------------------------
  	if $g(OEOrdItemID)="" Set OEOrdItemID=%request.Get("OEOrdItemID")
	;Quit:$g(OEOrdItemID)="" $$$OK
	s LocID=##class(web.DHCRisWorkBenchDo).GetSession("SelLocID")
	if LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	s OEOrdItemID=$p(OEOrdItemID,"^",1)
     s OrderRowid=$p(OEOrdItemID,"||",1)
     s itemsub=$p(OEOrdItemID,"||",2)
     s approwid=$p($g(^OEORD(OrderRowid,"I",itemsub,6)),"^",5)
     s SelApptRowid=""
     k ^tmpAppSch
     if (approwid'="")&(approwid'=$c(0))    //获得医嘱的预约计划
     {
	   s resrowid=$p(approwid,"||",1)
	   s CTCPDR=$p(^RB("RES",resrowid),"^",2)
	   i CTCPDR'="" d
	    .s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	   else  d
	    .s EQDR=$p($g(^RB("RES",resrowid)),"^",3)
	    .s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	   s Schrowid=$p(approwid,"||",2)
	   s appointmentrowid=$p(approwid,"||",3)
	   
	   //支持一个预约占多个时间段
	   //获取多个时间段 (RB_ApptFollowOnSlots)
	    s RBFOSRowid=0  f  s RBFOSRowid=$o(^RBAS(resrowid,Schrowid,"APPT",appointmentrowid,"SLOT",RBFOSRowid)) q:RBFOSRowid=""  d
	    .s AppSchrowid=$p(^RBAS(resrowid,Schrowid,"APPT",appointmentrowid,"SLOT",RBFOSRowid),"^",2)
	    .s ^tmpAppSch(AppSchrowid)=1

       //
	   s scheInfo=^RBAS(resrowid,Schrowid)
	   s SelApptRowid=resrowid_"||"_Schrowid
	   s AppointDate=$p(scheInfo,"^",1)
	   //s AppStDate=AppointDate
	   //s ResourceID=resrowid
	 }
	 
     if AppStDate="" s AppStDate=+$h
	 if ResourceID'="" d      // 查看指定资源的预约计划
	  .s CTCPDR=$p(^RB("RES",ResourceID),"^",2)
	  .i CTCPDR'="" d
	  ..s EQDR=""
	  ..s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	  .else  d
	  
	  ..s EQDR=$p(^RB("RES",ResourceID),"^",3) q:EQDR=""
	  ..s ^LXSEQDR(EQDR,"A")=EQDR
	  ..q:'$d(^RBC("EQ",EQDR))
	  ..s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
   	  .s session=0 f  s session=$o(^RBAS(ResourceID,0,"DateSTime",AppStDate,session)) q:session=""  d
      ..s childsub=0 f  s childsub=$o(^RBAS(ResourceID,0,"DateSTime",AppStDate,session,childsub)) q:childsub=""  d
      ...s apptschinfo=^RBAS(ResourceID,childsub)
      ...s ApptRowid=ResourceID_"||"_childsub
      ...s SessNoAppt=$p(apptschinfo,"^",2) ;在一次会话中预约的数量
      ...s BookedNum=$p(apptschinfo,"^",11) ; 在一次会话中已经预约的数量
      ...;q:(BookedNum'="")&(BookedNum>=SessNoAppt) 
      ...s SessNoLoad=$p(apptschinfo,"^",9) ;在一次会话中预约的最大数量 
      ...s SessDate=$p(apptschinfo,"^",1)
      ...s strSessDate=$zd(SessDate,3)
      ...s SessStTime=$p(apptschinfo,"^",4)
      ...i SessStTime="86400" s SessStTime="0"
      ...s strSessStTime=$zt(SessStTime)
      ...s SessEdTime=$p(apptschinfo,"^",5)
      ...i SessEdTime="86400" s SessEdTime=0
      ...s strSessEdTime=$zt(SessEdTime)
      ...s DateSessionDr=$p(apptschinfo,"^",12)
      ...s ResRowid=$p(DateSessionDr,"||",1)
      ...s EffRowid=$p(DateSessionDr,"||",2)
      ...s EesChild=$p(DateSessionDr,"||",3)
      ...s length=$p(^RB("RES",ResRowid,"DATE",EffRowid,"SESS",EesChild),"^",7)
      ...s OeOrdRowid=$p(OEOrdItemID,"||",1)
      ...s ItemSub=$p(OEOrdItemID,"||",2)
      ...s arcitemdr=$p(^OEORD(OeOrdRowid,"I",ItemSub,1),"^",2)
      ...s subscript=$p(arcitemdr,"||",1)
      ...s version=$p(arcitemdr,"||",2)
      ...s itmName=$p(^ARCIM(subscript,version,1),"^",2)
      ...s Select=0
      ...;Do OutputRow1
      ...s ^tmpAppSch(ApptRowid)=$g(^tmpAppSch(ApptRowid))
      ...if (^tmpAppSch(ApptRowid)=1)  d //显示当前医嘱的预约时间
      ....s Select=1
      ....Do OutputRow1
      ...else  if (BookedNum="")!(BookedNum<SessNoAppt) d //显示没有预约的时间段
      ....s Select=0
      ....Do OutputRow1
   else  d       //查看所有资源的预约计划
    .Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
	..s CTCPDR=$p(^RB("RES",RowId),"^",2)
	..i CTCPDR'="" d
	...s EQDR=""
	...s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	..else  d
	...s EQDR=$p(^RB("RES",RowId),"^",3)
	...q:EQDR=""
	...s ^LXSEQDR(EQDR,"B")=EQDR
	...q:'$d(^RBC("EQ",EQDR))
	...s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
    ..;s ResEffDateDr=$o(^RB("RES",RowId,"DATE",""))
    ..s session=0
    ..f  s session=$o(^RBAS(RowId,0,"DateSTime",AppStDate,session)) q:session=""  d
    ...s childsub=0 f  s childsub=$o(^RBAS(RowId,0,"DateSTime",AppStDate,session,childsub)) q:childsub=""  d
    ....s apptschinfo=^RBAS(RowId,childsub)
    ....s ApptRowid=RowId_"||"_childsub
    ....s SessNoAppt=$p(apptschinfo,"^",2) ;在一次会话中预约的数量
    ....s BookedNum=$p(apptschinfo,"^",11) ; 在一次会话中已经预约的数量
    ....;q:(BookedNum'="")&(BookedNum>=SessNoAppt)    
    ....s SessNoLoad=$p(apptschinfo,"^",9) ;在一次会话中预约的最大数量 
    ....s SessDate=$p(apptschinfo,"^",1)
    ....s strSessDate=$zd(SessDate,3)
    ....s SessStTime=$p(apptschinfo,"^",4)
    ....i SessStTime="86400" s SessStTime="0"
    ....s strSessStTime=$zt(SessStTime)
    ....s SessEdTime=$p(apptschinfo,"^",5)
    ....i SessEdTime="86400" s SessEdTime=0
    ....s strSessEdTime=$zt(SessEdTime)
    ....s DateSessionDr=$p(apptschinfo,"^",12)
    ....s ResRowid=$p(DateSessionDr,"||",1)
    ....s EffRowid=$p(DateSessionDr,"||",2)
    ....s EesChild=$p(DateSessionDr,"||",3)
    ....s length=$p(^RB("RES",ResRowid,"DATE",EffRowid,"SESS",EesChild),"^",7)
    ....s OeOrdRowid=$p(OEOrdItemID,"||",1)
 	....s ItemSub=$p(OEOrdItemID,"||",2)
    ....s arcitemdr=$p(^OEORD(OeOrdRowid,"I",ItemSub,1),"^",2)
    ....s subscript=$p(arcitemdr,"||",1)
    ....s version=$p(arcitemdr,"||",2)
    ....s itmName=$p(^ARCIM(subscript,version,1),"^",2)
    ....s Select=0
    ....;Do OutputRow1
    ....s ^tmpAppSch(ApptRowid)=$g(^tmpAppSch(ApptRowid))
    ....if (^tmpAppSch(ApptRowid)=1)  d //显示当前医嘱的预约时间
    .....s Select=1
    .....Do OutputRow1
    ....else  if (BookedNum="")!(BookedNum<SessNoAppt) d  //显示没有预约的时间段
    .....s Select=0
    .....Do OutputRow1
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK

OutputRow1
	set Data=$lb(ResDesc,itmName,strSessDate,strSessStTime,strSessEdTime,SessNoAppt,BookedNum,SessNoLoad,length,ApptRowid,Select,EQDR)
 	;w !,Data
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResApptScheduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResApptScheduleExecute ]
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

ClassMethod QueryResApptScheduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResApptScheduleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UpdateBooked(paadmdr, OEOrdItemID, BookedDate, BookedTime, OperID, length, ApttSchDr)
{
	s ^para=paadmdr_"^"_OEOrdItemID_"^"_BookedDate_"^"_BookedTime_"^"_OperID_"^"_length_"^"_ApttSchDr
	s nums=$l(OEOrdItemID,"^")
	s ret=""
	for i=1:1:nums  d
	.s perOEOrdItemID=$p(OEOrdItemID,"^",i)
	.s ret=##class(web.DHCRisAppointmentDo).UpdatePerBooked("", perOEOrdItemID, BookedDate, BookedTime, OperID, length, ApttSchDr)
	q ret
}

ClassMethod UpdatePerBooked(paadmdr, OEOrdItemID, BookedDate, BookedTime, OperID, length, ApttSchDr)
{
	s OeOrdRowid=$p(OEOrdItemID,"||",1)
 	s ItemSub=$p(OEOrdItemID,"||",2)
  
 	s paadmdr=$p(^OEORD(OeOrdRowid),"^",1) 
	
	s patmasdr=$p(^PAADM(paadmdr),"^",1)
	s paadmtype=$p(^PAADM(paadmdr),"^",2)
	
     s arcitemdr=$p(^OEORD(OeOrdRowid,"I",ItemSub,1),"^",2)
    s RBServiceDr=$o(^RBC("SER",0,"ARCIM",arcitemdr,0)) 
    s Status="P"
    
    s BookedDate=$zdh(BookedDate,3)
    s BookedTime=$zth(BookedTime,3)
    s OperDate=+$h
    s OperTime=$p($h,",",2) 
    
    
    s ^Ins=paadmdr_"^"_patmasdr_"^"_paadmtype_"^"_OEOrdItemID_"^"_BookedDate_"^"_BookedTime_"^"_OperID_"^"_length_"^"_ApttSchDr_"^"_RBServiceDr

	/*
	s approwid=$p(^OEORD(OeOrdRowid,"I",ItemSub,6),"^",5)
    q:approwid'="" -104
    
    s ItemStatDR=$p(^OEORD(OeOrdRowid,"I",ItemSub,1),"^",13) ; 医嘱状态
	s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)  
	q ItemStatusCode'="V" -104
	*/
	s ret=..DeleteBookInfo(OEOrdItemID)

    TSTART
    s ApttSchDr1=$p(ApttSchDr,"^",1)
    &sql(insert into RB_Appointment (APPT_PAPMI_DR,APPT_Status,APPT_Adm_DR,APPT_ETA,APPT_DateSearch,APPT_TransDate,APPT_TransTime,APPT_TransUser_DR,APPT_AdmType,APPT_RBCServ_DR,APPT_Duration,APPT_LastUpdateDate, APPT_AS_ParRef) 
   							values (:patmasdr,:Status,:paadmdr,:BookedTime,:BookedDate,:OperDate,:OperTime,:OperID,:paadmtype,:RBServiceDr,:length,:OperDate,:ApttSchDr1))

    I SQLCODE TRollBack  Quit SQLCODE
  
    ;&sql(select Max(APPT_RowId) into :Apptrowid from RB_Appointment where APPT_AS_ParRef=:ApttSchDr)
    s ResRowid=$p(ApttSchDr1,"||",1)
    s Apptchildsub=$p(ApttSchDr1,"||",2)
 
    s RBChildsub=$o(^RBAS(ResRowid,Apptchildsub,"APPT",""),-1)
    s Apptrowid=ApttSchDr1_"||"_RBChildsub
  
    //支持多个预约时间段
    s nums=$l(ApttSchDr,"^")
    for i=1:1:nums  d
    .s ApttSchDr1=$p(ApttSchDr,"^",i)
    .&sql(insert into RB_ApptFollowOnSlots (RBFOS_ParRef,RBFOS_NoOfslots,RBFOS_ApptSch_DR) values(:Apptrowid,1,:ApttSchDr1))
    .s ResRowid=$p(ApttSchDr1,"||",1)
    .s Apptchildsub=$p(ApttSchDr1,"||",2)
    .;I SQLCODE TRollBack  Quit SQLCODE
   	.;&sql(select AS_BookedSlots into :BookedNums from RB_ApptSchedule where AS_RowId=:ApttSchDr)
   	.s BookedNums=$p(^RBAS(ResRowid,Apptchildsub),"^",11)
   	.i $g(BookedNums)="" s BookedNums=0 
   	.s BookedNums=BookedNums+1
   	.&sql(update RB_ApptSchedule set AS_BookedSlots=:BookedNums where AS_RowId=:ApttSchDr1)
   	
   	I SQLCODE TRollBack  Quit SQLCODE
    &sql(update OE_OrdItem set OEORI_APPT_DR=:Apptrowid where OEORI_RowId=:OEOrdItemID)
    I SQLCODE TRollBack  Quit SQLCODE
   	TCOMMIT
    q SQLCODE
}

// d ##class(web.DHCRisAppointmentDo).GetBookedInfo(^TMPOeorditemdr)

ClassMethod GetBookedInfo(Oeorditemdr) As %String
{
	q:(Oeorditemdr="") "^^^^^^^^^^^^^"
    s OrderRowid=$p(Oeorditemdr,"||",1)
    s itemsub=$p(Oeorditemdr,"||",2)
    s ^TMP1111=Oeorditemdr
    	
	s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	s papatmasmdr=$p(^PAADM(paadmdr),"^",1)   
	s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)   
    s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
    s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
    s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
    s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
    s Locdr=$p(^PAADM(paadmdr),"^",4)
    s LocName=$p(^CTLOC(Locdr),"^",2) 
      
    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
  	s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
  	s (GroupDescDR,GroupDesc,RoomDR,RoomDesc,EQDR)=""
  	s approwid=$p($g(^OEORD(OrderRowid,"I",itemsub,6)),"^",5)
  	
	i (approwid'="")&&(approwid'=$c(0)) d 
	.s resrowid=$p(approwid,"||",1)
	.s CTCPDR=$p($g(^RB("RES",resrowid)),"^",2)
	.i CTCPDR'="" d
	..s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	.else  d
	..s EQDR=$p($g(^RB("RES",resrowid)),"^",3)
	..s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	..s RoomDR=$o(^DHCRBC("EQDR-ROOM",EQDR,""))
    ..i RoomDR'="" s RoomDesc=$p(^DHCRBC("Room",RoomDR),"^",2)
    ..s GroupDescDR=$p(^RBC("EQ",EQDR),"^",3)
    ..i GroupDescDR'="" s GroupDesc=$p(^RBC("GRP",GroupDescDR),"^",2) 
	.s Schrowid=$p(approwid,"||",2)
	.s scheInfo=^RBAS(resrowid,Schrowid)
	.s AppointDate=$p(scheInfo,"^",1)
	.s AppointDate=$zd(AppointDate,3)
	.s AppointstTime=$p(scheInfo,"^",4)
	.s AppointstTime=$zt(AppointstTime,1)
	else  d   ;孙毅调试暂时注视
	.s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,Oeorditemdr,0))
    .i BookedRowid'="" d
    ..s GetPatientStatusCode="B"
    ..s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
    ..i SchudleRowid'="" d
    ...s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
    ...s ResDesc=""
 	...s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
    ...s CTCPDR=$p(CTCPDR,$c(0))
    ...i CTCPDR'="" d
    ....s ResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
    ...else  d
    ....s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
    ....s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
    ....s RoomDR=$o(^DHCRBC("EQDR-ROOM",EQDR,""))
    ....i RoomDR'="" s RoomDesc=$p($g(^DHCRBC("Room",RoomDR)),"^",2)
    ....s GroupDescDR=$p(^RBC("EQ",EQDR),"^",3)
    ....i GroupDescDR'="" s GroupDesc=$p($g(^RBC("GRP",GroupDescDR)),"^",2) 
    ...s RppDate=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",2)
    ...s AppointDate=$zd(RppDate,3)
    ...s RppTime=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",5)
    ...s AppointstTime=$zt(RppTime,1)
  
    s Info=RegNo_"^"_Name_"^"_SexDesc_"^"_DOB_"^"_LocName_"^"_strOrderName_"^"_$g(ResDesc)_"^"_$g(AppointDate)_"^"_$g(AppointstTime)_"^"_GroupDescDR_"^"_GroupDesc_"^"_RoomDR_"^"_RoomDesc_"^"_EQDR
    q Info
}

/*ClassMethod DeleteBookInfo(Oeorditemdr) As %String
{
    s OrderRowid=$p(Oeorditemdr,"||",1)
    s itemsub=$p(Oeorditemdr,"||",2)
    s approwid=""
   	i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s approwid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
   	;q:$g(approwid)="" "" 
   	;q:approwid=$C(0) "" 
   	
   	if (approwid'="")&&(approwid'=$c(0))
   	{ 
    TSTART
   	&sql(update OE_OrdItem set OEORI_APPT_DR="" where OEORI_RowId=:Oeorditemdr)
   	I SQLCODE TRollBack  Quit SQLCODE_"^"_"-1"
   
   
    s resrowid=$p(approwid,"||",1)
   	s apptsch=$p(approwid,"||",2)
   	s aptchildsub=$p(approwid,"||",3)
    s Soltchild=0 f  s Soltchild=$o(^RBAS(resrowid,apptsch,"APPT",aptchildsub,"SLOT",Soltchild)) q:Soltchild=""  d
    .s apptschdr=$p(^RBAS(resrowid,apptsch,"APPT",aptchildsub,"SLOT",Soltchild),"^",2)
    .s resrowid1=$p(apptschdr,"||",1)
   	.s apptsch1=$p(apptschdr,"||",2)
    .s BookedNums=$p(^RBAS(resrowid1,apptsch1),"^",11)
   	.i BookedNums'="" s BookedNums=BookedNums-1
   	.i BookedNums="0" s BookedNums=""
   	.&sql(update RB_ApptSchedule set AS_BookedSlots=:BookedNums where AS_RowId=:apptschdr)
   	;I SQLCODE TRollBack  Quit SQLCODE
   	&sql(delete from RB_ApptFollowOnSlots where RBFOS_ParRef=:approwid)
   	I SQLCODE TRollBack  Quit SQLCODE_"^"_"-1"
   
   	&sql(delete from RB_Appointment where APPT_RowId=:approwid)
   	I SQLCODE TRollBack  Quit SQLCODE_"^"_"-1"

    TCOMMIT
   	}
   	else 
   	{
	   	s SQLCODE=##class(web.DHCRisResourceApptSchudle).CancelBookedInfo(Oeorditemdr)
   	}
    
    s DHCENSInfo="",ret="0"
    ;s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).CancelHisBookedInfo(Oeorditemdr)
    ;s ret=$p(DHCENSInfo,"^",1)  
     
   	q SQLCODE_"^"_ret
}*/
/// 取消预约函数注释 sunyi 
/// 对于多预约医嘱转预约函数
/// sunyi 2012-12-09
/// do ##class(web.DHCRisAppointmentDo).DeleteBookInfo(Oeorditemdr)
ClassMethod DeleteBookInfo(Oeorditemdr) As %String
{
	Set $ZT="ERROR"
	s Count=$l(Oeorditemdr,"@")
	for i=1:1:Count 
    {
	    s perOrditemRowid=$p(Oeorditemdr,"@",i)
	    s OrderRowid=$p(perOrditemRowid,"||",1)
	    s itemsub=$p(perOrditemRowid,"||",2)
	    s approwid=""
	   	i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s approwid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
	   	;q:$g(approwid)="" "" 
	   	;q:approwid=$C(0) "" 
	   	
	   	if (approwid'="")&&(approwid'=$c(0))
	   	{ 
		    TSTART
		   	&sql(update OE_OrdItem set OEORI_APPT_DR="" where OEORI_RowId=:perOrditemRowid)
		   	I SQLCODE TRollBack 
		    q:SQLCODE_"^"_"-1"  
		   
		   
		    s resrowid=$p(approwid,"||",1)
		   	s apptsch=$p(approwid,"||",2)
		   	s aptchildsub=$p(approwid,"||",3)
		    s Soltchild=0 f  s Soltchild=$o(^RBAS(resrowid,apptsch,"APPT",aptchildsub,"SLOT",Soltchild)) q:Soltchild=""  d
		    .s apptschdr=$p(^RBAS(resrowid,apptsch,"APPT",aptchildsub,"SLOT",Soltchild),"^",2)
		    .s resrowid1=$p(apptschdr,"||",1)
		   	.s apptsch1=$p(apptschdr,"||",2)
		    .s BookedNums=$p(^RBAS(resrowid1,apptsch1),"^",11)
		   	.i BookedNums'="" s BookedNums=BookedNums-1
		   	.i BookedNums="0" s BookedNums=""
		   	.&sql(update RB_ApptSchedule set AS_BookedSlots=:BookedNums where AS_RowId=:apptschdr)
		   	
		   	;I SQLCODE TRollBack  Quit SQLCODE
		   	&sql(delete from RB_ApptFollowOnSlots where RBFOS_ParRef=:approwid)
		    I SQLCODE TRollback  
            q:SQLCODE_"^"_"-1"
		   
		   	&sql(delete from RB_Appointment where APPT_RowId=:approwid)
		   	I SQLCODE TRollBack  
		    q:SQLCODE_"^"_"-1"
		    
		    TCOMMIT
		 }
		 else 
	   	 {
		   
			s SQLCODE=##class(web.DHCRisResourceApptSchudle).CancelBookedInfo(perOrditemRowid)	
			/*else
			{ 
		   	   s SQLCODE=##class(web.DHCRisResourceApptSchudle).CancelBookedInfo(perOrditemRowid)
			}*/
	     }
		    
		 s DHCENSInfo="",ret="0"
		 ;s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).CancelHisBookedInfo(perOrditemRowid)
		 ;s ret=$p(DHCENSInfo,"^",1) 	    
		    
    }  
   	q SQLCODE_"^"_ret
   	
ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	q SQLCODE_"^"_ret
}

ClassMethod GetBookedTitle()
{
	
	s Title="检查预约单"
	if $g(^DHCRisVersion)="HF_SL" s Title="安徽省立医院检查预约单"
	if $g(^DHCRisVersion)="BJ_JST" s Title="北京积水潭检查预约单"
	q Title
}

ClassMethod GetDay(offset)
{
	s getday=+$h+offset
	s getday=$zd(getday,4)
	q getday
}

ClassMethod GetLocBookedPrintTemplate(LocDR As %String) As %String
{
  s PrintName=""
  if LocDR'="" d 
  .s locprowid=$o(^DHCRBC("Loc",LocDR,0)) 
  .i locprowid'="" d
  ..s PrintName=$p(^DHCRBC("LocParam",locprowid),"^",10)
  q PrintName
}

ClassMethod GetEQBookedPrintTemplate(EQDR As %String) As %String
{
  s PrintName=""
  if EQDR'="" d 
  .s ClientDR=$o(^DHCRBCi("Client","Equipment",EQDR,0))
  .i ClientDR'="" s PrintName=$p(^DHCRBC("Client",ClientDR),"^",6)
  q PrintName
}

/// 查询预约中心位置设置
/// sunyi 2011-10-25
/// d ##class(%ResultSet).RunQuery("web.DHCRisAppointmentDo","QueryAppointmentLoc") 
Query QueryAppointmentLoc() As %Query(ROWSPEC = "Rowid:%String,LocNmae:%String,AppDesc:%String,Location:%String,TelNo:%String,InValidate:%String,LocId:%String")
{
}

ClassMethod QueryAppointmentLocExecute(ByRef qHandle As %Binary) As %Status
{
	//ROWID LOCID DESC  LOCATION  TEL inValidate
	//      LocNmae  AppDesc LOCATION TelNo InValidate
 s ind=1
 Set repid=$I(^CacheTemp)
 
 s Rowid=0 f  s Rowid=$O(^DHCRBCAppointmentLoc(Rowid)) q:(Rowid="")  d
 .s LocID=$p($g(^DHCRBCAppointmentLoc(Rowid)),"^",1)
 .i LocID'="" s LocNmae=$p($g(^CTLOC(LocID)),"^",2)
 .s AppDesc=$p($g(^DHCRBCAppointmentLoc(Rowid)),"^",2)
 .s Location=$p($g(^DHCRBCAppointmentLoc(Rowid)),"^",4)
 .s TelNo=$p($g(^DHCRBCAppointmentLoc(Rowid)),"^",3)
 .s InValidate=$p($g(^DHCRBCAppointmentLoc(Rowid)),"^",5)
 .Do OutAppointmentLoc
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutAppointmentLoc
 set Data=$lb(Rowid,LocNmae,AppDesc,Location,TelNo,InValidate,LocID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryAppointmentLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppointmentLocExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryAppointmentLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppointmentLocExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 设置预约中心信息
/// sunyi 2011-10-25
/// do ##class(web.DHCRisAppointmentDo).SetAppointmentLoc("1^83^憋尿检查^产科东单楼^62662346^Y","U")
ClassMethod SetAppointmentLoc(AllInfo As %String, OperateCode As %String) As %String
{
	//Rowid,LocNmae,AppDesc,Location,TelNo,InValidate,LocID
	
	s Rowid=$P($g(AllInfo),"^",1)
	s LocID=$p($g(AllInfo),"^",2)
    s AppDesc=$p($g(AllInfo),"^",3)
    s Location=$p($g(AllInfo),"^",4)
    s TelNo=$p($g(AllInfo),"^",5)
    s InValidate=$p($g(AllInfo),"^",6)
    s SQLCODE=0

	i OperateCode="I" d
	.&sql(Insert into DHCRBC_AppointmentLoc(DRCAL_LocID,DRCAL_Desc,DRCAL_Tel,DRCAL_Location,DRCAL_InValidate) 
	      values(:LocID,:AppDesc,:TelNo,:Location,:InValidate))
	
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_AppointmentLoc(DRCAL_LocID,DRCAL_Desc,DRCAL_Tel,DRCAL_Location,DRCAL_InValidate) 
	       values(:LocID,:AppDesc,:TelNo,:Location,:InValidate)
	      where DRCAL_RowId=:Rowid )
	      
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_AppointmentLoc where DRCAL_RowId=:Rowid)
    q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisAppointmentDo","QueryLocInfo","X") 
Query QueryLocInfo(LocName As %String) As %Query(ROWSPEC = "TLocName:%String,TRowid:%String")
{
}

ClassMethod QueryLocInfoExecute(ByRef qHandle As %Binary, LocName As %String) As %Status
{
	s LocType="E"
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	Set RowId=0	f  s RowId=$o(^CTLOC(RowId)) q:RowId=""  d
	.s GetDesc=$p($g(^CTLOC(RowId)),"^",2)
	.s Gettype=$p($g(^CTLOC(RowId)),"^",13)
	.q:(LocType'="")&(Gettype'=LocType)
	.i (GetDesc[LocName) d
	..Do OutLocRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutLocRow
	set Data=$lb(GetDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocInfoExecute ]
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

ClassMethod QueryLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 给薛珊项目组提供的预约信息接口程序
/// 入参:医嘱Rowid
/// 作者:sunyi
/// 日期:2012-07-28
/// w ##class(web.DHCRisAppointmentDo).QueryBooedInfo("70113||276")
ClassMethod QueryBooedInfo(Oeorditemdr As %String) As %String
{
	q:(Oeorditemdr="") "^^^^^^^^^^^^"
    s OrderRowid=$p(Oeorditemdr,"||",1)
    s itemsub=$p(Oeorditemdr,"||",2)
    s ^TMP1111=Oeorditemdr
    s GRowid="",Goal="",RecLocdr="",RecLocDesc="",approwid=""
    
    s approwid=$p($g(^OEORD(OrderRowid,"I",itemsub,6)),"^",5)
    q:(approwid="") "^^^^^^^^^^^^"	
	s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	s papatmasmdr=$p(^PAADM(paadmdr),"^",1)   
	s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)   
    s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
    s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
    i DOB'="" s DOB=$ZD(DOB,3)
    s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
    s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
    s Locdr=$p(^PAADM(paadmdr),"^",4)
    s LocName=$p(^CTLOC(Locdr),"^",2) 
      
    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    i (arcimid'="")
    {
	  	s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	  	s GRowid=$o(^DHCRBAppi("Goal-orditem",arcimid,0))
	  	i GRowid'="" d
	  	.s Goal=$p($g(^DHCRBCApp("GLOBAL",GRowid)),"^",2)
    }
    
  	s RecLocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	if RecLocdr'="" d
	.s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
	.i $f(RecLocDesc,"-")>0 d
	..s RecLocDesc=$p(RecLocDesc,"-",2)
  	
  	s (GroupDescDR,GroupDesc,RoomDR,RoomDesc,EQDR,ResDesc)=""
  	s (AppointDate,AppointstTime,scheInfo)=""

	i (approwid'="")&&(approwid'=$c(0)) d 
	.s resrowid=$p(approwid,"||",1)
	.s CTCPDR=$p($g(^RB("RES",resrowid)),"^",2)
	.i CTCPDR'="" d
	..s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	.else  d
	..s EQDR=$p($g(^RB("RES",resrowid)),"^",3)
	..s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	..s RoomDR=$o(^DHCRBC("EQDR-ROOM",EQDR,""))
    ..i RoomDR'="" s RoomDesc=$p(^DHCRBC("Room",RoomDR),"^",2)
    ..s GroupDescDR=$p($g(^RBC("EQ",EQDR)),"^",3)
    ..i GroupDescDR'="" s GroupDesc=$p($g(^RBC("GRP",GroupDescDR)),"^",2) 
	.s Schrowid=$p(approwid,"||",2)
	.s scheInfo=^RBAS(resrowid,Schrowid)
	.s AppointDate=$p($g(scheInfo),"^",1)
	.i AppointDate'="" s AppointDate=$zd(AppointDate,3)
	.s AppointstTime=$p($g(scheInfo),"^",4)
	.i AppointstTime'="" s AppointstTime=$zt(AppointstTime,1)
    s Info=RegNo_"^"_Name_"^"_SexDesc_"^"_DOB_"^"_LocName_"^"_strOrderName_"^"_$g(ResDesc)_"^"_$g(AppointDate)_"^"_$g(AppointstTime)_"^"_$g(GroupDesc)_"^"_$g(RoomDesc)_"^"_RecLocDesc_"^"_Goal
    q Info
}

/// 协和医院医生站停医嘱时,调用取消预约函数
/// sunyi 20121026
/// w ##class(web.DHCRisAppointmentDo).CancelHasBooked("59866||689")
ClassMethod CancelHasBooked(Oeorditemdr) As %String
{
	s Counts=$l(Oeorditemdr,"@")
	for j=1:1:Counts
    {
	    s (DetailRowid,ret,sqlvalue,value)=""
	    s perOrdItmRowid=$p(Oeorditemdr,"@",j)
	   
	    s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOrdItmRowid,0))
		i (DetailRowid'="")
		{
		   s ret=..DeleteBookInfo(perOrdItmRowid)
		   i (ret'="")
		   {
			   s sqlvalue=$p($g(ret),"^",1)
		       s value=$p($g(ret),"^",2)
		   }
		  
		   i (sqlvalue'="0") 
		   {
			  s ^DHCRISCANCELBOOKEDERROR(perOrdItmRowid)=sqlvalue_"^"_value
			  Goto MyError

		   }
		}
		
    }
    
    q 0
    
MyError
    q -1
}

}
