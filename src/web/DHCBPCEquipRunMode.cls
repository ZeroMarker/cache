Import SQLUser

/// 
/// 
/// 此web类对应User.DHCBPCEquipRunParaCat
Class web.DHCBPCEquipRunMode Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCEquipRunMode","FindERunMode")
Query FindERunMode() As %Query(ROWSPEC = "tBPCERMRowId:%String,tBPCERMCode:%String,tBPCERMDesc:%String")
{
}

ClassMethod FindERunModeExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPCERMRowId=0
	f  s tBPCERMRowId=$o(^DHCBPC("EquipRunMode",tBPCERMRowId)) q:tBPCERMRowId=""  d
	    .s tBPCERMCode=$lg(^DHCBPC("EquipRunMode",tBPCERMRowId),1)
	    .q:tBPCERMCode=""
	    .s tBPCERMDesc=$lg(^DHCBPC("EquipRunMode",tBPCERMRowId),2)
	    .q:tBPCERMDesc=""
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCERMRowId,tBPCERMCode,tBPCERMDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindERunModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindERunModeExecute ]
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

ClassMethod FindERunModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindERunModeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPCEquipRunMode).InsertERunMode("2","模式2")
ClassMethod InsertERunMode(bpcERMCode, bpcERMDesc) As %String
{
	q:bpcERMCode="" "代码不能为空!"
	q:bpcERMDesc="" "描述不能为空!"
	s objERunMode = ##class(User.DHCBPCEquipRunMode).%New()
	s objERunMode.BPCERMCode=bpcERMCode
	s objERunMode.BPCERMDesc=bpcERMDesc
	s saveStatus=objERunMode.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s bpcERMId=objERunMode.%Id()
	d objERunMode.%Close()
	q 0
}

/// d ##class(web.DHCBPCEquipRunMode).UpdateERunMode(1,"1","模式")
ClassMethod UpdateERunMode(bpcERMId, bpcERMCode, bpcERMDesc) As %String
{
	q:bpcERMId="" "ID不能为空!"
	q:bpcERMCode="" "代码不能为空!"
	q:bpcERMDesc="" "描述不能为空!"
	q:'##class(User.DHCBPCEquipRunMode).%ExistsId(bpcERMId) "日志码表指针无对应记录!"
	s objERunMode = ##class(User.DHCBPCEquipRunMode).%OpenId(bpcERMId)
	s objERunMode.BPCERMCode=bpcERMCode
	s objERunMode.BPCERMDesc=bpcERMDesc
	s updateStatus=objERunMode.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s bpcERMId=objERunMode.%Id()
	d objERunMode.%Close()
	q 0
}

/// d ##class(web.DHCBPCEquipRunMode).DeleteERunMode(1)
ClassMethod DeleteERunMode(bpcERMId) As %String
{
	q:bpcERMId="" "ID不能为空!"
	q:'##class(User.DHCBPCEquipRunMode).%ExistsId(bpcERMId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCBPCEquipRunMode).%DeleteId(bpcERMId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

Query GetEquipRunModeList() As %SQLQuery(CONTAINID = 1)
{
   SELECT %ID As Id,
	   BPCERPC_Code As Code,
	   BPCERPC_Desc As Description,
	   BPCERPC_ValueType As ValueType
	   FROM DHC_BPC_EquipRunParaCat
}

}
