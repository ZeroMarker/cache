Import SQLUser

Class web.DHCRisWorkBenchDo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 341;

//获得该用户可以登陆的其他科室

Query QueryExamStatus() As %Query(ROWSPEC = "TDesc:%String,TCode:%String")
{
}

ClassMethod QueryExamStatusExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	s rowid=0 f  s rowid=$o(^websys.StandardTypeD("STD","RadiologyOrderStatus","ITM",rowid)) q:rowid=""  d  //=E^E^Executed^^0
	.s Desc=$p(^websys.StandardTypeD("STD","RadiologyOrderStatus","ITM",rowid),"^",3)
	.s Code=$p(^websys.StandardTypeD("STD","RadiologyOrderStatus","ITM",rowid),"^",1)
	.;s Code="["_Code_"]"
	.i (Code="E")!(Code="A")!(Code="V")!(Code="S")!(Code="R")!(Code="H") d
	..d OutRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow1
	set Data=$lb(Desc,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^CacheTemp(repid,ind+1)=$lb("所有","")
 
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryExamStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamItemExecute ]
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

ClassMethod QueryExamStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetStatus(inCode As %String)
{
  s Code=""
  s rowid=0 f  s rowid=$o(^websys.StandardTypeD("STD","RadiologyOrderStatus","ITM",rowid)) q:(rowid="")!(inCode=Code)  d  
  .s Code=$p(^websys.StandardTypeD("STD","RadiologyOrderStatus","ITM",rowid),"^",1)
  .i (inCode=Code)&&(inCode'="") d
  ..s Desc=$p(^websys.StandardTypeD("STD","RadiologyOrderStatus","ITM",rowid),"^",3)
}

Query QueryExamItem(type As %String, RegNo As %String, StudyNo As %String, LocDr As %String, StdDate As %String, enddate As %String, StatusCode As %String, ReportDoc As %String, VerifyDoc As %String, Name As %String, ResourceID As %String, OrderByIndex As %String, RegEQID As %String) As %Query(ROWSPEC = "Tregno:%String,TName:%String,TSex:%String,TDob:%String,TAge:%String,TDiagonse:%String,TStudyNo:%String,TstrOrderName:%String,TDoctor:%String,TstrAccessionNum:%String,TstrDate:%String,TstrTime:%String,TAppointDate:%String,TAppointstTime:%String,TstrRegDate:%String,TstrRegTime:%String,TReportDoc:%String,TReportVerifyDoc:%String,TPatientStatus:%String,Tpaadmdr:%String,TOeorditemdr:%String,TLocName:%String,Tprice:%String,TOEORIItemStatus:%String,TBillStatus:%String,TPatientType:%String,TNum:%String,TPerprice:%String,TIndex:%String,TRegEQ:%String,TBookedRes:%String,TNotes:%String,Tpatmasdr:%String")
{
}

ClassMethod QueryExamItemExecute(ByRef qHandle As %Binary, type As %String, RegNo As %String, StudyNo As %String, LocDr As %String, StdDate As %String, enddate As %String, StatusCode As %String, ReportDoc As %String, VerifyDOc As %String, Name As %String, ResourceID As %String, OrderByIndex As %String, RegEQID As %String) As %Status
{
	
   s LocDr=##class(web.DHCRisWorkBenchDo).GetSession("SelLocID")
   if LocDr="" s LocDr=%session.Get("LOGON.CTLOCID")
   s UserID=%session.Get("LOGON.USERID")
   
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1

   ;s UserID="12233"
   //s UserID=123
   //根据锁定的条件检索
   if ($g(^DHCRisLookupCondition(UserID))'="")
   {
	   	//s StudyNo=$p(^DHCRisLookupCondition(UserID),"^",1)
		s RegNo=$p(^DHCRisLookupCondition(UserID),"^",1)
		s Name=$p(^DHCRisLookupCondition(UserID),"^",2)
	    s ReportDoc=$p(^DHCRisLookupCondition(UserID),"^",3) 
	    s VerifyDOc=$p(^DHCRisLookupCondition(UserID),"^",4) 
        s StatusCode=$p(^DHCRisLookupCondition(UserID),"^",6) 
  
        s type=$p(^DHCRisLookupCondition(UserID),"^",7) 
        s ResourceID=$p(^DHCRisLookupCondition(UserID),"^",10) 
   	    s RegEQID=$p(^DHCRisLookupCondition(UserID),"^",12)
   	
   	    s StdDate=$p(^DHCRisLookupCondition(UserID),"^",13) 
   	    s enddate=$p(^DHCRisLookupCondition(UserID),"^",14)
   	    s StdDate=$zdh(StdDate,4)
   	    s enddate=$zdh(enddate,4)
   	    s OrderByIndex=$p(^DHCRisLookupCondition(UserID),"^",18)
   	    s Vlist=$p(^DHCRisLookupCondition(UserID),"^",19)
   	    s Blist=$p(^DHCRisLookupCondition(UserID),"^",20)
   	    s Elist=$p(^DHCRisLookupCondition(UserID),"^",21)
   	   
   	    if (Vlist="on") s StatusCode=StatusCode_"V"
   	    if (Blist="on") s StatusCode=StatusCode_"S"
   	    if (Elist="on") s StatusCode=StatusCode_"E"
		   
   }
   s ^tempcondi=LocDr_"^"_StudyNo_"^"_RegNo_"^"_Name_"^"_ReportDoc_"^"_VerifyDOc_"^"_StatusCode_"^"_type_"^"_ResourceID_"^"_RegEQID_"^"_StdDate_"^"_enddate_"^"_OrderByIndex
   //if StdDate="" s StdDate=+$h
   //if enddate="" s enddate=+$h
  
   s StatusCode=$tr(StatusCode," ")
   s ReportDoc=$tr(ReportDoc," ")
   s VerifyDOc=$tr(VerifyDOc," ")
   s StudyNo=$tr(StudyNo," ")
   
     
   if (OrderByIndex="on")
   {
	 s return=..OrderByIndex(type,LocDr,StdDate,OrderByIndex,RegEQID,StatusCode,ReportDoc,VerifyDOc)  
	 Quit $$$OK
   }
  
   
	i (RegNo="")&(StudyNo="")&(Name="")
    {
	    //i listtype="1" s StatusCode="V"   ; Verfied Order List
	    //i listtype="2" s StatusCode="S"   ; Booked Order List
	    s return=..QueryByLoc(type,LocDr,StdDate,enddate,StatusCode,ReportDoc, VerifyDOc,ResourceID,RegEQID)
   	    Quit $$$OK
     }
     
   if (StudyNo'="") 
   {	
	   s return=..QueryByStudyNo(type,StudyNo, LocDr,StdDate,enddate,StatusCode,ReportDoc,VerifyDOc)
       Quit $$$OK
   }
   
   if (RegNo'="")
   {
	    s return=..QueryByRegNo(type,RegNo,LocDr,StdDate,enddate,StatusCode,ReportDoc, VerifyDOc)
		Quit $$$OK
   }
   
   if (Name'="")
   {
	   s return=..QueryByName(type,Name,LocDr,StdDate,enddate,StatusCode,ReportDoc, VerifyDOc)
	   Quit $$$OK
   }
}

ClassMethod QueryExamItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamItemExecute ]
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

ClassMethod QueryExamItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByRegNo(type As %String, RegNo As %String, LocDr As %String, StdDate As %String, enddate As %String, StatusCode As %String, ReportDoc As %String, VerifyDOc As %String)
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    &sql(declare Admcur cursor for select PAADM_Rowid from PA_Adm where PAADM_PAPMI_DR->PAPMI_No=:RegNo )
    &sql(open Admcur)
    f  &sql(fetch Admcur into :paadmdr ) q:SQLCODE  d
     .; get patient diagnose 
	 .s IDCDesc="",Desc=""
     .s mradmdr=$p(^PAADM(paadmdr),"^",61)
     .s diachildsub=0  f  s diachildsub=$o(^MR(mradmdr,"DIA",diachildsub)) q:(diachildsub="")  d     
     ..s IDCCodeDR=$p(^MR(mradmdr,"DIA",diachildsub),"^",1)
     ..i $g(IDCCodeDR)'=""  d
     ...s Desc=$p($g(^MRC("ID",IDCCodeDR)),"^",2)
     ...s IDCDesc=IDCDesc_Desc
     .s papatmasmdr=$p(^PAADM(paadmdr),"^",1)        
     .s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
     .s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
     .s strAge=""
     .i DOB="" d
 	 ..s strDOB=""
 	 ..s strAge=""
 	 .e  d
     ..s strDOB=$ZD(DOB,3)
     ..s strToday=$ZD(+$h,3)
     ..s strAge=##class(web.DHCRisWorkBenchDo).CalAge(strDOB,strToday)
     .s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
     .s SexDesc=$p(^CT("SEX",SexDr),"^",2)
     .s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
     .s typedesc=..GetTypeDesc(patienttype)
     .q:(type'="")&(type'=patienttype)
     .s Locdr=$p(^PAADM(paadmdr),"^",4)
     .s LocName=$p(^CTLOC(Locdr),"^",2) 
     .s OrderRowid=""
 	 .s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
 	 .q:OrderRowid="" 
	 .s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	 ..s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)   ;
	 ..q:(LocDr'="")&(reploc'=LocDr)
	 ..s oeorditemdr=OrderRowid_"||"_itemsub 
	 ..s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	 ..s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	 ..s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	 ..s instypedr=$p(^PAADM(paadmdr,1),"^",7) 
	 ..s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
	 ..s price=$p(priceinfo,"^",1)
	 ..s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
	 ..s TotalPrice=price*Num
	 ..s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)   ;
	 ..i $g(^DHCRisVersion)'="HF_SL" q:(billed'="P")&(patienttype="O")&(price'="0")     ;门诊病人没有付费的退出
	 ..s AppointDate1="", StudyNo="",AppointstTime="",AppointDate="",strRegDate="",strRegTime="",Index="",EQDesc="",ResDesc=""
	 ..s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	 ..s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
	 ..s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
	 ..s CatDesc=$p(^OEC("ORCAT",OrdCatDr),"^",2)
	 ..s ServDesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7),"^",6)
	 ..q:($g(^DHCRisVersion)="BJ_JST")&(ServDesc="")
	 ..s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	 ..s Notstr=""
	 ..s countN=^OEORD(OrderRowid,"I",itemsub,"DEP",0)
	 ..f i=1:countN:1 d
	 ...s Notstr=Notstr_^OEORD(OrderRowid,"I",itemsub,"DEP",i)
	 ..s requestdoc=""
	 ..s ssusrdr=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",1)
	 ..i ssusrdr'="" s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2)         ; request doctor
	 ..s PatientStatus="医嘱核实"
	 ..s PatientStatusCode="V"
	 ..s approwid=""
	 ..i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s approwid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
	 ..i (approwid'="")&(approwid'=$c(0)) d 
	 ...s resrowid=$p(approwid,"||",1)
	 ...s Schrowid=$p(approwid,"||",2)
	 ...s scheInfo=^RBAS(resrowid,Schrowid)
	 ...s AppointDate1=$p(scheInfo,"^",1)
	 ...s AppointDate=$zd(AppointDate1,3)
	 ...s AppointstTime=$p(scheInfo,"^",4)
	 ...s AppointstTime=$zt(AppointstTime,1)
	 ...s CTCPDR=$p(^RB("RES",resrowid),"^",2)
	 ...i CTCPDR'="" d
	 ....s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	 ...else  d
	 ....s EQDR=$p(^RB("RES",resrowid),"^",3)
	 ....s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	 ...;s AppointedTime=$p(scheInfo,"^",5)
	 ...s PatientStatus="预约"
	 ...s PatientStatusCode="S"
	 ..q:((approwid="")!(approwid=$c(0)))&((Date1>enddate)!(Date1<StdDate))
	 ..q:(AppointDate1'="")&((AppointDate1>enddate)!(AppointDate1<StdDate))
	 ..;q:((AppointDate1>enddate)!(AppointDate1<StdDate))
	 ..s ReportDoc="",ReportVerifyDoc=""
	 ..s strDate=$zd(Date1,3)
	 ..;w !,strDate_"^"_Date1_"^"_enddate_"^"_StdDate
	 ..s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",10)
	 ..s strAccessionNum=$p(^OEORD(OrderRowid,"I",itemsub,8),"^",19) 
	 ..s strTime=$zt(Time1,1)
	 ..;s PatientStatus=""
	 ..s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	 ..i ItemStatDR="" q
	 ..i $g(^OEC("OSTAT",ItemStatDR))'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)  
	 ..i (ItemStatusCode="V")!(ItemStatusCode="E") d
	 ...;获得去预约时间
	 ...if ItemStatusCode="E"  d  ; 医嘱执行
	 ....s PatientStatus="执行" 
	 ....s PatientStatusCode="E"
	 ....s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,0))  ; 登记的表中获得检查号
	 ....i regrowid '="" d 
	 .....s ^tmpoeord=oeorditemdr
	 .....s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	 .....s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
	 .....s strRegDate=$zd(RegDate,3)
	 .....s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
	 .....s strRegTime=$zt(RegTime,1)
	 .....s Index=$p(^DHCPACRegInfo(regrowid),"^",15)
	 .....s EQDescdr=$p(^DHCPACRegInfo(regrowid),"^",14)
	 .....i EQDescdr'="" d
	 ......s EQDesc=$p($g(^RBC("EQ",EQDescdr)),"^",2)
	 .....s ResStatDR="",resrowid=0
	 .....s resrowid=$o(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid))
	 .....i resrowid'="" d 
	 ......s ResCode=""
	 ......s ResStatDR=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",2)
	 ......i ResStatDR'="" s ResCode=$p(^OEC("RESST",ResStatDR),"^",1)
	 ......b
	 ......i ResCode="H"  d
	 .......s PatientStatus="已发片" 
	 .......s PatientStatusCode="H"
	 ......i ResCode="E"  d 
	 .......s PatientStatus="报告" ; 审核的报告
	 .......s PatientStatusCode="R"
	 .......s CPReportDocDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",35)
	 .......i CPReportDocDr'="" d
	 ........i $g(^CTPCP(CPReportDocDr,1))'="" d 
	 .........i ^DHCRisGetNameSet="ID" d 
	 ..........s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)   
	 .........else  d
	 ..........s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)    
	 ......i ResCode="V" d
	 .......s PatientStatus="审核"
	 .......s PatientStatusCode="A"
	 .......s CPVerifyDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",36)
	 .......i CPVerifyDr'=""  d
	 ........i $g(^CTPCP(CPVerifyDr,1))'="" d 
	 .........i ^DHCRisGetNameSet="ID" d 
	 ..........s ReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",3)
	 .........else  d
	 ..........s ReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",2)
	 .......s CPReportDocDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",35)
	 .......i CPReportDocDr'="" d
	 ........i $g(^CTPCP(CPReportDocDr,1))'="" d 
	 .........i ^DHCRisGetNameSet="ID" d 
	 ..........s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)   
	 .........else  d
	 ..........s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2) 
	 ...i (StatusCode="")!(StatusCode[PatientStatusCode) d       
	 ....Do OutRow3
	&sql(close Admcur)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow3
  	set Data=$lb(RegNo,Name,SexDesc,strDOB,strAge,IDCDesc,$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(AppointDate),$g(AppointstTime),$g(strRegDate),$g(strRegTime),$g(ReportDoc),$g(ReportVerifyDoc),PatientStatus,paadmdr,oeorditemdr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),$g(ResDesc),Notstr,papatmasmdr)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryByName(type As %String, PatientName As %String, LocDr As %String, StdDate As %String, enddate As %String, StatusCode As %String, ReportDoc As %String, VerifyDOc As %String)
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    
    //^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
    /*s flag="N"
    s Name1=$$ALPHAUP^SSUTIL4(PatientName)
    s Name=Name1 f  s Name=$o(^PAPERi("PAPER_PatName",Name)) q:(Name="")&(flag="Y")  d
    .if $L(Name1),$e(Name,1,$l(Name1))'[Name1  s flag="Y" q
    */
    s strPatientName="%"_PatientName_"%"
    &sql(declare AdmcurN cursor for select PAADM_Rowid from PA_Adm where PAADM_PAPMI_DR->PAPMI_Name like :strPatientName )
    &sql(open AdmcurN)
    f  &sql(fetch AdmcurN into :paadmdr ) q:SQLCODE  d
     .; get patient diagnose 
     .s IDCDesc="",Desc=""
     .s mradmdr=$p(^PAADM(paadmdr),"^",61)
     .s diachildsub=0  f  s diachildsub=$o(^MR(mradmdr,"DIA",diachildsub)) q:(diachildsub="")  d     
     ..s IDCCodeDR=$p(^MR(mradmdr,"DIA",diachildsub),"^",1)
     ..i $g(IDCCodeDR)'=""  d
     ...s Desc=$p($g(^MRC("ID",IDCCodeDR)),"^",2)
     ...s IDCDesc=IDCDesc_Desc
     .s papatmasmdr=$p(^PAADM(paadmdr),"^",1)        
     .s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
     .s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
     .s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
     .s strAge=""
     .i DOB="" d
 	 ..s strDOB=""
 	 ..s strAge=""
 	 .e  d
     ..s strDOB=$ZD(DOB,3)
     ..s strToday=$ZD(+$h,3)
     ..s strAge=##class(web.DHCRisWorkBenchDo).CalAge(strDOB,strToday)
     .s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
     .s SexDesc=$p(^CT("SEX",SexDr),"^",2)
     .s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
     .s typedesc=..GetTypeDesc(patienttype)
     .q:(type'="")&(type'=patienttype)
     .s Locdr=$p(^PAADM(paadmdr),"^",4)
     .s LocName=$p(^CTLOC(Locdr),"^",2) 
     .s OrderRowid=""
 	 .s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
 	 .q:OrderRowid=""
	 .s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	 ..s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)   ;
	 ..q:(LocDr'="")&(reploc'=LocDr)
	 ..s oeorditemdr=OrderRowid_"||"_itemsub 
	 ..s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	 ..s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
     ..s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	 ..s instypedr=$p(^PAADM(paadmdr,1),"^",7) 
	 ..s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
	 ..s price=$p(priceinfo,"^",1)
	 ..s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
	 ..s TotalPrice=price*Num
	 ..s Notstr=""
	 ..s countN=^OEORD(OrderRowid,"I",itemsub,"DEP",0)
	 ..f i=1:countN:1 d
	 ...s Notstr=Notstr_^OEORD(OrderRowid,"I",itemsub,"DEP",i)
	 ..s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)   ;
	 ..i $g(^DHCRisVersion)'="HF_SL" q:(billed'="P")&(patienttype="O")&(price'="0")     ;门诊病人没有付费的退出
	 ..s AppointDate1="", StudyNo="",AppointstTime="",AppointDate="",strRegDate="",strRegTime="",ResDesc=""
	 ..s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	 ..s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
	 ..s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
	 ..s CatDesc=$p(^OEC("ORCAT",OrdCatDr),"^",2)
	 ..s ServDesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7),"^",6)
	 ..q:($g(^DHCRisVersion)="BJ_JST")&(ServDesc="")
	 ..s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	 ..s ssusrdr=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",1)
	 ..s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2)         ; request doctor
	 ..s PatientStatus="医嘱核实"
	 ..s PatientStatusCode="V"
	 ..s approwid=""
	 ..i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s approwid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
	 ..i (approwid'="")&(approwid'=$c(0)) d 
	 ...s resrowid=$p(approwid,"||",1)
	 ...s Schrowid=$p(approwid,"||",2)
	 ...s scheInfo=^RBAS(resrowid,Schrowid)
	 ...s AppointDate1=$p(scheInfo,"^",1)
	 ...s AppointDate=$zd(AppointDate1,3)
	 ...s AppointstTime=$p(scheInfo,"^",4)
	 ...s AppointstTime=$zt(AppointstTime,1)
	 ...s CTCPDR=$p(^RB("RES",resrowid),"^",2)
	 ...i CTCPDR'="" d
	 ....s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	 ...else  d
	 ....s EQDR=$p(^RB("RES",resrowid),"^",3)
	 ....s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	 ...s PatientStatus="预约"
	 ...s PatientStatusCode="S"
	 ..q:(approwid="")&((Date1>enddate)!(Date1<StdDate))
	 ..q:(AppointDate1'="")&((AppointDate1>enddate)!(AppointDate1<StdDate))
	 ..;q:((AppointDate1>enddate)!(AppointDate1<StdDate))
	 ..s strDate=$zd(Date1,3)
	 ..s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",10)
	 ..s strAccessionNum=$p(^OEORD(OrderRowid,"I",itemsub,8),"^",19) 
	 ..s strTime=$zt(Time1,1)
	 ..;s PatientStatus=""
	 ..s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	 ..i ItemStatDR="" q 
	 ..i $g(^OEC("OSTAT",ItemStatDR))'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)  
	 ..i (ItemStatusCode="V")!(ItemStatusCode="E") d
	 ...;获得去预约时间
	 ...if ItemStatusCode="E"  d  ; 医嘱执行
	 ....s PatientStatus="执行" 
	 ....s PatientStatusCode="E"
	 ....s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,0))  ; 登记的表中获得检查号
	 ....i regrowid '="" d 
	 .....s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	 .....s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
	 .....s strRegDate=$zd(RegDate,3)
	 .....s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
	 .....s strRegTime=$zt(RegTime,1)
     .....s Index=$p(^DHCPACRegInfo(regrowid),"^",15)
	 .....s EQDescdr=$p(^DHCPACRegInfo(regrowid),"^",14)
	 .....i EQDescdr'="" s EQDesc=$p(^RBC("EQ",EQDescdr),"^",2)
	 .....s ResStatDR="",resrowid=0
	 .....s resrowid=$o(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid))
	 .....i resrowid'="" d 
	 ......s ResStatDR=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",2)
	 ......s ResCode=""
	 ......i ResStatDR'="" s ResCode=$p(^OEC("RESST",ResStatDR),"^",1)
	 ......i ResCode="H"  d
	 .......s PatientStatus="已发片" 
	 .......s PatientStatusCode="H"
	 ......i ResCode="E"  d 
	 .......s PatientStatus="报告" ; 审核的报告
	 .......s PatientStatusCode="R"
	 .......s CPReportDocDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",35)
	 .......i $g(^CTPCP(CPReportDocDr,1))'="" d
	 ........i ^DHCRisGetNameSet="ID" d 
	 .........s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)
	 ........else  d
	 .........s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)       
	 ......i ResCode="V" d
	 .......s PatientStatus="审核"
	 .......s PatientStatusCode="A"
	 .......s CPVerifyDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",36)
	 .......i $g(^CTPCP(CPVerifyDr,1))'="" d
	 ........i ^DHCRisGetNameSet="ID" d 
	 .........s ReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",3)
	 ........else  d
	 .........s ReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",3)
	 .......s CPReportDocDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",35)
	 .......i CPReportDocDr'="" d
	 ........i $g(^CTPCP(CPReportDocDr,1))'="" d 
	 .........i ^DHCRisGetNameSet="ID" d 
	 ..........s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)   
	 .........else  d
	 ..........s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)
	 ...i (StatusCode="")!(StatusCode[PatientStatusCode) d       
	 ....Do OutRow9
	&sql(close AdmcurN)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow9
  	set Data=$lb(RegNo,Name,SexDesc,strDOB,strAge,IDCDesc,$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(AppointDate),$g(AppointstTime),$g(strRegDate),$g(strRegTime),$g(ReportDoc),$g(ReportVerifyDoc),PatientStatus,paadmdr,oeorditemdr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),$g(ResDesc),Notstr,papatmasmdr)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryByLoc(type As %String, LocDr As %String, StdDate As %String, enddate As %String, StatusCode As %String, ReportDoc As %String, VerifyDOc As %String, ResourceID As %String, RegEQID As %String)
{
	
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    ;if ResourceID'="" s StatusCode="S"
    f date=enddate:-1:StdDate d
    .s return=..QueryBookedItem(type,StatusCode,"", date, LocDr,ResourceID,ReportDoc,VerifyDOc,RegEQID)  ;查询到指定的日期的预约医嘱
    .s OrderRowid="" f  s OrderRowid=$o(^OEORDi(0,"ItemDate",date,OrderRowid)) q:OrderRowid=""  d               ;循环查询
	..q:$g(OrderRowid)=""   ;2003-12-28 修改
	..s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	..s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
	..s RegNo="",Name=""
	..i $g(papatmasmdr)'="" d   
	...s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)   
    ...s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
    ..; get patient diagnose 
	..s IDCDesc="",Desc=""
    ..s mradmdr=$p(^PAADM(paadmdr),"^",61)
    ..s diachildsub=0  f  s diachildsub=$o(^MR(mradmdr,"DIA",diachildsub)) q:(diachildsub="")  d     
    ...s IDCCodeDR=$p(^MR(mradmdr,"DIA",diachildsub),"^",1)
    ...i $g(IDCCodeDR)'=""  d
    ....s Desc=$p($g(^MRC("ID",IDCCodeDR)),"^",2)
    ....s IDCDesc=IDCDesc_Desc
    ..s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
    ..s strAge=""
    ..i DOB="" d
 	...s strDOB=""
 	...s strAge=""
 	..e  d
    ...s strDOB=$ZD(DOB,3)
    ...s strToday=$ZD(+$h,3)
    ...s strAge=##class(web.DHCRisWorkBenchDo).CalAge(strDOB,strToday)
    ..s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
    ..s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    ..s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
    ..s typedesc=..GetTypeDesc(patienttype)
    ..q:(type'="")&(type'=patienttype)
    ..s Locdr=$p(^PAADM(paadmdr),"^",4)
    ..i $g(Locdr)'="" s LocName=$p(^CTLOC(Locdr),"^",2) 
   	..s itemsub=0 f  s itemsub=$o(^OEORDi(0,"ItemDate",date,OrderRowid,itemsub)) q:(itemsub="")  d
	...s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	...;w !,OrderRowid_"||"_itemsub  ;
	...q:(reploc'=LocDr)&(LocDr'="")
	...s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	...s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	...s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	...s instypedr=$p(^PAADM(paadmdr,1),"^",7) 
	...s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
	...s Notstr=""
	...s countN=^OEORD(OrderRowid,"I",itemsub,"DEP",0)
	...f i=1:countN:1 d
	....s Notstr=Notstr_^OEORD(OrderRowid,"I",itemsub,"DEP",i)
	...s price=$p(priceinfo,"^",1)
	...s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
	...s TotalPrice=price*Num
	...s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)   ;
	...;w !,patienttype_"^"_billed_"^"_price
	...q:(billed'="P")&(patienttype="O")&($g(^DHCRisVersion)'="HF_SL")    ;门诊病人没有付费的退出
	...s oeorditemdr=OrderRowid_"||"_itemsub 
	...s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	...s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	...q:(Date1>enddate)!(Date1<StdDate) 
	...s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
	...s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
	...s CatDesc=$p(^OEC("ORCAT",OrdCatDr),"^",2)
	...s ServDesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7),"^",6)
	...s ServDesc=$tr($g(ServDesc)," ")
	...;w !,"ServerDesc^"_ServDesc_"^"_strOrderName
	...q:($g(^DHCRisVersion)="BJ_JST")&(ServDesc="")
	...s StudyNo=""
	...s strDate=$zd(Date1,3)
	...s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",10)  ;--------------------
	...s requestdoc=""
	...s ssusrdr=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",1)
	...if ssusrdr'="" s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2)         ; request doctor
	...s strAccessionNum=$p(^OEORD(OrderRowid,"I",itemsub,8),"^",19) 
	...s strTime=$zt(Time1,1)
	...s PatientStatus="医嘱核实"
	...s PatientStatusCode="V"
	...s ItemStatusCode=""
	...s approwid="",AppointDate="",AppointstTime="",strRegDate="",strRegTime="",getReportDoc="",getReportVerifyDoc="",Index="",EQDesc="",EQDescdr=""
	...s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	...i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	...i (ItemStatusCode="V")!(ItemStatusCode="E") d
	....i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s approwid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)  ; RB_Appointment Rowid
	....i ItemStatusCode="E"  d  ; 医嘱执行
	.....s PatientStatus="执行"
	.....s PatientStatusCode="E"
	.....s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))  ; 登记的表中获得检查号
	.....i regrowid '="" d 
	......s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	......s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
	......s strRegDate=$zd(RegDate,3)
	......s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
	......s strRegTime=$zt(RegTime,1)
    ......s Index=$p(^DHCPACRegInfo(regrowid),"^",15)
	......s EQDescdr=$p(^DHCPACRegInfo(regrowid),"^",14)
	......i EQDescdr'="" d 
	.......s EQDesc=$p($g(^RBC("EQ",EQDescdr)),"^",2)
	......s ResStatDR="",resrowid=0
	......s resrowid=$o(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid)) ; 在医嘱结果表
	......i resrowid'="" d 
	.......s ResStatDR=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",2)
	.......s ResCode=""
	.......i ResStatDR'="" s ResCode=$p(^OEC("RESST",ResStatDR),"^",1)
	.......i ResCode="H"  d
	........s PatientStatus="已发片" 
	........s PatientStatusCode="H"
	.......i ResCode="E"  d 
	........s PatientStatus="报告" ; 审核的报告
	........s PatientStatusCode="R"
	........s CPReportDocDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",35)
	........i $g(CPReportDocDr)'="" d 
	.........i $g(^CTPCP(CPReportDocDr,1))'="" d 
	..........i ^DHCRisGetNameSet="ID" d 
	...........s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)
	..........else  d
	...........s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)       
	.......i ResCode="V" d
	........s PatientStatus="审核"
	........s PatientStatusCode="A"
	........s CPVerifyDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",36)
    ........i $g(CPVerifyDr)'=""  d 
	.........i $g(^CTPCP(CPVerifyDr,1))'="" d 
	..........i ^DHCRisGetNameSet="ID" d 
	...........s getReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",3)
	..........else  d
	...........s getReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",2)
	........s CPReportDocDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",35)
	........i $g(CPReportDocDr)'="" d 
	.........i $g(^CTPCP(CPReportDocDr,1))'="" d 
	..........i ^DHCRisGetNameSet="ID" d 
	...........s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)
	..........else  d
	...........s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)
	....s approwid=$tr($p(approwid,$c(0)),"")
   	....i ((RegEQID="")!(RegEQID=EQDescdr))&((StatusCode="")!(StatusCode[PatientStatusCode))&(approwid="")&((ReportDoc="")!(ReportDoc=getReportDoc))&((VerifyDOc="")!(VerifyDOc=getReportVerifyDoc))&(ResourceID="") d    
	.....Do OutRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow4
    set Data=$lb(RegNo,Name,$g(SexDesc),$g(strDOB),$g(strAge),$g(IDCDesc),$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(AppointDate),$g(AppointstTime),$g(strRegDate),$g(strRegTime),$g(getReportDoc),$g(getReportVerifyDoc),PatientStatus,paadmdr,oeorditemdr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),"",Notstr,papatmasmdr)
	Set ^CacheTemp(repid,ind)=Data
	;s ^gpQuery(ind)=Data
  	Set ind=ind+1
 	quit
}

ClassMethod QueryByStudyNo(type As %String, StudyNo As %String, LocDr As %String, StdDate As %String, enddate As %String, StatusCode As %String, ReportDoc As %String, VerifyDOc As %String)
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s Regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,"")) 
    i $g(Regrowid)=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	
    s RegDate=$p(^DHCPACRegInfo(Regrowid),"^",8)
	s strRegDate=$zd(RegDate,3)
	s RegTime=$p(^DHCPACRegInfo(Regrowid),"^",9)
	s strRegTime=$zt(RegTime,1)
	s Index=$p(^DHCPACRegInfo(Regrowid),"^",15)
	s EQDescdr=$p(^DHCPACRegInfo(Regrowid),"^",14)
	i EQDescdr'="" d
	.s EQDesc=$p($g(^RBC("EQ",EQDescdr)),"^",2)
	s Oeorditemdr=$p(^DHCPACRegInfo(Regrowid),"^",11)
	s OrderRowid=$p(Oeorditemdr,"||",1)
	s itemsub=$p(Oeorditemdr,"||",2)
	s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
 
	s instypedr=$p(^PAADM(paadmdr,1),"^",7) 
	s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
	;s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimid, SttDate, "", "", "", "")
	s price=$p(priceinfo,"^",1)
	s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
	s TotalPrice=price*Num
    s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)   ;
	q:(reploc'=LocDr)&(LocDr'="") 
    s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	IF (Date1>enddate)!(Date1<StdDate) Set qHandle=$lb(0,repid,0) Quit $$$OK

	s papatmasmdr=$p(^PAADM(paadmdr),"^",1) 
	; get patient diagnose 
	s IDCDesc="",Desc=""
    s mradmdr=$p(^PAADM(paadmdr),"^",61)
    s diachildsub=0  f  s diachildsub=$o(^MR(mradmdr,"DIA",diachildsub)) q:(diachildsub="")  d     
    .s IDCCodeDR=$p(^MR(mradmdr,"DIA",diachildsub),"^",1)
    .i $g(IDCCodeDR)'=""  d
    ..s Desc=$p($g(^MRC("ID",IDCCodeDR)),"^",2)
    ..s IDCDesc=IDCDesc_Desc
	s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)   
    s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
    s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
    s strAge=""
    i DOB="" d
 	 .s strDOB=""
 	 .s strAge=""
 	e  d
     .s strDOB=$ZD(DOB,3)
     .s strToday=$ZD(+$h,3)
     .s strAge=##class(web.DHCRisWorkBenchDo).CalAge(strDOB,strToday)
    s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
    s SexDesc=""
    i $g(SexDr)'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
    s typedesc=..GetTypeDesc(patienttype)
    q:(type'="")&(type'=patienttype)
    s Locdr=$p(^PAADM(paadmdr),"^",4)
    s LocName=$p(^CTLOC(Locdr),"^",2)   ; 
  
    s OrderRowid=$p(Oeorditemdr,"||",1)
    s itemsub=$p(Oeorditemdr,"||",2)
    
    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
  	s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    s strDate=$zd(Date1,3)
	s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",10)
	s strAccessionNum=$p(^OEORD(OrderRowid,"I",itemsub,8),"^",19) 
	s ssusrdr=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",1)
	s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2)         ; request doctor
	s strTime=$zt(Time1)
	s PatientStatus=""
	
	s Notstr=""
	s countN=^OEORD(OrderRowid,"I",itemsub,"DEP",0)
	f i=1:countN:1 d
	.s Notstr=Notstr_^OEORD(OrderRowid,"I",itemsub,"DEP",i)

	s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
	s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
	s CatDesc=$p(^OEC("ORCAT",OrdCatDr),"^",2)
	s ServDesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7),"^",6)
	q:($g(^DHCRisVersion)="BJ_JST")&(ServDesc="")
	s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	s approwid="",ReportDoc="",ReportVerifyDoc="",ResDesc=""
	s billed="P"
	i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" d 
	.s approwid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
	.i (approwid'="")&(approwid'=$c(0))  d 
	..s resrowid=$p(approwid,"||",1)
	..s Schrowid=$p(approwid,"||",2)
	..s scheInfo=^RBAS(resrowid,Schrowid)
	..s AppointDate=$p(scheInfo,"^",1)
	..s AppointDate=$zd(AppointDate,3)
	..s AppointstTime=$p(scheInfo,"^",4)
	..s AppointstTime=$zt(AppointstTime,1)
	..s CTCPDR=$p(^RB("RES",resrowid),"^",2)
	..i CTCPDR'="" d
	...s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	..else  d
	...s EQDR=$p(^RB("RES",resrowid),"^",3)
	...s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	..;s AppointedTime=$p(scheInfo,"^",5)
	..s PatientStatus="预约"
	..s PatientStatusCode="S"
	s ResStaotDR="",resrowid=0
	s resrowid=$o(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid))
	s PatientStatus="执行"
	s PatientStatusCode="E"
	i resrowid'="" d 
	.s ResStatDR=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",2)
	.;w !,strOrderName_"^"_OrderRowid_"||"_itemsub_"||"_resrowid_"^"_ResStatDR
	.s ResCode=""
	.i ResStatDR'="" s ResCode=$p(^OEC("RESST",ResStatDR),"^",1)
	.i ResCode="H"  d
	 ..s PatientStatus="已发片" 
	 ..s PatientStatusCode="H"
	.i ResCode="E"  d 
	..s PatientStatus="报告" ; 审核的报告
    ..s PatientStatusCode="R"
	..s CPReportDocDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",35)
	..i $g(CPReportDocDr)'="" d
	...i ^DHCRisGetNameSet="ID" d 
	....s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)
	...else  d
	....s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)
	.i ResCode="V" d
	..s PatientStatus="审核"
	..s PatientStatusCode="A"
	..s CPVerifyDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",36)
    ..i $g(CPVerifyDr)'="" d
	...i ^DHCRisGetNameSet="ID" d 
	....s ReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",3)
	...else  d
	....s ReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",2)
	..; report doctor
	..s CPReportDocDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",35)
	..i $g(CPReportDocDr)'="" d
	...i ^DHCRisGetNameSet="ID" d 
	....s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)
	...else  d
	....s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)
	i (StatusCode="")!(StatusCode[PatientStatusCode) d     
	.Do OutRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow5
   	set Data=$lb(RegNo,Name,SexDesc,strDOB,strAge,IDCDesc,$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(AppointDate),$g(AppointstTime),$g(strRegDate),$g(strRegTime),$g(ReportDoc),$g(ReportVerifyDoc),PatientStatus,paadmdr,Oeorditemdr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),$g(ResDesc),Notstr,papatmasmdr)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatientInfo(RegNo)
{

	 &sql(select Max(PAADM_Rowid) into :paadmdr  from PA_Adm where PAADM_PAPMI_DR->PAPMI_No=:RegNo )
     if ($g(paadmdr)'="")
     {
     s papatmasmdr=$p(^PAADM(paadmdr),"^",1)        
     s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
     s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
     i DOB'="" s strDOB=$zd(DOB,3)
     i strDOB="1840-12-31" s strDOB="" 
     s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
     s SexDesc=$p(^CT("SEX",SexDr),"^",2)
     s Type=$p(^PAADM(paadmdr),"^",2) ;病人类型
     s Locdr=$p(^PAADM(paadmdr),"^",4)
     s LocName=$p(^CTLOC(Locdr),"^",2) 
	 q Name_"^"_SexDesc_"^"_Type_"^"_$g(strDOB)_"^"_$g(LocName)
     }
     else
     {
	   q "^^^^"
     }
}

ClassMethod QueryBookedItem(type, StatusCode, paadmdr, AppStDate, LocID, ResourceID, ReportDoc, ReportVerifyDoc, RegEQID)
{

 Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
 .s ResDesc=""
 .s CTCPDR=$p($g(^RB("RES",RowId)),"^",2)
 .i CTCPDR'="" d
 ..s ResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
 .else  d
 ..s EQDR=$p($g(^RB("RES",RowId)),"^",3)
 ..s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
 .q:(ResourceID'="")&(ResourceID'=RowId)
 .s session=0
 .f  s session=$o(^RBAS(RowId,0,"DateSTime",AppStDate,session)) q:session=""  d
 ..s childsub=0 f  s childsub=$o(^RBAS(RowId,0,"DateSTime",AppStDate,session,childsub)) q:childsub=""  d
 ...s apptschinfo=^RBAS(RowId,childsub)
 ...s AppointDate=$p(apptschinfo,"^",1)
 ...q:AppointDate'=AppStDate
 ...s AppointDate=$zd(AppointDate,3)
 ...s AppointstTime=$p(apptschinfo,"^",4)
 ...s AppointstTime=$zt(AppointstTime,1)
 ...s ApptRowid=RowId_"||"_childsub
 ...s appointchildsub=0  f  s appointchildsub=$o(^RBAS(RowId,childsub,"APPT",appointchildsub)) q:appointchildsub=""  d
 ....s apppintrowid=ApptRowid_"||"_appointchildsub
 ....s ordrowid=0 
 ....s ordrowid=$o(^OEORDi(0,"Appt",apppintrowid,ordrowid))
 ....i ordrowid'=""  d
 .....s orditemchildsub=0  
 .....s orditemchildsub=$o(^OEORDi(0,"Appt",apppintrowid,ordrowid,orditemchildsub))
 .....s oeorditemdr=ordrowid_"||"_orditemchildsub
 .....;w !,oeorditemdr
 .....s GetPaadmr=$p(^OEORD(ordrowid),"^",1)
 .....q:(paadmdr'="")&(GetPaadmr'=paadmdr)
 .....s papatmasmdr=$p(^PAADM(GetPaadmr),"^",1)  
 .....;get patient diagnose 
 .....s IDCDesc="",Desc=""
 .....s mradmdr=$p(^PAADM(GetPaadmr),"^",61)
 .....s diachildsub=0  f  s diachildsub=$o(^MR(mradmdr,"DIA",diachildsub)) q:(diachildsub="")  d     
 ......s IDCCodeDR=$p(^MR(mradmdr,"DIA",diachildsub),"^",1)
 ......i $g(IDCCodeDR)'=""  d
 .......s Desc=$p($g(^MRC("ID",IDCCodeDR)),"^",2)
 .......s IDCDesc=IDCDesc_Desc
 .....s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)
 .....s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
 .....s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
 .....s strAge=""
 .....i DOB="" d
 ......s strDOB=""
 ......s strAge=""
 .....e  d
 ......s strDOB=$ZD(DOB,3)
 ......s strToday=$ZD(+$h,3)
 ......s strAge=##class(web.DHCRisWorkBenchDo).CalAge(strDOB,strToday)
 .....s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
 .....s SexDesc=$p(^CT("SEX",SexDr),"^",2)
 .....s patienttype=$p(^PAADM(GetPaadmr),"^",2)
 .....s typedesc=..GetTypeDesc(patienttype)
 .....q:(type'="")&(type'=patienttype)
 .....s Locdr=$p(^PAADM(GetPaadmr),"^",4)
 .....i $g(Locdr)'="" s LocName=$p(^CTLOC(Locdr),"^",2)
 .....s arcimid=$p(^OEORD(ordrowid,"I",orditemchildsub,1),"^",2)
 .....s billed=$p(^OEORD(ordrowid,"I",orditemchildsub,3),"^",5)
 .....s SttDate=$p(^OEORD(ordrowid,"I",orditemchildsub,1),"^",9)  
 .....s Notstr=""
 .....s countN=^OEORD(ordrowid,"I",orditemchildsub,"DEP",0)
 .....f i=1:countN:1 d
 ......s Notstr=Notstr_^OEORD(ordrowid,"I",orditemchildsub,"DEP",i)
 .....;s arcimid=$p(^OEORD(ordrowid,"I",orditemchildsub,1),"^",2)
 .....s OEPrice=$p($g(^OEORD(ordrowid,"I",orditemchildsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
 .....s instypedr=$p(^PAADM(GetPaadmr,1),"^",7) 
 .....s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
 .....;s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimid, SttDate, "", "", "", "")
 .....s price=$p(priceinfo,"^",1)
 .....s Num=$p(^OEORD(ordrowid,"I",orditemchildsub,1),"^",12)
 .....s TotalPrice=price*Num
 .....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
 .....s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
 .....s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
 .....s CatDesc=$p(^OEC("ORCAT",OrdCatDr),"^",2)
 .....s ServDesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7),"^",6)
 .....;w !,"booked-server^"_ServDesc_"^"_strOrderName
 .....q:($g(^DHCRisVersion)="BJ_JST")&(ServDesc="")
 .....s Date1=$p(^OEORD(ordrowid,"I",orditemchildsub,3),"^",7)
 .....s StudyNo=""
 .....s strDate=$zd(Date1,3)
 .....s Time1=$p(^OEORD(ordrowid,"I",orditemchildsub,1),"^",10)  ;--------------------
 .....s strAccessionNum=$p(^OEORD(ordrowid,"I",orditemchildsub,8),"^",19) 
 .....s ssusrdr=$p(^OEORD(ordrowid,"I",orditemchildsub,7),"^",1)
 .....s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2)         ; request doctor
 .....s strTime=$zt(Time1,1)
 .....s PatientStatusCode="S"
 .....s PatientStatus="预约"
 .....s ItemStatusCode=""
 .....s strRegDate="",strRegTime="",getReportDoc="",getReportVerifyDoc="",EQDescdr=""
 .....s ItemStatDR=$p(^OEORD(ordrowid,"I",orditemchildsub,1),"^",13)
 .....i $g(ItemStatDR)'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
 .....i (ItemStatusCode="E") d
 ......s PatientStatus="执行"
 ......s PatientStatusCode="E"
 ......s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))  ; 登记的表中获得检查号
 ......i regrowid '="" d 
 .......s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
 .......s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
 .......s strRegDate=$zd(RegDate,3)
 .......s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
 .......s strRegTime=$zt(RegTime,1)
 .......s Index=$p(^DHCPACRegInfo(regrowid),"^",15)
 .......s EQDescdr=$p(^DHCPACRegInfo(regrowid),"^",14)
 .......i EQDescdr'="" d
 ........s EQDesc=$p($g(^RBC("EQ",EQDescdr)),"^",2)
 .......s ResStatDR="",resrowid=0
 .......s resrowid=$o(^OEORD(ordrowid,"I",orditemchildsub,"RES",resrowid)) ; 在医嘱结果表
 .......i resrowid'="" d 
 ........s ResStatDR=$p(^OEORD(ordrowid,"I",orditemchildsub,"RES",resrowid),"^",2)
 ........s ResCode=""
 ........i ResStatDR'="" s ResCode=$p(^OEC("RESST",ResStatDR),"^",1)
 ........i ResCode="E"  d 
 .........s PatientStatus="报告" ; 审核的报告
 .........s PatientStatusCode="R"
 .........s CPReportDocDr=$p(^OEORD(ordrowid,"I",orditemchildsub,"RES",resrowid),"^",35)
 .........i $g(CPReportDocDr)'="" d
 ..........i $g(^CTPCP(CPReportDocDr,1))'=""  d
 ...........i ^DHCRisGetNameSet="ID" d 
 ............s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)
 ...........else  d
 ............s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)       
 ........i ResCode="V" d
 .........s PatientStatus="审核"
 .........s PatientStatusCode="A"
 .........s CPVerifyDr=$p(^OEORD(ordrowid,"I",orditemchildsub,"RES",resrowid),"^",36)
 .........i $g(CPVerifyDr)'="" d
 ..........i $g(^CTPCP(CPVerifyDr,1))'=""  d
 ...........i ^DHCRisGetNameSet="ID" d 
 ............s getReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",3)  
 ...........else  d
 ............s getReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",2)
 .........s CPReportDocDr=$p(^OEORD(ordrowid,"I",orditemchildsub,"RES",resrowid),"^",35)
 .........i $g(CPReportDocDr)'="" d
 ..........i $g(^CTPCP(CPReportDocDr,1))'=""  d
 ...........i ^DHCRisGetNameSet="ID" d 
 ............s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)
 ...........else  d
 ............s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)
 .....i ((StatusCode="")!(StatusCode[$g(PatientStatusCode)))&((type="")!(type=patienttype))&((ReportDoc="")!(ReportDoc=getReportDoc))&((ReportVerifyDoc="")!(ReportVerifyDoc=getReportVerifyDoc))&((RegEQID="")!(RegEQID=$g(EQDescdr))) d   
 ......Do OutRow6
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK  
OutRow6
 	set Data=$lb(RegNo,Name,SexDesc,strDOB,strAge,IDCDesc,$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(AppointDate),$g(AppointstTime),$g(strRegDate),$g(strRegTime),$g(getReportDoc),$g(getReportVerifyDoc),PatientStatus,GetPaadmr,oeorditemdr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),$g(ResDesc),Notstr,papatmasmdr)
	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
 	quit
}

ClassMethod ExectueBilledOrder(Info, userid)
{
	/*
	/DHC_INVPRT ----->ROWID

   DHC_BillConINV
   DHC_PatientBill
   DHC_PatBillOrder.PBO_OEORI_DR
	*/
	s IsSuccess=$p(Info,"^",1)  // 结算是否成功
	q:IsSuccess'=0    
	s billno=0 f i=2:1:20 q:billno=""  d             //考虑最多20
	.s billno=$p(Info,"^",i)
	.q:billno="" 
	.s DHCBCIDR=0  f   s DHCBCIDR=$o(^DHCBCI(0,"INV",billno,DHCBCIDR)) q:(DHCBCIDR="")   d
	..s PatBillDR=$p(^DHCBCI(DHCBCIDR),"^",2)   ;DHC_PatientBill
	..s childsub=0  f  s childsub=$o(^DHCPB(PatBillDR,"O",childsub)) q:childsub=""  d
	...s oeorditemdr=$p(^DHCPB(PatBillDR,"O",childsub),"^",4)
	...s OrderRowid=$p(oeorditemdr,"||",1)
	...s itemsub=$p(oeorditemdr,"||",2)
	...s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
  	...s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    ...;w !,strOrderName
	...s ret=##class(web.DHCRisRegisterPatientDo).UpdataOrdInfo(userid,oeorditemdr,"6","RG") 
	
	q 0
}

ClassMethod CalAge(Birth, Today)
{
 ; pass in date of birth in internal format
 ;
 n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
 s Birth=$g(Birth),Today=$g(Today)
 s reage=""
 q:(Birth="")
 s IBirth="",IToday=""
 s IBirth=$zdh(Birth,3)
 s IToday=$zdh(Today,3)
  ;hack of date of birth
 i IBirth>2980000 s IBirth=""
 i IBirth<0 s IBirth=""
 q:'$G(IBirth) ""
  ;
 s XBirth=$ZD(IBirth)
 s XToday=$ZD(IToday)
 s AgeMth=XToday-XBirth
 s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
 s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
 s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
 s AgeYear=CurrYear-BirthYear
 ;
 i AgeDay<0 d
 . s AgeMth=AgeMth-1
 . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
 . q:XToday'=2
 . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
 i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1

 s $P(AgeYr,"|",12)=AgeYear
 i $P(AgeYr,"|",12)=0 d
 .i AgeMth=0 s reage=AgeDay_"天"
 .e  s reage=AgeMth_"月 "
 e  s reage=$p(AgeYr,"|",12)_"岁 "
  ;s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
 q reage
}

Query QueryPadmType() As %Query(ROWSPEC = "TDesc:%String,TCode:%String")
{
}

ClassMethod QueryPadmTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ^CacheTemp(repid,1)=$lb("住院病人","I")
 	Set ^CacheTemp(repid,2)=$lb("门诊病人","O")
 	Set ^CacheTemp(repid,3)=$lb("急诊病人","E")
    Set ^CacheTemp(repid,4)=$lb("体检病人","H")
    Set ^CacheTemp(repid,5)=$lb("其他病人","N")
    Set ^CacheTemp(repid,6)=$lb("所有","")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPadmTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPadmTypeExecute ]
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

ClassMethod QueryPadmTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPadmTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetTypeDesc(type)
{
	I type="I" d
	.s Desc="住院病人"
	else  i type="O" d 
	.s Desc="门诊病人"
	else  i type="E" d 
	.s Desc="急诊病人"
	else  i type="H" d
	.s Desc="体检病人" d
	else
	.s Desc="其他病人"
   q Desc
}

/// order by Index of reg number 
/// 
ClassMethod OrderByIndex(type As %String, LocDr As %String, StdDate As %String, OrderByIndex As %String, regEQID As %String, StatusCode As %String, ReportDoc As %String, VerifyDoc As %String)
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
   
  	s Index=0 f  s Index=$o(^DHCPACRegInfoi("Index",StdDate,LocDr,Index)) q:Index=""  d 
	.s rowid=0  s rowid=$o(^DHCPACRegInfoi("Index",StdDate,LocDr,Index,rowid))
	.s reginfo=^DHCPACRegInfo(rowid) 
	.s PatientStatus="执行"
	.s PatientStatusCode="E"
	.s ResDesc=""
	.s approwid=$p(reginfo,"^",1)
	.i (approwid'="")&(approwid'=$c(0))&(approwid'="undefined")  d 
	..s resrowid=$p(approwid,"||",1)
	..s Schrowid=$p(approwid,"||",2)
	..s scheInfo=^RBAS(resrowid,Schrowid)
	..s AppointDate=$p(scheInfo,"^",1)
	..s AppointDate=$zd(AppointDate,3)
	..s AppointstTime=$p(scheInfo,"^",4)
	..s AppointstTime=$zt(AppointstTime,1)
    ..s CTCPDR=$p(^RB("RES",resrowid),"^",2)
    ..i CTCPDR'="" d
    ...s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
    ..else  d
    ...s EQDR=$p($g(^RB("RES",resrowid)),"^",3)
    ...s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
    .s StudyNo=$p(reginfo,"^",2)
	.s resourcedr=$p(reginfo,"^",4)
	.s regdate=$p(reginfo,"^",8)
	.s strregdate=$zd(regdate,3)
	.s regtime=$p(reginfo,"^",9)
	.s strregtime=$zt(regtime,1)
	.s paadmdr=$p(reginfo,"^",10)
	.s papatmasmdr=$p(^PAADM(paadmdr),"^",1) 
	.; get patient diagnose 
	.s IDCDesc="",Desc=""
    .s mradmdr=$p(^PAADM(paadmdr),"^",61)
    .s diachildsub=0  f  s diachildsub=$o(^MR(mradmdr,"DIA",diachildsub)) q:(diachildsub="")  d     
    ..s IDCCodeDR=$p(^MR(mradmdr,"DIA",diachildsub),"^",1)
    ..i $g(IDCCodeDR)'=""  d
    ...s Desc=$p($g(^MRC("ID",IDCCodeDR)),"^",2)
    ...s IDCDesc=IDCDesc_Desc
	.s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)   
    .s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
    .s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
    .s strAge=""
    .i DOB="" d
 	 ..s strDOB=""
 	 ..s strAge=""
 	.e  d
     ..s strDOB=$ZD(DOB,3)
     ..s strToday=$ZD(+$h,3)
     ..s strAge=##class(web.DHCRisWorkBenchDo).CalAge(strDOB,strToday)
    .s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
    .s SexDesc=""
    .i $g(SexDr)'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    .s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
    .s typedesc=..GetTypeDesc(patienttype)
    .q:(type'="")&(type'=patienttype)
    .s Locdr=$p(^PAADM(paadmdr),"^",4)
    .s LocName=$p(^CTLOC(Locdr),"^",2)   ; 
   	.s oeorddr=$p(reginfo,"^",11)
   	.s ordrowid=$p(oeorddr,"||",1)
   	.s orditemchildsub=$p(oeorddr,"||",2)
    .s arcimid=$p(^OEORD(ordrowid,"I",orditemchildsub,1),"^",2)
    .s billed=$p(^OEORD(ordrowid,"I",orditemchildsub,3),"^",5)
    .s SttDate=$p(^OEORD(ordrowid,"I",orditemchildsub,1),"^",9)  
    .s Notstr=""
	.s countN=^OEORD(ordrowid,"I",orditemchildsub,"DEP",0)
	.f i=1:countN:1 d
	..s Notstr=Notstr_^OEORD(ordrowid,"I",orditemchildsub,"DEP",i)
	.s OEPrice=$p($g(^OEORD(ordrowid,"I",orditemchildsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
    .s instypedr=$p(^PAADM(paadmdr,1),"^",7) 
    .s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
    .;s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimid, SttDate, "", "", "", "")
    .s price=$p(priceinfo,"^",1)
    .s Num=$p(^OEORD(ordrowid,"I",orditemchildsub,1),"^",12)
    .s TotalPrice=price*Num
    .s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    .s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
    .s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
    .s CatDesc=$p(^OEC("ORCAT",OrdCatDr),"^",2)
    .s ServDesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7),"^",6)
    .q:($g(^DHCRisVersion)="BJ_JST")&(ServDesc="")
    .s Date1=$p(^OEORD(ordrowid,"I",orditemchildsub,3),"^",7)
    .s strDate=$zd(Date1,3)
    .s Time1=$p(^OEORD(ordrowid,"I",orditemchildsub,1),"^",10)  ;--------------------
    .s strTime=$zt(Time1,1)
    .s strAccessionNum=$p(^OEORD(ordrowid,"I",orditemchildsub,8),"^",19) 
    .s ssusrdr=$p(^OEORD(ordrowid,"I",orditemchildsub,7),"^",1)
    .s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2)         ; request doctor
    .s ItemStatusCode="",strRegDate="",strRegTime=""
    .s ResStatDR="",resrowid=0
    .s resrowid=$o(^OEORD(ordrowid,"I",orditemchildsub,"RES",resrowid)) ; 在医嘱结果表
    .s getReportDoc="",getReportVerifyDoc=""
    .i resrowid'="" d 
    ..s ResStatDR=$p(^OEORD(ordrowid,"I",orditemchildsub,"RES",resrowid),"^",2)
    ..s ResCode=""
    ..i ResStatDR'="" s ResCode=$p(^OEC("RESST",ResStatDR),"^",1)
    ..i ResCode="E"  d 
    ...s PatientStatus="报告" 
    ...s PatientStatusCode="R"
    ...s CPReportDocDr=$p(^OEORD(ordrowid,"I",orditemchildsub,"RES",resrowid),"^",35)
    ...i $g(CPReportDocDr)'="" d
    ....i $g(^CTPCP(CPReportDocDr,1))'=""  d
    .....i ^DHCRisGetNameSet="ID" d 
    ......s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)
    .....else  d
    ......s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)       
    ..i ResCode="V" d
    ...s PatientStatus="审核"
    ...s PatientStatusCode="A"
    ...s CPVerifyDr=$p(^OEORD(ordrowid,"I",orditemchildsub,"RES",resrowid),"^",36)
    ...i $g(CPVerifyDr)'="" d
    ....i $g(^CTPCP(CPVerifyDr,1))'=""  d
    .....i ^DHCRisGetNameSet="ID" d 
    ......s getReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",3)  
    .....else  d
    ......s getReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",2)
    ......s CPReportDocDr=$p(^OEORD(ordrowid,"I",orditemchildsub,"RES",resrowid),"^",35)
    ......i $g(CPReportDocDr)'="" d
    .......i $g(^CTPCP(CPReportDocDr,1))'=""  d
    ........i ^DHCRisGetNameSet="ID" d 
    .........s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)
    ........else  d
    .........s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)
    .s regEQdr=$p(reginfo,"^",14)
	.i regEQdr'="" s EQDesc=$p($g(^RBC("EQ",regEQdr)),"^",2)
	.i ((regEQID="")!(regEQID=regEQdr))&((StatusCode="")!(StatusCode[$g(PatientStatusCode)))&((ReportDoc="")!(ReportDoc=$g(getReportDoc)))&((VerifyDoc="")!(VerifyDoc=$g(getReportVerifyDoc))) d  
	..Do OutRowI
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutRowI
 	set Data=$lb(RegNo,Name,SexDesc,strDOB,strAge,IDCDesc,$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(AppointDate),$g(AppointstTime),$g(strregdate),$g(strregtime),$g(getReportDoc),$g(getReportVerifyDoc),PatientStatus,paadmdr,oeorddr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),$g(ResDesc),Notstr,papatmasmdr)
	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
 	quit
}

ClassMethod SendPatient(PatientStr As %String) As %String
{
	Set Count=$I(^DHCCalledPatientUl(+$H))
	Set Date=$ZD(+$H,3)
	Set Time=$ZT($P($H,",",2))
	Set ^DHCCalledPatientUl(+$H,Count)=PatientStr_"^"_Date_"^"_Time
	Quit
}

ClassMethod SetConditionInfo(Info, Userid)
{
	s ^DHCRisLookupCondition(Userid)=Info
}

ClassMethod GetConditionInfo(Userid) As %String
{
	 quit $g(^DHCRisLookupCondition(Userid))
}

ClassMethod CancelConditionInfo(Userid)
{
	 k ^DHCRisLookupCondition(Userid)
}

ClassMethod StatusUpdate()
{
}

Query QueryOtherLogLoc(USERDR As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod QueryOtherLogLocExecute(ByRef qHandle As %Binary, USERDR As %String) As %Status
{
	s ^testgp11=USERDR
	Set repid=$I(^CacheTemp)
	s ind=1
	s ochildsub=0 f  s ochildsub=$o(^SSU("SSUSR",USERDR,"OTHLL",ochildsub)) q:(ochildsub="")  d
	.s LocDR=$p(^SSU("SSUSR",USERDR,"OTHLL",ochildsub),"^",1)
	.i LocDR'="" d
	..s LocDesc=$p(^CTLOC(LocDR),"^",2)
	..Do OutOtherLoc 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutOtherLoc
	set Data=$lb(LocDesc,LocDR)
 	Set ^CacheTemp(repid,ind)=Data
 	set Defaultdr=$p(^SSU("SSUSR",USERDR),"^",4)
 	i Defaultdr'=""  s DefaultLocDesc=$p(^CTLOC(Defaultdr),"^",2)
 	Set ^CacheTemp(repid,ind+1)=$lb(DefaultLocDesc,Defaultdr)
 	Set ind=ind+1
	quit
}

ClassMethod QueryOtherLogLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOtherLogLocExecute ]
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

ClassMethod QueryOtherLogLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOtherLogLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetSession(Name As %Library.String, Value As %Library.String)
{
	//if %session.Data(Name)="" s %session.Data(Name)=%session.Get("LOGON.CTLOCID")
	s %session.Data(Name)=Value
}

ClassMethod GetSession(Name As %Library.String)
{
	s val=%session.Get(Name)  
	q val
}

ClassMethod CalDays(Stday As %String, Edday As %String)
{
	s stday=$zdh(Stday,4)
	s edday=$zdh(Edday,4)
	s days=edday-stday
	q days
}

ClassMethod KillDHCRis() As %String
{
   k ^DHCRisLookupCondition
   q 0
}

}
