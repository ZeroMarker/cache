Import SQLUser

/// DHCBPCDeceaseReason
/// 刘阳
/// 添加，更新，删除功能
/// DHCBPCDeceaseReason  死亡原因
Class web.DHCBPCDeceaseReason Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(web.DHCBPCDeceaseReason).AddDHCBPCDeceaseReason("1","我")  ///增加数据语句	
ClassMethod AddDHCBPCDeceaseReason(BPCDRCode, BPCDRDesc) As %String
{
	q:BPCDRCode="" "代码不能为空!"
	;q:TSCDesc="" "描述不能为空!"
	s objDHCBPCDeceaseReason = ##class(User.DHCBPCDeceaseReason).%New()
	s objDHCBPCDeceaseReason.BPCDRCode=BPCDRCode
	s objDHCBPCDeceaseReason.BPCDRDesc=BPCDRDesc
	s saveStatus=objDHCBPCDeceaseReason.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s BPCDRRowId=objDHCBPCDeceaseReason.%Id()
	d objDHCBPCDeceaseReason.%Close()
	q 0
}

/// BPCDRRowId
/// 更新功能维护
/// d ##class(web.DHCBPCDeceaseReason).UpdateDHCBPCDeceaseReason(2,"2","我")
ClassMethod UpdateDHCBPCDeceaseReason(BPCDRRowId, BPCDRCode, BPCDRDesc) As %String
{
	q:BPCDRRowId="" "RowId不能为空!"
	q:BPCDRCode="" "代码不能为空!"
	;q:TSCDesc="" "描述不能为空!"
	s objDHCBPCDeceaseReason = ##class(User.DHCBPCDeceaseReason).%OpenId(BPCDRRowId)
	s objDHCBPCDeceaseReason.BPCDRCode=BPCDRCode
	s objDHCBPCDeceaseReason.BPCDRDesc=BPCDRDesc
	s updateStatus=objDHCBPCDeceaseReason.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	///BPCDRRowId ???????????
	s BPCDRRowId=objDHCBPCDeceaseReason.%Id()
	d objDHCBPCDeceaseReason.%Close()
	q 0
}

/// 删除功能维护
/// d ##class(web.DHCBPCDeceaseReason).DeleteDHCBPCDeceaseReason()
ClassMethod DeleteDHCBPCDeceaseReason(BPCDRRowId) As %String
{
	q:BPCDRRowId="" "RowId不能为空!"
	s deleteStatus=##class(User.DHCBPCDeceaseReason).%DeleteId(BPCDRRowId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

/// 查询功能维护
/// d ##class(%ResultSet).RunQuery("web.DHCBPCDeceaseReason","FindDHCBPCDeceaseReason")
Query FindDHCBPCDeceaseReason() As %Query(ROWSPEC = "tBPCDRRowId:%String,tBPCDRCode:%String,tBPCDRDesc:%String")
{
}

ClassMethod FindDHCBPCDeceaseReasonExecute(ByRef qHandle As %Binary) As %Status
{
 	//new repid,index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	////^DHCBPC("BloodPurificationMode")
 	///^DHCBPC("DeceaseReason")
 	s tBPCDRRowId=0
 	f  s tBPCDRRowId=$O(^DHCBPC("DeceaseReason",tBPCDRRowId)) q:tBPCDRRowId=""  d
 	.
	.d SetBPCDRInfo
	
	Quit $$$OK
OutputRowFindDHCBPCDeceaseReason
	set Data=$lb(tBPCDRRowId,tBPCDRCode,tBPCDRDesc)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
SetBPCDRInfo
  	s RowId=tBPCDRRowId
 	s tBPCDRCode=$lg(^DHCBPC("DeceaseReason",RowId),1)
 	s tBPCDRDesc=$lg(^DHCBPC("DeceaseReason",RowId),2)
 	d OutputRowFindDHCBPCDeceaseReason
 	
 	quit
}

ClassMethod FindDHCBPCDeceaseReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDHCBPCDeceaseReasonExecute ]
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

ClassMethod FindDHCBPCDeceaseReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDHCBPCDeceaseReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetDeceaseReasonList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCDR_Code As Code,
	   BPCDR_Desc As Description
	   FROM DHC_BPC_DeceaseReason
}

}
