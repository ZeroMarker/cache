Class web.DHCBPDetectionUser Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCManufacturer","FindDetectionUser","")
Query FindDetectionUser(BPDetectionId) As %Query(ROWSPEC = "tRowId:%String,BPDUUserDr:%String,BPDUUserName:%String")
{
}

ClassMethod FindDetectionUserExecute(ByRef qHandle As %Binary, BPDetectionId) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tRowId=0
 	i BPDetectionId="" d
	.for  s tRowId=$o(^DHCBPDetectionUser(tRowId)) q:tRowId=""  d
	..s tBPDetectionId=$lg(^DHCBPDetectionUser(tRowId),1)
	..s userId=$lg(^DHCBPDetectionUser(tRowId),2)
	..s userName=$lg(^DHCBPDetectionUser(tRowId),3)
	..d OutputRow1
	e  d
	.s tRowId=0
	.f  s tRowId=$o(^DHCBPDetectionUser(0,"Detection",BPDetectionId,tRowId)) q:tRowId=""  d
	..s tBPDetectionId=$lg(^DHCBPDetectionUser(tRowId),1)
	..s userId=$lg(^DHCBPDetectionUser(tRowId),2)
	..s userName=$lg(^DHCBPDetectionUser(tRowId),3)
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCMRowId,mCode,mDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindDetectionUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDetectionUserExecute ]
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

ClassMethod FindDetectionUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDetectionUserExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据检测表ID获取参加人信息
/// w ##class(web.DHCBPDetectionUser).GetDetectionUser("")
ClassMethod GetDetectionUser(BPDetectionId) As %String
{
	s useridList=""
	s userNameList=""
	s tRowId=0
	for  s tRowId=$o(^DHCBPDetectionUser(tRowId)) q:tRowId=""  d
	.s tBPDetectionId=$lg(^DHCBPDetectionUser(tRowId),1)
	.q:(BPDetectionId'="")&&(BPDetectionId '=tBPDetectionId)
	.s userId=$lg(^DHCBPDetectionUser(tRowId),2)
	.i useridList="" s useridList=userId
	.e  d
	..s useridList=useridList_","_userId
	.s userName=$lg(^DHCBPDetectionUser(tRowId),3)
	.i userNameList="" s userNameList=userName
	.e  d
	..s userNameList=userNameList_","_userName
	q useridList_"^"_userNameList
}

}
