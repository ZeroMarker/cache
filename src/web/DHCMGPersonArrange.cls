Import SQLUser

Class web.DHCMGPersonArrange Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindDPArrange() As %Query(ROWSPEC = "tARRPerId,tARRPerDR ,tARRPerDRDesc,tARRPostDR ,tARRPostDRDesc,tARRDate ,tARRRecordUser ,tARRRecDate ,tARRRecTime ,tARRMem ,tARRDepDR ,tARRDepDRDesc,tARRRelayDR ,tAuditDr ")
{
}

ClassMethod FindDPArrangeExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tDPArrangeId=0
	f  s tDPArrangeId=$o(^User.DHCMGPersonArrangeD(tDPArrangeId)) q:tDPArrangeId=""  d
	   .S tARRPerDR=$li(^User.DHCMGPersonArrangeD(tDPArrangeId),5) 
	   .s tARRPerDRDesc="" ;用户名称
       .;i tARRPerDR'="" S tARRPerDRDesc=$p(^CTPCP(tARRPerDR,1),"^",2) 
       .S tARRPostDR    =$li(^User.DHCMGPersonArrangeD(tDPArrangeId),6) 
       .S tARRPostDRDesc=""  ;类型名称 valueList="N^V",valueListDesc="夜班^休假"
       .i tARRPostDR="N" d
       ..s tARRPostDRDesc="夜班"
       .e  d
       ..s tARRPostDRDesc="休假"
       .S tARRDate      =$zd($li(^User.DHCMGPersonArrangeD(tDPArrangeId),2),4)
       
       .S tARRRecordUser=$li(^User.DHCMGPersonArrangeD(tDPArrangeId),9) 
       
       .S tARRRecDate   =$zd($li(^User.DHCMGPersonArrangeD(tDPArrangeId),7),4) 
       
       .S tARRRecTime   =$zt($li(^User.DHCMGPersonArrangeD(tDPArrangeId),8),4) 
       
       .S tARRMem       =$li(^User.DHCMGPersonArrangeD(tDPArrangeId),4) 
       
       .S tARRDepDR     =$li(^User.DHCMGPersonArrangeD(tDPArrangeId),3) 
       .s tARRDepDRDesc="" ;科室名称
       .i tARRDepDR'="" S tARRDepDRDesc =$p($g(^CTLOC(tARRDepDR)),"^",2)
       .S tARRRelayDR   =$li(^User.DHCMGPersonArrangeD(tDPArrangeId),10) 
       .S tAuditDr      =$li(^User.DHCMGPersonArrangeD(tDPArrangeId),11)
       .s tARRPerId=tDPArrangeId
       .d OutputRow
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow
	s Data=$lb(tARRPerId,tARRPerDR ,tARRPerDRDesc,tARRPostDR ,tARRPostDRDesc,tARRDate ,tARRRecordUser ,tARRRecDate ,tARRRecTime ,tARRMem ,tARRDepDR ,tARRDepDRDesc,tARRRelayDR ,tAuditDr )
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindDPArrangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDPArrangeExecute ]
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

ClassMethod FindDPArrangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDPArrangeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// w ##class(web.DHCMGPersonArrange).InsertDPArrange(ARRPerDR , ARRPostDR, ARRDate, ARRRecordUser, ARRMem, ARRDepDR , ARRRelayDR, AuditDr)

ClassMethod InsertDPArrange(ARRPerDR = "", ARRPostDR = "", ARRDate = "", ARRRecordUser = "", ARRMem = "", ARRDepDR = "", ARRRelayDR = "", AuditDr = "") As %String
{
	q:ARRPerDR="" "代码不能为空!"
	s objDPArrange = ##class(User.DHCMGPersonArrange).%New()
	s objDPArrange.ARRPerDR=ARRPerDR
	s objDPArrange.ARRPostDR=ARRPostDR
	s objDPArrange.ARRDate=$zdh(ARRDate,4)
	s objDPArrange.ARRRecordUser=ARRRecordUser
	s objDPArrange.ARRRecDate=+$h
	s objDPArrange.ARRRecTime=$p($h,",",2)
	s objDPArrange.ARRMem=ARRMem
	s objDPArrange.ARRDepDR=ARRDepDR
	s objDPArrange.ARRRelayDR=ARRRelayDR
	s objDPArrange.AuditDr=AuditDr
	s saveStatus=objDPArrange.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s dpaId=objDPArrange.%Id()
	d objDPArrange.%Close()
	q 0
}

ClassMethod UpdateDPArrange(DPAId, ARRPerDR, ARRPostDR, ARRDate, ARRRecordUser, ARRMem, ARRDepDR, ARRRelayDR, AuditDr) As %String
{
	q:DPAId="" "RowId不能为空!"
	q:'##class(User.DHCMGPersonArrange).%ExistsId(DPAId) "表指针无对应记录!"
	s objDPArrange = ##class(User.DHCMGPersonArrange).%OpenId(DPAId)
	s objDPArrange.ARRPerDR=ARRPerDR
	s objDPArrange.ARRPostDR=ARRPostDR
	s objDPArrange.ARRDate=$zdh(ARRDate,4)
	s objDPArrange.ARRRecordUser=ARRRecordUser
	s objDPArrange.ARRRecDate=+$h
	s objDPArrange.ARRRecTime=$p($h,",",2)
	s objDPArrange.ARRMem=ARRMem
	s objDPArrange.ARRDepDR=ARRDepDR
	s objDPArrange.ARRRelayDR=ARRRelayDR
	s objDPArrange.AuditDr=AuditDr
	s updateStatus=objDPArrange.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s dpaId=objDPArrange.%Id()
	d objDPArrange.%Close()
	q 0
}

//w ##class(web.DHCMGPersonArrange).DeleteDPArrange("1") 

ClassMethod DeleteDPArrange(DPAId) As %String
{
	q:DPAId="" "RowId不能为空!"
	q:'##class(User.DHCMGPersonArrange).%ExistsId(DPAId) "表指针无对应记录!"
	s deleteStatus=##class(User.DHCMGPersonArrange).%DeleteId(DPAId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

Storage Default
{
<Data name="DHCMGPersonArrangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMGPersonArrangeD</DataLocation>
<DefaultData>DHCMGPersonArrangeDefaultData</DefaultData>
<IdLocation>^web.DHCMGPersonArrangeD</IdLocation>
<IndexLocation>^web.DHCMGPersonArrangeI</IndexLocation>
<StreamLocation>^web.DHCMGPersonArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
