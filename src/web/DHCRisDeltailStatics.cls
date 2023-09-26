Import SQLUser

Class web.DHCRisDeltailStatics Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCRisDeltailStatics","LocDeltailStatics","YXYXKCS-医学影像科超声","62854","63255","","ris","")
Query LocDeltailStatics(FLocation As %String, stdate As %String, eddate As %String, Techician As %String, ReportDoc As %String, CheckDoc As %String) As %Query(ROWSPEC = "regDate:%String,patname:%String,SexDesc:%String,Age:%String,typedesc:%String,OrderName:%String,Techician:%String,ReportDoc:%String,VeriedDoc:%String,perIcome:%String,OeordDR:%String")
{
}

ClassMethod LocDeltailStaticsExecute(ByRef qHandle As %Binary, FLocation As %String, stdate As %String, eddate As %String, Techician As %String, ReportDoc As %String, CheckDoc As %String) As %Status
{
	s ^testDeltail=FLocation_"^"_stdate_"^"_eddate_"^"_Techician_"^"_ReportDoc_"^"_CheckDoc
	Set repid=$I(^CacheTemp)
	s ind=1
	
    k ^DelitalPrintData
    i $g(^DHCRisGetNameSet)="" s ^DHCRisGetNameSet="ID"
   
 	if (FLocation'="") 
 	{
	s FLocation=$zCVT(FLocation,"I","URL")
 	S locID=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(FLocation),""))
 	f regdate=stdate:1:eddate d 
	.Set RowId=0	f  s RowId=$o(^DHCPACRegInfoi("RegDate",regdate,RowId)) q:RowId=""  d
	..s getVeriedDoc="",getReportDoc="",patienttype="",DOB="",strAge="",SexDr=""
	..s SexDesc=""
	..s reglocdr=$p($g(^DHCPACRegInfo(RowId)),"^",13)
	..i reglocdr=locID d 
	...s OeordDR=$p($g(^DHCPACRegInfo(RowId)),"^",11)
	...q:OeordDR=""
	...s OrderRowid="",itemsub="",strOrderName="",arcimid="",Num=0,price=0,perIcome=""
	...s OrderRowid=$p(OeordDR,"||",1)
	...s itemsub=$p(OeordDR,"||",2)
	...s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	...s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	...s Num=""
	...s Num=$p($g(^OEORD(OrderRowid,"I",itemsub,9)),"^",4)
	...i Num="" s Num=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",12)
	...s price=##class(web.DHCRisCommFunction).GetItemPrice(OeordDR)
	...s perIcome=Num*price
	...s Paadmdr=$p($g(^DHCPACRegInfo(RowId)),"^",10)
	...s patmasdr=$p($g(^PAADM($g(Paadmdr))),"^",1)
	...s patname=$p($g(^PAPER(patmasdr,"ALL")),"^",1)
	...s DOB=$p($g(^PAPER(patmasdr,"ALL")),"^",6)
    ...i DOB="" d
 	....s strDOB=""
 	....s strAge=""
 	...e  d
    ....s strDOB=$ZD(DOB,3)
    ....s strToday=$ZD(+$h,3)
    ....s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
    ....s year=$p(strDOB,"-",1)
    ....s Month=$p(strDOB,"-",2)
    ....s day=$p(strDOB,"-",3)
    ....s strDOB=day_"/"_Month_"/"_year
    ...s SexDr=$p($g(^PAPER(patmasdr,"ALL")),"^",7)
    ...i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    ...s patienttype=$p(^PAADM(Paadmdr),"^",2) ;病人类型
    ...s typedesc=##class(web.DHCRisCommFunction).GetTypeDesc(patienttype)
    ...s MainDr=$p(^DHCPACRegInfo(RowId),"^",5)
    ...i MainDr'="" d
    ....i ^DHCRisGetNameSet="ID" d
	.....s getTechician=$p($g(^CTPCP(MainDr,1)),"^",3)
	....else  d
    .....s getTechician=$p($g(^CTPCP(MainDr,1)),"^",2) ; 技师
    ...s getTechician=$g(getTechician)
    ..s StudyNo=$p($g(^DHCPACRegInfo(RowId)),"^",2)  
    ..if StudyNo'="" d
    ...s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
    ...i Rptrowid'="" d
    ....s rptssdr=$p(^DHCRBStudy("Report",Rptrowid),"^",8) ;报告医生
    ....i rptssdr'="" d
    .....s ReportCPDr=$p(^SSU("SSUSR",rptssdr),"^",14) 
    .....i ReportCPDr'="" d
    ......i ^DHCRisGetNameSet="ID" d
	.......s getReportDoc=$p(^CTPCP(ReportCPDr,1),"^",3)
    ......else  d
	.......s getReportDoc=$p($g(^CTPCP(ReportCPDr,1)),"^",2)
    ....s rptssdr=$p(^DHCRBStudy("Report",Rptrowid),"^",11) ;审核医生
    ....i rptssdr'="" d
    .....s ReportCPDr=$p(^SSU("SSUSR",rptssdr),"^",14) 
    .....i ReportCPDr'="" d
    ......i ^DHCRisGetNameSet="ID" d
	.......s getVeriedDoc=$p(^CTPCP(ReportCPDr,1),"^",3)
    ......else  d
	.......s getVeriedDoc=$p($g(^CTPCP(ReportCPDr,1)),"^",2)
    ...q:($g(getTechician)'=Techician)&&(Techician'="")
    ...q:(ReportDoc'=$g(getReportDoc))&&(ReportDoc'="")
	...q:(CheckDoc'="")&&(CheckDoc'=$g(getVeriedDoc))
	...q:(ReportDoc="")&&(CheckDoc="")&&(Techician="") 
	...d OutputRow1
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
    i $g(regdate)'="" d
     .s Data=$lb($zd(regdate,3),$g(patname),$g(SexDesc),$g(strAge),$g(typedesc),$g(strOrderName),$g(getTechician),$g(getReportDoc),$g(getVeriedDoc),$g(perIcome),$g(OeordDR))
     .Set ^CacheTemp(repid,ind)=Data
     .s ^DelitalPrintData(ind)=$zd(regdate,3)_"^"_$g(patname)_"^"_$g(SexDesc)_"^"_$g(strAge)_"^"_$g(typedesc)_"^"_$g(strOrderName)_"^"_$g(getTechician)_"^"_$g(getReportDoc)_"^"_$g(getVeriedDoc)_"^"_$g(perIcome)_"^"_$g(OeordDR)
     .s ^DelitalPrintData=ind
   	 .Set ind=ind+1
   quit
}

ClassMethod LocDeltailStaticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocDeltailStaticsExecute ]
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

ClassMethod GetNum() As %Integer
{
	q ^DelitalPrintData
}

ClassMethod GetData(i) As %String
{
	q ^DelitalPrintData(i)
}

ClassMethod LocDeltailStaticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocDeltailStaticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
