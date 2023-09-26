Import SQLUser

Class web.DHCJFopapprov Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 26;

ClassMethod findapprovExecute(ByRef qHandle As %Binary, datefrm As %String, dateto As %String, admreasid As %String, ordreasid As %String, apprid As %String) As %Status
{
   
	;d ##class(%ResultSet).RunQuery("web.UDHCJFinfro","findpatient","60630","","","","on","","","","")
    
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    
    s apprid=$g(apprid)
    s apprid=$tr(apprid," ")
    s datefrm=$g(datefrm)
	s dateto=$g(dateto)
 	s admreasonid=$g(admreasid)
 	s admreasonid=$tr(admreasid," ")
 	s ordreasonid=$g(ordreasid)
 	s ordreasonid=$tr(ordreasid," ")

 	i apprid'=""  d
 	.s opa=$p(apprid,$c(1))
 	.d opadetail(opa,"","")
 	else   d
 	.i admreasonid'=""  d
 	..i ordreasonid'=""  d 
 	...s opa=""
 	...s opa=$o(^DHCOPApproved(0,"OrdAppAR",admreasonid,ordreasonid,opa))   q:opa=""  d 
    ...d opadetail(opa,admreasonid,ordreasonid)
    ..else  d
    ...s ordreasonid=""
    ...f  s ordreasonid=$o(^DHCOPApproved(0,"OrdAppAR",admreasonid,ordreasonid))   q:ordreasonid=""  d 
    ....s opa=""
    ....f  s opa=$o(^DHCOPApproved(0,"OrdAppAR",admreasonid,ordreasonid,opa))   q:opa=""  d 
    .....s opa=$p(opa,$c(1))
    .....d opadetail(opa,admreasonid,ordreasonid)
    .else  d
    ..s opa="0"
    ..f  s opa=$o(^DHCOPApproved(opa)) q:opa=""  d
    ...d opadetail(opa,"","")
    s qHandle=$lb(0,repid,0)
	quit $$$OK
   
opadetail(opa,admreasonid,ordreasonid)
   s opa=$p(opa,$c(1))
   q:'$d(^DHCOPApproved(opa))
   s stdate=$p($g(^DHCOPApproved(opa)),"^",5) 
   s enddate=$p($g(^DHCOPApproved(opa)),"^",6)
   s disreasid=$p($g(^DHCOPApproved(opa)),"^",3)
   s:admreasonid="" admreasonid=$p($g(^DHCOPApproved(opa)),"^",1)
   s:ordreasonid="" ordreasonid=$p($g(^DHCOPApproved(opa)),"^",2)
   s:((disreasid'="")&&($d(^PAC("ADMREA",disreasid)))) disreas=$p($g(^PAC("ADMREA",disreasid)),"^",2)
   s:((admreasonid'="")&&($d(^PAC("ADMREA",admreasonid)))) admreas=$p($g(^PAC("ADMREA",admreasonid)),"^",2)
   s:((ordreasonid'="")&&($d(^PAC("ADMREA",ordreasonid)))) ordreas=$p($g(^PAC("ADMREA",ordreasonid)),"^",2)
   q:(((datefrm'="")&(enddate<datefrm))||((dateto'="")&(stdate>dateto)))
   s:enddate'="" enddate=$zd(enddate,4)
   s:stdate'="" stdate=$zd(stdate,4)
   s opac=$p($p($g(^DHCOPApproved(opa)),"^",4),$c(1))
   s:((opac'="")&&($d(^DHCOPAppCon(opac)))) opacds=$p($g(^DHCOPAppCon(opac)),"^",1)
   d outputrow1    
   q 
   

outputrow1
	set Data=$lb($g(admreas),$g(ordreas),$g(disreas),$g(opacds),stdate,enddate,opac,opa)
 	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod findapprovFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findapprovExecute ]
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

Query findapprov(datefrm As %String, dateto As %String, admreasid As %String, ordreasid As %String, apprid As %String) As %Query(ROWSPEC = "Tpatadmrea:%String,Tordadmrea:%String,Tdisadmrea:%String,Topac:%String,Tdatefrm:%String,Tdateto:%String,Topacid:%String,Tapprid:%String")
{
}

ClassMethod findapprovClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findapprovExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod upac(dateto, minamt, id)
{
	s id=$g(id)
	s id=$tr(id," ")
	s dateto=$g(dateto)
	s dateto=$tr(dateto," ")
	s minamt=$g(minamt)
	q:(($g(id)="")||('$d(^DHCOPAppCon(id)))) 100
	s enddate=$p($g(^DHCOPAppCon(id)),"^",4)
	
	q:((+enddate<=+$h)&&(+dateto<+enddate)) 111
	s:dateto'="" dateto=$zdh(dateto,4)
	&sql(UPDATE DHC_OPAppCon set OPAC_MinAmount=:minamt,OPAC_DateTo=:dateto  WHERE OPAC_RowId=:id)
	
	q SQLCODE
}

ClassMethod insertac(val)
{
	q:$g(val)="" 100
    k PLIST
	s PLIST(2)=$p($g(val),"^",1)
	s opac=$p($g(val),"^",1)
	s PLIST(3)=$p($g(val),"^",2)
	s PLIST(4)=$p($g(val),"^",3)
	s:PLIST(4)'="" PLIST(4)=$zdh(PLIST(4),4)
	s PLIST(5)=$p($g(val),"^",4)
	s:PLIST(5)'="" PLIST(5)=$zdh(PLIST(5),4)
	k PLIST(1)
	s:$d(^DHCOPAppCon(0,"Name")) id=$o(^DHCOPAppCon(0,"Name",opac,""))
	q:$g(id)'="" 100
	&sql(INSERT INTO DHC_OPAppCon  Values PLIST())
	q SQLCODE
}

ClassMethod insertacc(val)
{
	q:$g(val)="" 100
    k PLIST
	s PLIST(0)=$p($g(val),"^",1)
	s opacid=$p($g(val),"^",1)
	s opacid=$tr(opacid, " ")
	q:opacid="" 100
	s PLIST(4)=$p($g(val),"^",2)
	s PLIST(5)=$p($g(val),"^",3)
	s:PLIST(5)'="" PLIST(5)=$zdh(PLIST(5),4)
	s PLIST(6)=$p($g(val),"^",4)
	s:PLIST(6)'="" PLIST(6)=$zdh(PLIST(6),4)
	s PLIST(3)=$p($g(val),"^",5)
	s subcat=$tr(PLIST(3)," ")
	k PLIST(1),PLIST(2)
	
	s:subcat'="" acc=$o(^DHCOPAppCon(0,"SubCate",subcat,opacid,"")) 
    q:$g(acc)'="" 100
    
	&sql(INSERT INTO DHC_OPAppConCate  Values PLIST())
	q SQLCODE
}

ClassMethod insert(val)
{
   q:$g(val)="" 100
    k PLIST
	s PLIST(2)=$p($g(val),"^",1)
	s admre=$tr(PLIST(2)," ")
	s PLIST(3)=$p($g(val),"^",2)
	s ordre=$tr(PLIST(3)," ")
	q:(admre="")||(ordre="") 100

	s PLIST(4)=$p($g(val),"^",3)
	s PLIST(6)=$p($g(val),"^",4)
	s stdate=PLIST(6)
	s:PLIST(6)'="" PLIST(6)=$zdh(PLIST(6),4)
	s PLIST(7)=$p($g(val),"^",5)
	s:PLIST(7)'="" PLIST(7)=$zdh(PLIST(7),4)
	s PLIST(5)=$p($g(val),"^",6)
	
	i $d(^DHCOPApproved(0,"OrdAppAR",admre,ordre))  d
	.s appr=""
	.f  s appr=$o(^DHCOPApproved(0,"OrdAppAR",admre,ordre,appr),-1) q:(appr="")||($g(flag)["Y")   d
	..s enddate=$p($g(^DHCOPApproved(appr)),"^",6)
	..i (enddate="") s flag="Y"
	..i (enddate'="")&&(+enddate>+$h)&&(PLIST(6)<+enddate)  s flag="Y"

	q:$g(flag)["Y" 100
	
	k PLIST(1)
	&sql(INSERT INTO DHC_OPApproved  Values PLIST())
	q SQLCODE
}

ClassMethod delapp(appr)
{
	s appr=$tr($g(appr)," ")
	s err=1
	i (appr'="")&&($d(^DHCOPApproved(appr)))  d
	.&sql(delete from DHC_OPApproved  where OPA_RowID=:appr)
	.s err=SQLCODE
	q err
}

ClassMethod delapcn(apcn)
{
	s apcn=$tr($g(apcn)," ")
	s err=1
	i (apcn'="")&&($d(^DHCOPAppCon(apcn)))  d
	.i $d(^DHCOPApproved(0,"OPAC",apcn)) s err=100
	.else  d
	..&sql(delete from DHC_OPAppCon  where OPAC_RowID=:apcn)
	..s err=SQLCODE
	q err
}

ClassMethod delapcc(apcc)
{
	s apcc=$tr($g(apcc)," ")
	s err=1
	i (apcc'="")&&($d(^DHCOPAppCon(+apcc,"C",$p(apcc,"||",2))))  d
	.&sql(delete from DHC_OPAppConCate  where OPACC_RowID=:apcc)
	.s err=SQLCODE
	q err
}

ClassMethod setapp(oestr, user)
{
   q:$tr($g(oestr)," ")="" 0
    s user=$g(user)
    f i=2:1:$l(oestr,"^")  d
    .s oeid=$p(oestr,"^",i)
	.s oeid=$tr($g(oeid)," ")
	.s dhcoe=$o(^DHCORDItem(0,oeid,""))
	.s dhcoe=$tr($g(dhcoe)," ")
	.i ((dhcoe="")||('$d(^DHCORDItem(dhcoe)))) d
	..k PLIST
	..s PLIST(20)="Y"
	..s PLIST(21)=user
	..s PLIST(22)=+$h
	..s PLIST(23)=$p($h,",",2)
	..s PLIST(2)=oeid
	..k PLIST(1)
	..&sql(INSERT INTO DHC_OE_OrdItem  Values PLIST())
    .else  d
	..s flag=$p($g(^DHCORDItem(dhcoe,2)),"^",1)
	..q:flag["Y" 
    ..s $p(^DHCORDItem(dhcoe,2),"^",1)="Y"
    ..s $p(^DHCORDItem(dhcoe,2),"^",2)=user
    ..s $p(^DHCORDItem(dhcoe,2),"^",3)=+$h	
    ..s $p(^DHCORDItem(dhcoe,2),"^",4)=$p($h,",",2)
	q 1
}

ClassMethod update(val1, acid, val2)
{
   
   s val1=$tr($g(val1)," ")
   s val2=$tr($g(val2)," ")
   q:(($g(val1)="")||($g(val2)="")) 100
    s val2=$p(val2,$c(1))
    s acid=$g(acid)
    s acid=$tr(acid," ")
    q:'$d(^DHCOPApproved(val2)) 100
 
    s dateto=$p($g(^DHCOPApproved(val2)),"^",6)
    q:((+dateto<=+$h)&(+val1<+dateto)) 111
    s ac=$p($g(^DHCOPApproved(val2)),"^",4)
    s:ac'="" acid=ac
    s:val1'="" enddate=$zdh(val1,4)
	&sql(UPDATE DHC_OPApproved set OPA_DateTo=:enddate,OPA_OPAC_Dr=:acid  WHERE OPA_RowId=:val2)
	
	q SQLCODE
}

ClassMethod updateacc(dateto, minamt, id)
{
   	s id=$g(id)
   	s id=$tr(id," ")
	s dateto=$g(dateto)
	s dateto=$tr(dateto," ")
	s minamt=$g(minamt)
	q:(($g(id)="")||('$d(^DHCOPAppCon(+id,"C",$p(id,"||",2))))) 100
	s enddate=$p($g(^DHCOPAppCon(+id,"C",$p(id,"||",2))),"^",4)
	q:((+enddate<=+$h)&&(+dateto<+enddate)) 111
	s:dateto'="" dateto=$zdh(dateto,4)
	&sql(UPDATE DHC_OPAppConCate set OPACC_MinAmount=:minamt,OPACC_DateTo=:dateto  WHERE OPACC_RowId=:id)
	
	q SQLCODE
}

ClassMethod findreasonExecute(ByRef qHandle As %Binary) As %Status
{
  
   
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s reasonid=""
	f  s reasonid=$o(^PAC("ADMREA",reasonid))  q:reasonid=""   d
	.q:'$d(^PAC("ADMREA",reasonid))
	.s reason=$p($g(^PAC("ADMREA",reasonid)),"^",2)
	.s dateto=$p($g(^PAC("ADMREA",reasonid)),"^",4)
	.q:((dateto'="")&&(dateto<+$h))
	.d outputrow2
   
    
    s qHandle=$lb(0,repid,0)
	quit $$$OK
   

outputrow2
	set Data=$lb(reason,reasonid)
 	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod findreasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findreasonExecute ]
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

Query findreason() As %Query(ROWSPEC = "Treason:%String,Treasonid:%String")
{
}

ClassMethod findreasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findreasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findappcnExecute(ByRef qHandle As %Binary, opacid) As %Status
{
  
   
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s opacid=$g(opacid)
	s opacid=$tr(opacid," ")
	s:opacid="" opacid="0"
	if opacid="0"  d
	.f  s opacid=$o(^DHCOPAppCon(opacid))  q:opacid=""   d
	..s opacid=$p(opacid,$c(1))
	..q:'$d(^DHCOPAppCon(opacid))
	..s acdes=$p($g(^DHCOPAppCon(opacid)),"^",1)
	..s minamt=$p($g(^DHCOPAppCon(opacid)),"^",2)
	..s datefrm=$p($g(^DHCOPAppCon(opacid)),"^",3)
	..s:datefrm'="" datefrm=$zd(datefrm,4)
	..s dateto=$p($g(^DHCOPAppCon(opacid)),"^",4)
	..s:dateto'="" dateto=$zd(dateto,4)
	..d outputrow6
   else  d
    .s opacid=$p(opacid,$c(1))
    .q:'$d(^DHCOPAppCon(opacid))
	.s acdes=$p($g(^DHCOPAppCon(opacid)),"^",1)
	.s minamt=$p($g(^DHCOPAppCon(opacid)),"^",2)
	.s datefrm=$p($g(^DHCOPAppCon(opacid)),"^",3)
	.s:datefrm'="" datefrm=$zd(datefrm,4)
	.s dateto=$p($g(^DHCOPAppCon(opacid)),"^",4)
	.s:dateto'="" dateto=$zd(dateto,4)
    .d outputrow6
    s qHandle=$lb(0,repid,0)
	quit $$$OK
   

outputrow6
	set Data=$lb(acdes,opacid,minamt,datefrm,dateto)
 	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod findappcnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findappcnExecute ]
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

Query findappcn(opacid) As %Query(ROWSPEC = "Topac:%String,Topacid:%String,Tminamt:%String,Tdatefrm:%String,Tdateto:%String")
{
}

ClassMethod findappcnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findappcnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod tarsublookExecute(ByRef qHandle As %Binary) As %Status
{
  
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s rowid=""
    f  s rowid=$o(^DHCTarC("SC",rowid))  q:rowid=""   d
    .q:'$d(^DHCTarC("SC",rowid))
    .s tardesc=$p($g(^DHCTarC("SC",rowid)),"^",2)
    .s tarrowid=rowid 
 	.Do outputrow4 	
 
   
    
    s qHandle=$lb(0,repid,0)
	quit $$$OK
   

outputrow4
  
	set Data=$lb(tardesc,tarrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod tarsublookFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = tarsublookExecute ]
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

Query tarsublook() As %Query(ROWSPEC = "Ttardesc:%String,Ttarrowid:%String")
{
}

ClassMethod tarsublookClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = tarsublookExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findappccExecute(ByRef qHandle As %Binary, opacid As %String, datefrm As %String, dateto As %String) As %Status
{
  
   
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s opacid=$g(opacid)
	s opacid=$tr(opacid," ")

	s datefrm=$g(datefrm)
	s dateto=$g(dateto)
    if opacid=""   s qHandle=$lb(0,repid,0)   quit $$$OK
    
    s accid="0"
    f  s accid=$o(^DHCOPAppCon(opacid,"C",accid))  q:accid=""  d
    .s accid=$p(accid,$c(1))
    .q:'$d(^DHCOPAppCon(opacid,"C",accid))
    .s tarsub=$p($g(^DHCOPAppCon(opacid,"C",accid)),"^",1)
    .s:((tarsub'="")&&($d(^DHCTarC("SC",tarsub)))) tarsubdesc=$p($g(^DHCTarC("SC",tarsub)),"^",2)
    .s stdate=$p($g(^DHCOPAppCon(opacid,"C",accid)),"^",3)
    .s enddate=$p($g(^DHCOPAppCon(opacid,"C",accid)),"^",4)
    .q:(((datefrm'="")&(+enddate<+datefrm))||((dateto'="")&(+stdate>+dateto)))
    .s:stdate'="" stdate=$zd(stdate,4)
    .s:enddate'="" enddate=$zd(enddate,4)
    .s minamt=$p($g(^DHCOPAppCon(opacid,"C",accid)),"^",2)
    .s opacc=opacid_"||"_accid
	.d outputrow5
   
    
    s qHandle=$lb(0,repid,0)
	quit $$$OK
   

outputrow5
	set Data=$lb(tarsub,$g(tarsubdesc),opacc,stdate,enddate,minamt)
 	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod findappccFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findappccExecute ]
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

Query findappcc(opacid As %String, datefrm As %String, dateto As %String) As %Query(ROWSPEC = "Ttarsid:%String,Ttarsub:%String,Topaccid:%String,Tdatefrm:%String,Tdateto:%String,Tminamt:%String")
{
}

ClassMethod findappccClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findappccExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findadmExecute(ByRef qHandle As %Binary, papno As %String) As %Status
{
    
   
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s papno=$g(papno)
 	if papno=""  s qHandle=$lb(0,repid,0)  quit $$$OK
 	s:papno'="" papno=##class(web.UDHCJFBaseCommon).regnocon(papno)
	s papno=$$ALPHAUP^SSUTIL4(papno)
	s papmi=$o(^PAPERi("PAPMI_PatNo",papno,""))
	s adm=""
	f  s adm=$o(^PAPERdr(papmi,"ADM","O",adm),-1)  q:adm=""  d
	.q:'$d(^PAADM(adm))
	.s flag="O"
	.s VisitStatus=$p($g(^PAADM(adm)),"^",20)
	.q:VisitStatus="C"
	.s dep=$p($g(^PAADM(adm)),"^",4)
	.s:((dep'="")&&($d(^CTLOC(dep)))) dep=$p($g(^CTLOC(dep)),"^",2)
	.s doc=$p($g(^PAADM(adm)),"^",9)
	.s:((doc'="")&&($d(^CTPCP(doc)))) doc=$p($g(^CTPCP(doc,1)),"^",2)
	.s date=$p($g(^PAADM(adm)),"^",6)
	.s:date'="" date=$zd(date,4)
	.s reason=$p($g(^PAADM(adm,1)),"^",7)
	.q:reason=""
	.q:'$d(^DHCOPApproved(0,"OrdAppAR",reason))
	.s:((reason'="")&&($d(^PAC("ADMREA",reason)))) reason=$p($g(^PAC("ADMREA",reason)),"^",2)
	.
	.d outputrow7
    s adm=""
    f  s adm=$o(^PAPERdr(papmi,"ADM","E",adm),-1)  q:adm=""  d
    .q:'$d(^PAADM(adm))
    .s falg="E"
    .s VisitStatus=$p($g(^PAADM(adm)),"^",20)
	.q:VisitStatus="C"
	.s dep=$p($g(^PAADM(adm)),"^",4)
	.s:((dep'="")&&($d(^CTLOC(dep)))) dep=$p($g(^CTLOC(dep)),"^",2)
	.s doc=$p($g(^PAADM(adm)),"^",9)
	.s:((doc'="")&&($d(^CTPCP(doc)))) doc=$p($g(^CTPCP(doc,1)),"^",2)
	.s date=$p($g(^PAADM(adm)),"^",6)
	.s:date'="" date=$zd(date,4)
	.s reason=$p($g(^PAADM(adm,1)),"^",7)
	.q:reason=""
	.q:'$d(^DHCOPApproved(0,"OrdAppAR",reason))
	.s:((reason'="")&&($d(^PAC("ADMREA",reason)))) reason=$p($g(^PAC("ADMREA",reason)),"^",2)
	.
	.d outputrow7
	
	
    s qHandle=$lb(0,repid,0)
	quit $$$OK
   

outputrow7
	set Data=$lb(adm,date,$g(dep),$g(doc),$g(reason),flag)
 	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod findadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findadmExecute ]
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

Query findadm(papno As %String) As %Query(ROWSPEC = "Tadm:%String,Tdate:%String,Tdep:%String,Tloc:%String,Treason:%String,Tflag:%String")
{
}

ClassMethod findadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findacoeExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
  
   
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s adm=$g(adm)  
	s adm=$tr(adm," ")
	if (adm="")   s qHandle=$lb(0,repid,0)   quit $$$OK
	s:($g(reasid)="")&($d(^PAADM(adm))) reasid=$p($g(^PAADM(adm,1)),"^",7)
	if (reasid="")   s qHandle=$lb(0,repid,0)   quit $$$OK
	
	s oeid=$o(^OEORD(0,"Adm",adm,""))
	i oeid=""  s qHandle=$lb(0,repid,0)   quit $$$OK
	s item=""
	f  s item=$o(^OEORD(oeid,"I",item)) q:item=""  d
	.s oecheck="N"
	.q:'$d(^OEORD(oeid,"I",item))
	.s billed=$p($g(^OEORD(oeid,"I",item,3)),"^",5)
	.q:billed["P"
	.s stat=$p($g(^OEORD(oeid,"I",item,1)),"^",13)
	.s statcode=$p($g(^OEC("OSTAT",+stat)),"^") 
	.q:((statcode="D")||(statcode="I"))
	.s rowid=oeid_"||"_item
	.s dhcoe=$o(^DHCORDItem(0,rowid,""))
	.s appflag=""
	.s:(dhcoe'="")&&($d(^DHCORDItem(dhcoe))) appflag=$p(^DHCORDItem(dhcoe,2),"^",1)
	.q:$g(appflag)["Y"
	.s itmast=$p($g(^OEORD(oeid,"I",item,1)),"^",2)
	.s oereas=$p($g(^OEORD(oeid,"I",item,11)),"^",18)
	.q:(oereas="")||('$d(^DHCOPApproved(0,"OrdAppAR",reasid,oereas)))
	.s taritm=""
	.f  s taritm=$o(^DHCOLT(0,"ARTTA",itmast,taritm))  q:((taritm="")||(oecheck="Y"))  d
	..s stdate=""
	..s tarid=""
	..f  s stdate=$o(^DHCOLT(0,"ARTTA",itmast,taritm,stdate))  q:((stdate>+$h)||(stdate="")||($g(tarid)'=""))  d
	...s link=""
	...f  s link=$o(^DHCOLT(0,"ARTTA",itmast,taritm,stdate,link))  q:((link="")||($g(tarid)'=""))  d
	....q:'$d(^DHCOLT(link))
	....s enddate=$p($g(^DHCOLT(link)),"^",5)
	....q:((enddate'="")&&(+enddate<+$h))
	....s tarid=taritm
	....s:((tarid'="")&&($d(^DHCTARI(tarid)))) trasub=$p($p($g(^DHCTARI(tarid)),"^",4),$c(1))
	..q:$g(trasub)=""
	..s opa=""
	..f  s opa=$o(^DHCOPApproved(0,"OrdAppAR",reasid,oereas,opa))  q:((opa="")||(oecheck="Y"))  d
	...q:'$d(^DHCOPApproved(opa)) 
	...s apprto=$p($g(^DHCOPApproved(opa)),"^",6)
	...q:(apprto'="")&&(+apprto<+$h)
	...s ac=$p($p($g(^DHCOPApproved(opa)),"^",4),$c(1)) 
	...s ac=$tr(ac," ")

	...q:((ac'="")&(($g(trasub)="")||('$d(^DHCOPAppCon(0,"SubCate",trasub,ac)))))
	...s:$d(^DHCOPAppCon(ac)) appcnto=$p($g(^DHCOPAppCon(ac)),"^",4)
	...q:($g(appcnto)'="")&&(+appcnto<+$h)
	...s oecheck="Y"
	...s doc=$p($g(^OEORD(oeid,"I",item,1)),"^",11)
	...s:((doc'="")&&($d(^CTPCP(doc)))) doc=$p($g(^CTPCP(doc,1)),"^",2)
	...s dep=$p($g(^OEORD(oeid,"I",item,3)),"^",6)
	...s:((dep'="")&&($d(^CTLOC(dep)))) dep=$p($g(^CTLOC(dep)),"^",2)
	...s oedate=$p($g(^OEORD(oeid,"I",item,3)),"^",7)
	...s:oedate'="" oedate=$zd(oedate,4)
	...s stdate=$p($g(^OEORD(oeid,"I",item,1)),"^",9)
	...s price=$p($g(^OEORD(oeid,"I",item,3)),"^",25)
	...s epitype=$p($g(^PAADM(adm,1)),"^",6)
	...s oeprice=##class(web.UDHCJFPRICE).GetOrderPrice(epitype,reasid,itmast,stdate,"","","",price)
	...s oeprice=+$p(oeprice,"^",1)
	...s billuom=$p($g(^ARCIM(+itmast,$p(itmast,"||",2),8)),"^",14)    
	...s:+billuom'=0 buomcod=$p($g(^CT("UOM",billuom)),"^")
	...s arcgrp=$p($g(^ARCIM(+itmast,$p(itmast,"||",2),1)),"^",10) 
	...s itmdes=$p($g(^ARCIM(+itmast,$p(itmast,"||",2),1)),"^",2)                             
	...s ordCateType=$p($g(^ARC("IC",arcgrp)),"^",7)     
	...s qty=##class(web.UDHCJFBILL).GetBillQtyO(rowid,$g(statcode),$g(buomcod),arcgrp,ordCateType,itmast)
	...s:qty'="" amt=(+$g(oeprice))*(+qty)
	...s AppConStr=##class(web.UDHCOPOrdApproved).GetAppConStr(ac,+$H)
	...s MinAmt=+$p(AppConStr,$c(3),1)
	...q:oeprice'>MinAmt
	...s oeprice=$j(oeprice,3,2)
	...d outputrow8
	 
   
    
    s qHandle=$lb(0,repid,0)
	quit $$$OK
   

outputrow8
	set Data=$lb(rowid,itmdes,oedate,doc,dep,$g(amt),oeprice,qty)
 	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod findacoeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findacoeExecute ]
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

Query findacoe(adm As %String) As %Query(ROWSPEC = "Toeitm:%String,Titmdes:%String,Toedate:%String,Tdoc:%String,Tdep:%String,Tamt:%String,Tprice:%String,Tqty:%String")
{
}

ClassMethod findacoeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findacoeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPatInfo(RegNo)
{
	n (RegNo)
	s RegNo=$g(RegNo)
	s rtn=""
	q:RegNo="" rtn
	s RegNo=..regnocon(RegNo)
	s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	q:papmi="" rtn
	s PatName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	s PatAdm="",AdmReasonDesc="",AdmDate="",AdmLoc="",AdmDoc="",AdmType=""
	s find=0
	s type=""
	f  s type=$o(^PAPERdr(papmi,"ADM",type),-1) q:(type="")!(find=1)  d
	.q:type="I"
	.s adm=""
	.f  s adm=$o(^PAPERdr(papmi,"ADM",type,adm),-1) q:(adm="")!(find=1)  d
	..;s AdmType=$p(^PAADM(adm),"^",2)
	..;q:AdmType="I"
	..s VisitStatus=$p($g(^PAADM(adm)),"^",20)
	..q:VisitStatus="C"
	..;
	..s AdmType=type
	..s AdmReason=$p($g(^PAADM(adm,1)),"^",7)
	..q:AdmReason=""
	..q:'$d(^DHCOPApproved(0,"OrdAppAR",AdmReason))
	..s PatAdm=adm,find=1
	..s AdmReasonDesc=$p($g(^PAC("ADMREA",AdmReason)),"^",2)
	..s AdmDate=$p($g(^PAADM(PatAdm)),"^",6)
	..i AdmDate'="" s AdmDate=$zd(AdmDate,4)
	..s AdmLoc=$p($g(^PAADM(PatAdm)),"^",4)
	..i AdmLoc'="" s AdmLoc=$p($g(^CTLOC(AdmLoc)),"^",2)
	..i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
	..s AdmDoc=$p($g(^PAADM(PatAdm)),"^",9)
	..i AdmDoc'="" s AdmDoc=$p($g(^CTPCP(AdmDoc,1)),"^",2)
	s rtn=PatAdm_"^"_AdmDate_"^"_AdmLoc_"^"_AdmDoc_"^"_AdmReasonDesc_"^"_AdmType_"^"_RegNo_"^"_PatName
	q rtn
}

ClassMethod regnocon(regno1 As %String) As %String
{
	q:regno1=""
	s reglen=$l(regno1)
	f i=reglen:1:7  d
	.s regno1="0"_regno1
	q regno1
}

}
