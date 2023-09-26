Import SQLUser

Class web.DHCBPCEquipModel Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCEquipModel","FindEModel")
Query FindEModel(ManufacturerDr As %String = "") As %Query(ROWSPEC = "tID:%String,tBPCEMCode:%String,tBPCEMDesc:%String,tBPCEMAbbreviation:%String,tBPCEMManufacturerDr:%String,tBPCEMManufacturerDesc:%String,tBPCEMAgent:%String,tBPCEMType:%String,tBPCEMTypeD:%String,tBPCEMNote:%String,tBPCEMCanFilterB:%String,tBPCEMCanFilter:%String")
{
}

ClassMethod FindEModelExecute(ByRef qHandle As %Binary, ManufacturerDr As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tID=0
	f  s tID=$o(^DHCBPC("EquipModel",tID)) q:tID=""  d
	    .s tBPCEMCode=$lg(^DHCBPC("EquipModel",tID),1)
	    .q:tBPCEMCode=""
	    .s tBPCEMDesc=$lg(^DHCBPC("EquipModel",tID),2)
	    .q:tBPCEMDesc=""
	    .s tBPCEMAbbreviation=$lg(^DHCBPC("EquipModel",tID),3)
	    .s tBPCEMManufacturerDr=$lg(^DHCBPC("EquipModel",tID),4)
	    .q:(ManufacturerDr'="")&&(ManufacturerDr'=tBPCEMManufacturerDr)
	    .s tBPCEMManufacturerDesc=""
	    .i tBPCEMManufacturerDr'=""  s tBPCEMManufacturerDesc=$lg(^DHCBPC("Manufacturer",tBPCEMManufacturerDr),2) //厂家名
	    .s tBPCEMAgent=$lg(^DHCBPC("EquipModel",tID),5)
	    .s tBPCEMType=$lg(^DHCBPC("EquipModel",tID),6)
	    .s:tBPCEMType="W" tBPCEMTypeD="水处理"
	    .s:tBPCEMType="B" tBPCEMTypeD="血液净化"
	    .s tBPCEMNote=$lg(^DHCBPC("EquipModel",tID),7)
	    .s tBPCEMCanFilterB=$lg(^DHCBPC("EquipModel",tID),8)
	    .s:tBPCEMCanFilterB=1 tBPCEMCanFilter="是"
	    .s:tBPCEMCanFilterB=0 tBPCEMCanFilter="否"
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tID,tBPCEMCode,tBPCEMDesc,tBPCEMAbbreviation,tBPCEMManufacturerDr,tBPCEMManufacturerDesc,tBPCEMAgent,tBPCEMType,tBPCEMTypeD,tBPCEMNote,tBPCEMCanFilterB,tBPCEMCanFilter)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindEModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEModelExecute ]
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

ClassMethod FindEModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEModelExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPCEquipModel).InsertEModel("2","型号2","","","","W","","Y")
ClassMethod InsertEModel(bpcEMCode, bpcEMDesc, bpcEMAbbreviation, bpcEMManufacturerDr, bpcEMAgent, bpcEMType, bpcEMNote, bpcEMCanFilter) As %String
{
	q:bpcEMCode="" "代码不能为空!"
	q:bpcEMDesc="" "描述不能为空!"
	s BPCMFacRowid=""
	//f  s BPCMFacRowid=$o(^DHCBPC("Manufacturer",BPCMFacRowid)) q:BPCMFacRowid=""  
	s objEModel = ##class(User.DHCBPCEquipModel).%New()
	s objEModel.BPCEMCode=bpcEMCode
	s objEModel.BPCEMDesc=bpcEMDesc
	s objEModel.BPCEMAbbreviation=bpcEMAbbreviation
	i bpcEMManufacturerDr'=""
	{
	   s objEMManufacturer= ##class(User.DHCBPCManufacturer).%OpenId(bpcEMManufacturerDr)
	   s objEModel.BPCEMBPCManufacturerDr=objEMManufacturer
	}
	s objEModel.BPCEMAgent=bpcEMAgent
	s objEModel.BPCEMType=bpcEMType
	s objEModel.BPCEMNote=bpcEMNote
	s objEModel.BPCEMCanFilter=bpcEMCanFilter
	s saveStatus=objEModel.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s bpcEMId=objEModel.%Id()
	d objEModel.%Close()
	q 0
}

/// d ##class(web.DHCBPCEquipModel).UpdateEModel(1,"1","型号1","","","","W","","N")
ClassMethod UpdateEModel(bpcEMId, bpcEMCode, bpcEMDesc, bpcEMAbbreviation, bpcEMManufacturerDr, bpcEMAgent, bpcEMType, bpcEMNote, bpcEMCanFilter) As %String
{
	q:bpcEMId="" "ID不能为空!"
	q:bpcEMCode="" "代码不能为空!"
	q:bpcEMDesc="" "描述不能为空!"
	q:'##class(User.DHCBPCEquipModel).%ExistsId(bpcEMId) "日志码表指针无对应记录!"
	s objEModel = ##class(User.DHCBPCEquipModel).%OpenId(bpcEMId)
	s objEModel.BPCEMCode=bpcEMCode
	s objEModel.BPCEMDesc=bpcEMDesc
	s objEModel.BPCEMAbbreviation=bpcEMAbbreviation
	i bpcEMManufacturerDr'=""
	{
	   s objEMManufacturer= ##class(User.DHCBPCManufacturer).%OpenId(bpcEMManufacturerDr)
	   s objEModel.BPCEMBPCManufacturerDr=objEMManufacturer
	}
	s objEModel.BPCEMAgent=bpcEMAgent
	s objEModel.BPCEMType=bpcEMType
	s objEModel.BPCEMNote=bpcEMNote
	s objEModel.BPCEMCanFilter=bpcEMCanFilter
	s updateStatus=objEModel.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s bpcEMId=objEModel.%Id()
	d objEModel.%Close()
	q 0
}

/// d ##class(web.DHCBPCEquipModel).DeleteEModel(1)
ClassMethod DeleteEModel(bpcEMId) As %String
{
	q:bpcEMId="" "ID不能为空!"
	q:'##class(User.DHCBPCEquipModel).%ExistsId(bpcEMId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCBPCEquipModel).%DeleteId(bpcEMId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

Query FindEMType() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindEMTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="W",Desc="水处理"
	d OutputRow1
	s Id="B",Desc="血液净化"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindEMTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEMTypeExecute ]
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

ClassMethod FindEMTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEMTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetEquipModelList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCEM_Code As Code,
	   BPCEM_Desc As Description,
	   BPCEM_Abbreviation As Abbreviation,
	   BPCEM_BPCManufacturer_Dr As Manufacturer,
	   BPCEM_Agent As Agent,
	   BPCEM_Type As ModelType,
	   BPCEM_Note As Note,
	   BPCEM_CanFilter As CanFilter
	   FROM DHC_BPC_EquipModel
}

}
