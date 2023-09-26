Import SQLUser

Class web.DHCRisReportStatics Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 83;

/// ///////////////////// 
/// ///////////////////// //                                    //////////////////////
Query ReportStatics(LocID As %String, StDate As %String, EndDate As %String, Diagnose As %String, mascluline As %String, EQRowid As %String) As %Query(ROWSPEC = "GetRegNo:%String,GetName:%String,GetSexDesc:%String,GetstrAge:%String,GetLocName:%String,GetWardName:%String,GetBedNo:%String,GetNum:%String,Getprice:%String,StudyNo:%String,GetstrOrderName:%String,GetstrDate:%String,GetstrTime:%String,GetTotalPrice:%String,Gettypedesc:%String,ResultEx:%String,ResultDescEx:%String,GetRptDocName:%String,GetVerifyDocName:%String,ViewReport:%String,ReportStatus:%String,EQDesc:%String")
{
}

ClassMethod ReportStaticsExecute(ByRef qHandle As %Binary, LocID As %String, StDate As %String, EndDate As %String, Diagnose As %String, mascluline As %String, EQRowid As %String) As %Status
{
	set repid=$I(^CacheTemp)
	s ind=1
	k ^DHCRisTempStudyNo
	s Num1=0,PNums=0,TotalF=0,MNum=0
    if LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    i StDate="" s StDate=+$h
    i EndDate="" s EndDate=+$h
    i mascluline="阳性" s mascluline="Y"
    i mascluline="阴性" s mascluline="N"
    
    k ^DHCRISTEMPortInfo(LocID,$J,"Ward")
    k ^DHCRISTEMPortInfo(LocID,"Ward")
    
    s ^DHCRISTEMPortInfo(LocID,"Ward")=$J 
    s i=0
    
   	f regdate=StDate:1:EndDate d 
	.Set RowId=0	f  s RowId=$o(^DHCPACRegInfoi("RegDate",regdate,RowId)) q:RowId=""  d
	..s reglocdr=$p(^DHCPACRegInfo(RowId),"^",13)
	..q:reglocdr'=LocID 
    ..s StudyNo=$p(^DHCPACRegInfo(RowId),"^",2)
    ..q:(StudyNo="")
	..q:$g(^DHCRisTempStudyNo(StudyNo))'=""
	..s ^DHCRisTempStudyNo(StudyNo)=StudyNo
	..s OeordDR=$p(^DHCPACRegInfo(RowId),"^",11)
    ..s RegEQDr=$p(^DHCPACRegInfo(RowId),"^",14)
    ..q:(EQRowid'="")&(RegEQDr'=EQRowid) 
    ..s EQDesc=""
    ..i RegEQDr'="" s EQDesc=$p(^RBC("EQ",RegEQDr),"^",2)
    ..s Rptrowid=0  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,Rptrowid)) q:Rptrowid=""  d
    ...s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
	...s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	...s ReportStatus=""
    ...i GetRptStatusDR'="" d
	....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
	....s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	...s Result=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
	...s ResultEx=""
	...s ReportDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
	...s GetstrDate=$zd(ReportDate,3)
	...s ReportTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
	...s GetstrTime=$zt(ReportTime,2)
	...s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
	...s GetRptDocName="",GetVerifyDocName=""
    ...i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
    ...s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
    ...i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
	...q:(mascluline'="")&&(mascluline'=Result)
	...s ResultDescEx=$g(^DHCRBStudy("Report",Rptrowid,"ResultDescEx"))
	...s ResultDescEx=$p(ResultDescEx,"_$c_",1)
	...q:(Diagnose'="")&&'(ResultDescEx[Diagnose)   
	...i Result="Y" d
	....s MNum=MNum+1
	....s ResultEx="阳性"
	...s Ordrowid=$p(OeordDR,"||",1)
	...s OrdItemrowid=$p(OeordDR,"||",2)
	...s GetstrOrderName=""
	...s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(Ordrowid,OrdItemrowid)
    ...s GetstrOrderName=$p(ordInfo,"^",1)
    ...;s GetstrDate=$p(ordInfo,"^",2)
    ...;s GetstrTime=$p(ordInfo,"^",3)
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
    ...s Num1=Num1+1
    ...s TotalF=TotalF+GetTotalPrice
	...d OutputRow2
 		
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
    s i=i+1
    s ^DHCRISTEMPortInfo(LocID,$J,"Ward",i)=$g(LocID)_"^"_$J_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(ResultEx)_"^"_$g(ResultDescEx)_"^"_$g(ViewReport)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(Gettypedesc)_"^"_$g(GetstrOrderName)_"^"_$g(StudyNo)_"^"_$g(ReportStatus)_"^"_$g(EQDesc)_"^"_$g(GetWardName)_"^"_$g(GetLocName)
    set yyl=$j(MNum/Num1,3,2)
  	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetLocName,GetWardName,GetBedNo,GetNum,Getprice,StudyNo,GetstrOrderName,GetstrDate,GetstrTime,GetTotalPrice,Gettypedesc,ResultEx,ResultDescEx,GetRptDocName,GetVerifyDocName,"Browse",ReportStatus,EQDesc)
 	set ^CacheTemp(repid,ind)=Data
   	Set ^CacheTemp(repid,ind+1)=$lb("合计","","","","","","",Num1,"","","","","","","",yyl,"","","","","","")
  	Set ind=ind+1
	quit
}

ClassMethod ReportStaticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReportStaticsExecute ]
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

ClassMethod ReportStaticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReportStaticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/* 查询：QueryPadmType
/  功能：查询病人类型
   传入参数：空
   返回结果:病人类型，ROWID 
*/
Query QueryResult() As %Query(ROWSPEC = "TDesc:%String")
{
}

ClassMethod QueryResultExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ^CacheTemp(repid,1)=$lb("阳性")
 	Set ^CacheTemp(repid,2)=$lb("阴性")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResultExecute ]
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

ClassMethod QueryResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPath()
{
	&sql(select pathtoreports into :reportPath from websys.configuration)
	q reportPath
}

/// do ##class(web.DHCRisReportStatics).GetDataNum("83")
ClassMethod GetDataNum(LocID As %String) As %String
{
	s ^tt="LocID="_LocID
	q:(LocID="") "0"
	s Index="",Num=""
	
	s Index=$g(^DHCRISTEMPortInfo(LocID,"Ward"))
	i (Index'="")
	{
	  s Num=$o(^DHCRISTEMPortInfo(LocID,Index,"Ward",Num),-1)
	}
	
	q Num
}

/// w ##class(web.DHCRisReportStatics).GetData("83","1")
ClassMethod GetData(LocID As %String, j As %String) As %String
{
	q:(LocID="") ""
	s Index="",Info=""
	s Index=$g(^DHCRISTEMPortInfo(LocID,"Ward"))
	i (Index'="")
	{
		s Info=^DHCRISTEMPortInfo(LocID,Index,"Ward",j)
	}
	
	q Info
}

}
