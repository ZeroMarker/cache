Class web.DHCEkgApplicationSheet Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("web.DHCEkgApplicationSheet","QueryStudyByPaadmDR","457")

Query QueryStudyByPaadmDR(ekgAppintNo As %String) As %Query(ROWSPEC = "ekgExamCode:%String,ekgDeptCode:%String,ekgPatientID:%String,TEkgItemName:%String,ekgName:%String,ekgGender:%String,ekgBirthday:%String,ekgReportUserID:%String,ekgOperateTime:%String,ekgReportTime:%String,ekgStatusCode:%String,TOpenRpt:%String,TOpenAllRpt:%String,TIsOpenFrostRpt:%String")
{
}

ClassMethod QueryStudyByPaadmDRExecute(ByRef qHandle As %Binary, ekgAppintNo As %String) As %Status
{
	 Set repid=$I(^CacheTemp) 
	 s ind=1
	 
	 s Paadmdr=$P(ekgAppintNo,$c(0))
	 if $g(Paadmdr)="" Set Paadmdr=%request.Get("EpisodeID")
	 Set repid=$I(^CacheTemp)
	 If $g(ind)="" Set ind=1

    s ekgExamCode="",ekgDeptCode="",ekgPatientID="",TEkgItemName="",ekgName="",ekgGender="",ekgBirthday="",ekgReportUserID="",ekgOperateTime="",ekgReportTime="",ekgStatusCode=""


	zn "DHC-EKG"
	
	s id=0 f  s id=$o(^dbo.tblRequestI("idxAppointNo",Paadmdr,id)) q:id=""  d
	.i '$d(^dbo.tblRequestD(id)) q
	.s Info=##class(dbo.tblRequest).%OpenId(id)
	.s ekgExamCode=Info.ekgExamCode
	.b ;1
	.s ekgExamItemCode=Info.ekgExamItemCode
	.s examItemId=0  f  s examItemId=$o(^dbo.tblDictExamItemI("idxExamItemCode"," "_ekgExamItemCode,examItemId))  q:examItemId=""  d
	..i '$d(^dbo.tblDictExamItemD(examItemId)) q
	..s ExamItemInfo=##class(dbo.tblDictExamItem).%OpenId(examItemId)
	..s TEkgItemName=ExamItemInfo.ekgName
	..d ExamItemInfo.%Close()
	..s ExamItemInfo=""
	.b ;2
	.s ekgDeptCode=Info.ekgDeptCode
	.s ekgPatientID=Info.ekgPatientID
	.d Info.%Close()
	.s Info=""
	.i ekgPatientID'="" d
	..s patInfo=##class(dbo.tblPatient).%OpenId(ekgPatientID)
	..s ekgName=patInfo.ekgName
	..s ekgGender=patInfo.ekgGender
	..s ekgBirthday=patInfo.ekgBirthday
	..d patInfo.%Close()
	..s patInfo=""
	.s rptid=0 f  s rptid=$o(^dbo.tblExaminationI("idxRequestID",id,rptid)) q:rptid=""  d
	..i '$d(^dbo.tblExaminationD(rptid)) q
	..s examInfo=##class(dbo.tblExamination).%OpenId(rptid)
	..s ekgStatusCode=examInfo.ekgStatusCode
	..q:((ekgStatusCode'="15")&(ekgStatusCode'="17"))
	..s ekgReportUserID=examInfo.ekgReportUserID
	..s ekgReportTime=examInfo.ekgArbiterTime
	..s ekgOperateTime=examInfo.ekgOperateTime
	..s ekgStatusCode=examInfo.ekgStatusCode
	..d examInfo.%Close()
	..s examInfo=""
	..Do OutStudy

	
	zn "DHC-APP"
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutStudy
	set Data=$lb(ekgExamCode,ekgDeptCode,ekgPatientID,TEkgItemName,ekgName,ekgGender,ekgBirthday,ekgReportUserID,ekgOperateTime,ekgReportTime,ekgStatusCode,"Report")
 	b ;Data
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryStudyByPaadmDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStudyByPaadmDRExecute ]
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

ClassMethod QueryStudyByPaadmDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStudyByPaadmDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
