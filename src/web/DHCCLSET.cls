Import SQLUser

Class web.DHCCLSET Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod SaveLongSet(Str)
{
	S ^TEMPSC("SaveLongSet")=Str
  //医嘱设置longstr+"!"+temstr+"!"+medcat+"!"+NotLoc+"!"+NotOrdCat+"!"+NotSordCat+"!"+ifstop.checked+"!"+ifnur.checked
  // n (Str)
	s longpri=$P(Str,"!",3)
	s TempPri=$P(Str,"!",2)
	s MedCat=$P(Str,"!",1)
	s NotLoc=$P(Str,"!",4)
	s NotOrdCat=$P(Str,"!",5)
	s ifstop=$P(Str,"!",7)
	s ifnur=$P(Str,"!",8)
	s NotSordCat=$P(Str,"!",6)
	s ifShowOrderGroupFlag = $P(Str,"!",9)
	s dateType =  $P(Str,"!",10)
	s timeType =  $P(Str,"!",11)
	
	s ifLongNextPage= $P(Str,"!",12) ;//长期医嘱单转科是换页
  	s ifLongRedLine=$P(Str,"!",13) ;//长期医嘱单转科是划线
  	s ifTempNextPage=$P(Str,"!",14) ;//临时医嘱单转科是换页
  	s ifTempRedLine=$P(Str,"!",15) ;//临时医嘱单转科是划线
  	
  	s ifLongOperNextPage= $P(Str,"!",16) ;//长期医嘱单手术是换页
  	s ifLongOperRedLine=$P(Str,"!",17) ;//长期医嘱单手术是划线
  	s ifTempOperNextPage=$P(Str,"!",18) ;//临时医嘱单手术是换页
  	s ifTempOperRedLine=$P(Str,"!",19) ;//临时医嘱单手术是划线
	s OperOrderArcimDr=$P(Str,"!",20) ;//医嘱单术后标志医嘱
	s OperOrderArcim=$P(Str,"!",21) ;//医嘱单术后标志医嘱
	
	s ifLongDeliverNextPage= $P(Str,"!",22) ;//长期医嘱单产后是换页
  	s ifLongDeliverRedLine=$P(Str,"!",23) ;//长期医嘱单产后是划线
  	s ifTempDeliverNextPage=$P(Str,"!",24) ;//临时医嘱单产后是换页
  	s ifTempDeliverRedLine=$P(Str,"!",25) ;//临时医嘱单产后是划线
	s DeliverOrderArcimDr=$P(Str,"!",26) ;//医嘱单产后标志医嘱
	s DeliverOrderArcim=$P(Str,"!",27) ;//医嘱单产后标志医嘱
	
	s ifLongReformNextPage= $P(Str,"!",28) ;//长期医嘱单转科是换页
  	s ifLongReformRedLine=$P(Str,"!",29) ;//长期医嘱单转科是划线
	s HospID=$P(Str,"!",30) 
	s ifTranslate=$P(Str,"!",31) //是否翻译
	i HospID'="" {	
		s ^DHCLONGSET("longprior",HospID)=longpri
		s ^DHCLONGSET("tempprior",HospID)=TempPri
		s ^DHCLONGSET("medcat",HospID)=MedCat
		S ^DHCOEOrdPrintSet("L","OrdTyp",HospID)=..GetPrior()
		S ^DHCOEOrdPrintSet("OrdCat",HospID)=..GetMedCat()
		s ^DHCOEOrdPrintSet("OrdTyp",HospID)=..GetTempPrior()
		s ^DHCOEOrdPrintSet("NotLoc",HospID)=..GetNotLoc(NotLoc)
		s ^DHCOEOrdPrintSet("NotOrdCat",HospID)=..GetNotLoc(NotOrdCat)
		s ^DHCOEOrdPrintSet("NotSordCat",HospID)=..GetNotLoc(NotSordCat)
		s ^DHCOEOrdPrintSet("ifstop",HospID)=ifstop
		s ^DHCOEOrdPrintSet("ifnur",HospID)=ifnur
		s ^DHCOEOrdPrintSet("ifShowOrderGroupFlag",HospID)=ifShowOrderGroupFlag
		s ^DHCOEOrdPrintSet("dateType",HospID)=dateType
		s ^DHCOEOrdPrintSet("timeType",HospID)=timeType
		
		s ^DHCOEOrdPrintSet("ifLongNextPage",HospID)=ifLongNextPage
		s ^DHCOEOrdPrintSet("ifLongRedLine",HospID)=ifLongRedLine
		s ^DHCOEOrdPrintSet("ifTempNextPage",HospID)=ifTempNextPage
		s ^DHCOEOrdPrintSet("ifTempRedLine",HospID)=ifTempRedLine
		
		s ^DHCOEOrdPrintSet("ifLongOperNextPage",HospID)=ifLongOperNextPage
		s ^DHCOEOrdPrintSet("ifLongOperRedLine",HospID)=ifLongOperRedLine
		s ^DHCOEOrdPrintSet("ifTempOperNextPage",HospID)=ifTempOperNextPage
		s ^DHCOEOrdPrintSet("ifTempOperRedLine",HospID)=ifTempOperRedLine
		s ^DHCOEOrdPrintSet("OperOrderArcimDr",HospID)=OperOrderArcimDr
		s ^DHCOEOrdPrintSet("OperOrderArcim",HospID)=OperOrderArcim
		
		s ^DHCOEOrdPrintSet("ifLongDeliverNextPage",HospID)=ifLongDeliverNextPage
		s ^DHCOEOrdPrintSet("ifLongDeliverRedLine",HospID)=ifLongDeliverRedLine
		s ^DHCOEOrdPrintSet("ifTempDeliverNextPage",HospID)=ifTempDeliverNextPage
		s ^DHCOEOrdPrintSet("ifTempDeliverRedLine",HospID)=ifTempDeliverRedLine
		s ^DHCOEOrdPrintSet("DeliverOrderArcimDr",HospID)=DeliverOrderArcimDr
		s ^DHCOEOrdPrintSet("DeliverOrderArcim",HospID)=DeliverOrderArcim
		
		s ^DHCOEOrdPrintSet("ifLongReformNextPage",HospID)=ifLongReformNextPage
		s ^DHCOEOrdPrintSet("ifLongReformRedLine",HospID)=ifLongReformRedLine
		s ^DHCOEOrdPrintSet("ifTranslate",HospID)=ifTranslate
	}
	q 0
}

ClassMethod GetPrior(HospID = "") As %String
{
	//n
	s ^tempsc("GetPrior")=HospID
	if $d(%session)&&($g(HospID)=""){
 		set HospID=%session.Get("LOGON.HOSPID")
	}
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_DHCOEOrdPrintSet",HospID)
  
	
	s num=$L(^DHCLONGSET("longprior",defHospID),"^")
	f i=1:1:num
	{
		s str=$P(^DHCLONGSET("longprior",defHospID),"^",i)
		s LPrior=$G(LPrior)_$P(str,"|",2)_"^"
		
	}
	q "^"_$G(LPrior)
}

ClassMethod GetTempPrior(HospID = "") As %String
{
	//n
	if $d(%session)&&($g(HospID)=""){
 		set HospID=%session.Get("LOGON.HOSPID")
	}
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_DHCOEOrdPrintSet",HospID)
  
	s num=$L(^DHCLONGSET("tempprior",defHospID),"^")
	f i=1:1:num
	{
		s str=$P(^DHCLONGSET("tempprior",defHospID),"^",i)
		s TempPrior=$G(TempPrior)_$P(str,"|",2)_"^"
		
	}
	q "^"_$G(TempPrior)
}

ClassMethod GetMedCat(HospID = "") As %String
{
   //n	
   if $d(%session)&&($g(HospID)=""){
 		set HospID=%session.Get("LOGON.HOSPID")
	}
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_DHCOEOrdPrintSet",HospID)
  
	s num=$L(^DHCLONGSET("medcat",defHospID),"^")
	f i=1:1:num
	{
		s str=$P(^DHCLONGSET("medcat",defHospID),"^",i)
		s catdr=$P(str,"|",1)
		q:catdr=""
		s catcode=$P(^OEC("ORCAT",catdr),"^",1)
		s medcat=$G(medcat)_catcode_"^"
	}
	q "^"_$G(medcat)
}

ClassMethod GetNotLoc(SelStr) As %String
{
   //n (SelStr)	
	s num=$L(SelStr,"^")
	f i=1:1:num
	{
		s str=$P(SelStr,"^",i)
		s dr=$P(str,"|",1)
		s redr=$G(redr)_dr_"^"
	}
	q:$G(redr)="" ""
	q "^"_$G(redr)
}

ClassMethod GetSetValue(HsopID = "")
{
	s ^tempsc("GetSetValue")=HsopID
	if $d(%session)&&(HsopID=""){
	 	;w "yiyuan:"_%session.Get("LOGON.HOSPID")
 		set HsopID=%session.Get("LOGON.HOSPID")
	}
	i HsopID'="" {
		s HsopID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_DHCOEOrdPrintSet",HsopID)
		q $G(^DHCOEOrdPrintSet("NotLoc",HsopID))_"!"_$G(^DHCOEOrdPrintSet("NotOrdCat",HsopID))_"!"_$G(^DHCOEOrdPrintSet("NotSordCat",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifstop",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifnur",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifShowOrderGroupFlag",HsopID))
		_"!"_$G(^DHCOEOrdPrintSet("dateType",HsopID))_"!"_$G(^DHCOEOrdPrintSet("timeType",HsopID))
		_"!"_$G(^DHCOEOrdPrintSet("ifLongNextPage",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifLongRedLine",HsopID))
		_"!"_$G(^DHCOEOrdPrintSet("ifTempNextPage",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifTempRedLine",HsopID))
		_"!"_$G(^DHCOEOrdPrintSet("ifLongOperNextPage",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifLongOperRedLine",HsopID))
		_"!"_$G(^DHCOEOrdPrintSet("ifTempOperNextPage",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifTempOperRedLine",HsopID))_"!"_$G(^DHCOEOrdPrintSet("OperOrderArcimDr",HsopID))_"!"_$G(^DHCOEOrdPrintSet("OperOrderArcim",HsopID))
		_"!"_$G(^DHCOEOrdPrintSet("ifLongDeliverNextPage",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifLongDeliverRedLine",HsopID))
		_"!"_$G(^DHCOEOrdPrintSet("ifTempDeliverNextPage",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifTempDeliverRedLine",HsopID))_"!"_$G(^DHCOEOrdPrintSet("DeliverOrderArcimDr",HsopID))_"!"_$G(^DHCOEOrdPrintSet("DeliverOrderArcim",HsopID))
		_"!"_$G(^DHCOEOrdPrintSet("ifLongReformNextPage",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifLongReformRedLine",HsopID))_"!"_$G(^DHCOEOrdPrintSet("ifTranslate",HsopID))
	}
	q ""
#;	q $G(^DHCOEOrdPrintSet("NotLoc"))_"!"_$G(^DHCOEOrdPrintSet("NotOrdCat"))_"!"_$G(^DHCOEOrdPrintSet("NotSordCat"))_"!"_$G(^DHCOEOrdPrintSet("ifstop"))_"!"_$G(^DHCOEOrdPrintSet("ifnur"))_"!"_$G(^DHCOEOrdPrintSet("ifShowOrderGroupFlag"))
#;	_"!"_$G(^DHCOEOrdPrintSet("dateType"))_"!"_$G(^DHCOEOrdPrintSet("timeType"))
#;	_"!"_$G(^DHCOEOrdPrintSet("ifLongNextPage"))_"!"_$G(^DHCOEOrdPrintSet("ifLongRedLine"))
#;	_"!"_$G(^DHCOEOrdPrintSet("ifTempNextPage"))_"!"_$G(^DHCOEOrdPrintSet("ifTempRedLine"))
#;	_"!"_$G(^DHCOEOrdPrintSet("ifLongOperNextPage"))_"!"_$G(^DHCOEOrdPrintSet("ifLongOperRedLine"))
#;	_"!"_$G(^DHCOEOrdPrintSet("ifTempOperNextPage"))_"!"_$G(^DHCOEOrdPrintSet("ifTempOperRedLine"))_"!"_$G(^DHCOEOrdPrintSet("OperOrderArcimDr"))_"!"_$G(^DHCOEOrdPrintSet("OperOrderArcim"))
#;	_"!"_$G(^DHCOEOrdPrintSet("ifLongDeliverNextPage"))_"!"_$G(^DHCOEOrdPrintSet("ifLongDeliverRedLine"))
#;	_"!"_$G(^DHCOEOrdPrintSet("ifTempDeliverNextPage"))_"!"_$G(^DHCOEOrdPrintSet("ifTempDeliverRedLine"))_"!"_$G(^DHCOEOrdPrintSet("DeliverOrderArcimDr"))_"!"_$G(^DHCOEOrdPrintSet("DeliverOrderArcim"))
#;	_"!"_$G(^DHCOEOrdPrintSet("ifLongReformNextPage"))_"!"_$G(^DHCOEOrdPrintSet("ifLongReformRedLine"))
}

ClassMethod GetLongPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLongPriorExecute ]
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

ClassMethod GetLongPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLongPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLongPriorExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^tempsc("GetPrior")=HospID
	if $d(%session)&&($g(HospID)=""){
 		set HospID=%session.Get("LOGON.HOSPID")
	}
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_DHCOEOrdPrintSet",HospID)
  
	
 	if '$D(^DHCLONGSET("longprior",defHospID)) Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	s num=$L(^DHCLONGSET("longprior",defHospID),"^")    

 	f i=1:1:num
 	{   s prior=$P(^DHCLONGSET("longprior",defHospID),"^",i)
	 	s rw=$P(prior,"|")
	 	s desc=$P(prior,"|",2)
	 	Do Outputcat1
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat1
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetLongPrior(HospID = "") As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetTempPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempPriorExecute ]
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

ClassMethod GetTempPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetTempPriorExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^tempsc("GetPrior")=HospID
	if $d(%session)&&($g(HospID)=""){
 		set HospID=%session.Get("LOGON.HOSPID")
	}
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_DHCOEOrdPrintSet",HospID)
  
	
 	if '$D(^DHCLONGSET("tempprior",defHospID))   Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	s num=$L(^DHCLONGSET("tempprior",defHospID),"^")
 	f i=1:1:num
 	{   s prior=$P(^DHCLONGSET("tempprior",defHospID),"^",i)
	 	s rw=$P(prior,"|")
	 	s desc=$P(prior,"|",2)
	 	Do Outputcat
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetTempPrior(HospID = "") As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetMedCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedCatExecute ]
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

ClassMethod GetMedCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetMedCatExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if $d(%session)&&($g(HospID)=""){
 		set HospID=%session.Get("LOGON.HOSPID")
	}
	s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_DHCOEOrdPrintSet",HospID)
    if '$D(^DHCLONGSET("medcat",defHospID))   Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	s num=$L(^DHCLONGSET("medcat",defHospID),"^")
 	f i=1:1:num
 	{   s prior=$P(^DHCLONGSET("medcat",defHospID),"^",i)
	 	s rw=$P(prior,"|")
	 	s desc=$P(prior,"|",2)
	 	Do Outputcat2
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat2
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetMedCat(HospID = "") As %Query(ROWSPEC = "rw,desc")
{
}

Query GetSordcat() As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetSordcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSordcatExecute ]
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

ClassMethod GetSordcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSordcatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSordcatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
   // if '$D(^DHCLONGSET("medcat"))   Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	//s num=$L(^DHCLONGSET("medcat"),"^")
 //	f i=1:1:num
 //	{   s prior=$P(^DHCLONGSET("medcat"),"^",i)
	// 	s rw=$P(prior,"|")
	// 	s desc=$P(prior,"|",2)
	// 	Do Outputcat2
	//}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat2
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetOrcatBak() As %SQLQuery(CONTAINID = 1, ROWSPEC = "orcat_rowid:%Integer,orcat_Desc:%String")
{
	 select orcat_rowId,orcat_desc from OEC_OrderCategory
}

Query GetOrcat(HospID = "") As websys.Query(CONTAINID = 1, ROWSPEC = "orcat_rowid:%Integer,orcat_Desc:%String")
{
}

/// ##class(%ResultSet).RunQuery("web.DHCCLSET","GetOrcat")
ClassMethod GetOrcatExecute(ByRef qHandle As %Binary, HospID As %String = "") As %Status
{
	s ^tempsc("GetOrcat")=HospID
	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	if $d(%session)&&(HospID=""){
	 	;w "yiyuan:"_%session.Get("LOGON.HOSPID")
 		set HospID=%session.Get("LOGON.HOSPID")
	}
 	s isGetHospShowDataFlag=##class(websys.Conversions).IsValidMethodName("web.DHCBL.BDP.BDPMappingHOSP","GetHospShowDataFlag")
 	s rw="" 
 	f  s rw=$o(^OEC("ORCAT",rw)) q:rw=""  d
 	.s desc=$p(^OEC("ORCAT",rw),"^",2)
 	.if isGetHospShowDataFlag s isHospAricm=##class(Nur.Interface.Other.BDPInterface).GetHospShowDataFlag("OEC_OrderCategory",rw,HospID)
	.q:($g(isHospAricm)'="")&&($g(isHospAricm)'="Y")
 	.d Output5
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
Output5
	s Data=$lb(rw,desc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

Query SSGROUP(desc As %String) As %Query(ROWSPEC = "Group:%String,ID:%String")
{
}

ClassMethod SSGROUPExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s rw=0  f  s rw=$O(^SSU("SSGRP",rw)) q:rw=""  d
 	.s GrpDesc=$P(^SSU("SSGRP",rw),"^",1)
 	.s GrpDescTmp=$$ALPHAUP^SSUTIL4(GrpDesc)
 	.s desc=$$ALPHAUP^SSUTIL4(desc)
 	.q:(GrpDescTmp'[desc)&(desc'="")
    .d Output4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
Output4
	s Data=$lb(GrpDesc,rw)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod SSGROUPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SSGROUPExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SSGROUPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SSGROUPExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetArcCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcCatExecute ]
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

ClassMethod GetArcCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetArcCatExecute(ByRef qHandle As %Binary, OrdCatId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s rw=""
 	s ^TT=OrdCatId
 	f  s rw=$O(^ARC("IC",rw)) q:rw=""  d
 	.s desc=$P(^ARC("IC",rw),"^",2)
 	.s ordid=$P(^ARC("IC",rw),"^",8)
 	.q:(ordid'=OrdCatId)&(OrdCatId'="")
	.Do Outputcat2

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat2
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetArcCat(OrdCatId As %String) As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod SaveFayao(Str)
{
  //保存发药子类;
	s ^DHCCLNurseExec("fayaocat")=Str
	s num=$L(^DHCCLNurseExec("fayaocat"),"^")
	for i=1:1:num
	{
		s str=$P(^DHCCLNurseExec("fayaocat"),"^",i)
		s id=$P(str,"|",1)
		s fayaostr=$G(fayaostr)_id_"^"
	}
	s fayaostr="^"_$g(fayaostr)
	s ^DHCNURSEITEMCAT("FaYao")=fayaostr
	//s ^TT=$L(^DHCNURSEITEMCAT("FaYao"),"^")

	q 0
}

ClassMethod GetFayaoCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFayaoCatExecute ]
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

ClassMethod GetFayaoCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFayaoCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetFayaoCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if '$D(^DHCCLNurseExec("fayaocat")) Set qHandle=$lb(0,repid,0)	Quit $$$OK

 	s num=$L(^DHCCLNurseExec("fayaocat"),"^")
 	f i=1:1:num
 	{   s prior=$P(^DHCCLNurseExec("fayaocat"),"^",i)
	 	s rw=$P(prior,"|")
	 	s desc=$P(prior,"|",2)
	 	Do Outputcat
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetFayaoCat() As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetArcItemCat(OrdCatId) As %String
{
	//n (OrdCatId)
	s rw=""
	f  s rw=$O(^ARC("IC",rw)) q:rw=""  d
 	.s desc=$P(^ARC("IC",rw),"^",2)
 	.s ordid=$P(^ARC("IC",rw),"^",8)
 	.q:(ordid'=OrdCatId)&(OrdCatId'="")
 	.s CatStr=$G(CatStr)_rw_"!"_desc_"^"
 	q $G(CatStr)
}

/// w ##class(%ResultSet).RunQuery("web.DHCCLSET","DateType",DateType)
Query DateType() As %Query(ROWSPEC = "dateFormatVal:%String,dateFormat:%String")
{
}

ClassMethod DateTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s dateFormatVal="3",dateFormat="yyyy-MM-dd"
 	Do OutputRow2
 	s dateFormatVal="4",dateFormat="dd/MM/yyyy"
 	Do OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(dateFormatVal,dateFormat)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DateTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DateTypeExecute ]
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

ClassMethod DateTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DateTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCCLSET","TimeType")
Query TimeType() As %Query(ROWSPEC = "timeFormatVal:%String,timeFormat:%String")
{
}

ClassMethod TimeTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s timeFormatVal="1",timeFormat="HH:mm:ss"
 	Do OutputRow2
 	s timeFormatVal="2",timeFormat="HH:mm"
 	Do OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(timeFormatVal,timeFormat)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod TimeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TimeTypeExecute ]
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

ClassMethod TimeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TimeTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取医嘱子类  ##class(%ResultSet).RunQuery("web.DHCCLSET","GetArcic")
Query GetArcic(HospID As %String = "") As websys.Query(CONTAINID = 1, ROWSPEC = "ARCIC_RowId:%Integer,ARCIC_Desc:%String")
{
}

ClassMethod GetArcicExecute(ByRef qHandle As %Binary, HospID As %String = "") As %Status
{
	s ^tempsc("GetArcicExecute")=HospID
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if $d(%session)&&(HospID=""){
	 	;w "yiyuan:"_%session.Get("LOGON.HOSPID")
 		set HospID=%session.Get("LOGON.HOSPID")
	} 	
	s isGetHospShowDataFlag=##class(websys.Conversions).IsValidMethodName("web.DHCBL.BDP.BDPMappingHOSP","GetHospShowDataFlag")
 	s rw="" f  s rw=$o(^ARC("IC",rw)) q:rw=""  d
	.s desc=$p(^ARC("IC",rw),"^",2)
	.if isGetHospShowDataFlag s isHospAricm=##class(Nur.Interface.Other.BDPInterface).GetHospShowDataFlag("ARC_ItemCat",rw,HospID)
	.q:($g(isHospAricm)'="")&&($g(isHospAricm)'="Y")
	.d getArcic
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getArcic
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Storage Default
{
<Data name="DHCCLSETDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCLSETD</DataLocation>
<DefaultData>DHCCLSETDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCCLSETD</IdLocation>
<IndexLocation>^web.DHCCLSETI</IndexLocation>
<StreamLocation>^web.DHCCLSETS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
