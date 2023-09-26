Class web.DHCENS.STBLL.HERP.Method.FindJKHis Extends (%RegisteredObject, %XML.Adaptor)
{

/// 住院结算日报表 
/// d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.HERP.Method.FindJKHis","FindJKHis","2016-07-01","2016-08-01")
Query FindJKHis(stdate, enddate) As %Query(ROWSPEC = "Tjsdate:%String,TPreDeposit:%String,TPayMode:%String,depositPaydesc:%String,TPayAmt:%String,TPrtUserRowid:%String,TPrtUserName:%String,PatType:%String,PatientName:%String") [ SqlProc ]
{
}

ClassMethod FindJKHisExecute(ByRef qHandle As %Binary, stdate, enddate) As %Status
{
  
	Set repid=$I(^CacheTemp)
   
    s ind=1
    s num=1
    s count=0
    s:(stdate'="")&&(stdate'=$c(0)) stdate=$zdh(stdate,3)
    s:(enddate'="")&&(enddate'=$c(0)) enddate=$zdh(enddate,3)
    s:(stdate="")||(stdate=$c(0)) stdate=+$h-2
	s:(enddate="")||(enddate=$c(0)) enddate=+$h-2
	
	f jsdate1=stdate:1:enddate d
	  .s jkdr=""
	  .f  s jkdr=$o(^DHCJFUSERJK(0,"date",jsdate1,jkdr)) q:jkdr=""  d
	  ..s RowId=""   f  s RowId=$o(^DHCINVPRTZY(0,"JK",jkdr,RowId)) q:RowId=""  d
	  ...s patfee=$p(^DHCINVPRTZY(RowId),"^",6) ;病人费用
	  ...;q:prtFlag'="N"  ;只考虑正常发票
	  ...s patdeposit=0
	  ...s patdeposit=+$p(^DHCINVPRTZY(RowId),"^",22)  ;冲销预交金	  
	  ...s prtUsr=$p(^DHCINVPRTZY(RowId),"^",7)
	  ...s PatType=$p(^DHCINVPRTZY(RowId),"^",9)
	  ...s prtUsName=$p(^SSU("SSUSR",prtUsr),"^",2)
	  ...s arrcpDr=$p(^DHCINVPRTZY(RowId),"^",17) 
	  ...q:arrcpDr="" 
	  ...s PaadmRowID=$p(^DHCINVPRTZY(RowId),"^",4)
	  ...s PapmiRowID=$p($g(^PAADM(PaadmRowID)),"^")
	  ...s PatientName=$p($g(^PAPER(PapmiRowID,"ALL")),"^")
	  ...s paym="0" f  s paym=$o(^ARRCP(arrcpDr,"PAYM",paym)) q:paym=""  d
	  ....s ss=^ARRCP(arrcpDr,"PAYM",paym)
	  ....s mode=$p(ss,"^",1)
	  ....s code=$p(^CT("CTPM",mode),"^",1)
	  ....q:code["INSU"
	  ....s:mode="" mode="1"
	  ....s depositPaydesc=$p(^CT("CTPM",mode),"^",2)
	  ....s m2=$p(ss,"^",3)
	  ....i ((m2<0) && (patfee>0)) s patdeposit=patdeposit+m2
	  ....i ((m2>0) && (patfee<0)) s patdeposit=patdeposit+m2
	  ...Do OutputRow5    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow5

	s jsdate=$zd(jsdate1,3)
	set Data=$lb(jsdate,patdeposit,mode,depositPaydesc,patfee,prtUsr,prtUsName,PatType,PatientName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindJKHisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindJsHisExecute ]
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

ClassMethod FindJKHisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindJKHisExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
