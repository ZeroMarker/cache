Class web.DHCRisEQStatics Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 58;

// d ##class(%ResultSet).RunQuery("web.DHCRisEQStatics","QueryEQInCome",^DHCRISTEMP(1),^DHCRISTEMP(2),^DHCRISTEMP(3))

Query QueryEQInCome(LocID As %String, Stdate As %String, EndDate As %String) As %Query(ROWSPEC = "TDesc:%String,TNum:%String,TInCome:%String,TPeopleNums:%String")
{
}

ClassMethod QueryEQInComeExecute(ByRef qHandle As %Binary, LocID As %String, Stdate As %String, EndDate As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	s ind=1
	s ^DHCRISTEMP(1)=LocID
	s ^DHCRISTEMP(2)=Stdate
	s ^DHCRISTEMP(3)=EndDate
 	k ^tempEQSta
 	;i LocID="" S qHandle=$lb(0,repid,0)   
 	;Quit LocID="" $$$OK
    if LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    i Stdate="" s Stdate=+$h
    i EndDate="" s EndDate=+$h
  
   	
 	s perTotalPrice=0
 	s ^Inp=LocID_"^"_Stdate_"^"_EndDate
 	
	s resrowid=0
	f  s resrowid=$o(^RB("RES",0,"CTLOC",LocID,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s EQrowid=$p(ResInfo,"^",3)
	.i EQrowid'=""  d
	..s EQDesc=$p(^RBC("EQ",EQrowid),"^",2)
	..s ^tempEQSta(EQrowid)=ind
 	..s ^tempEQSta(ind,1)=EQDesc //名称
 	..s ^tempEQSta(ind,2)=0  //数量
 	..s ^tempEQSta(ind,3)=0  //收入
 	..s ^tempEQSta(ind,4)=0  //人数
 	..s ind=ind+1
    s ^tempEQSta=ind-1
    
    s ind=1
   	f regdate=Stdate:1:EndDate d 
	.Set RowId=0	f  s RowId=$o(^DHCPACRegInfoi("RegDate",regdate,RowId)) q:RowId=""  d
	..s reglocdr=$p(^DHCPACRegInfo(RowId),"^",13)
	..i reglocdr=LocID d
	...s regEQDr=$p(^DHCPACRegInfo(RowId),"^",14)
	...i regEQDr'="" d
	....q:'$d(^RBC("EQ",regEQDr))
	....s Index=$g(^tempEQSta(regEQDr))
	....q:Index="" 
	....s ^tempEQSta(Index,2)=^tempEQSta(Index,2)+1
	....s OeordDR=$p(^DHCPACRegInfo(RowId),"^",11) 
	....q:((OeordDR="")!(OeordDR=$c(0)))
	....s Ordrowid=$p(OeordDR,"||",1)
	....s OrdItemrowid=$p(OeordDR,"||",2)
	....s SttDate=$p(^OEORD(Ordrowid,"I",OrdItemrowid,3),"^",7)  
	....s arcimid=$p(^OEORD(Ordrowid,"I",OrdItemrowid,1),"^",2)
	....s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimid, SttDate, "", "", "", "")
	....s price=$p(priceinfo,"^",1)
	....s Num=$p(^OEORD(Ordrowid,"I",OrdItemrowid,1),"^",12)
	....s perTotalPrice=price*Num
	....s ^tempEQSta(Index,3)=^tempEQSta(Index,3)+perTotalPrice
	....s paadmdr=$p(^DHCPACRegInfo(RowId),"^",10)
	....s StudyNo=$p(^DHCPACRegInfo(RowId),"^",2)
	....q:StudyNo="" 
	....i $g(^tempEQSta(Index,StudyNo))="" d 
	.....s ^tempEQSta(Index,StudyNo)=1
	.....s ^tempEQSta(Index,4)=^tempEQSta(Index,4)+1
	....d OutputRow1
 		
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
    s Num=0,InCome=0,PNum=0
    for i=1:1:^tempEQSta d
  	.set Data=$lb(^tempEQSta(i,1),^tempEQSta(i,2),^tempEQSta(i,3),^tempEQSta(i,4))
  	.Set ^CacheTemp(repid,i)=Data
  	.Set Num=Num+^tempEQSta(i,2)
  	.Set InCome=InCome+^tempEQSta(i,3)
  	.Set PNum=PNum+^tempEQSta(i,4)
  	.Set ^CacheTemp(repid,i+1)=$lb("合计",Num,InCome,PNum)
  	.Set ind=ind+1
	quit
}

ClassMethod QueryEQInComeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEQInComeExecute ]
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

ClassMethod QueryEQInComeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEQInComeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
