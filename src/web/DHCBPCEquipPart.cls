Import SQLUser

Class web.DHCBPCEquipPart Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCEquipPart","FindEPart","")
Query FindEPart(BPCEPBPCEquipModelDr, bpcEPCode As %String = "", bpcEPDesc As %String = "") As %Query(ROWSPEC = "tBPCEPRowId:%String,tBPCEPCode:%String,tBPCEPDesc:%String,tBPCEPBPCEquipModelDr:%String,tBPCEPBPCEquipModel:%String")
{
}

ClassMethod FindEPartExecute(ByRef qHandle As %Binary, BPCEPBPCEquipModelDr, bpcEPCode As %String = "", bpcEPDesc As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i BPCEPBPCEquipModelDr="" d
 	.s tBPCEPRowId=0
	.f  s tBPCEPRowId=$o(^DHCBPC("EquipPart",tBPCEPRowId)) q:tBPCEPRowId=""  d
	    ..s tBPCEPCode=$lg(^DHCBPC("EquipPart",tBPCEPRowId),2)
	    ..q:tBPCEPCode=""
	    ..q:(bpcEPCode'="")&&(tBPCEPCode'=bpcEPCode)
	    ..s tBPCEPDesc=$lg(^DHCBPC("EquipPart",tBPCEPRowId),3)
	    ..q:tBPCEPDesc=""
	    ..q:(bpcEPDesc'="")&&(tBPCEPDesc'=bpcEPDesc)
	    ..s tBPCEPBPCEquipModelDr=$lg(^DHCBPC("EquipPart",tBPCEPRowId),1)
	    ..s tBPCEPBPCEquipModel=""
	    ..i tBPCEPBPCEquipModelDr'="" s tBPCEPBPCEquipModel=$lg(^DHCBPC("EquipModel",tBPCEPBPCEquipModelDr),2)
	    ..d OutputRow1
	e  d
	.s tBPCEPBPCEquipModelDr=BPCEPBPCEquipModelDr
	.s tBPCEPRowId=0
	.f  s tBPCEPRowId=$o(^DHCBPC("EquipPart",0,"BPCEquipModel",tBPCEPBPCEquipModelDr,tBPCEPRowId)) q:tBPCEPRowId=""  d
	    ..s tBPCEPCode=$lg(^DHCBPC("EquipPart",tBPCEPRowId),2) 
	    ..q:tBPCEPCode=""
	    ..q:(bpcEPCode'="")&&(tBPCEPCode'=bpcEPCode)
	    ..s tBPCEPDesc=$lg(^DHCBPC("EquipPart",tBPCEPRowId),3)
	    ..q:tBPCEPDesc=""
	    ..q:(bpcEPDesc'="")&&(tBPCEPDesc'=bpcEPDesc)
	    ..s tBPCEPBPCEquipModel=$lg(^DHCBPC("EquipModel",tBPCEPBPCEquipModelDr),2)
	    ..d OutputRow1 
	     
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCEPRowId,tBPCEPCode,tBPCEPDesc,tBPCEPBPCEquipModelDr,tBPCEPBPCEquipModel)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindEPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEPartExecute ]
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

ClassMethod FindEPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEPartExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPCEquipPart).InsertEPart(2,"1","配件1")
ClassMethod InsertEPart(bpcEPBPCEquipModelDr, bpcEPCode, bpcEPDesc) As %String
{
	q:bpcEPCode="" "代码不能为空!"
	q:bpcEPDesc="" "描述不能为空!"
	s objEPart = ##class(User.DHCBPCEquipPart).%New()
	s objEPart.BPCEPCode=bpcEPCode
	s objEPart.BPCEPDesc=bpcEPDesc
	s objEModel= ##class(User.DHCBPCEquipModel).%OpenId(bpcEPBPCEquipModelDr)
	s objEPart.BPCEPBPCEquipModelDr=objEModel
	s saveStatus=objEPart.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s bpcEPId=objEPart.%Id()
	d objEPart.%Close()
	q 0
}

/// d ##class(web.DHCBPCEquipPart).UpdateEPart(5,2,"2","配件2")
ClassMethod UpdateEPart(bpcEPId, bpcEPBPCEquipModelDr, bpcEPCode, bpcEPDesc) As %String
{
	q:bpcEPId="" "ID不能为空!"
	q:bpcEPCode="" "代码不能为空!"
	q:bpcEPDesc="" "描述不能为空!"
	q:'##class(User.DHCBPCEquipPart).%ExistsId(bpcEPId) "日志码表指针无对应记录!"
	s objEPart = ##class(User.DHCBPCEquipPart).%OpenId(bpcEPId)
	s objEPart.BPCEPCode=bpcEPCode
	s objEPart.BPCEPDesc=bpcEPDesc
	s objEModel= ##class(User.DHCBPCEquipModel).%OpenId(bpcEPBPCEquipModelDr)
	s objEPart.BPCEPBPCEquipModelDr=objEModel
	s updateStatus=objEPart.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s bpcERMId=objEPart.%Id()
	d objEPart.%Close()
	q 0
}

/// d ##class(web.DHCBPCEquipPart).DeleteEPart(5)
ClassMethod DeleteEPart(bpcEPId) As %String
{
	q:bpcEPId="" "ID不能为空!"
	q:'##class(User.DHCBPCEquipPart).%ExistsId(bpcEPId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCBPCEquipPart).%DeleteId(bpcEPId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

Query GetEquipPartList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCEP_BPCEquipModel_Dr As EquipModelId,
	   BPCEP_Code As Code,
	   BPCEP_Desc As Description
       FROM DHC_BPC_EquipPart
}

}
