Import SQLUser

Class web.DHCNurCareSet Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/*
ClassMethod InsertNurCarePlanDetailOld(NCAdmDr As %String, NCNurDiagDr As %String, UseId As %String, NCPIStatus As %String, NCPIPriority As %String, NCPIStartDate As %String, NCPIStartTime As %String, NCPIEndDate As %String, NCPIEndTime As %String)
{

	k PLIST
	Set $ZT="ERROR"
	s ParrefRowID=0
	s ParrefRowID=$o(^DHCNurCare(ParrefRowID))
	i ParrefRowID'=""
	{
		s SubRowID=0
		s SubRowID=$o(^DHCNurCare(ParrefRowID,"P",SubRowID))
		i SubRowID'=""
		{
			TSTART
			s RowID=ParrefRowID_"||"_SubRowID
			k PLIST
			s PLIST(0)=RowID
			s PLIST(3)=NCPIStatus
			s PLIST(4)=NCPIPriority
			s PLIST(5)=$ZDH(NCPIStartDate,4)
			s PLIST(6)=$ZTH(NCPIStartTime)
			s PLIST(7)=$ZDH(NCPIEndDate,4)
			s PLIST(8)=$ZTH(NCPIEndTime)
			s PLIST(13)=UseId
			s PLIST(14)=+$h
			s PLIST(15)=$p($h,",",2)
			&SQL(insert into DHC_NurCarePlanDetail Values :PLIST())
			If SQLCODE TROLLBACK   
			q:SQLCODE "插入护理计划明11细表错误"
			TCOMMIT
			q SQLCODE
		}
		i SubRowID=""
		{
			TSTART
			k PLIST
			s PLIST(0)=ParrefRowID
			&SQL(insert into DHC_NurCarePlan Values :PLIST())
			If SQLCODE TROLLBACK   
			q:SQLCODE "插入护理计划表错误"
			s RowID=$g(%ROWID)
			k PLIST
			s PLIST(0)=RowID
			s PLIST(3)=NCPIStatus
			s PLIST(4)=NCPIPriority
			s PLIST(5)=$ZDH(NCPIStartDate,4)
			s PLIST(6)=$ZTH(NCPIStartTime)
			s PLIST(7)=$ZDH(NCPIEndDate,4)
			s PLIST(8)=$ZTH(NCPIEndTime)
			s PLIST(13)=UseId
			s PLIST(14)=+$h
			s PLIST(15)=$p($h,",",2)
			&SQL(insert into DHC_NurCarePlanDetail Values :PLIST())
			If SQLCODE TROLLBACK   
			q:SQLCODE "插入护理计划明细表错误"
			TCOMMIT
			q SQLCODE
		}
	}
	i ParrefRowID=""
	{
		TSTART
		s PLIST(2)=NCAdmDr
		s PLIST(6)=NCNurDiagDr
		s PLIST(15)=UseId
		s PLIST(16)=+$h
		s PLIST(17)=$p($h,",",2)
		&SQL(insert into DHC_NurCare Values :PLIST())
		If SQLCODE TROLLBACK   
		q:SQLCODE "插入护理表错误"
		k PLIST
		s ParRowID=$g(%ROWID)
		s PLIST(0)=ParRowID
		&SQL(insert into DHC_NurCarePlan Values :PLIST())
		If SQLCODE TROLLBACK   
		q:SQLCODE "插入护理计划表错误"
		s RowID=$g(%ROWID)
		k PLIST
		s PLIST(0)=RowID
		s PLIST(3)=NCPIStatus
		s PLIST(4)=NCPIPriority
		s PLIST(5)=$ZDH(NCPIStartDate,4)
		s PLIST(6)=$ZTH(NCPIStartTime)
		s PLIST(7)=$ZDH(NCPIEndDate,4)
		s PLIST(8)=$ZTH(NCPIEndTime)
		s PLIST(13)=UseId
		s PLIST(14)=+$h
		s PLIST(15)=$p($h,",",2)
		&SQL(insert into DHC_NurCarePlanDetail Values :PLIST())
		If SQLCODE TROLLBACK   
		q:SQLCODE "插入护理计划明细表错误"
		TCOMMIT
		q SQLCODE
	}
	
ERROR	
	Set ErrorMsg=$ZE	          
 	TROLLBACK		       
 	Quit "<ERROR>"_ErrorMsg   
    q SQLCODE
}
*/
ClassMethod InsertNurCarePlanDetail(NCPRowid As %String, Status As %String, ViewCatId As %String, ComOrdId As %String, NCPIStartDate As %String, NCPIStartTime As %String, NCPIEndDate As %String, NCPIEndTime As %String, UseId As %String) As %String
{
	//Rowid,Status,ViewCatId,ComOrdID,Priority,StartDate,StartTime,EndDate,EndTime
	q:NCPRowid=""
	TSTART
	k PLIST
	s PLIST(0)=NCPRowid
	s PLIST(3)=Status
	s PLIST(5)=$ZDH(NCPIStartDate,4)
	s PLIST(6)=$ZTH(NCPIStartTime)
	i NCPIEndDate'="" s NCPIEndDate=$ZDH(NCPIEndDate,4)
	s PLIST(7)=NCPIEndDate
	i NCPIEndTime'="" s NCPIEndTime=$ZTH(NCPIEndTime)
	s PLIST(8)=NCPIEndTime
	s PLIST(9)=ViewCatId
	s PLIST(10)=ComOrdId
	s PLIST(13)=UseId
	s PLIST(14)=+$h
	s PLIST(15)=$p($h,",",2)
	&SQL(insert into DHC_NurCarePlanDetail Values :PLIST())
	If SQLCODE TROLLBACK   
	q:SQLCODE "插入护理计划明细表错误:"_SQLCODE
	TCOMMIT
	q SQLCODE
	
ERROR	
	Set ErrorMsg=$ZE	          
 	TROLLBACK		       
 	Quit "<ERROR>"_ErrorMsg   
    q SQLCODE
}

ClassMethod UpdateNurCarePlanDetail(Rowid As %String, Status As %String, ViewCatId As %String, ComOrdId As %String, NCPIStartDate As %String, NCPIStartTime As %String, NCPIEndDate As %String, NCPIEndTime As %String, UseId As %String) As %String
{
	//Rowid,Status,ViewCatId,ComOrdID,Priority,StartDate,StartTime,EndDate,EndTime
	q:Rowid=""
	Set $ZT="ERROR"
	TSTART
	k PLIST
	s PLIST(3)=Status
	s NCPIStartDate=$ZDH(NCPIStartDate,4)
	s PLIST(5)=NCPIStartDate
	s NCPIStartTime=$ZTH(NCPIStartTime)
	s PLIST(6)=NCPIStartTime
	i NCPIEndDate'="" s NCPIEndDate=$ZDH(NCPIEndDate,4)
	s PLIST(7)=NCPIEndDate
	i NCPIEndTime'="" s NCPIEndTime=$ZTH(NCPIEndTime)
	s PLIST(8)=NCPIEndTime
	s PLIST(9)=ViewCatId
	s PLIST(10)=ComOrdId
	s PLIST(13)=UseId
	s PLIST(14)=+$h
	s PLIST(15)=$p($h,",",2)
	&SQL(update DHC_NurCarePlanDetail Values :PLIST() where NCPI_RowId=:Rowid)
	If SQLCODE TROLLBACK   
	q:SQLCODE "更新护理计划明细表错误:"_SQLCODE
	TCOMMIT
	q SQLCODE
	
ERROR	
	Set ErrorMsg=$ZE	          
 	TROLLBACK		       
 	Quit "<ERROR>"_ErrorMsg   
    q SQLCODE
}

ClassMethod CopyNurCarePlanDetail(Rowid As %String, CTLocId As %String) As %String
{
	q:(Rowid="")!(CTLocId="") 1
	s Flag=1
	i Rowid'="" d
	.s NCRowId=$p(Rowid,"||",1)
	.s NCICDRowId=$p(^DHCNurCare(NCRowId),"^",5)
	.q:NCICDRowId=""
	.i $g(^DHCNurC("ICD",NCICDRowId))'="" d
	..m ^DHCNurC("ICD",NCICDRowId,CTLocId)=^DHCNurCare(NCRowId)
	..s Flag=0
	Q Flag
}

ClassMethod GetNurCarePlanId(Rowid As %String) As %String
{
	q:Rowid=""
	Set $ZT="ERROR"
	s Flag=0
	TSTART
	k PLIST
	s PLIST(0)=Rowid
	&SQL(insert into DHC_NurCarePlan Values :PLIST())
	i SQLCODE TROLLBACK  q "插入护理计划表错误:"_SQLCODE
	TCOMMIT
	q $g(%ROWID)
	
ERROR	
	Set ErrorMsg=$ZE	          
 	TROLLBACK		       
 	Quit "<ERROR>"_ErrorMsg   
    q SQLCODE
}

ClassMethod GetNurCareId(EpisodeID As %String, NCNurDiagDr As %String, UseId As %String) As %String
{
	Set $ZT="ERROR"
	s ncId=$o(^DHCNurCare(0,"Adm",EpisodeID,0))
	q:ncId'="" 0_"^"_ncId_"||"_1
	q:$o(^DHCNurC("ICD",0))="" "未定义护理计划码表!"
	TSTART
	k PLIST
	s PLIST(2)=EpisodeID
	s PLIST(6)=$o(^DHCNurC("ICD",0))
	s PLIST(8)=+$h
	s PLIST(9)=$p($h,",",2)
	s PLIST(15)=UseId
	s PLIST(16)=+$h
	s PLIST(17)=$p($h,",",2)
	&SQL(insert into DHC_NurCare Values :PLIST())
	i SQLCODE TROLLBACK  q "插入护理表错误!"
	s Rowid=$g(%ROWID)
	s Flag=..GetNurCarePlanId(Rowid)
	I Flag<1 TROLLBACK  q Flag
	TCOMMIT
	q 0_"^"_Flag
	
ERROR	
	Set ErrorMsg=$ZE	          
 	TROLLBACK		       
 	Quit "<ERROR>"_ErrorMsg   
    q SQLCODE
}

//查询

Query FindNurCarePlanDetail() As %Query(ROWSPEC = "Rowid:%String,NCPIStatus:%String,NCPIStatusVal:%String,NCPIViewCatDr:%String,NCPIViewCat:%String,NCPICommOrdDr:%String,NCPICommOrd:%String,NCPIStartDate:%String,NCPIStartTime:%String,NCPIEndDate:%String,NCPIEndTime:%String,NCPRowid:%String")
{
}

ClassMethod FindNurCarePlanDetailExecute(ByRef qHandle As %Binary) As %Status
{
   ;d ##class(%ResultSet).RunQuery("web.DHCNurCareSet","FindNurCarePlanDetail")
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s CareRowid=0
	f  s CareRowid=$o(^DHCNurCare(CareRowid))  q:CareRowid=""  d
	.s CarePlanRowid=0
	.f  s CarePlanRowid=$o(^DHCNurCare(CareRowid,"P",CarePlanRowid))  q:CarePlanRowid=""  d
	..s CarePlanDetailRowid=0
	..f  s CarePlanDetailRowid=$o(^DHCNurCare(CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid))  q:CarePlanDetailRowid=""  d
	...s NCPIStatus=$p($g(^DHCNurCare(CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid)),"^",1)
	...q:NCPIStatus'="A"
	...i NCPIStatus="A" s NCPIStatusVal="活动"
	...s NCPIViewCatDr=$p($g(^DHCNurCare(CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid)),"^",7)
	...i NCPIViewCatDr="" d
	....s NCPIViewCat=""
	...e  d
	....s NCPIViewCat=$p($g(^DHCANC("ViewCat",NCPIViewCatDr)),"^",2)
	...s NCPICommOrdDr=$p($g(^DHCNurCare(CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid)),"^",8)
	...i NCPICommOrdDr="" d
	....s NCPICommOrd=""
	...e  d
	....s NCPICommOrd=$p($g(^DHCANC("ComOrd",NCPICommOrdDr)),"^",2)
	...s NCPIStartDate=$ZD($p(^DHCNurCare(CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid),"^",3),4)
	...s NCPIStartTime=$ZT($p(^DHCNurCare(CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid),"^",4),2)
	...s NCPIEndDate=$p($g(^DHCNurCare(CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid)),"^",5)
	...i NCPIEndDate'="" s NCPIEndDate=$ZD(NCPIEndDate,4)
	...s NCPIEndTime=$p($g(^DHCNurCare(CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid)),"^",6)
	...i NCPIEndTime'="" s NCPIEndTime=$ZT(NCPIEndTime,2)
	...s Rowid=CareRowid_"||"_CarePlanRowid_"||"_CarePlanDetailRowid
	...s NCPRowid=CareRowid_"||"_CarePlanRowid
	...d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Rowid,NCPIStatus,NCPIStatusVal,NCPIViewCatDr,NCPIViewCat,NCPICommOrdDr,NCPICommOrd,NCPIStartDate,NCPIStartTime,NCPIEndDate,NCPIEndTime,NCPRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindNurCarePlanDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurCarePlanDetailExecute ]
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

ClassMethod FindNurCarePlanDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurCarePlanDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//取得显示分类和常用医嘱

Query GetViewComm(CTLoc As %String) As %Query(ROWSPEC = "rowid:%String,code:%String")
{
}

ClassMethod GetViewCommExecute(ByRef qHandle As %Binary, CTLoc As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=2
 	S code=""
    s ^CacheTemp(repid,1)=$lb("$$$","")
    s NCICDrowid=0
    f  s NCICDrowid=$o(^DHCNurC("ICD",NCICDrowid))  q:NCICDrowid=""  d
 	.s CareRowid=0
 	.s NCICDdesc=$p($g(^DHCNurC("ICD",1)),"^",2)
	.f  s CareRowid=$o(^DHCNurC("ICD",NCICDrowid,CareRowid))  q:CareRowid=""  d
	..q:(CTLoc'="")&&(CTLoc'=CareRowid)
	..s CarePlanRowid=0
	..f  s CarePlanRowid=$o(^DHCNurC("ICD",NCICDrowid,CareRowid,"P",CarePlanRowid))  q:CarePlanRowid=""  d
	...s CarePlanDetailRowid=0
	...f  s CarePlanDetailRowid=$o(^DHCNurC("ICD",NCICDrowid,CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid))  q:CarePlanDetailRowid=""  d
	....s NCPIViewCatDr=$p($g(^DHCNurC("ICD",NCICDrowid,CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid)),"^",7)
	....i NCPIViewCatDr="" d
	.....s NCPIViewCat=""
	....e  d
	.....s NCPIViewCat=$p($g(^DHCANC("ViewCat",NCPIViewCatDr)),"^",2)
	....s NCPICommOrdDr=$p($g(^DHCNurC("ICD",NCICDrowid,CareRowid,"P",CarePlanRowid,"D",CarePlanDetailRowid)),"^",8)
	....i NCPICommOrdDr="" d
	.....s NCPICommOrd=""
	....e  d
	.....s NCPICommOrd=$p($g(^DHCANC("ComOrd",NCPICommOrdDr)),"^",2)
 	....s Data=$lb(NCPIViewCatDr_"$"_NCPIViewCat_"$"_NCPICommOrdDr_"$"_NCPICommOrd,NCICDrowid_"-"_NCICDrowid_"-"_NCICDdesc_"-"_NCPIViewCat_"-"_NCPICommOrd)
 	....Set ^CacheTemp(repid,ind)=Data
    ....Set ind=ind+1
  
    Set qHandle=$lb(0,repid,0)
    
	Quit $$$OK
}

ClassMethod GetViewCommClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetViewCommExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetViewCommFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetViewCommExecute ]
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

//放大镜

Query FindViewCat() As %Query(ROWSPEC = "Desc:%String,Rowid:%String")
{
}

ClassMethod FindViewCatExecute(ByRef qHandle As %Binary) As %Status
{
 
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Rowid=0
	f  s Rowid=$o(^DHCANC("ViewCat",Rowid))  q:Rowid=""  d
    .s icuApply=$p($g(^DHCANC("ViewCat",Rowid)),"^",8)
    .q:(icuApply="N")
    .s superViewCatId=$p($g(^DHCANC("ViewCat",Rowid)),"^",10)
    .q:(superViewCatId'=60)
    .s Desc=$p($g(^DHCANC("ViewCat",Rowid)),"^",2)
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(Desc,Rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindViewCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindViewCatExecute ]
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

ClassMethod FindViewCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindViewCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindComOrd(viewCatId) As %Query(ROWSPEC = "Desc:%String,Rowid:%String")
{
}

ClassMethod FindComOrdExecute(ByRef qHandle As %Binary, viewCatId) As %Status
{
 
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Rowid=0
	f  s Rowid=$o(^DHCANC("ComOrd",Rowid))  q:Rowid=""  d
    .s icuApply=$p($g(^DHCANC("ComOrd",Rowid)),"^",10)
    .q:(icuApply="N")
    .s viewCatDr=$p($g(^DHCANC("ComOrd",Rowid)),"^",5)
    .q:(viewCatId'="")&(viewCatId'=viewCatDr)
    .s Desc=$p($g(^DHCANC("ComOrd",Rowid)),"^",2)
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(Desc,Rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindComOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindComOrdExecute ]
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

ClassMethod FindComOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindViewCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindStatus() As %Query(ROWSPEC = "StatusCode:%String,StatusDese:%String")
{
}

ClassMethod FindStatusExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s StatusCode="A",StatusDese="活动"
	d OutputRow22
	s StatusCode="C",StatusDese="取消"
	d OutputRow22
	s StatusCode="F",StatusDese="结束"
	d OutputRow22
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow22
	set Data=$lb(StatusCode,StatusDese)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStatusExecute ]
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

ClassMethod FindStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindRowid() As %Query(ROWSPEC = "Rowid:%String,Adm:%String")
{
}

ClassMethod FindRowidExecute(ByRef qHandle As %Binary) As %Status
{
   ;d ##class(%ResultSet).RunQuery("web.DHCNurCareSet","FindNurCarePlanDetail")
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s CareRowid=0
	f  s CareRowid=$o(^DHCNurCare(CareRowid))  q:CareRowid=""  d
	.s Adm=$p(^DHCNurCare(CareRowid),"^",1)
	.s CarePlanRowid=0
	.f  s CarePlanRowid=$o(^DHCNurCare(CareRowid,"P",CarePlanRowid))  q:CarePlanRowid=""  d
	..s Adm=Adm
	..s Rowid=CareRowid_"||"_CarePlanRowid
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Rowid,Adm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindRowidFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRowidExecute ]
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

ClassMethod FindRowidClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRowidExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurCarePlanDetailList(parref As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT * FROM DHC_NurCarePlanDetail Where NCPI_Parref=:parref
}

}
