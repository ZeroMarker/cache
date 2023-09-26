Import SQLUser

Class web.DHCICUDocEvent Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCICUDocEvent","GetDocEventList","","")
Query GetDocEventList(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "rowId,docEventCode,docEventDesc,docEventCat,docEventCatId,docEventCII,docEventCIIId,docEventStartTime")
{
}

ClassMethod GetDocEventListExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
    //i adm="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
    s rowId=""
	f  s rowId=$o(^CF.ICU.DocEventD(rowId)) q:rowId=""  d
	.s docEventCat="",docEventCII=""
	.s docEventCode=$lg(^CF.ICU.DocEventD(rowId),1)
	.s docEventDesc=$lg(^CF.ICU.DocEventD(rowId),2)
	.s docEventCatId=$lg(^CF.ICU.DocEventD(rowId),3)
	.i docEventCatId'="" s docEventCat=$lg(^CF.ICU.DocEventCatD(docEventCatId),2)
	.s docEventCIIId=$lg(^CF.ICU.DocEventD(rowId),4)
	.s ICUCIIDr=$p(docEventCIIId,"||",1)
	.s ICUCIIlocation=$p(docEventCIIId,"||",2)
	.i ICUCIIDr'="" s docEventCII=$lg($g(^DHCICUCInquiry(ICUCIIDr,"I",ICUCIIlocation)),2)
	.s docEventStartTime=$zt($lg(^CF.ICU.DocEventD(rowId),5))
	.d OutRowOPList
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowOPList
	set Data=$lb(rowId,docEventCode,docEventDesc,docEventCat,docEventCatId,docEventCII,docEventCIIId,docEventStartTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetDocEventListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetDocEventListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	k ^tmpCk
    q $$$OK
}

Query FindDocEventCatList() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select ID as catId,
		   CFICUDEC_Code as catCode,
		   CFICUDEC_Desc as catDesc
		   from CF_ICU.DocEventCat
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUDocEvent","GetDocEventList","","")
Query FindDocEventCIIList(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "rowId,docEventCode,docEventDesc,docEventCat,docEventCatId,docEventCII,docEventCIIId,docEventStartTime")
{
}

ClassMethod FindDocEventCIIListExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
    //i adm="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
    s rowId=""
	f  s rowId=$o(^CF.ICU.DocEventD(rowId)) q:rowId=""  d
	.s docEventCat="",docEventCII=""
	.s docEventCode=$lg(^CF.ICU.DocEventD(rowId),1)
	.s docEventDesc=$lg(^CF.ICU.DocEventD(rowId),2)
	.s docEventCatId=$lg(^CF.ICU.DocEventD(rowId),3)
	.i docEventCatId'="" s docEventCat=$lg(^CF.ICU.DocEventCatD(docEventCatId),2)
	.s docEventCIIId=$lg(^CF.ICU.DocEventD(rowId),4)
	.s ICUCIIDr=$p(docEventCIIId,"||",1)
	.s ICUCIIlocation=$p(docEventCIIId,"||",2)
	.i ICUCIIDr'="" s docEventCII=$lg($g(^DHCICUCInquiry(ICUCIIDr,"I",ICUCIIlocation)),2)
	.s docEventStartTime=$zt($lg(^CF.ICU.DocEventD(rowId),5))
	.d OutRowOPList
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowOPList
	set Data=$lb(rowId,docEventCode,docEventDesc,docEventCat,docEventCatId,docEventCII,docEventCIIId,docEventStartTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindDocEventCIIListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindDocEventCIIListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	k ^tmpCk
    q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUDocEvent","FindDocEventInquiryList","40||8")
Query FindDocEventInquiryList(ICUCIIDr As %String = "") As %Query(ROWSPEC = "rowId,ICUCIIMainICUCIICode,ICUCIIMainICUCIIDesc,ICUCIIMainICUCIIType,ICUCIIMainICUCIISearch,ICUCIIMainICUCIIDisplay")
{
}

ClassMethod FindDocEventInquiryListExecute(ByRef qHandle As %Binary, ICUCIIDr As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
    if ICUCIIDr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ICUCIIMainICUCIIDr=$lg($g(^DHCICUCInquiry($p(ICUCIIDr,"||",1),"I",$p(ICUCIIDr,"||",2))),27)
	i ICUCIIMainICUCIIDr="" d
	.s rowId=ICUCIIDr
	.s ICUCIIMainICUCIICode=$lg($g(^DHCICUCInquiry($p(ICUCIIDr,"||",1),"I",$p(ICUCIIDr,"||",2))),1)
	.s ICUCIIMainICUCIIDesc=$lg($g(^DHCICUCInquiry($p(ICUCIIDr,"||",1),"I",$p(ICUCIIDr,"||",2))),2)
	.s TICUCIIType=$lg($g(^DHCICUCInquiry($p(ICUCIIDr,"||",1),"I",$p(ICUCIIDr,"||",2))),3)
	.s ICUCIIMainICUCIIType=""
    .s:TICUCIIType="P" ICUCIIMainICUCIIType="Patient"
    .s:TICUCIIType="B" ICUCIIMainICUCIIType="Baseline"
    .s:TICUCIIType="I" ICUCIIMainICUCIIType="ICD"
    .s:TICUCIIType="D" ICUCIIMainICUCIIType="Docter"
    .s:TICUCIIType="O" ICUCIIMainICUCIIType="Order"
    .s:TICUCIIType="R" ICUCIIMainICUCIIType="Record"
    .s:TICUCIIType="L" ICUCIIMainICUCIIType="Lab"
    .s:TICUCIIType="C" ICUCIIMainICUCIIType="CalcuLate"
	.s TICUCIIIsSearch=$lg($g(^DHCICUCInquiry($p(ICUCIIDr,"||",1),"I",$p(ICUCIIDr,"||",2))),4)
	.s:TICUCIIIsSearch="1" ICUCIIMainICUCIISearch="是"
    .s:TICUCIIIsSearch="0" ICUCIIMainICUCIISearch="否"
    .s:TICUCIIIsSearch="" ICUCIIMainICUCIISearch="是"
	.s TICUCIIIsDisplay=$lg($g(^DHCICUCInquiry($p(ICUCIIDr,"||",1),"I",$p(ICUCIIDr,"||",2))),5)
	.s:TICUCIIIsDisplay="1" ICUCIIMainICUCIIDisplay="是"
    .s:TICUCIIIsDisplay="0" ICUCIIMainICUCIIDisplay="否"
    .s:TICUCIIIsDisplay="" ICUCIIMainICUCIIDisplay="是" 
	.d OutRowOPList
	e  d
	.f i=1:1:$l(ICUCIIMainICUCIIDr,"^") d
	..s rowId=$p(ICUCIIMainICUCIIDr,"^",i)
	..s ICUCIIMainICUCIICode=$lg($g(^DHCICUCInquiry($p(rowId,"||",1),"I",$p(rowId,"||",2))),1)
	..s ICUCIIMainICUCIIDesc=$lg($g(^DHCICUCInquiry($p(rowId,"||",1),"I",$p(rowId,"||",2))),2)
	..s TICUCIIType=$lg($g(^DHCICUCInquiry($p(rowId,"||",1),"I",$p(rowId,"||",2))),3)
	..s ICUCIIMainICUCIIType=""
    ..s:TICUCIIType="P" ICUCIIMainICUCIIType="Patient"
    ..s:TICUCIIType="B" ICUCIIMainICUCIIType="Baseline"
    ..s:TICUCIIType="I" ICUCIIMainICUCIIType="ICD"
    ..s:TICUCIIType="D" ICUCIIMainICUCIIType="Docter"
    ..s:TICUCIIType="O" ICUCIIMainICUCIIType="Order"
    ..s:TICUCIIType="R" ICUCIIMainICUCIIType="Record"
    ..s:TICUCIIType="L" ICUCIIMainICUCIIType="Lab"
    ..s:TICUCIIType="C" ICUCIIMainICUCIIType="CalcuLate"
	..s TICUCIIIsSearch=$lg($g(^DHCICUCInquiry($p(rowId,"||",1),"I",$p(rowId,"||",2))),4)
	..s:TICUCIIIsSearch="1" ICUCIIMainICUCIISearch="是"
    ..s:TICUCIIIsSearch="0" ICUCIIMainICUCIISearch="否"
    ..s:TICUCIIIsSearch="" ICUCIIMainICUCIISearch="是"
	..s TICUCIIIsDisplay=$lg($g(^DHCICUCInquiry($p(rowId,"||",1),"I",$p(rowId,"||",2))),5)
	..s:TICUCIIIsDisplay="1" ICUCIIMainICUCIIDisplay="是"
    ..s:TICUCIIIsDisplay="0" ICUCIIMainICUCIIDisplay="否"
    ..s:TICUCIIIsDisplay="" ICUCIIMainICUCIIDisplay="是" 
	..d OutRowOPList
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowOPList
	set Data=$lb(rowId,ICUCIIMainICUCIICode,ICUCIIMainICUCIIDesc,ICUCIIMainICUCIIType,ICUCIIMainICUCIISearch,ICUCIIMainICUCIIDisplay)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindDocEventInquiryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindDocEventInquiryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	k ^tmpCk
    q $$$OK
}

/// w ##class(web.DHCICUDocEvent).InsertDocEvent("ceshi","测试","01:00","40||1","1")
ClassMethod InsertDocEvent(code As %String, desc As %String, time As %String, FCII As %String, eventCat As %String) As %String
{
	
    set docEventObj=##class(CF.ICU.DocEvent).%New() 
    
    set docEventObj.CFICUDECode=code
	set docEventObj.CFICUDEDesc=desc
	set docEventObj.CFICUDECFICUDECCode=eventCat
	set docEventObj.CFICUDEICUCIIDr=##class(User.DHCICUCInquiryItem).%OpenId(FCII)
	set docEventObj.CFICUDEStartTime=$zth(time)
	set docEventObj.CFICUDEIntervalMinute=1
	set docEventObj.CFICUDEExcludeSecond=21600
    set sc=docEventObj.%Save()
    if ($System.Status.IsError(sc))
    {
        set result="E^"_$System.Status.GetErrorText(sc,"zh-cn") 
    }
    else
    {
        set result="S^"_docEventObj.%Id()
    }
    quit result
}

/// w ##class(web.DHCICUDocEvent).UpdateDocEvent("67","ceshi2","测试12","04:00","40||2","1")
ClassMethod UpdateDocEvent(rowId As %String, code As %String, desc As %String, time As %String, FCII As %String, eventCat As %String) As %String
{
	q:rowId="" ""
    set docEventObj=##class(CF.ICU.DocEvent).%OpenId(rowId)
    
    set docEventObj.CFICUDECode=code
	set docEventObj.CFICUDEDesc=desc
	set docEventObj.CFICUDECFICUDECCode=eventCat
	set docEventObj.CFICUDEICUCIIDr=##class(User.DHCICUCInquiryItem).%OpenId(FCII)
	set docEventObj.CFICUDEStartTime=$zth(time)
	set docEventObj.CFICUDEIntervalMinute=1
	set docEventObj.CFICUDEExcludeSecond=21600
    set sc=docEventObj.%Save()
    if ($System.Status.IsError(sc))
    {
        set result="E^"_$System.Status.GetErrorText(sc,"zh-cn") 
    }
    else
    {
        set result="S^"_docEventObj.%Id()
    }
    quit result
}

/// w ##class(web.DHCICUDocEvent).DeleteDocEvent("68")
ClassMethod DeleteDocEvent(rowId As %String) As %String
{
	q:rowId="" ""
	&sql(DELETE FROM CF_ICU.DocEvent WHERE ID = :rowId )
    
    q SQLCODE
}

Storage Default
{
<Data name="DHCICUDocEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCICUDocEventD</DataLocation>
<DefaultData>DHCICUDocEventDefaultData</DefaultData>
<IdLocation>^web.DHCICUDocEventD</IdLocation>
<IndexLocation>^web.DHCICUDocEventI</IndexLocation>
<StreamLocation>^web.DHCICUDocEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
