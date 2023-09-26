Class web.DHCRBResEffDateSessNotAvail Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Delete(RowId As %String) As %String
{
	&SQL(Delete From SQLUser.RB_ResEffDateSessNotAvail Where NA_RowId=:RowId )
	Q SQLCODE
}

ClassMethod GetNotAvailClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetNotAvailExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNotAvailExecute(ByRef qHandle As %Binary, ResSessRowId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCRBResEffDateSessNotAvail","GetNotAvail","")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if ResSessRowId="" {
		do ResetVariables1
		Do OutputRow1
	}else{
		s ResRowId=$P(ResSessRowId,"||",1)
		s DateRowId=$P(ResSessRowId,"||",2)
		s SessRowId=$P(ResSessRowId,"||",3)
		s NAChild=0 f  s NAChild=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId,"NA",NAChild)) Q:NAChild=""  d
		.s NA=^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId,"NA",NAChild)
		.s NAFrDate=$P(NA,"^",1)
		.s NAToDate=$P(NA,"^",2)
		.s NAFrDate=##Class(websys.Conversions).DateLogicalToHtml(NAFrDate) ;$ZD(NAFrDate,4)
		.s NAReasonDR=$P(NA,"^",3)
		.i NAReasonDR'="" s NAReason=$P($G(^RBC("NA",NAReasonDR)),"^",2) 
		.e  s NAReason=""
		.i (NAToDate'="")&&(NAToDate'=0) d
		..s NAToDate=##Class(websys.Conversions).DateLogicalToHtml(NAToDate)
		.e  d
		..s NAToDate=" "
		..s NAToTime=" "
		.s NARemarks=^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId,"NA",NAChild,"REM",1)
		.s NARowId=ResRowId_"||"_DateRowId_"||"_SessRowId_"||"_NAChild
		.d OutputRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(NARowId,NAFrDate,NAToDate,NAReason,NAReasonDR,NARemarks)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
ResetVariables1
	set (NARowId,NAFrDate,NAToDate,NAReason,NAReasonDR,NARemarks)=""
	quit
}

ClassMethod GetNotAvailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNotAvailExecute ]
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

ClassMethod Insert(ResSessRowId As %String, Para As %String) As %String
{
	;d ##class(web.DHCRBResEffDateSessNotAvail).Insert("1103||1||1","16/09/2007^0")
	;s Para="16/09/2007^^^^^"
	;s ^zhou("para")=Para
	S NADateFrom=$P(Para,"^",1)
	if NADateFrom'="" s NADateFrom=$ZDH(NADateFrom,4)

	S NADateTo=$P(Para,"^",2)
	if NADateTo'="" {
		s NADateTo=$ZDH(NADateTo,4)
	}else{
		s NADateTo=0
	}
	
	S NAReasonDR=$P(Para,"^",3)
	s NARemarks=$P(Para,"^",4)
	
	Set object = ##class(User.RBResEffDateSessNotAvail).%New(ResSessRowId)
	d object.NAParRefSetObjectId(ResSessRowId)
	s object.NADateFrom=NADateFrom
	s object.NADateTo=NADateTo
	i NAReasonDR'="" d object.NAReasonDRSetObjectId(NAReasonDR)
	d object.NARemarks.Insert(NARemarks)
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		 Do $System.Status.DisplayError()
		 Quit 100
	}
	d object.%Close()
	Q 0
}

ClassMethod Update(Para As %String) As %String
{
	;s Para="11^09/16/2007^06:00:00^09/16/2007^06:00:00^2^bbb"
	;d ##class(web.DHCRBResEffDateSessNotAvail).Update("1103||1||1||1^16/09/2007^16/10/2007^^")
	s NARowid=$P(Para,"^",1)
	S NADateFrom=$P(Para,"^",2)
	;##Class(websys.Conversions).DateHtmlToLogical
	if NADateFrom'="" s NADateFrom=$ZDH(NADateFrom,4)

	S NADateTo=$P(Para,"^",3)
	if NADateTo'="" {
		s NADateTo=$ZDH(NADateTo,4)
	}else{
		s NADateTo=0
	}
	
	S NAReasonDR=$P(Para,"^",4)
	s NARemarks=$P(Para,"^",5)

	Set object = ##class(User.RBResEffDateSessNotAvail).%OpenId(NARowid)
	s object.NADateFrom=NADateFrom
	s object.NADateTo=NADateTo
	d object.NAReasonDRSetObjectId(NAReasonDR)
	d object.NARemarks.SetAt(NARemarks,1)
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		 Do $System.Status.DisplayError()
		 Quit 100
	}
	d object.%Close()
	Q 0
}

Query GetNotAvail(ResSessRowId As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "RowId:%String,DateFrom:%String,DateTo:%String,Reason:%String,ReasonRowId:%String,Remarks:%String")
{
}

}
