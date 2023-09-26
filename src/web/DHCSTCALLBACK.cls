Include webimport

IncludeGenerator webimport

Class web.DHCSTCALLBACK Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod CallbackCollectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CallbackCollectExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod CallbackCollectExecute(ByRef qHandle As %Binary, CallbackNo As %String, wardid As %String, StartDate As %String, EndDate As %String, ackflag As %String, displocid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
	;n (CallbackNo,wardid,StartDate,EndDate,AckFlag)
	
 ;s ^TMP("uuu")=CallbackNo_"^"_wardid_"^"_StartDate_"^"_EndDate_"^"_ackflag_"^"_displocid
	;d ResetVariables
	//实现；
 f date=StartDate:1:EndDate  d
 .
 .s warddr=""
 .f  s warddr=$o(^DHCPCB(0,"CreateDate",date,"Ward",warddr)) q:warddr=""  d
 ..q:(wardid'="")&(warddr'=wardid)
 ..
 ..d ResetVariables
 ..s dhcpcid=""
 ..f  s dhcpcid=$o(^DHCPCB(0,"CreateDate",date,"Ward",warddr,dhcpcid)) q:dhcpcid=""  d
 ...
 ...
 ...s number=$p(^DHCPCB(dhcpcid),"^",1)
 ...q:(CallbackNo'="")&(number'=CallbackNo)
 ...
 ...s tmpackflag=$p(^DHCPCB(dhcpcid),"^",7)
 ...i tmpackflag="" s tmpackflag="N"   
 ...q:(ackflag'="")&(tmpackflag'=ackflag)
 ...
 ...s disploc=$p(^DHCPCB(dhcpcid),"^",9)
 ...q:(displocid'="")&(disploc'=displocid)
 ...i disploc'="" s locdesc=$p(^CTLOC(disploc),"^",2)
 ...s createuser=$p(^DHCPCB(dhcpcid),"^",4)
 ...i createuser'="" s userdesc=$p(^SSU("SSUSR",createuser),"^",2)
 ...s createdate=$p(^DHCPCB(dhcpcid),"^",3)
 ...s ackdate=$p(^DHCPCB(dhcpcid),"^",6)
 ...i ackdate'="" s ackdate=$zd(ackdate,3)
 ...s ackuser=$p(^DHCPCB(dhcpcid),"^",5)
 ...i ackuser'="" s ackuserdesc=$p(^SSU("SSUSR",ackuser),"^",2)
 ...s ward=$p(^PAWARD(warddr),"^",2)
 ...
 ...s printedflag=$p(^DHCPCB(dhcpcid),"^",8)
 ...
 ...d OutputRow
 .
	Quit $$$OK
	
OutputRow
	set Data=$lb(number,locdesc,ward,$zd(createdate,3),userdesc,ackdate,ackuserdesc,dhcpcid,printedflag,disploc)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
	
ResetVariables
	set (number,locdesc,ward,createdate,userdesc,ackdate,ackuserdesc,dhcpcid,printedflag,disploc)=""
	quit
}

ClassMethod CallbackCollectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CallbackCollectExecute ]
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

Query CallbackCollect(CallbackNo As %String, wardid As %String, StartDate As %String, EndDate As %String, ackflag As %String, displocid As %String) As %Query(ROWSPEC = "TCallbackNo:%String,TDispLoc:%String,TWard:%String,TCallbackDate:%String,TCallbackUser:%String,TAckDate:%String,TAckUser:%String,TMainId:%String,TPrintedFlag:%String,TDispLocRowid:%String")
{
}

ClassMethod CallbackItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CallbackItmExecute ]
{
		Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CallbackItmExecute(ByRef qHandle As %Binary, dhcpcdr As %String) As %Status
{
	 
	 n (qHandle,dhcpcdr)	 
	 Set repid=$I(^CacheTemp)
		Set qHandle=$lb(0,repid,0)
		Set ind=1
	
	 d ResetVariablesItm
	 
		//实现；
		s chl=""
		i dhcpcdr'="" d
		.f  s chl=$o(^DHCPCB(0,"ParRef",dhcpcdr,"ChildSub",chl)) q:chl=""  d
		..s data=^DHCPCB(dhcpcdr,"I",chl)
		..s incdr=$p(data,"^",3) q:incdr=""
		..s inci=$p(^INCI(incdr,1),"^",2)
		..s form=##class(web.DHCSTCOMMONSRV).GetForm(incdr)
	 ..s barcode=##class(web.DHCSTCOMMONSRV).getBarcode(incdr)
	 ..s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(incdr)
		..
		..s uomdr=$p(data,"^",4) q:uomdr=""
		..s uom=$p(^CT("UOM",uomdr),"^",2)
		..s qty=$p(data,"^",5)
		..s price=$p(data,"^",6)
		..s amt=qty*price
		..s dhcpci=dhcpcdr_"||"_chl
	 ..d OutputRowItm
	 .
	 
	 i ind=1 d OutputRowItm
	 
	 Quit $$$OK
	
OutputRowItm
	 set Data=$lb(incdr,inci,barcode,form,manf,uom,qty,price,amt,dhcpci)
		Set ^CacheTemp(repid,ind)=Data	
		Set ind=ind+1

	 quit
	
ResetVariablesItm
	 set (incdr,inci,barcode,form,manf,uom,qty,price,amt)=""
	 quit
}

ClassMethod CallbackItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CallbackItmExecute ]
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

ClassMethod CallbackQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CallbackQueryExecute ]
{
		Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SaveData(DispLocID As %String, WardID As %String, UserId As %String, DetailStr As %String, Dhcpcdr As %String) As %String
{
	
	n (DispLocID,WardID,UserId,DetailStr,Dhcpcdr)

	//q:DispLocID="" ""
	//q:WardID="" ""
  
 q:(DispLocID="")&(WardID="")&(Dhcpcdr="") ""
 
 //i $f(DetailStr,"||") s cnt=$l(DetailStr,"||")
	//e  d
	//.s cnt=1
	//.s DetailStr=DetailStr_"||"
	
	s dhcpcrowid=$g(Dhcpcdr)
	i dhcpcrowid="" s dhcpcrowid=$$CreatePhaCallback()
	q:dhcpcrowid=-1 ""

 s i=0
	
	s cnt=$l(DetailStr,"&")   //总记录条数
	
	f num=1:1:cnt  d
	.s detail=$p(DetailStr,"&",num)
	.
	.s incdr=$p(detail,"^",1)
	.s qty=$p(detail,"^",2)
	.s dhcpci=$p(detail,"^",3)
	.s uomdr=$p(^INCI(incdr,1),"^",10)
	.s price=##class(web.DHCSTPCHCOLLS).getprice(incdr,+$h)
 .
 .k PLIST
	.
 .i dhcpci'="" d
 ..&sql(select * into :PLIST() from dhc_phacallbackitm where dhcpci_rowid=:dhcpci)
 .e  d
 ..s PLIST(0)=$g(dhcpcrowid)
 ..s PLIST(9)=$o(^DHCPCB(dhcpcrowid,"I",""),-1)+1
	.
	.s PLIST(3)=$g(incdr)
	.s PLIST(4)=$g(uomdr)
	.s PLIST(5)=+$g(qty)
	.s PLIST(6)=+$g(price)
	.s PLIST(8)=+$g(qty)
	.
	.
	.i dhcpci="" d
	..&sql(INSERT INTO DHC_PhaCallbackItm VALUES PLIST())
	.e  d
	..;&sql(update DHC_PhaCallbackItm set dhcpci_qty=:qty where dhcpci_rowid=:dhcpci)
	..&sql(update DHC_PhaCallbackItm  values :PLIST() where dhcpci_rowid=:dhcpci )
	.s ^TMP("uuu")=SQLCODE
	.s i=i+1
	.
	
	i (i=0)&(dhcpcrowid>0) d
	.&sql(delete from DHC_PhaCallback where DHCPC_rowid=:dhcpcrowid )
	
	q:i=0 ""
	q $g(dhcpcrowid)_"^"_$g(callbackno)
	
CreatePhaCallback()
 k PLIST
 l +^STLOCK("CreateCallbackCode"):10
 e  q -100
 s callbackno=..GetCallbackNo($g(WardID))
	s PLIST(2)=callbackno
	s PLIST(3)=WardID
	s PLIST(4)=+$h
	s PLIST(5)=$g(UserId)
	s PLIST(8)="N"
	s PLIST(9)=0
	s PLIST(10)=$g(DispLocID)
	
	&sql(INSERT INTO DHC_PhaCallback VALUES :PLIST())
	l -^STLOCK("CreateCallbackCode")
	;i SQLCODE'=0 w !,$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)
	q:SQLCODE -1
 q +$g(%ROWID)
}

ClassMethod CallbackQueryExecute(ByRef qHandle As %Binary, displocid As %String, wardid As %String) As %Status
{
	 n (qHandle,displocid,wardid)	 
	 Set repid=$I(^CacheTemp)
		Set qHandle=$lb(0,repid,0)
		Set ind=1
		
		q:displocid="" $$$OK
		q:wardid="" $$$OK
		
	 d ResetVariablesQuery
	 
		//实现；
		s dhcpcdr=0
		f  s dhcpcdr=$o(^DHCPCB(0,"DispLocWard",displocid,wardid,dhcpcdr)) q:dhcpcdr=""  d
		.s chl=0
		.s ackflag=$p(^DHCPCB(dhcpcdr),"^",7)
		.q:ackflag="N"
		.f  s chl=$o(^DHCPCB(0,"ParRef",dhcpcdr,"ChildSub",chl))  q:chl=""  d
		..s data=^DHCPCB(dhcpcdr,"I",chl)
		..s incdr=$p(data,"^",3) q:incdr=""
		..s inci=$p(^INCI(incdr,1),"^",2)
		..s form=##class(web.DHCSTCOMMONSRV).GetForm(incdr)
	 ..s barcode=##class(web.DHCSTCOMMONSRV).getBarcode(incdr)
	 ..s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(incdr)
		..
		..s uomdr=$p(data,"^",4) q:uomdr=""
		..s uom=$p(^CT("UOM",uomdr),"^",2)
		..;s qty=$p(data,"^",5)
		..s presdr=$o(^DHCPRES(0,"LOCINCIWARD",displocid,incdr,wardid,"")) q:presdr=""
		..s resqty=$p(^DHCPRES(presdr),"^",4)
		..
		..i '$d(^DHCPCBTMP(repid,"INCI",incdr)) d
		...s ^DHCPCBTMP(repid,"INCI",incdr)=incdr_"^"_inci_"^"_barcode_"^"_manf_"^"_resqty_"^"_uom_"^"_form
	 ..
	 .
	 
	 s incrowid=0
	 f  s incrowid=$o(^DHCPCBTMP(repid,"INCI",incrowid))  q:incrowid=""  d
	 .s data=^DHCPCBTMP(repid,"INCI",incrowid)
	 .s incdr=$p(data,"^",1)
	 .s incdesc=$p(data,"^",2)
	 .s barcode=$p(data,"^",3)
	 .s manf=$p(data,"^",4)
	 .s resqty=$p(data,"^",5)
	 .s uom=$p(data,"^",6)
	 .s form=$p(data,"^",7)
	 .
	 . d OutputRowQuery
	 
	 Quit $$$OK
	
OutputRowQuery
	 set Data=$lb(incdr,incdesc,barcode,manf,resqty,uom,form)
		Set ^CacheTemp(repid,ind)=Data	
		Set ind=ind+1

	 quit
	
ResetVariablesQuery
	 set (incdr,incdesc,barcode,manf,resqty,uom,form)=""
	 quit
}

ClassMethod UpdateAckflag(dhcpcdr As %Library.String, userid As %Library.String) As %String
{
	
	n (itmjs,itmjsex,dhcpcdr,userid)
	q:dhcpcdr="" ""
 q:$p($g(^DHCPCB(dhcpcdr)),"^",7)="Y" 0

 q:..LkMain(dhcpcdr)<0 -100
	//l +^STLOCK("CallBackAck",dhcpcdr):10 e  q -100
 //i $p($g(^DHCPCB(dhcpcdr)),"^",7)="Y" d UnLockAck
 //q:$p($g(^DHCPCB(dhcpcdr)),"^",7)="Y" 0
 
 s ackdate=+$h
 s ackflag="Y"
 s err=0
 
 tstart
	&sql(update DHC_PhaCallback set dhcpc_ackdate=:ackdate,dhcpc_ackuser=:userid,dhcpc_ackflag=:ackflag
	where dhcpc_rowid=:dhcpcdr)
	i SQLCODE'=0 s err=1
	i err=1 trollback
	i err=1 d ..ULkMain(dhcpcdr)
	q:err=1 -2
	s ret=..SaveDatoToReserve(dhcpcdr)
	i ret=1 trollback
	q:ret=1 -3
	i err=1 d ..ULkMain(dhcpcdr)
	tcommit
	d ..ULkMain(dhcpcdr)
	q 1
}

ClassMethod CallbackQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CallbackQueryExecute ]
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

ClassMethod SaveDatoToReserve(dhcpcdr As %Library.String) As %String
{
	
	n (dhcpcdr)

	q:dhcpcdr="" 0
 s err=0
 s chl=0
 
 f  s chl=$o(^DHCPCB(0,"ParRef",dhcpcdr,"ChildSub",chl)) q:(chl="")!(err=1)  d
 .s incdr=$p(^DHCPCB(dhcpcdr,"I",chl),"^",3) q:incdr=""
 .s qty=$p(^DHCPCB(dhcpcdr,"I",chl),"^",5)
 .s disploc=$p(^DHCPCB(dhcpcdr),"^",9)
 .s ward=$p(^DHCPCB(dhcpcdr),"^",2)
 .i $d(^DHCPRES(0,"LOCINCIWARD",disploc,incdr,ward))  d
 ..s dhcpres=$o(^DHCPRES(0,"LOCINCIWARD",disploc,incdr,ward,0))
 ..
 ..&sql(update DHC_PhaReserve set pres_resqty=pres_resqty+:qty	where pres_rowid=:dhcpres)
	..i SQLCODE'=0  s err=1
	.e  d
	..k PLIST
	..s PLIST(2)=disploc
	..s PLIST(3)=incdr
	..s PLIST(4)=qty
	..s PLIST(5)=ward
	..
	..&sql(INSERT INTO DHC_PhaReserve VALUES :PLIST())
	..i SQLCODE'=0  s err=1
 .
 q err
}

Query CallbackItm(dhcpcdr As %String) As %Query(ROWSPEC = "TInciRowid:%String,TInci:%String,TBarCode:%String,TForm:%String,TManf:%String,TUom:%String,TQty:%String,TPrice:%String,TAmt:%String,TRowid:%String")
{
}

ClassMethod GetCallbackNo(ward As %String) As %String
{
  n (ward)
  s dhcpc=$o(^DHCPCB(0,"CreateDate",+$h,"Ward",ward,""),-1)
  i dhcpc="" d   
  . s maxno=0
 	e  d
 	. s no=$p(^DHCPCB(dhcpc),"^",1)
  . s maxno=+$e(no,$l(no)-3,$l(no))
  s maxno=maxno+1
  s date=$zd(+$h,8)
  s date=$e(date,3,$l(date))
  s newno="HSD"_date_$tr($j(maxno,4)," ","0")
  q newno
}

ClassMethod DeleteMain(dhcpcdr As %Library.String) As %String
{
	n ( dhcpcdr)
	q:dhcpcdr="" ""
 q:'$d(^DHCPCB(dhcpcdr)) ""
 s ackflag=$p(^DHCPCB(dhcpcdr),"^",7) 
	q:ackflag="Y" 0
 q:..LkMain(dhcpcdr)<0
	&sql(delete from DHC_PhaCallback where dhcpc_rowid=:dhcpcdr)
	i SQLCODE  d ..ULkMain(dhcpcdr) 
	q:SQLCODE ""
	d ..ULkMain(dhcpcdr) 
	q 1
}

/*
ClassMethod DeleteDetail(itmjs As %Library.String = "", itmjsex As %Library.String = "", dhcpcdr As %Library.String, incdr As %Library.String) As %String
{
	
	n (itmjs,itmjsex,dhcpcdr,incdr)

	q:dhcpcdr="" ""
	q:incdr="" ""
	
 s ackflag=$p(^DHCPCB(dhcpcdr),"^",7) 
 q:ackflag="Y" 0
 
	&sql(delete from DHC_PhaCallbackItm where dhcpci_dhcpc_parref=:dhcpcdr and dhcpci_inci_dr=:incdr)
	q:SQLCODE ""
	
	q 1
}
*/
ClassMethod DelCallBackItm(dhcpci As %String) As %String
{
	//根据子表的rowid ,予以删除
	q:dhcpci="" 1
	q:$g(^DHCPCB(+dhcpci))=""
 s ackflag=$p($g(^DHCPCB(+dhcpci)),"^",7) 
 q:ackflag="Y" 0
	q:..LkMain(+dhcpci)<0 -100
	&Sql(delete from DHC_PhaCallbackItm where dhcpci_rowid=:dhcpci)
	d ..ULkMain(+dhcpci)
	i SQLCODE q -1
	q 1
}

Query CallbackQuery(displocid As %String, wardid As %String) As %Query(ROWSPEC = "TInciRowid:%String,TInci:%String,TBarCode:%String,TManf:%String,TQty:%String,TUom:%String,TForm:%String")
{
}

ClassMethod GetLocType(itmjs As %Library.String = "", itmjsex As %Library.String = "", locdr As %String) As %String
{
	n (itmjs,itmjsex,locdr)
	s type=$p(^CTLOC(locdr),"^",13)
	s desc=$p(^CTLOC(locdr),"^",2)
	i type="W" d
	.s warddr=$o(^PAWARD(0,"WARD_LocationDR",locdr,""))
	.s ward=$p(^PAWARD(warddr),"^",2)
	s result=type_"^"_desc_"^"_$g(warddr)_"^"_$g(ward)
 q result
}

ClassMethod GetPrintFlag(itmjs As %Library.String = "", itmjsex As %Library.String = "", callbackno As %String) As %String
{
	n (itmjs,itmjsex,callbackno)
	q:callbackno ""
	s dhcpcdr=$o(^DHCPCB(0,"CallbackNo",callbackno,"")) q:dhcpcdr="" ""
	s printflag=$p(^DHCPCB(dhcpcdr),"^",8)
 q printflag
}

ClassMethod SetPrintFlag(itmjs As %Library.String = "", itmjsex As %Library.String = "", callbackno As %String) As %String
{
	n (itmjs,itmjsex,callbackno)
	q:callbackno ""
	s dhcpcdr=$o(^DHCPCB(0,"CallbackNo",callbackno,"")) q:dhcpcdr="" ""
	&sql(update DHC_PhaCallback set dhcpc_printflag=1	where dhcpc_rowid=:dhcpcdr)
	q:SQLCODE ""
	
	q 1
}

ClassMethod LkMain(dhccb As %String) As %String
{
	l +^STLOCK("CallBack",dhccb):10 e  q -100
	q 1
}

ClassMethod ULkMain(dhccb As %String)
{
	l -^STLOCK("CallBack",dhccb)
}

}
