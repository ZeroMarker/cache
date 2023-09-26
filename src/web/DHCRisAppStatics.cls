/// 申请单统计
/// 
Class web.DHCRisAppStatics Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 336;

Query QueryAppBill(StDate As %String, EndDate As %String, AppLocID As %String, RecLocID As %String, AppItemName As %String, AppValue As %String) As %Query(ROWSPEC = "AppDate:%String,AppLocDesc:%String,requestdoc:%String,RecLocDesc:%String,RegNo:%String,Name:%String,SexDesc:%String,typedesc:%String,strOrderName:%String,Browse:%String,oeorditemID:%String")
{
}

ClassMethod QueryAppBillExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, AppLocID As %String, RecLocID As %String, AppItemName As %String, AppValue As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	s ind=1
    i StDate="" s StDate=+$h
    i EndDate="" s EndDate=+$h
  
    s ^tmpAppLocID=AppItemName_"^"_AppValue
    s num=0
   	for date=StDate:1:EndDate d
    .s approwid=0 f  s approwid=$o(^DHCRBAppi("AppDate",date,approwid)) q:(approwid="")  d
    ..s AppLocDesc="",RecLocDesc="",requestdoc="",ItemStatDR="",ItemStatusCode=""
    ..s AppDate=$zd(date,3)
    ..s OeorditemID=$p(^DHCRBApp("Bill",approwid),"^",6)
    ..i OeorditemID'=""  d
    ...s OrderRowid=$p(OeorditemID,"||",1)
    ...s itemsub=$p(OeorditemID,"||",2)
    ...s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    ...s ItemStatDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13) ; 医嘱状态
	...i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	...q:(ItemStatusCode'="E")
    ...s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
   	...s RecLocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
   	...q:(RecLocID'="")&(RecLocdr'=RecLocID)
	...if RecLocdr'="" d
	....s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
	....i $f(RecLocDesc,"-")>0 d
	.....s RecLocDesc=$p(RecLocDesc,"-",2)
	...s ssusrdr=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",1) ;下医嘱医生
	...if ssusrdr'="" s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2) 
	...s GetAppLocID=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",2)
	...q:(AppLocID'="")&(GetAppLocID'=AppLocID) 
	...i GetAppLocID'="" d
	....s AppLocDesc=$p(^CTLOC(GetAppLocID),"^",2)
	....i $f(AppLocDesc,"-")>0 d
	.....s AppLocDesc=$p(AppLocDesc,"-",2)
    ...s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
    ...s papatmasmdr=$p(^PAADM(paadmdr),"^",1)        
    ...s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)  
    ...s Name1=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
    ...s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
    ...s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    ...s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
    ...s typedesc=##class(web.DHCRisCommFunction).GetTypeDesc(patienttype)
    ...s num=num+1
    ...i AppItemName'="" d
    ....s AppValueRowid=0 f  s AppValueRowid=$o(^DHCRBAppi("Orditem",OeorditemID,AppValueRowid) ) q:AppValueRowid=""  d
    .....s Name=$p(^DHCRBApp("FieldValue",AppValueRowid),"^",1)
    .....s Value=$p(^DHCRBApp("FieldValue",AppValueRowid),"^",3)
    .....i (Name=AppItemName)&(Value=AppValue) d
    ......d OutputRow1
    ...else  d  
  	....d OutputRow1
 		
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
    set Data=$lb(AppDate,AppLocDesc,requestdoc,RecLocDesc,RegNo,Name1,SexDesc,typedesc,strOrderName,"浏览",OeorditemID)
  	Set ^CacheTemp(repid,ind)=Data
  	Set ^CacheTemp(repid,ind+1)=$lb("合计(数量:)"_num,"","","","","","","","","","")
  	Set ind=ind+1
	quit
}

ClassMethod QueryAppBillFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppBillExecute ]
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

ClassMethod QueryAppBillClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppBillExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryStaticField(StDate As %String, EndDate As %String, AppLocID As %String, RecLocID As %String, AppItemName As %String, AppValue As %String) As %Query(ROWSPEC = "FieldName:%String,Type:%String")
{
}

ClassMethod QueryStaticFieldExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, AppLocID As %String, RecLocID As %String, AppItemName As %String, AppValue As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	s ind=1
    s rowid=0 f  s rowid=$o(^DHCRBCApp("AppField",rowid)) q:rowid=""  d
    .s Name=$p(^DHCRBCApp("AppField",rowid),"^",1)
    .s Type=$p(^DHCRBCApp("AppField",rowid),"^",2)
    .d OutputRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
    set Data=$lb(Name,Type)
  	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
	quit
}

ClassMethod QueryStaticFieldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStaticFieldExecute ]
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

ClassMethod QueryStaticFieldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStaticFieldExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
