Import SQLUser

Class web.DHCRisOtherPatientStatics Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 49;

//d ##class(%ResultSet).RunQuery("web.DHCRisOtherPatientStatics","OtherStatics",780,"","","")

//                                     //////////////////////                           

/// /////////////////////
Query OtherStatics(LocID As %String, StartDate As %String, EndDate As %String, flag As %String) As %Query(ROWSPEC = "TranUnit:%String,GetRegNo:%String,GetName:%String,GetSexDesc:%String,GetstrAge:%String,StudyNo:%String,GetstrOrderName:%String,GetTotalPrice:%String,GetstrDate:%String,strregdate:%String,GetType:%String")
{
}

ClassMethod OtherStaticsExecute(ByRef qHandle As %Binary, LocID As %String, StartDate As %String, EndDate As %String, flag As %String) As %Status
{
	set repid=$I(^CacheTemp)
	s ind=1
	
	s Num1=0,PNums=0,TotalF=0,MNum=0
    if LocID="" s LocID=%session.Get("LOGON.CTLOCID")
   
    i StartDate="" s StartDate=+$h
    i EndDate="" s EndDate=+$h
      
    s ^tmpppflag=flag
   	f regdate=StartDate:1:EndDate d 
	.Set RowId=0	f  s RowId=$o(^DHCPACRegInfoi("RegDate",regdate,RowId)) q:RowId=""  d
	..s reglocdr=$p(^DHCPACRegInfo(RowId),"^",13)
	..q:reglocdr'=LocID 
 	..s note1=$p(^DHCPACRegInfo(RowId),"^",21)
	..q:(flag'="")&(note1'[flag)
	..s strregdate=$zd(regdate,3)
	..s GetType=""
	..i $e(note1,1,2)="O:" d 
	...s note1=$p(note1,":",2)
	...s GetType="转诊病人"
	..else  if note1="laterFee" d
	...s GetType="住院再收费"
	...s note1=""
    ..s StudyNo=$p(^DHCPACRegInfo(RowId),"^",2)
    ..s OeordDR=$p(^DHCPACRegInfo(RowId),"^",11)
    ..s GetstrDate=""
    ..s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0))  d
    ..i Rptrowid'="" d
  	...s ReportDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
	...s GetstrDate=$zd(ReportDate,3)
	...s ReportTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
	...s GetstrTime=$zt(ReportTime,2)
	..s Ordrowid=$p(OeordDR,"||",1)
	..s OrdItemrowid=$p(OeordDR,"||",2)
	..s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(Ordrowid,OrdItemrowid)
    ..s GetstrOrderName=$p(ordInfo,"^",1)
    ..s Getprice=$p(ordInfo,"^",10)
    ..s GetNum=$p(ordInfo,"^",11)
    ..s GetTotalPrice=$p(ordInfo,"^",12)
 	..s paadmdr=$p(^DHCPACRegInfo(RowId),"^",10)
	..s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    ..s GetRegNo=$p(PatInfo,"^",1)
    ..s GetName=$p(PatInfo,"^",2)
    ..s GetstrDOB=$p(PatInfo,"^",3)
    ..s GetstrAge=$p(PatInfo,"^",4)
 	..s GetSexDesc=$p(PatInfo,"^",5)
    ..;s Getpatienttype=$p(PatInfo,"^",6)
    ..s Gettypedesc=$p(PatInfo,"^",7)
    ..s GetLocName=$p(PatInfo,"^",8)
    ..s GetWardName=$p(PatInfo,"^",10)
    ..s GetBedNo=$p(PatInfo,"^",11)
    ..s Num1=Num1+1
    ..s TotalF=TotalF+GetTotalPrice
 	..d OutputRow2
 		
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
    set Data=$lb(note1,GetRegNo,GetName,GetSexDesc,GetstrAge,StudyNo,GetstrOrderName,GetTotalPrice,GetstrDate,strregdate,GetType)
 	set ^CacheTemp(repid,ind)=Data
   	Set ^CacheTemp(repid,ind+1)=$lb("合计","","","","","","",TotalF,"","","")
  	Set ind=ind+1
	quit
}

ClassMethod OtherStaticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OtherStaticsExecute ]
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

ClassMethod OtherStaticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OtherStaticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
