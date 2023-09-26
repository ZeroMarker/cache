Import SQLUser

Class web.DHCSTDISPSTAT2 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GroupLoc(input As %String) As %SQLQuery(CONTAINID = 1)
{
	select ctloc_desc,CTLOC_RowID From CT_LOC 
	where CTLOC_Type='D' and  %ALPHAUP(ctloc_desc) %STARTSWITH %ALPHAUP(:input) order by ctloc_desc
}

ClassMethod GetLocFromWard(wardid As %String) As %String
{
	;有病区rowid 得到对应的科室ROWID
	;n subdr,locdesc
	s locdesc=""
	q:$g(wardid)="" ""
	q:'$d(^PAWARD(wardid,"WBALL")) ""
	s subdr=0  f  s subdr=$o(^PAWARD(wardid,"WBALL",subdr)) q:subdr=""  d
	.s WardLocDr=$p(^PAWARD(wardid,"WBALL",subdr),"^",2)
	.q:'$d(^CTLOC(WardLocDr))
	.s locdesc1=$p(^CTLOC(WardLocDr),"^",2)
	.s locdesc=locdesc_" "_locdesc1
	q $g(locdesc)
}

ClassMethod ListDispItm(n)
{
	q ^WARDQUERYPLIST($j,n)
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTDISPSTAT2","GetCollectdata")
Query GetCollectdata(datef As %Date, datet As %Date, timef As %Time, timet As %Time, INCI As %String, RegNO As %String, ward As %String, DispLoc As %String, DistCatCode As %String, poisonrowid As %String, Name As %String) As %Query(ROWSPEC = "Tregno:%String,Tname:%String,Tbed:%String,Tadmloc:%String,Tincicode:%String,Tincidesc:%String,Tuomdesc:%String,Tqty:%String,Tprice:%String,Tamt:%String,Tprescno:%String,Tdoseqty:%String,Tdoseuom:%String,Tdisploc:%String,Tcollectdate:%String,Tcollecttime:%String,TGeneric:%String,TForm:%String,TBarCode:%String,TDiagnose:%String,TOrdTime:%String,Tmanf:%String,Tphatime:%String")
{
}

ClassMethod GetCollectdataExecute(ByRef qHandle As %Binary, datef As %Date, datet As %Date, timef As %Time, timet As %Time, INCI As %String, RegNO As %String, ward As %String, DispLoc As %String, DistCatCode As %String, poisonrowid As %String, Name As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:ward="" $$$OK
	s datef=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(datef)
	s datet=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(datet)
	s timef=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(timef)
	s timet=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(timet)
	s cnt=..GetColldata(datef,datet,timef,timet,INCI,RegNO,ward,DispLoc,DistCatCode,poisonrowid,Name)
	f i=1:1:cnt d
	.s data=..ListDispItm(i)
	.s patno=$p(data,"^",1)
	.s patname=$p(data,"^",2)
	.s bed=$p(data,"^",3)
	.s admloc=$p(data,"^",4)
	.s admloc=$p(admloc,"-",2)
	.s incicode=$p(data,"^",5)
	.s incidesc=$p(data,"^",6)
	.s uomdesc=$p(data,"^",7)
	.s qty=$p(data,"^",8)
	.s sprice=$p(data,"^",9)
	.s amt=$p(data,"^",10)
	.s prescno=$p(data,"^",11)
	.s dosegeqty=$p(data,"^",12)
	.s doseuom=$p(data,"^",13)
	.s tmpLoc=$p(data,"^",14)
	.s colldate=$p(data,"^",15)
	.s colltime=$p(data,"^",16)
	.s generic=$p(data,"^",17)
	.s form=$p(data,"^",18)
	.s Specifaction=$p(data,"^",19)
	.s diagnose=$p(data,"^",20)
	.s ordtime=$p(data,"^",21)
	.s manf=$p(data,"^",22)
	.s manf=$p(manf,"-",2)
	.s phatime=$p(data,"^",23)
	.d outputrowx
	 k ^WARDQUERYPLIST($j)
	Quit $$$OK
outputrowx
	 ; "Tregno:%String,Tname:%String,Tbed:%String,Tadmloc:%String,Tincicode:%String,Tincidesc:%String,Tuomdesc:%String,Tqty,Tprice:%String,Tamt:%String,Tprescno:%String,Tdoseqty:%String,Tdoseuom:%String,Tdisploc:%String"
	set Data=$lb(patno,patname,bed,admloc,incicode,incidesc,uomdesc,qty,sprice,amt,prescno,dosegeqty,doseuom,tmpLoc,colldate,colltime,generic,form,Specifaction,diagnose,ordtime,manf,phatime)
    Set ^CacheTemp(repid,ind)=Data	
    Set ind=ind+1
 	q
}

/// w ##class(web.DHCSTDISPSTAT2).GetColldata
ClassMethod GetColldata(datef, datet, timef, timet, ItmDR, Regno, ward, DispLoc, DistCatCode, poisondr, paname)
{
	//s ^hlh($h)=$lb(datef, datet, timef, timet, ItmDR, Regno, ward, DispLoc, DistCatCode, poisondr, paname)
    k ^WARDQUERYPLIST($j)
	s ward=$g(ward)
	i (ward'="")&&(ward'=+ward) s ward=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(ward),"")) q:ward="" -1
	i ward'="" s WardLocDr=..GetLocFromWard(ward)
	S WardLocDr=$g(WardLocDr)
    s wardloc=$p(^PAWARD(ward),"^",5)
	s n=0
	s sumamt=0
	s phaloc="" f  s phaloc=$o(^DHCPHAC(0,"PHP",phaloc)) q:phaloc=""  d  	
	.s tmpLoc=$p(^CTLOC(phaloc),"^",2)
	.q:(DispLoc'="")&&(DispLoc=+DispLoc)&&(DispLoc'=phaloc)
	.q:(DispLoc'="")&&(DispLoc'=+DispLoc)&&(DispLoc'=tmpLoc)
	.f date=datef:1:datet  d
	..s coll="" f  s coll=$o(^DHCPHAC(0,"PHP",phaloc,"DATE",date,coll)) q:coll=""  d
	...s colltime=$p(^DHCPHAC(coll),"^",3)
	...i (timef'="")&(date=datef) q:(colltime<timef)
	...i (timet'="")&(date=datet) q:(colltime>timet)		;按时间段检索
	...s collward=$p(^DHCPHAC(coll),"^",4) 
	...s collward=$s(collward'="":$p(^PAWARD(collward),"^",5),1:##class(web.DHCSTPCHCOLLS).DocLoc(coll))
	...q:(wardloc'="")&&(collward'=wardloc)
	...s discode=$p(^DHCPHAC(coll),"^",12)
	...i DistCatCode'="" q:discode'=DistCatCode
	...;s datenum=..GETDATA(coll,datenum1,Regno,Desc,DispLoc)
	...s ch=""
	...f  s ch=$o(^DHCPHAC(coll,"I",ch)) q:ch=""  d
	....;<--放开此段代码则按病区查时，把医生科室回归各病区---------------
	....;i collward="" d
	....;.s phadmdr=$p(^DHCPHAC(coll,"I",ch),"^",3) ;admdr
	....;.s collward=$p(^PAADM(phadmdr),"^",70)
	....;----------------------------------> 
	....s inclb=$p(^DHCPHAC(coll,"I",ch),"^",4)
	....s inci=+inclb
	....
	....s strpoison=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)  ;zdm,2007-8-2
	....
	....i strpoison'="" s poisonrowid=$p(strpoison,"^",1)
	....e  s poisonrowid=""
	....q:(poisondr'="")&($g(poisonrowid)'=poisondr)
	....
	....i ItmDR'="" q:inci'=ItmDR			;  Inci Item
	....s adm=$p(^DHCPHAC(coll,"I",ch),"^",3)
	....s admloc=$p(^DHCPHAC(coll,"I",ch),"^",11)
	....i admloc'="" s admloc=$p(^CTLOC(+admloc),"^",2)
	....s papmi=$P(^PAADM(adm),"^",1)
	....s patno=$p(^PAPER(papmi,"PAT",1),"^",1) ;登记号
	....i Regno'="" q:patno'=Regno     							 ; patient no
	....
	....s name=$p(^PAPER(papmi,"ALL"),"^",1)		;zdm,2007-8-2
	....i paname'="" q:$f(name,paname)<1
	....
	....s xdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date)
	....s xtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($g(colltime))
	....s patname=$p(^PAPER(papmi,"ALL"),"^",1) ;   patient name
	....s oedis=$p(^DHCPHAC(coll,"I",ch),"^",7)
	....s bed=$p(^DHCPHAC(coll,"I",ch),"^",8)
	....s prescno=$p(^DHCPHAC(coll,"I",ch),"^",5) 
	....s ord=$p(oedis,"||",1)
	....s itm=$p(oedis,"||",2)
	....s dosegeqty=$p(^OEORD(ord,"I",itm,2),"^",1) 
	....s doseuom=$p(^OEORD(ord,"I",itm,2),"^",3)
	....i doseuom'="" s doseuom=$p($g(^CT("UOM",doseuom)),"^",2)   
	....s qty=$p(^DHCPHAC(coll,"I",ch),"^",6)
 	....s amt="",sprice=""
 	....s phaclb=""
 	....f  s phaclb=$o(^DHCPHAC(coll,"I",ch,"B",phaclb)) q:phaclb=""  d
	.....s phaclbdata=^(phaclb)
	.....s amt=amt+$p(phaclbdata,"^",6) 
	.....i sprice="" s sprice=$p(phaclbdata,"^",5) 
	....s sprice=$fn(sprice,"",4)
	....s incicode=$p(^INCI(inci,1),"^",1)
	....s incidesc=$p(^INCI(inci,1),"^",2)
	....s uom=$p(^INCI(inci,1),"^",10)
	....s uomdesc=$p(^CT("UOM",uom),"^",2)
	....s sumamt=$g(sumamt)+amt
	....
	....;2007-8-2,zdm,增加通用名,剂型,规格,诊断,开单时间
	....s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci)
	....s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)
	....s Specifaction=##class(web.DHCSTCOMMONSRV).getBarcode(inci)  //规格
	....s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")
	....s oeoridate=$p(^OEORD(ord,"I",itm,3),"^",7)
	....s timeord=$p(^OEORD(ord,"I",itm,1),"^",17)
	....s datetime=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(oeoridate)_" "_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(timeord)
	....s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家	
	....s phadate=$p(^DHCPHAC(coll),"^",2)
	....s phatime=$p(^DHCPHAC(coll),"^",3)
	....s datetime2=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phadate)_" "_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(phatime) ;发药时间	
	....s n=n+1
	....s ^WARDQUERYPLIST($j,n)=patno_"^"_patname_"^"_bed_"^"_admloc_"^"_incicode_"^"_incidesc_"^"_uomdesc_"^"_qty_"^"_sprice_"^"_$fn(amt,"",2)_"^"_prescno_"^"_dosegeqty_"^"_doseuom_"^"_tmpLoc_"^"_xdate_"^"_xtime_"^"_generic_"^"_form_"^"_Specifaction_"^"_diagnose_"^"_datetime_"^"_manf_"^"_datetime2
	....
	s n=n+1
	s ^WARDQUERYPLIST($j,n)=""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_$fn(sumamt,"",2)_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"合计:"_"^"_""
	q n
}

ClassMethod GetCollectdataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCollectdataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCollectdataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCollectdataExecute ]
{
	
   Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod selectwardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = selectwardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod selectwardExecute(ByRef qHandle As %Binary, locid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1	
		//根据科室ID取病区
	s ^TMP("XXXXX")=locid
	q:locid="" $$$OK
	 ;k PLIST
	 ;s depid=""
	 ;s depdesc=$p(^CTLOC(locid),"^",2)
	; S depdesc=$P(depdesc,"-",2) 
	; S depid=$o(^RBC("DEP",0,"Desc",depdesc,""))
	 ;q:depid=""
	 ;s ctid="" f  s ctid=$o(^CTLOC(0,"DepGrp",depid,ctid)) q:ctid=""  d
	 ;.q:$p($g(^CTLOC(ctid)),"^",13)'="W"
	 ;.s i=i+1
	 ;.s locks=$p(^CTLOC(ctid),"^",2)
	 ;.d outputrow
	s locks=$p(^CTLOC(+locid),"^",2)
	d outputrow
	Quit $$$OK
outputrow
		set Data=$lb(locks)
 	    Set ^CacheTemp(repid,ind)=Data	
 	    Set ind=ind+1
 	q
}

ClassMethod selectwardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = selectwardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query selectward(locid As %String) As %Query(ROWSPEC = "ward:%String")
{
}

ClassMethod YPLX(code)
{
	s revalue=""
	i $g(code)="ZJ" d  s revalue="针剂"
	i $g(code)="DSY" d  s revalue="大输液"
	i $g(code)="WYY" d  s revalue="外用药"
	i $g(code)="DMY" d  s revalue="毒麻药"
	i $g(code)="PJ" d  s revalue="片剂"
	i $g(code)="ZCHY" d  s revalue="中成药"
	i $g(code)="ZCY" d  s revalue="中草药"
	q revalue
}

ClassMethod getDefaultLoc(loc As %String) As %String
{
	q:loc="" ""
	s locdesc=$p(^CTLOC(loc),"^",2)
	q locdesc
}

ClassMethod isWard(locid)
{
 ; check whether the loc is a ward ,if a ward then return desc,or return null
	q:locid="" ""
	&sql(select ctloc_desc,ctloc_type into :locdesc,:type
	 from ct_loc where ctloc_rowid=:locid)
	q:SQLCODE ""
	
	if type="W" q $g(locdesc)
	q ""
}

}
