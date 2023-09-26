Class web.UDHCJFOPdailyhand Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 374;

ClassMethod PrintInvDailycatHzExecute(ByRef qHandle As %Binary, stdate, enddate, Guser) As %Status
{

    i (Guser'="") &&($d(^TMP("DailyHandHzOP",Guser))) 	k ^TMP("DailyHandHzOP",Guser)
   	s job=$j
   
	Set repid=$I(^CacheTemp)
    i stdate="" Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    s job=$j
    s allsum=0.00
    d ..iniTMP(Guser,job)
    
    f date=stdate:1:enddate   d
    .s repot=""
    .f  s repot=$o(^DHCOPInsFootI(0,"Date",date,repot))  q:repot=""  d
    ..s datalist=$g(^DHCOPInsFoot(repot))
    ..s amt=$p(datalist,"^",1)
    ..s user=$p(datalist,"^",8)
    ..s rptno=$p(datalist,"^",10)
    ..s allsum=+$g(allsum)+amt
    ..s ^TMP("DailyHandHzOP",Guser,job,user)=rptno_"^"_amt
    ..s sub="0"
    ..f  s sub=$o(^DHCOPInsFoot(repot,"C",sub))    q:sub=""   d
    ...s sublist=$g(^DHCOPInsFoot(repot,"C",sub))
    ...s opcate=$p(sublist,"^",1)
    ...s opsubcate=$p(sublist,"^",3)
    ...s subamt=$p(sublist,"^",2)
    ...s ^TMP("DailyHandHzOP",Guser,job,"usrcate",user,opcate)=+$g(^TMP("DailyHandHzOP",Guser,job,"usrcate",user,opcate))+subamt
    ...s ^TMP("DailyHandHzOP",Guser,job,"usrsubcat",user,opsubcate)=+$g(^TMP("DailyHandHzOP",Guser,job,"usrsubcat",user,opsubcate))+subamt
    ...s ^TMP("DailyHandHzOP",Guser,job,"cate",opcate)=+$g(^TMP("DailyHandHzOP",Guser,job,"cate",opcate))+subamt
    
    s cat=""
    f  s cat=$o(^TMP("DailyHandHzOP",Guser,job,"cate",cat))   q:cat=""   d
    .s catdes=$p($g(^DHCTarC("TOC",cat)),"^",2)
    .s catsum=+$g(^TMP("DailyHandHzOP",Guser,job,"cate",cat))
    .s cat1=$o(^TMP("DailyHandHzOP",Guser,job,"cate",cat))
    .s (catdes1,catsum1)=""
    .s:cat1'="" catdes1=$p($g(^DHCTarC("TOC",cat1)),"^",2)
    .s:cat1'="" catsum1=+$g(^TMP("DailyHandHzOP",Guser,job,"cate",cat1)) 
    .s:cat1'="" cat=cat1
    .d OutputRow1
    
    if +allsum'=0  d
    .s catdes="合计"
    .i allsum>=0  s catsum=##class(web.UDHCJFBaseCommon).RMBDXXZH("","",allsum)
    .i allsum<0  s catsum="负"_##class(web.UDHCJFBaseCommon).RMBDXXZH("","",(-allsum))
    .s catdes1=""
    .s catsum1=allsum
    .Do OutputRow1
    
    k ^TMP("DailyHandHzOP",Guser,job)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(catdes,catsum,catdes1,catsum1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod PrintInvDailycatHzFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintInvDailycatHzExecute ]
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

ClassMethod PrintInvDailycatHzClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintInvDailycatHzExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query PrintInvDailycatHz(stdate, enddate, Guser) As %Query(ROWSPEC = "Tcatdes:%String,Tcatsum:%String,Tcatdes1:%String,Tcatsum1:%String")
{
}

ClassMethod iniTMP(Guser, job)
{
	
	s ocid=""
	f  s ocid=$o(^DHCTarC("TOC",ocid))   q:ocid=""   d
	.q:(ocid="")||('$d(^DHCTarC("TOC",ocid)))
	.s ^TMP("DailyHandHzOP",Guser,job,"cate",ocid)=0.00
	
	q
}

ClassMethod PrintOPInvdailyhzExecute(ByRef qHandle As %Binary, StDate, EndDate, RecDr) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.UDHCJFOPdailyhand","PrintOPInvdailyhz","60110","61110")
   	s job=$j
	Set repid=$I(^CacheTemp)
    i StDate="" Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s RecDr=$g(RecDr)
    s ind=1
    s allsum=0.00
    f date=StDate:1:EndDate   d
    .s repot=""
    .f  s repot=$o(^DHCOPInsFootI(0,"Date",date,repot))  q:repot=""  d
    ..s datalist=$g(^DHCOPInsFoot(repot))
    ..//change by wangli 20081124汇总表上体现应缴金额 
    ..//s amt=$p(datalist,"^",16)
    ..s Total=$p(datalist,"^",1)
    ..s Recid=$p(datalist,"^",67)
    ..q:(RecDr'=Recid)
    ..s RefundSum=$p(datalist,"^",22)
    ..s ParkSum=$p(datalist,"^",24)
    ..s amt=Total+RefundSum+ParkSum
    ..s user=$p(datalist,"^",8)
    ..s FootDate=$ZD($p(datalist,"^",2),3)
    ..s:(user'="")&&($d(^SSU("SSUSR",user))) user=$p($g(^SSU("SSUSR",user)),"^",2)
    ..s rptno=$p(datalist,"^",10)
    ..s allsum=+$g(allsum)+amt
    ..Do OutputRow2
    .s user="合计"
    .s amt=allsum 
    .s rptno=##class(web.UDHCJFBaseCommon).RMBDXXZH("","",allsum)
    Do OutputRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(user,rptno,amt,FootDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod PrintOPInvdailyhzFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintOPInvdailyhzExecute ]
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

ClassMethod PrintOPInvdailyhzClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintOPInvdailyhzExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query PrintOPInvdailyhz(StDate, EndDate, RecDr) As %Query(ROWSPEC = "Tuser:%String,Trcptno:%String,Tamt:%String,TFootDate:%String")
{
}

ClassMethod PrintOPAccdailyExecute(ByRef qHandle As %Binary, Guser, job) As %Status
{
    ;d ##class(%ResultSet).RunQuery("web.UDHCJFOPdailyhand","PrintOPAccdaily","5","61110")
	Set repid=$I(^CacheTemp)
    i (Guser="")||(job="") Set qHandle=$lb(0,repid,0) 	Set qHandle=$lb(0,repid,0)  Quit $$$OK
    i '$d(^TMP("MZJF","EPPreDeptDailyHand",Guser,job))  Set qHandle=$lb(0,repid,0)  Quit $$$OK
    k ^TMP("EPInvDailyHand/No",Guser,"MZYJ","no")
    k ^TMP("MZYJNO",Guser,job)
    k ^TMP("MZYJNOT",Guser,job)
    s Nflag=""
    s ind=1
    if $d(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"R")) k ^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"R")
    if $d(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"P")) k ^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"P")
    if $d(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All")) k ^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All")
    s id=""
    f  s id=$o(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,id))  q:id=""   d
    .q:'("0123456789"[$e(id))
    .s data=$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,id))
    .s status=$p(data,"^",7)
    .s PayModeDesc=$p(data,"^",6)
    .s PayAmt=$p(data,"^",5)
    .s DepNo=$p(data,"^",10)
    .i ((status="P")&(DepNo'=""))  s ^TMP("MZYJNO",Guser,job,DepNo)=DepNo
    .i ((status'="P")&(DepNo'=""))  d         ;;;; update by zhl 081110
    ..i $d(^TMP("MZYJNOT",Guser,job))    d
    ...s lastno=$p($g(^TMP("MZYJNOT",Guser,job)),"-",2)
    ...s lastno1=lastno,DepNo1=DepNo
    ...i lastno["H"  s lastno1=$p(lastno,"H",2)
    ...i DepNo["H"  s DepNo1=$p(DepNo,"H",2)
    ...if +DepNo1>+lastno1  s $p(^TMP("MZYJNOT",Guser,job),"-",2)=DepNo
    ...i +DepNo1<+lastno1   d
    ....s lastfirno=$p($g(^TMP("MZYJNOT",Guser,job)),"-",1)
    ....s lastfirno1=lastfirno
    ....i lastfirno["H"  s lastfirno1=$p(lastfirno,"H",2)
    ....if +DepNo1<+lastfirno1  s $p(^TMP("MZYJNOT",Guser,job),"-",1)=DepNo 
    ..e  s ^TMP("MZYJNOT",Guser,job)=DepNo_"-"_DepNo
    .;i DepNo'=""  d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","MZYJ",Guser,DepNo)
    .s ^TMP("MZJF","EPPreDeptDailyHand",Guser,job,status,PayModeDesc)=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,status,PayModeDesc))+(+PayAmt)
    .s ^TMP("MZJF","EPPreDeptDailyHand",Guser,job,status,PayModeDesc,"NUM")=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,status,PayModeDesc,"NUM"))+1
    .s ^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All",PayModeDesc)=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All",PayModeDesc))+(+PayAmt)
    .s ^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All",PayModeDesc,"NUM")=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All",PayModeDesc,"NUM"))+1
    .s ^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All")=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All"))+(+PayAmt)
    
    s depdr=""
    f  s depdr=$o(^TMP("MZYJNO",Guser,job,depdr)) q:depdr=""  d
    .s depnon=^TMP("MZYJNO",Guser,job,depdr)
    .i depnon'=""  d   ; d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","MZYJ",Guser,depnon)
    ..;;add by lc for 押金号前面有字母
    ..s Nflag="N"
    ..i depnon["H"  d
    ...s Nflag="Y"
    ...s non=$p(depnon,"H",2)
    ...d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","MZYJ",Guser,depnon)
    ..e  d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","MZYJ",Guser,depnon)
     i Nflag="Y"  d
	 .s newstr="",number="",nostrold="",oldstno="",oldendno=""
	 .s number=$l(^TMP("EPInvDailyHand/No",Guser,"MZYJ","no"),",")
	 .f numdr=1:1:number  d
	 ..s nostrold=$p(^TMP("EPInvDailyHand/No",Guser,"MZYJ","no"),",",numdr)
	 ..s oldstno=$p(nostrold,"-",1)
	 ..s oldendno=$p(nostrold,"-",2)
	 ..i newstr=""  s newstr="H"_oldstno_"-"_"H"_oldendno
	 ..e  s newstr=newstr_","_"H"_oldstno_"-"_"H"_oldendno
	 ..//w !,newstr 
	 .s ^TMP("EPInvDailyHand/No",Guser,"MZYJ","no")=newstr
       
    s payid=""
    f  s payid=$o(^CT("CTPM",payid))  q:payid=""  d
    .s paydes=$p($g(^CT("CTPM",payid)),"^",2)
    .q:paydes=""
    .q:paydes["预交金"
    .q:paydes["医保"
    .q:paydes["病种"
    .q:paydes["记账"
    .q:paydes["欠费"
    .s tamt=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"R",paydes))+(+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"F",paydes)))
    .s tnum=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"R",paydes,"NUM"))+(+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"F",paydes,"NUM")))
    .s samt=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"P",paydes))
    .s snum=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"P",paydes,"NUM"))
    .s amt=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All",paydes))
    .s num=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All",paydes,"NUM"))
    .d OutputRow4
    
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(paydes,tamt,tnum,samt,snum,amt,num)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod PrintOPAccdailyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintOPAccdailyExecute ]
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

ClassMethod PrintOPAccdailyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintOPAccdailyExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query PrintOPAccdaily(Guser, job) As %Query(ROWSPEC = "paydes,tamt,tnum,samt,snum,amt,num")
{
}

ClassMethod checklike(flag, stat, usr, no As %String)
{
	
	 s Nflag="N" 
     i no["H"  d
     .s no=$p(no,"H",2)
     .s Nflag="Y"
	 s flag=$g(flag)
	 s stat=$g(stat)
	 s no=$g(no)
	 s usr=$g(usr)
	 s (len,str,endno)=""

	 if $d(^TMP(flag,usr,stat,"no"))  d
	 .s len=$l(^TMP(flag,usr,stat,"no"),",")
	 .s str=$p($g(^TMP(flag,usr,stat,"no")),",",len)
	 .i str["-"  s endno=$p(str,"-",2)
	 .else  s endno=str
	 .s endno=$tr(endno," ") 
	 .s no=$tr(no," ")
	 .q:endno=no
     .//W !,no
	 .i $l(endno)=$l(no)  d
	 ..s endno1=endno+1
	 ..i endno1=+no   d
	 ...s retn="Y"
	 ...i str["-"  d
	 ....s $p(str,"-",2)=no
	 ....s $p(^TMP(flag,usr,stat,"no"),",",len)=str
	 ...else  d
	 ....s str=str_"-"_no
	 ....s $p(^TMP(flag,usr,stat,"no"),",",len)=str
	 ..else  s ^TMP(flag,usr,stat,"no")=^TMP(flag,usr,stat,"no")_","_no	
	 .else  d
	 ..s retn="N"
	 ..s ^TMP(flag,usr,stat,"no")=^TMP(flag,usr,stat,"no")_","_no
	 //W !,no
	 else  s ^TMP(flag,usr,stat,"no")=no
	 q 1
}

ClassMethod PrintOPAccUserDetailExecute(ByRef qHandle As %Binary, Guser, job) As %Status
{
    ;d ##class(%ResultSet).RunQuery("web.UDHCJFOPdailyhand","PrintOPAccUserDetail","5","61110")
	Set repid=$I(^CacheTemp)
    i (Guser="")||(job="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    i '$d(^TMP("MZJF","EPPreDeptDailyHand",Guser,job))  Set qHandle=$lb(0,repid,0)  Quit $$$OK
    s ind=1

    s username=$p($g(^SSU("SSUSR",Guser)),"^",2)
     s date=$p(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,ind),"^",11)
    i date'="" s date=$ZD(date,3)
    e  s date=$zd(+$h,3)
    s time=$p(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,ind),"^",12)
    i time'="" s time=$zt(time)
    e  s time=$zt($p($h,",",2))
    //add by wangli 2008-07-27    
    s sum=+$g(^TMP("MZJF","EPPreDeptDailyHand",Guser,job,"All"))
    i +sum>=0  s sumdx=##class(web.UDHCJFBaseCommon).RMBDXXZH("","",sum) 
    i +sum<0  s sumdx="负"_##class(web.UDHCJFBaseCommon).RMBDXXZH("","",(-sum))
    s YJNO=$G(^TMP("EPInvDailyHand/No",Guser,"MZYJ","no"))
    s TYJNO=$G(^TMP("MZYJNOT",Guser,job))
    d OutputRow3
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(username,date,time,sum,sumdx,YJNO,TYJNO)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod PrintOPAccUserDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintOPAccUserDetailExecute ]
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

ClassMethod PrintOPAccUserDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintOPAccUserDetailExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query PrintOPAccUserDetail(Guser, job) As %Query(ROWSPEC = "username,date,time,sum,sumdx,YJNO,TYJNO")
{
}

ClassMethod PrintOPInvdailyExecute(ByRef qHandle As %Binary, Guser, job) As %Status
{
    ;d ##class(%ResultSet).RunQuery("web.UDHCJFOPdailyhand","PrintOPInvdaily","640","140350")
	Set repid=$I(^CacheTemp)
    i (Guser="")||(job="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    i '$d(^TMP("MZJF","EPInvDailyHand",Guser,job))  Set qHandle=$lb(0,repid,0)  Quit $$$OK
    s ind=1
    k ^TMP("EPInvDailyHand/No",Guser)
    k ^TMP("ZYJF","OPInvNoAbort",Guser,job)
    k ^TMP("ZYJF","OPInvNoStrik",Guser,job)
    k ^TMP("ZYJF","OPInvNoA",Guser,job)
    k ^TMP("ZYJF","OPInvNoS",Guser,job)
    s (zfnum,zfsum,hcnum,hcsum,allsum,sknum,sksum)=0
    s sum=0
    s id="",initinv="",oldinvno=""
    f  s id=$o(^TMP("MZJF","EPInvDailyHand",Guser,job,id))  q:id=""   d
    .s data=$g(^TMP("MZJF","EPInvDailyHand",Guser,job,id))
    .s status=$p(data,"^",9)
    .s invno=$p(data,"^",1)
    .s amt=$p(data,"^",10)
    .s sum=+sum+(+amt)
    .s initinv=$p(data,"^",12)
    .//change by wangli 2009-09-03 
    .s accrowid=$p(data,"^",15)
    .i (initinv'="")&&(accrowid="")  d   
    ..i $d(^DHCINVPRT(initinv))'=0  d
    ...s oldinvno=$p(^DHCINVPRT(initinv),"^",14)
    .i (initinv'="")&&(accrowid'="")  d
    ..i $d(^DHCINVPRT(initinv))'=0  d
    ...s oldinvno=$p(^DHCINVPRTAP(initinv),"^",6)
    .i status["作废"  d
    ..i initinv'=""  d
    ...s zfnum=+zfnum+1
    ...s zfsum=+zfsum+(+amt)
    ...d ..checklike("EPInvDailyHand/No","Abort",Guser,oldinvno)
    ...i oldinvno'="" d
    ....s ^TMP("ZYJF","OPInvNoAbort",Guser,job,oldinvno)=oldinvno
    .i status["红冲"  d
    ..i initinv'=""  d
    ...s hcnum=+hcnum+1
    ...s hcsum=+hcsum+(+amt)
    ...d ..checklike("EPInvDailyHand/No","Strik",Guser,oldinvno)
    ...i oldinvno'=""  d
    ....s ^TMP("ZYJF","OPInvNoStrik",Guser,job,oldinvno)=oldinvno
    .i invno'=""  d   ;..checklike("EPInvDailyHand/No","All",Guser,invno)
    ..s sksum=+sksum+(+amt)
    ..s sknum=+sknum+1
    ..s ^TMP("MZRB","PRTINV",Guser,job,invno)=invno_"^"_status
    s user=$p($g(^SSU("SSUSR",Guser)),"^",2)
    s prtdate=$p($g(^TMP("MZJF","EPInvDailyHand",Guser,job,1)),"^",3)
    s invdr=""
    f  s invdr=$o(^TMP("MZRB","PRTINV",Guser,job,invdr)) q:invdr=""  d
    .s invnon=$p(^TMP("MZRB","PRTINV",Guser,job,invdr),"^",1)
    .s invstatus=$p(^TMP("MZRB","PRTINV",Guser,job,invdr),"^",2)
    .i invnon'=""  d ..checklike("EPInvDailyHand/No","All",Guser,invnon)
    s zfnonum=0,chnonum=0
    s oldinvno=""  
    f  s oldinvno=$o(^TMP("ZYJF","OPInvNoAbort",Guser,job,oldinvno))  q:(oldinvno="")  d
    .s zfnonum=zfnonum+1
    .s ^TMP("ZYJF","OPInvNoA",Guser,job,zfnonum)=oldinvno  
    s oldinvno=""  
    f  s oldinvno=$o(^TMP("ZYJF","OPInvNoStrik",Guser,job,oldinvno))  q:(oldinvno="")  d
    .s chnonum=chnonum+1
    .s ^TMP("ZYJF","OPInvNoS",Guser,job,chnonum)=oldinvno  
    s zfno=$g(^TMP("EPInvDailyHand/No",Guser,"Abort","no"))
    s hcno=$g(^TMP("EPInvDailyHand/No",Guser,"Strik","no"))
    ;s zfno=##class(web.UDHCJFBaseCommon).GetINVNOinfo(Guser, "OPInvNoA", job)
    ;s hcno=##class(web.UDHCJFBaseCommon).GetINVNOinfo(Guser, "OPInvNoS", job)
    s allno=$g(^TMP("EPInvDailyHand/No",Guser,"All","no"))
    //k ^TMP("MZJF","EPInvDailyHand",Guser,job)   ;测试前需要注释
    k ^TMP("EPInvDailyHand/No",Guser,"Abort","no")
    k ^TMP("EPInvDailyHand/No",Guser,"Strik","no")
    k ^TMP("EPInvDailyHand/No",Guser,"All","no")
    k ^TMP("MZRB","PRTINV",Guser,job)
    k ^TMP("ZYJF","OPInvNoAbort",Guser,job)
    k ^TMP("ZYJF","OPInvNoStrik",Guser,job)
    k ^TMP("ZYJF","OPInvNoA",Guser,job)
    k ^TMP("ZYJF","OPInvNoS",Guser,job)
    i sum>=0  s sumdx=##class(web.UDHCJFBaseCommon).RMBDXXZH("","",sum) 
    i sum<0  s sumdx="负"_##class(web.UDHCJFBaseCommon).RMBDXXZH("","",(-sum))
    d OutputRow5
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(user,prtdate,zfno,zfnum,zfsum,hcno,hcnum,hcsum,allno,sum,sumdx,sknum,sksum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod PrintOPInvdailyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintOPInvdailyExecute ]
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

ClassMethod PrintOPInvdailyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintOPInvdailyExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query PrintOPInvdaily(Guser, job) As %Query(ROWSPEC = "user,prtdate,zfno,zfnum,zfsum,hcno,hcnum,hcsum,allno,sum,sumdx,sknum,sksum")
{
}

ClassMethod PrintOPAccdailyHzExecute(ByRef qHandle As %Binary, StDate, EndDate, Guser, job, RecDr) As %Status
{
    ;d ##class(%ResultSet).RunQuery("web.UDHCJFOPdailyhand","PrintOPAccdailyHz","61377","61377","1","1298640","on",2)
	//s ^wl("Acchzkkk")=StDate_"^"_EndDate_"^"_Guser_"^"_job_"^"_Handin_"^"_RecDr
	Set repid=$I(^CacheTemp)
    i (Guser="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    s nostr=""
    s RecDr=$g(RecDr)
    f date=StDate:1:EndDate  d
    .s foot=""
    .f  s foot=$o(^DHCACDi("AccPDFL",0,"FootDT",date,foot))  q:foot=""   d
    ..s user=$p($g(^DHCACD("AccPDFL",foot)),"^",3)
    ..//add by wangli081227
    ..s RecDate=$p($g(^DHCACD("AccPDFL",foot)),"^",8)
    ..s RecTime=$p($g(^DHCACD("AccPDFL",foot)),"^",9)
    ..s Recid=$p($g(^DHCACD("AccPDFL",foot)),"^",23)
    ..//q:(RecDate'="")&&(RecDate>EndDate)
    ..q:(Recid'=RecDr)
    ..k ^TMP("MZYJHZ",user)  
    ..s username=""
    ..s:user'="" username=$p($g(^SSU("SSUSR",user)) ,"^",2)
    ..s ^TMP("MZJF","PrintOPAccdailyHz",Guser,job,"foot",foot)=user
    ..s allsum=0
    ..s accid=""
    ..f  s accid=$o(^DHCACDi("AccM",0,"PDFootDR",foot,accid)) q:accid=""  d
    ...s sub="0"
    ...f  s sub=$o(^DHCACDi("AccM",0,"PDFootDR",foot,accid,"AccPD",sub)) q:sub=""  d
    ....s data=$g(^DHCACD("AccM",accid,"AccPD",sub))
    ....s type=$p(data,"^",1)
    ....s amt=$p(data,"^",2)
    ....s number=$p(data,"^",6)
    ....s FootDate=$ZD($p(data,"^",11),3)
    ....;;i number'=""  ;;;d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","MZYJHZ",Guser,number)
    ....i number'=""  s ^TMP("MZYJHZ",user,number)=number
    ....s allsum=+allsum+(+amt)
    ....s ^TMP("MZJF","PrintOPAccdailyHz",Guser,job,"foot",foot,type)=$g(^TMP("MZJF","PrintOPAccdailyHz",Guser,job,"foot",foot,type))+(+amt)
    ....s ^TMP("MZJF","PrintOPAccdailyHz",Guser,job,"foot",foot)=$g(^TMP("MZJF","PrintOPAccdailyHz",Guser,job,"foot",foot))+(+amt)
    ....s paym=""
    ....f  s paym=$o(^DHCACDi("AccM",accid,"AccPD",sub,"P",paym)) q:paym=""  d
    .....s paymdr=$p($g(^DHCACDi("AccM",accid,"AccPD",sub,"P",paym)),"^",1)
    .....s payamt=$p($g(^DHCACDi("AccM",accid,"AccPD",sub,"P",paym)),"^",6)
    .....s ^TMP("MZJF","PrintOPAccdailyHz",Guser,job,"paym",paymdr)=$g(^TMP("MZJF","PrintOPAccdailyHz",Guser,job,"paym",paymdr))+(+payamt)
    ..s nodr=""
    ..s Nflag="N"
    ..f  s nodr=$o(^TMP("MZYJHZ",user,nodr)) q:nodr=""  d
    ...s non=^TMP("MZYJHZ",user,nodr)
    ...;;add by lc for 押金号前面有字母
    ...i non'=""  d
    ....i non["H"  d
    .....s Nflag="Y"
    .....s non=$p(non,"H",2)
    .....d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","MZYJHZ",user,non)
    ....e  d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","MZYJHZ",user,non)
     ..i Nflag="Y"  d
	 ...s newstr="",number="",nostrold="",oldstno="",oldendno=""
	 ...s number=$l(^TMP("EPInvDailyHand/No",user,"MZYJHZ","no"),",")
	 ...f numdr=1:1:number  d
	 ....s nostrold=$p(^TMP("EPInvDailyHand/No",user,"MZYJHZ","no"),",",numdr)
	 ....s oldstno=$p(nostrold,"-",1)
	 ....s oldendno=$p(nostrold,"-",2)
	 ....i newstr=""  s newstr="H"_oldstno_"-"_"H"_oldendno
	 ....e  s newstr=newstr_","_"H"_oldstno_"-"_"H"_oldendno
	 ...s ^TMP("EPInvDailyHand/No",user,"MZYJHZ","no")=newstr
    ..s nostr=^TMP("EPInvDailyHand/No",user,"MZYJHZ","no")
    ..k ^TMP("EPInvDailyHand/No",user,"MZYJHZ","no")
    ..d OutputRow6
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(username,nostr,allsum,FootDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod PrintOPAccdailyHzFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintOPAccdailyHzExecute ]
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

ClassMethod PrintOPAccdailyHzClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintOPAccdailyHzExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query PrintOPAccdailyHz(StDate, EndDate, Guser, job, RecDr) As %Query(ROWSPEC = "username,nostr,amt,FootDate")
{
}

ClassMethod PrintOPAccpayHzExecute(ByRef qHandle As %Binary, Guser, job) As %Status
{
   
	Set repid=$I(^CacheTemp)
    i (Guser="")||(job="")||('$d(^TMP("MZJF","PrintOPAccdailyHz",Guser,job))) Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    s allsum=0
    for i=1:1:16  d
    .s paym(i)=0.00
    .s name(i)=""
   
    s payid=""
    s num=0
    f  s payid=$o(^CT("CTPM",payid))  q:payid=""  d
    .s paydes=$p($g(^CT("CTPM",payid)),"^",2)
    .q:paydes=""
    .s num=num+1
    .s paym(num)=+$g(^TMP("MZJF","PrintOPAccdailyHz",Guser,job,"paym",payid))
    .s name(num)=paydes
    .s allsum=+allsum+(+paym(num))
   
    if allsum>=0  s sumdx=##class(web.UDHCJFBaseCommon).RMBDXXZH("","",allsum)
    if allsum<0  s sumdx="负"_##class(web.UDHCJFBaseCommon).RMBDXXZH("","",-(+allsum))

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(paym(1),name(1),paym(2),name(2),paym(3),name(3),paym(4),name(4),paym(5),name(5),paym(6),name(6),paym(7),name(7),paym(8),name(8),paym(9),name(9),paym(10),name(10),paym(11),name(11),paym(12),name(12),paym(13),name(13),paym(14),name(14),paym(15),name(15),paym(16),name(16),allsum,sumdx)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod PrintOPAccpayHzFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintOPAccpayHzExecute ]
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

ClassMethod PrintOPAccpayHzClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintOPAccpayHzExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query PrintOPAccpayHz(Guser, job) As %Query(ROWSPEC = "paym1,name1,paym2,name2,paym3,name3,paym4,name4,paym5,name5,paym6,name6,paym7,name7,paym8,name8,paym9,name9,paym10,name10,paym11,name11,paym12,name12,paym13,name13,paym14,name14,paym15,name15,paym16,name16,allsum,sumdx")
{
}

}
