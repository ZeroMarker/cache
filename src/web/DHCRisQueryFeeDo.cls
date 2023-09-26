Import SQLUser

Class web.DHCRisQueryFeeDo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 28;

ClassMethod GetPatientInfo(paadmdr) As %String
{
	s papatmasmdr=$p(^PAADM(paadmdr),"^",1)  
	s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",2)      
    s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
    s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
    s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
    s SexDesc=$p($g(^CT("SEX",SexDr)),"^",2)
    
    q RegNo_"^"_Name
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisQueryFeeDo","QueryExamFee","8","on","181")
Query QueryExamFee(paadmdr As %String, LocOEORDITEM As %String, LocID As %String) As %Query(ROWSPEC = "TStatus:%String,TItemName:%String,TDate:%String,TTime:%String,TNum:%String,TPrice:%String,TTotalPice:%String,TOrdStatus:%String,Titmprice:%String,Tqty:%String,Itmdesc:%String")
{
}

ClassMethod QueryExamFeeExecute(ByRef qHandle As %Binary, paadmdr As %String, LocOEORDITEM As %String, LocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	k ^DHCRIS("RISOLD")
    If $g(ind)="" Set ind=1
    if paadmdr="" 
    {
	   Set qHandle=$lb(0,repid,0)
	   Quit $$$OK
    }
    s ^iN=paadmdr_"^"_LocOEORDITEM_"^"_LocID
    i paadmdr'="" s patienttype=$p(^PAADM(paadmdr),"^",2)
    s TotalFee=0
    s OrderRowid=""
    s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
 	q:OrderRowid="" 
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)   ;
	.q:(LocOEORDITEM="on")&(reploc'=LocID)
	.s oeorditemdr=OrderRowid_"||"_itemsub 
	.s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.q:(arcimid="")
	.s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	.s instypedr=$p(^PAADM(paadmdr,1),"^",7) 
	.;s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
	.;s price=$p(priceinfo,"^",1)
	.s price=##class(web.DHCRisCommFunction).GetItemPrice(oeorditemdr)
	.s Num=$p($g(^OEORD(OrderRowid,"I",itemsub,9)),"^",4)
	.if Num="" s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
	.s TotalPrice=price*Num
	.s TotalFee=TotalFee+TotalPrice
	.i patienttype="I" d
	.s xrowid=$o(^OEORD(OrderRowid,"I",itemsub,"X",0))
	.i xrowid'="" d
	..s billed=$p(^OEORD(OrderRowid,"I",itemsub,"X",xrowid),"^",6) 
	..i billed'="" s billdesc=##class(web.DHCRisCommFunctionEx).GetBilledDesc(billed)
	.e  d
	..s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)
	..i billed'="" s billdesc=##class(web.DHCRisCommFunctionEx).GetBilledDesc(billed) 
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	.s strDate=$zd(Date1,3)
	.s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",10)
	.s strTime1=$zt(Time1,3)
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	.i $g(^OEC("OSTAT",ItemStatDR))'="" s ItemStatusDesc=$p(^OEC("OSTAT",ItemStatDR),"^",2)
	.s ExecuDate=""
	.f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",ExecuDate)) q:ExecuDate=""  d
	..q:(ExecuDate>SttDate)
	..s OLT=""
	..f  s OLT=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",ExecuDate,OLT)) q:OLT=""  d
    ...i ($g(^DHCRIS("RISOLD"))=arcimid) d
    ....s billdesc="",strOrderName="",strDate="",strTime1="",Num="",price="",TotalPrice="",ItemStatusDesc=""
	...s EndDate=$p(^DHCOLT(OLT),"^",5)
	...q:(EndDate<SttDate)&(EndDate'="")
	...s qty0="",Itm="",TariffDR="",Itmdesc=""
	...s qty0=$p(^DHCOLT(OLT),"^",3)
	...s Itm=$p(^DHCOLT(OLT),"^",2)
    ...s TariffDR=$p(^DHCOLT(OLT),"^",2)
    ...q:(TariffDR="")
	...s Itmdesc=$p(^DHCTARI(Itm),"^",2)
    ...s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","")
	...s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	...s ^DHCRIS("RISOLD")=arcimid
	...Do OutRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow3
  	set Data=$lb(billdesc,strOrderName,strDate,strTime1,Num,price,TotalPrice,ItemStatusDesc,$g(itmprice),$g(qty0),$g(Itmdesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^CacheTemp(repid,ind+1)=$lb("合计","","","","","",TotalFee,"")
  	Set ind=ind+1
	quit
}

ClassMethod QueryExamFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamFeeExecute ]
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

ClassMethod QueryExamFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
