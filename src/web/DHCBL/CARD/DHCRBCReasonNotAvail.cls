Class web.DHCBL.CARD.DHCRBCReasonNotAvail Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 删除RBCReasonNotAvail
ClassMethod DHCRBCReasonNotAvailDelete(DHCRBCReasonNotAvailInfo As web.DHCEntity.PCA.DHCRBCReasonNotAvail) As %String
{
 TStart
 set sc= ##class(User.RBCReasonNotAvail).%DeleteId(DHCRBCReasonNotAvailInfo.ID)

 If $$$ISERR(sc) {
 Do $System.Status.DisplayError()
 Trollback
 Quit -100
 }
 TCommit
 quit 0
}

/// 新增RBCReasonNotAvail
ClassMethod DHCRBCReasonNotAvailInsert(DHCRBCReasonNotAvailInfo As web.DHCEntity.PCA.DHCRBCReasonNotAvail) As %String
{
 set RNAVCode=DHCRBCReasonNotAvailInfo.RNAVCode
 set myCount=0
 &sql(select count(*) Into :myCount 
 from sqluser.RBC_ReasonNotAvail where RNAV_Code=:RNAVCode)
 if (myCount'=0)
 {
	 Quit 10
 }
 TStart
 set object=##class(User.RBCReasonNotAvail).%New()

 set object.RNAVCode=DHCRBCReasonNotAvailInfo.RNAVCode

 if (DHCRBCReasonNotAvailInfo.RNAVDateFrom'="")&&(DHCRBCReasonNotAvailInfo.RNAVDateFrom'=$c(1))
 {
 set object.RNAVDateFrom=..%ZDH(DHCRBCReasonNotAvailInfo.RNAVDateFrom) //$zdh(DHCRBCReasonNotAvailInfo.RNAVDateFrom,4)
 }

 if ($replace(DHCRBCReasonNotAvailInfo.RNAVDateTo," ","")'="")&&(DHCRBCReasonNotAvailInfo.RNAVDateTo'=$c(1))
 {
 set object.RNAVDateTo=..%ZDH(DHCRBCReasonNotAvailInfo.RNAVDateTo) //$zdh(DHCRBCReasonNotAvailInfo.RNAVDateTo,4)
 }
 else
 {
	 set object.RNAVDateTo=""
 }

 set object.RNAVDesc=DHCRBCReasonNotAvailInfo.RNAVDesc

 //set object.RNAVType=DHCRBCReasonNotAvailInfo.RNAVType

 set sc=object.%Save()
 If $$$ISERR(sc) {
	Do $System.Status.DisplayError(sc)	
	Trollback
	Quit -100
 }
 TCommit
 quit object.%Id()
}

/// 更新RBCReasonNotAvail
ClassMethod DHCRBCReasonNotAvailUpdate(DHCRBCReasonNotAvailInfo As web.DHCEntity.PCA.DHCRBCReasonNotAvail) As %String
{
 TStart
 set object=##class(User.RBCReasonNotAvail).%OpenId(DHCRBCReasonNotAvailInfo.ID)

 set object.RNAVCode=DHCRBCReasonNotAvailInfo.RNAVCode

 if (DHCRBCReasonNotAvailInfo.RNAVDateFrom'="")
 {
 set object.RNAVDateFrom=..%ZDH(DHCRBCReasonNotAvailInfo.RNAVDateFrom) //$zdh(DHCRBCReasonNotAvailInfo.RNAVDateFrom,4)
 }

 if ($tr(DHCRBCReasonNotAvailInfo.RNAVDateTo," ")'="")
 {
 set object.RNAVDateTo=..%ZDH(DHCRBCReasonNotAvailInfo.RNAVDateTo) //$zdh(DHCRBCReasonNotAvailInfo.RNAVDateTo,4)
 }
 else
 {
	 set object.RNAVDateTo=""
 }

 set object.RNAVDesc=DHCRBCReasonNotAvailInfo.RNAVDesc

 //set object.RNAVType=DHCRBCReasonNotAvailInfo.RNAVType
	
 set sc=object.%Save()
 If $$$ISERR(sc) {
 Do $System.Status.DisplayError()
 Trollback
 Quit -100
 }
 TCommit
 quit object.%Id()
}

Query DHCRBCReasonNotAvailQuery() As %SQLQuery(CONTAINID = 1)
{
 select %ID AS TID,
 RNAV_Code AS TRNAVCode,
 RNAV_DateFrom AS TRNAVDateFrom,
 RNAV_DateTo AS TRNAVDateTo,
 RNAV_Desc AS TRNAVDesc,
 RNAV_Type AS TRNAVType
 from sqluser.RBC_ReasonNotAvail Order By RNAV_Code
}

Query RBCReasonNotAvailQuery(Code As %String = "", Name As %String = "") As %Query(ROWSPEC = "TID:%String,TRNAVCode:%String,TRNAVDesc:%String,TRNAVDateFrom:%String,TRNAVDateTo:%String,TRNAVType:%String")
{
}

ClassMethod RBCReasonNotAvailQueryExecute(ByRef QHandle As %Binary, Code As %String = "", Name As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s RowId=0 f  s RowId=$o(^RBC("NA",RowId)) q:RowId=""  d
	.s TRNAVCode=$p(^RBC("NA",RowId),"^",1)
	.q:(Code'="")&&(TRNAVCode'=Code)
	.s TRNAVDesc=$p(^RBC("NA",RowId),"^",2)
	.q:(Name'="")&&(TRNAVDesc'=Name)
	.s TRNAVType=$p(^RBC("NA",RowId),"^",3)
	.s TRNAVDateFrom=$p(^RBC("NA",RowId),"^",4)
	.s TRNAVDateTo=$p(^RBC("NA",RowId),"^",5)
	.s:TRNAVDateFrom'="" TRNAVDateFrom=..%ZD(TRNAVDateFrom)
	.s:TRNAVDateTo'="" TRNAVDateTo=..%ZD(TRNAVDateTo)
	.s Data=$lb(RowId,TRNAVCode,TRNAVDesc,TRNAVDateFrom,TRNAVDateTo,TRNAVType)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	Quit $$$OK
}

ClassMethod RBCReasonNotAvailQueryClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = RBCReasonNotAvailQueryExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RBCReasonNotAvailQueryFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RBCReasonNotAvailQueryExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
