Class web.DHCRisEQDayStatics Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 47;

/// d ##class(%ResultSet).RunQuery("web.DHCRisEQDayStatics","QueryEQDay","780","")
/// 
Query QueryEQDay(LocID As %String, Date1 As %String) As %Query(ROWSPEC = "Device:%String,Time:%String,InpCounts:%String,InpInCome:%String,OutpCounts:%String,OutpInCome:%String,EmCounts:%String,EmInCome:%String,HCounts:%String,HIcomes:%String")
{
}

ClassMethod QueryEQDayExecute(ByRef qHandle As %Binary, LocID As %String, Date1 As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	s ind=1
 	k ^tempEQSta
 	 
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
 	..s ^tempEQSta(ind,1,1)=EQDesc //名称
 	..s ^tempEQSta(ind,1,2)="上午"
 	..s ^tempEQSta(ind,1,3)=0  //住院人数
 	..s ^tempEQSta(ind,1,4)=0  //住院收入
 	..s ^tempEQSta(ind,1,5)=0  //门诊人数
 	..s ^tempEQSta(ind,1,6)=0  //门诊收入
 	..s ^tempEQSta(ind,1,7)=0  //急诊人数
 	..s ^tempEQSta(ind,1,8)=0  //急诊收入
 	..s ^tempEQSta(ind,1,9)=0  //体检人数
 	..s ^tempEQSta(ind,1,10)=0  //体检收入
	..;下午>=12:00”
	..s ^tempEQSta(ind,2,1)="" //名称
 	..s ^tempEQSta(ind,2,2)="下午"  //时间
 	..s ^tempEQSta(ind,2,3)=0  //住院人数
 	..s ^tempEQSta(ind,2,4)=0  //住院收入
 	..s ^tempEQSta(ind,2,5)=0  //门诊人数
 	..s ^tempEQSta(ind,2,6)=0  //门诊收入
 	..s ^tempEQSta(ind,2,7)=0  //急诊人数
 	..s ^tempEQSta(ind,2,8)=0  //急诊收入
 	..s ^tempEQSta(ind,2,9)=0  //体检人数
 	..s ^tempEQSta(ind,2,10)=0  //体检收入
 	..s ind=ind+1
   
    s ^tempEQSta=ind-1
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
	..i RegTime<43200  d
	...s TIndex=1  ; 上午
	..else  d
	...s TIndex=2   ;下午
	..s StudyNo=$p(^DHCPACRegInfo(RowId),"^",2)
	..q:StudyNo="" 
	..s paadmdr=$p(^DHCPACRegInfo(RowId),"^",10)
	..q:paadmdr="" 
	..s type=$p(^PAADM(paadmdr),"^",2)
	..s OeordDR=$p(^DHCPACRegInfo(RowId),"^",11) 
	..q:((OeordDR="")!(OeordDR=$c(0)))
	..s Ordrowid=$p(OeordDR,"||",1)
	..s OrdItemrowid=$p(OeordDR,"||",2)
	..;s SttDate=$p(^OEORD(Ordrowid,"I",OrdItemrowid,3),"^",7)  
	..;s arcimid=$p(^OEORD(Ordrowid,"I",OrdItemrowid,1),"^",2)
	..;s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimid, SttDate, "", "", "", "")
	..;s price=$p(priceinfo,"^",1)
	..s price=##class(web.DHCRisCommFunction).GetItemPrice(OeordDR)
	..s Num=$p(^OEORD(Ordrowid,"I",OrdItemrowid,1),"^",12)
	..s perTotalPrice=price*Num
	..i type="I" d
	...;i $g(^tempEQSta(Index,TIndex,3,StudyNo))="" d
	...s ^tempEQSta(Index,TIndex,3,StudyNo)="1"
	...s ^tempEQSta(Index,TIndex,3)=^tempEQSta(Index,TIndex,3)+1
	...s ^tempEQSta(Index,TIndex,4)=^tempEQSta(Index,TIndex,4)+perTotalPrice
	..else  if type="O"  d
	...;i $g(^tempEQSta(Index,TIndex,5,StudyNo))="" d
	...;s ^tempEQSta(Index,TIndex,5,StudyNo)="1"
	...s ^tempEQSta(Index,TIndex,5)=^tempEQSta(Index,TIndex,5)+1
	...s ^tempEQSta(Index,TIndex,6)=^tempEQSta(Index,TIndex,6)+perTotalPrice
	..else  if type="E"  d
	...;i $g(^tempEQSta(Index,TIndex,7,StudyNo))="" d
	...;s ^tempEQSta(Index,TIndex,7,StudyNo)="1"
	...s ^tempEQSta(Index,TIndex,7)=^tempEQSta(Index,TIndex,7)+1
	...s ^tempEQSta(Index,TIndex,8)=^tempEQSta(Index,TIndex,8)+perTotalPrice
	..else  if type="H"  d
	...;i $g(^tempEQSta(Index,TIndex,9,StudyNo))="" d
	...;s ^tempEQSta(Index,TIndex,9,StudyNo)="1"
	...s ^tempEQSta(Index,TIndex,9)=^tempEQSta(Index,TIndex,9)+1
	...s ^tempEQSta(Index,TIndex,10)=^tempEQSta(Index,TIndex,10)+perTotalPrice
    d OutputRow1
 		
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
    
    ;s ^tempEQSta=0
    s (InpCounts,InpInCome,OutpCounts,OutpInCome,EmCounts,EmInCome,HCounts,HIcomes)=0
    set Data=$lb("设备名称","时间","人数","收入","人数","收入","人数","收入","人数","收入")
  	Set ^CacheTemp(repid,1)=Data

    for i=1:1:^tempEQSta d
    .s pos=i*2
    .set Data=$lb(^tempEQSta(i,1,1),^tempEQSta(i,1,2),^tempEQSta(i,1,3),^tempEQSta(i,1,4),^tempEQSta(i,1,5),^tempEQSta(i,1,6),^tempEQSta(i,1,7),^tempEQSta(i,1,8),^tempEQSta(i,1,9),^tempEQSta(i,1,10))
  	.Set ^CacheTemp(repid,pos)=Data
  	.set Data=$lb(^tempEQSta(i,2,1),^tempEQSta(i,2,2),^tempEQSta(i,2,3),^tempEQSta(i,2,4),^tempEQSta(i,2,5),^tempEQSta(i,2,6),^tempEQSta(i,2,7),^tempEQSta(i,2,8),^tempEQSta(i,2,9),^tempEQSta(i,2,10))
    .Set ^CacheTemp(repid,pos+1)=Data
    .s InpCounts=InpCounts+^tempEQSta(i,1,3)+^tempEQSta(i,2,3)
    .s InpInCome=InpInCome+^tempEQSta(i,1,4)+^tempEQSta(i,2,4)
    .s OutpCounts=OutpCounts+^tempEQSta(i,1,5)+^tempEQSta(i,2,5)
    .s OutpInCome=OutpInCome+^tempEQSta(i,1,6)+^tempEQSta(i,2,6)
    .s EmCounts=EmCounts+^tempEQSta(i,1,7)+^tempEQSta(i,2,7)
    .s EmInCome=EmInCome+^tempEQSta(i,1,8)+^tempEQSta(i,2,8)
    .s HCounts=HCounts+^tempEQSta(i,1,9)+^tempEQSta(i,2,9)
    .s HIcomes=HIcomes+^tempEQSta(i,1,10)+^tempEQSta(i,2,10)
    Set ^CacheTemp(repid,i*2+3)=$lb("合计","",InpCounts_"(项)",InpInCome_"(元)",OutpCounts_"(项)",OutpInCome_"(元)",EmCounts_"项",EmInCome_"(元)",HCounts_"(项)",HIcomes_"(元)")
	quit
}

ClassMethod QueryEQDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEQDayExecute ]
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

ClassMethod QueryEQDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEQDayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
