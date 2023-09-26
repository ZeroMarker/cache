Class web.DHCENS.STBLL.HERP.Method.FindJsHis Extends (%RegisteredObject, %XML.Adaptor)
{

/// 门诊结算日报表
/// d ##class(%ResultSet).RunQuery("web.DHCENS.Method.Query.FindJsHis","FindJsHis","2016-07-01","2016-08-01")
Query FindJsHis(stdate, enddate) As %Query(ROWSPEC = "Tjsdate:%String,TPreDeposit:%String,TPayMode:%String,paytypename:%String,TPayAmt:%String,TPrtUserRowid:%String,TPrtUserName:%String,PatType:%String") [ SqlProc ]
{
}

ClassMethod FindJsHisExecute(ByRef qHandle As %Binary, stdate, enddate) As %Status
{
   
	Set repid=$I(^CacheTemp)
   
    s ind=1
    s num=1
    
    s:(stdate'="")&&(stdate'=$c(0)) stdate=$zdh(stdate,3)
    s:(enddate'="")&&(enddate'=$c(0)) enddate=$zdh(enddate,3)
    s:(stdate="")||(stdate=$c(0)) stdate=+$h-2
	s:(enddate="")||(enddate=$c(0)) enddate=+$h-2
	f jsdate1=stdate:1:enddate d
	  .s jkdr=""
	  .f  s jkdr=$o(^DHCOPInsFootI(0,"Date",jsdate1,jkdr)) q:jkdr=""  d
	  ..s RowId=""   f  s RowId=$o(^DHCINVPRT(0,"Report",jkdr,RowId)) q:RowId=""  d
	  ...s PreDeposit=0
	  ...s prtUsr=$p(^DHCINVPRT(RowId),"^",21)
	  ...s prtUsName=$p(^SSU("SSUSR",prtUsr),"^",2)
	  ...s PrtAmt=$p(^DHCINVPRT(RowId),"^",1)
	  ...s PatType=$p(^DHCINVPRT(RowId),"^",9)
	  ...s sub="0"  f  s sub=$o(^DHCINVPRT(RowId,"P",sub))  q:sub=""  d
	  ....s mode=$p(^DHCINVPRT(RowId,"P",sub),"^",1)
	  ....s paytypename=$p(^CT("CTPM",mode),"^",2)
	  ....q:((mode'="3")&&(mode'=15))
	  ....s PayAmt=$p(^DHCINVPRT(RowId,"P",sub),"^",2)	   
	  ...Do OutputRow4    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow4
	s jsdate=$zd(jsdate1,3)
	set Data=$lb(jsdate,PreDeposit,mode,paytypename,PrtAmt,prtUsr,prtUsName,PatType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindJsHisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindJsHisExecute ]
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

ClassMethod FindJsHisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindJsHisExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
