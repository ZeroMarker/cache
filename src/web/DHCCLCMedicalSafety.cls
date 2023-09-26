Class web.DHCCLCMedicalSafety Extends %RegisteredObject
{

ClassMethod AddMedicalSafety(str)
{
	
	q:str=""
	s Code=$p(str,"^",1)
	s ret=0
	s rowId=0
	f  s rowId=$O(^DHCCLC("MedicalSafety",rowId)) q:rowId=""  d
	.i (Code=$li(^DHCCLC("MedicalSafety",rowId),1)) d
	..s ret=1
	..q
	q:(ret=1) "该代码已经存在，请重新输入！"
	k PLIST
	s PLIST(2)=$P(str,"^",1)
	s PLIST(3)=$P(str,"^",2)
	s PLIST(4)=$P(str,"^",4)
	s PLIST(5)=$P(str,"^",3)
	&sql(insert into sqluser.DHC_CLC_MedicalSafety Values :PLIST())
    i SQLCODE'=0 q "插入不良事件出错！"
    q "数据成功插入"
	//&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	//q:SQLCODE'=0 "更新护士组出错!"
}

ClassMethod UpdateMedicalSafety(rowId, str)
{
	q:((rowId="")||(str=""))
	s Code=$p(str,"^",1)
	s ret=0
	s trowId=0
	f  s trowId=$O(^DHCCLC("MedicalSafety",trowId)) q:trowId=""  d
	.i (Code=$li(^DHCCLC("MedicalSafety",trowId),1)&(trowId'=rowId)) d
	..s ret=1
	..q
	q:(ret=1) "该代码已经存在，请重新输入！"
	k PLIST
	s PLIST(2)=$P(str,"^",1)
	s PLIST(3)=$P(str,"^",2)
	s PLIST(4)=$P(str,"^",4)
	s PLIST(5)=$P(str,"^",3)
	&sql(update sqluser.DHC_CLC_MedicalSafety Values :PLIST() where CLCMS_RowId=:rowId) 
	i SQLCODE'=0 q "更新护士组出错！"
	q "更新成功"
}

ClassMethod DeleteMedicalSafety(rowId)
{
	q:rowId=""
	&sql(delete from sqluser.DHC_CLC_MedicalSafety where CLCMS_RowId=:rowId)
	q 0
}

Query MedicalSafety(ret As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String,ctlocId:%String,ctlocDesc:%String,rowId:%String,type:%String")
{
}

ClassMethod MedicalSafetyExecute(ByRef qHandle As %Binary, ret As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s rowId=0
 	f  s rowId=$O(^DHCCLC("MedicalSafety",rowId)) q:rowId=""  d
 	.s Code=$li(^DHCCLC("MedicalSafety",rowId),1)
 	.q:Code'[ret
	.s Desc=$li(^DHCCLC("MedicalSafety",rowId),2)
	.s ctlocId=$li(^DHCCLC("MedicalSafety",rowId),4)
	.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
	.s type=$li(^DHCCLC("MedicalSafety",rowId),3)
	.d OutMedicalSafety
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutMedicalSafety
	set Data=$lb(Code,Desc,ctlocId,ctlocDesc,rowId,type)
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

Query FindLocList(desc As %String, locListCodeStr As %String = "", EpisodeID As %String = "") As %Query(ROWSPEC = "ctlocId:%String,ctlocDesc:%String,ctlocCode:%String")
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, desc As %String, locListCodeStr As %String = "INOPDEPT", EpisodeID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s desc=$$ALPHAUP^SSUTIL4(desc)
	//s locListCodeStr=..AdjustLocListCode(locListCodeStr,EpisodeID)
	//s ctlocIdList=..GetLocIdByLocListCode(locListCodeStr)
	s ctlocId=""
	f  s ctlocId=$O(^CTLOC(ctlocId)) q:ctlocId=""  d
	.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
	.q:(desc'="")&($p($$ALPHAUP^SSUTIL4(ctlocDesc),desc)'="")
	    .s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
	    .Do OutputRow6
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow6
	set Data=$lb(ctlocId,ctlocDesc,ctlocCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListExecute ]
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

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CheckIsValid(desc, id) As %String
{
	q:+id'>0 1
	q:$d(^CTLOC(id))<1 1
	s curDesc=$p(^CTLOC(id),"^",2)
	q:curDesc'=desc 1
	q 0
}

}
