Import SQLUser

Class web.DHCBPCVisitStatus Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCVisitStatus","FindVStatus")
Query FindVStatus() As %Query(ROWSPEC = "tBPCVSRowId:%String,tBPCVSCode:%String,tBPCVSDesc:%String")
{
}

ClassMethod FindVStatusExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPCVSRowId=0
	f  s tBPCVSRowId=$o(^DHCBPC("VisitStatus",tBPCVSRowId)) q:tBPCVSRowId=""  d
	    .s tBPCVSCode=$lg(^DHCBPC("VisitStatus",tBPCVSRowId),1)
	    .q:tBPCVSCode=""
	    .s tBPCVSDesc=$lg(^DHCBPC("VisitStatus",tBPCVSRowId),2)
	    .q:tBPCVSDesc=""
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCVSRowId,tBPCVSCode,tBPCVSDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindVStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVStatusExecute ]
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

ClassMethod FindVStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVStatusExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPCVisitStatus).InsertVStatus("2","模式2")
ClassMethod InsertVStatus(bpcVSCode, bpcVSDesc) As %String
{
	q:bpcVSCode="" "代码不能为空!"
	q:bpcVSDesc="" "描述不能为空!"
	s objVStatus = ##class(User.DHCBPCVisitStatus).%New()
	s objVStatus.BPCVSCode=bpcVSCode
	s objVStatus.BPCVSDesc=bpcVSDesc
	s saveStatus=objVStatus.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s bpcVSId=objVStatus.%Id()
	d objVStatus.%Close()
	q 0
}

/// d ##class(web.DHCBPCVisitStatus).UpdateVStatus(1,"1","模式")
ClassMethod UpdateVStatus(bpcVSId, bpcVSCode, bpcVSDesc) As %String
{
	q:bpcVSId="" "ID不能为空!"
	q:bpcVSCode="" "代码不能为空!"
	q:bpcVSDesc="" "描述不能为空!"
	q:'##class(User.DHCBPCVisitStatus).%ExistsId(bpcVSId) "日志码表指针无对应记录!"
	s objVStatus = ##class(User.DHCBPCVisitStatus).%OpenId(bpcVSId)
	s objVStatus.BPCVSCode=bpcVSCode
	s objVStatus.BPCVSDesc=bpcVSDesc
	s updateStatus=objVStatus.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s bpcVSId=objVStatus.%Id()
	d objVStatus.%Close()
	q 0
}

/// d ##class(web.DHCBPCVisitStatus).DeleteVStatus(1)
ClassMethod DeleteVStatus(bpcVSId) As %String
{
	q:bpcVSId="" "ID不能为空!"
	q:'##class(User.DHCBPCVisitStatus).%ExistsId(bpcVSId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCBPCVisitStatus).%DeleteId(bpcVSId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

/*
Query GetVisitStatusList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCVS_Code As Code,
	   BPCVS_Desc As Description
	   FROM DHC_BPC_VisitStatus
}*/
Query GetVisitStatusList(TypeCode As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,SubType:%String")
{
}

ClassMethod GetVisitStatusListExecute(ByRef qHandle As %Binary, TypeCode As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPCVSRowId=0
	f  s tBPCVSRowId=$o(^DHCBPC("VisitStatus",tBPCVSRowId)) q:tBPCVSRowId=""  d
		.s Id=tBPCVSRowId
	    .s Code=$lg(^DHCBPC("VisitStatus",tBPCVSRowId),1)
	    .q:Code=""
	    .s Description=$lg(^DHCBPC("VisitStatus",tBPCVSRowId),2)
	    .q:Description=""
	    .s SubType=$lg(^DHCBPC("VisitStatus",tBPCVSRowId),3)	
	    .q:(SubType'="")&&(TypeCode'="")&&(SubType'=TypeCode)
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,Code,Description,SubType)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetVisitStatusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVisitStatusListExecute ]
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

ClassMethod GetVisitStatusListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVisitStatusListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
