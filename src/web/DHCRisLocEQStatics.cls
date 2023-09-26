Import SQLUser

Class web.DHCRisLocEQStatics Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 47;

/// d ##class(%ResultSet).RunQuery("web.DHCRisLocEQStatics","QueryLocEQDay","83","62966")
Query QueryLocEQDay(LocID As %String, Date1 As %String) As %Query(ROWSPEC = "Device:%String,Time:%String,InpCounts:%String")
{
}

ClassMethod QueryLocEQDayExecute(ByRef qHandle As %Binary, LocID As %String, Date1 As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	s ind=1
 	k ^tempLocEQSta
 	 
    if LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    i Date1="" s Date1=+$h
    
    s resrowid=0
	f  s resrowid=$o(^RB("RES",0,"CTLOC",LocID,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s EQrowid=$p(ResInfo,"^",3)
	.i EQrowid'=""  d
	..s EQDesc=$p(^RBC("EQ",EQrowid),"^",2)
	..s ^tempEQSta(EQrowid)=ind
	..; 上午<=12:00
 	..s ^tempLocEQSta(ind,1,1)=EQDesc //名称
 	..s ^tempLocEQSta(ind,1,2)="上午"
 	..s ^tempLocEQSta(ind,1,3)=0  //人数
	..;下午>=12:00”
	..s ^tempLocEQSta(ind,2,1)="" //名称
 	..s ^tempLocEQSta(ind,2,2)="下午"  //时间
 	..s ^tempLocEQSta(ind,2,3)=0  //人数
 	..s ind=ind+1
   
    s ^tempLocEQSta=ind-1
    s ind=1
 	Set RowId=0	f  s RowId=$o(^DHCPACRegInfoi("RegDate",Date1,RowId)) q:RowId=""  d
	.s reglocdr=$p(^DHCPACRegInfo(RowId),"^",13)
	.s Flag=$p(^DHCPACRegInfo(RowId),"^",21)  
	.q:Flag'=""                          ;不统计转诊病人，不统计住院再收费病人
	.q:(reglocdr'=LocID)!(reglocdr="")   ;不统计不是本科室登记的病人
	.s regEQDr=$p(^DHCPACRegInfo(RowId),"^",14)
	.i regEQDr'="" d
	..q:'$d(^RBC("EQ",regEQDr))
	..s Index=$g(^tempEQSta(regEQDr))
	..s RegTime=$p(^DHCPACRegInfo(RowId),"^",9)
	..s StudyNo=$p(^DHCPACRegInfo(RowId),"^",2)
	..q:StudyNo="" 
	..s RoomIndex="",TimeFlag=""
	..s RoomIndex=$p($g(^DHCPACRegInfo(RowId)),"^",24)
	..i RoomIndex'="" s TimeFlag=$p(RoomIndex,"_",1)
	..q:(TimeFlag="")
	..i TimeFlag="A"  d
	...s TIndex=1  ; 上午
	..else  d
	...s TIndex=2   ;下午
	..s paadmdr=$p(^DHCPACRegInfo(RowId),"^",10)
	..q:paadmdr="" 
	..s type=$p(^PAADM(paadmdr),"^",2)
	..s OeordDR=$p(^DHCPACRegInfo(RowId),"^",11) 
	..q:((OeordDR="")!(OeordDR=$c(0)))
	..s Ordrowid=$p(OeordDR,"||",1)
	..s OrdItemrowid=$p(OeordDR,"||",2)
	..s price=##class(web.DHCRisCommFunction).GetItemPrice(OeordDR)
	..s Num=$p(^OEORD(Ordrowid,"I",OrdItemrowid,1),"^",12)
	..s perTotalPrice=price*Num
	..i $g(^tempLocEQSta(Index,TIndex,3,StudyNo))="" d
	...s ^tempLocEQSta(Index,TIndex,3,StudyNo)="1"
	...s ^tempLocEQSta(Index,TIndex,3)=^tempLocEQSta(Index,TIndex,3)+1
    d OutputRow1
 		
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
    s (InpCounts,InpInCome,OutpCounts)=0
    for i=1:1:^tempLocEQSta d
    .s pos=i*2
    .set Data=$lb(^tempLocEQSta(i,1,1),^tempLocEQSta(i,1,2),^tempLocEQSta(i,1,3))
  	.Set ^CacheTemp(repid,pos)=Data
  	.set Data=$lb(^tempLocEQSta(i,2,1),^tempLocEQSta(i,2,2),^tempLocEQSta(i,2,3))
    .Set ^CacheTemp(repid,pos+1)=Data
	quit
}

ClassMethod QueryLocEQDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocEQDayExecute ]
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

ClassMethod QueryLocEQDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocEQDayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
