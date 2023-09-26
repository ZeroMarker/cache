Class web.DHCRBNotAvail Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Delete(RowId As %String) As %String
{
	&SQL(Delete From SQLUser.RB_NotAvail Where NA_RowId=:RowId )
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

ClassMethod GetNotAvailExecute(ByRef qHandle As %Binary, ResRowId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCRBNotAvail","GetNotAvail","")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if ResRowId="" {
		do ResetVariables1
		Do OutputRow1
	}else{
		s NAFrDateTime=0 f  s NAFrDateTime=$O(^RB("NA",0,"RES",ResRowId,NAFrDateTime)) q:NAFrDateTime=""  d
		.s NARowId=0  f  s NARowId=$O(^RB("NA",0,"RES",ResRowId,NAFrDateTime,NARowId)) q:NARowId=""  d
		..s NAFrDateTime=$P(^RB("NA",NARowId),"^",2)
		..s NAFrDate=$P(NAFrDateTime,"Z",1)
		..s NAFrTime=$P(NAFrDateTime,"Z",2)
		..s NAFrDate=##Class(websys.Conversions).DateLogicalToHtml(NAFrDate) ;$ZD(NAFrDate,4)
		..s NAFrTime=$ZT(NAFrTime)
		..s NAReasonDR=$P(^RB("NA",NARowId),"^",4)
		..i NAReasonDR'="" s NAReason=$P($G(^RBC("NA",NAReasonDR)),"^",2) 
		..e  s NAReason=""
		..s NAToDateTime=$P(^RB("NA",NARowId),"^",3)
		..s NAToDate=$P(NAToDateTime,"Z",1)
		..s NAToTime=$P(NAToDateTime,"Z",2)
		..i (NAToDate'="")&&(NAToDate'=0) d
		...s NAToDate=##Class(websys.Conversions).DateLogicalToHtml(NAToDate)
		...s NAToTime=$ZT(NAToTime)
		..e  d
		...s NAToDate=" "
		...s NAToTime=" "
		..s NARemarks=^RB("NA",NARowId,"REM",1)
		..d OutputRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(NARowId,NAFrDate,NAFrTime,NAToDate,NAToTime,NAReason,NAReasonDR,NARemarks)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
ResetVariables1
	set (NARowId,NAFrDate,NAFrTime,NAToDate,NAToTime,NAReason,NAReasonDR,NARemarks)=""
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

ClassMethod GetReasonStr() As %String
{
	s ret=""
	Set rset=##class(%ResultSet).%New("web.DHCRBNotAvail:LookupReason")
	do rset.Execute()
	While (rset.Next()) {
		if ret="" s ret=rset.Data("RNAVRowId")_$C(1)_rset.Data("RNAVDesc")
		e  s ret=ret_"^"_rset.Data("RNAVRowId")_$C(1)_rset.Data("RNAVDesc")
	}
	d rset.Close()
	Q ret
}

ClassMethod Insert(ResRowId As %String, Para As %String) As %String
{
	s ResRowId="1103"
	;s Para="16/09/2007^^^^^"
	;s ^zhou("para")=Para
	k PLIST
	S NAFrDate=$P(Para,"^",1)
	if NAFrDate'="" s NAFrDate=$ZDH(NAFrDate,4)
	S NAFrTime=$P(Para,"^",2)
	if NAFrTime'="" s NAFrTime=$ZTH(NAFrTime) 
	e  s NAFrTime=0

	S NAToDate=$P(Para,"^",3)
	S NAToTime=$P(Para,"^",5)
	if NAToDate'="" {
		s NAToDate=$ZDH(NAToDate,4)
		if NAToTime="" s NAToTime="23:59:59"
		s NAToTime=$ZTH(NAToTime)
	}else{
		s NAToDate=0
		S NAToTime=0
	}
	
	S NAReasonDR=$P(Para,"^",5)
	s NARemarks=$P(Para,"^",6)
	
	Set object = ##class(User.RBNotAvail).%New()
	d object.NARESDRSetObjectId(ResRowId)
	s object.NAFrDate=NAFrDate
	s object.NAFrTime=NAFrTime
	s object.NAToDate=NAToDate
	s object.NAToTime=NAToTime
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

	s NARowid=$P(Para,"^",1)
	S NAFrDate=$P(Para,"^",2)
	;##Class(websys.Conversions).DateHtmlToLogical
	if NAFrDate'="" s NAFrDate=$ZDH(NAFrDate,4)
	S NAFrTime=$P(Para,"^",3)
	if NAFrTime'="" s NAFrTime=$ZTH(NAFrTime) e  s NAFrTime=0

	S NAToDate=$P(Para,"^",4)
	S NAToTime=$P(Para,"^",5)
	if NAToDate'="" {
		s NAToDate=$ZDH(NAToDate,4)
		if NAToTime="" s NAToTime="23:59:59"
		s NAToTime=$ZTH(NAToTime)
	}else{
		s NAToDate=0
		S NAToTime=0
	}
	
	S NAReasonDR=$P(Para,"^",6)
	s NARemarks=$P(Para,"^",7)

	Set object = ##class(User.RBNotAvail).%OpenId(NARowid)
	s object.NAFrDate=NAFrDate
	s object.NAFrTime=NAFrTime
	s object.NAToDate=NAToDate
	s object.NAToTime=NAToTime
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

Query GetNotAvail(ResRowId As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "RowId:%String,FrDate:%String,FrTime:%String,ToDate:%String,ToTime:%String,Reason:%String,ReasonRowId:%String,Remarks:%String")
{
}

Query LookupReason() As %SQLQuery(CONTAINID = 0, ROWSPEC = "RNAVDesc,RNAVRowId")
{
SELECT RNAV_Desc,RNAV_RowId FROM SQLUser.RBC_ReasonNotAvail
}

}
