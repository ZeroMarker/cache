Class web.DHCCLMedicalSafety Extends %RegisteredObject
{

ClassMethod AddMedicalSafety(str)
{
	
	q:str=""
	/*
	s Code=$p(str,"^",1)
	s ret=0
	s rowId=0
	f  s rowId=$O(^DHCCLC("MedicalSafety",rowId)) q:rowId=""  d
	.i (Code=$li(^DHCCLC("MedicalSafety",rowId),1)) d
	..s ret=1
	..q
	q:(ret=1) "该代码已经存在，请重新输入！"
	*/
	k PLIST
	s PLIST(6)=$P(str,"^",1)
	s PLIST(8)=$P(str,"^",2)
	s PLIST(9)=$P(str,"^",3)
	s PLIST(10)=$P(str,"^",4)
	s PLIST(11)=$P(str,"^",5)
	s PLIST(13)=$P(str,"^",6)
	s PLIST(4)=$P(str,"^",7)
	&sql(insert into sqluser.DHC_CL_MedicalSafety Values :PLIST())
    i SQLCODE'=0 q "插入不良事件出错！"
    q "数据成功插入"
	//&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	//q:SQLCODE'=0 "更新护士组出错!"
}

ClassMethod UpdateMedicalSafety(rowId, str)
{
	q:((rowId="")||(str=""))
	/*
	s Code=$p(str,"^",1)
	s ret=0
	s trowId=0
	f  s trowId=$O(^DHCCLC("MedicalSafety",trowId)) q:trowId=""  d
	.i (Code=$li(^DHCCLC("MedicalSafety",trowId),1)&(trowId'=rowId)) d
	..s ret=1
	..q
	q:(ret=1) "该代码已经存在，请重新输入！"
	*/
	k PLIST
	s PLIST(8)=$P(str,"^",1)
	s PLIST(10)=$P(str,"^",2)
	s PLIST(11)=$P(str,"^",3)
	&sql(update sqluser.DHC_CL_MedicalSafety Values :PLIST() where CLMS_RowId=:rowId)
    i SQLCODE'=0 q "插入不良事件出错！"
    q "数据成功插入"
}

ClassMethod DeleteMedicalSafety(rowId)
{
	q:rowId=""
	&sql(delete from sqluser.DHC_CL_MedicalSafety where CLMS_RowId=:rowId)
	q 0
}

Query MedicalSafety(icuId As %String) As %Query(ROWSPEC = "rowId:%String,EventId:%String,EventDesc:%String,statusCode:%String,statusDesc:%String,note:%String")
{
}

ClassMethod MedicalSafetyExecute(ByRef qHandle As %Binary, icuId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s rowId=""
 	f  s rowId=$o(^DHCCLMedicalSafety(0,"ICUA",icuId,rowId)) q:rowId=""  d
 	.s EventId=$li(^DHCCLMedicalSafety(rowId),7)
 	.s EventDesc=$li(^DHCCLC("MedicalSafety",EventId),2)
 	.s statusCode=$li(^DHCCLMedicalSafety(rowId),9)
 	.i (statusCode="N") s statusDesc="Normal"
 	.i (statusCode="A") s statusDesc="Audit"
 	.s note=$li(^DHCCLMedicalSafety(rowId),10)
	.d OutMedicalSafety
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutMedicalSafety
	set Data=$lb(rowId,EventId,EventDesc,statusCode,statusDesc,note)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MedicalSafetyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MedicalSafetyExecute ]
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

ClassMethod MedicalSafetyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MedicalSafetyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetEvent(ret As %String, ctloc As %String) As %Query(ROWSPEC = "rowId:%String,Desc:%String")
{
}

ClassMethod GetEventExecute(ByRef qHandle As %Binary, ret As %String, ctloc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s rowId=0
 	f  s rowId=$O(^DHCCLC("MedicalSafety",rowId)) q:rowId=""  d
 	.s Code=$li(^DHCCLC("MedicalSafety",rowId),1)
 	.q:Code'[ret
	.s Desc=$li(^DHCCLC("MedicalSafety",rowId),2)
	.s ctlocId=$li(^DHCCLC("MedicalSafety",rowId),4)
	.s ^TempLm("20130717",rowId)=ctlocId_"^"_ctloc
	.q:ctlocId'=ctloc
	.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
	.s type=$li(^DHCCLC("MedicalSafety",rowId),3)
	.d OutEvent
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutEvent
	set Data=$lb(rowId,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEventFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEventExecute ]
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

ClassMethod GetEventClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEventExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetWardDescByWardId(rowId)
{
	s rowId=+rowId
	q:rowId=""
	s wardDesc=$p(^PAWARD(rowId),"^",2)
	q wardDesc
}

ClassMethod GetPatName(rowId)
{
	s rowId=+rowId
	q:rowId=""
	s papmiId=$p($g(^PAADM(rowId)),"^",1)
	s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	q PatName
}

Query MedicalSafetyAn(opaId As %String) As %Query(ROWSPEC = "rowId:%String,EventId:%String,EventDesc:%String,statusCode:%String,statusDesc:%String,note:%String")
{
}

ClassMethod MedicalSafetyAnExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	k ^TempLm
 	s ^TempLm("20130717","OPA")=$d(^DHCCLMedicalSafety(0,"OPA",opaId))
 	q:'$d(^DHCCLMedicalSafety(0,"OPA",opaId))
 	s rowId=0
 	f  s rowId=$o(^DHCCLMedicalSafety(0,"OPA",opaId,rowId)) q:rowId=""  d
 	.s ^TempLm("20130717","OPA",rowId,1)=0
 	.s EventId=$li(^DHCCLMedicalSafety(rowId),7)
 	.s EventDesc=$li(^DHCCLC("MedicalSafety",EventId),2)
 	.s statusCode=$li(^DHCCLMedicalSafety(rowId),9)
 	.i (statusCode="N") s statusDesc="Normal"
 	.i (statusCode="A") s statusDesc="Audit"
 	.s note=$li(^DHCCLMedicalSafety(rowId),10)
 	.s ^TempLm("20130717","OPA",rowId)=$lb(rowId,EventId,EventDesc,statusCode,statusDesc,note)
	.d OutMedicalSafetyAn
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutMedicalSafetyAn
	set Data=$lb(rowId,EventId,EventDesc,statusCode,statusDesc,note)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MedicalSafetyAnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MedicalSafetyAnExecute ]
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

ClassMethod MedicalSafetyAnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MedicalSafetyAnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AddMedicalSafetyAn(str)
{
	
	q:str=""
	/*
	s Code=$p(str,"^",1)
	s ret=0
	s rowId=0
	f  s rowId=$O(^DHCCLC("MedicalSafety",rowId)) q:rowId=""  d
	.i (Code=$li(^DHCCLC("MedicalSafety",rowId),1)) d
	..s ret=1
	..q
	q:(ret=1) "该代码已经存在，请重新输入！"
	*/
	k PLIST
	s PLIST(4)=$P(str,"^",7)
	s PLIST(5)=$P(str,"^",1)
	s PLIST(8)=$P(str,"^",2)
	s PLIST(9)=$P(str,"^",3)
	s PLIST(10)=$P(str,"^",4)
	s PLIST(11)=$P(str,"^",5)
	s PLIST(13)=$P(str,"^",6)
	&sql(insert into sqluser.DHC_CL_MedicalSafety Values :PLIST())
    i SQLCODE'=0 q "插入不良事件出错！"
    q "数据成功插入"
	//&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	//q:SQLCODE'=0 "更新护士组出错!"
}

}
